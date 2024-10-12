//
//  AuthorizationProvider.swift
//  apple-maps-kit
//
//  Created by FarouK on 11/10/2024.
//

import AsyncHTTPClient
import Foundation
import JWTKit
import NIOHTTP1

// MARK: - auth/c & auth/z
internal actor AuthorizationProvider {

    private let httpClient: HTTPClient
    private let apiServer: String
    private let teamID: String
    private let keyID: String
    private let key: String

    private var currentToken: TokenResponse?
    private var refreshTask: Task<TokenResponse, any Error>?

    internal init(httpClient: HTTPClient, apiServer: String, teamID: String, keyID: String, key: String) {
        self.httpClient = httpClient
        self.apiServer = apiServer
        self.teamID = teamID
        self.keyID = keyID
        self.key = key
    }

    func validToken() async throws -> TokenResponse {
        // If we're currently refreshing a token, await the value for our refresh task to make sure we return the refreshed token.
        if let handle = refreshTask {
            return try await handle.value
        }

        // If we don't have a current token, we request a new one.
        guard let token = currentToken else {
            return try await refreshToken()
        }

        if token.isValid {
            return token
        }

        // None of the above applies so we'll need to refresh the token.
        return try await refreshToken()
    }

    private func refreshToken() async throws -> TokenResponse {
        if let refreshTask = refreshTask {
            return try await refreshTask.value
        }

        let task = Task { () throws -> TokenResponse in
            defer { refreshTask = nil }
            let authToken = try await createJWT(teamID: teamID, keyID: keyID, key: key)
            let newToken = try await getAccessToken(authToken: authToken)
            currentToken = newToken
            return newToken
        }

        self.refreshTask = task
        return try await task.value
    }
}

// MARK: - HELPERS
extension AuthorizationProvider {

    /// Makes an HTTP request to exchange Auth token for Access token.
    ///
    /// - Parameters:
    ///   - httpClient: The HTTP client to use.
    ///   - authToken: The authorization token.
    ///
    /// - Throws: Error response object.
    ///
    /// - Returns: An access token.
    fileprivate func getAccessToken(authToken: String) async throws -> TokenResponse {
        var headers = HTTPHeaders()
        headers.add(name: "Authorization", value: "Bearer \(authToken)")

        var request = HTTPClientRequest(url: "\(apiServer)/v1/token")
        request.headers = headers

        let response = try await httpClient.execute(request, timeout: .seconds(30))

        if response.status == .ok {
            return try await JSONDecoder()
                .decode(TokenResponse.self, from: response.body.collect(upTo: 1024 * 1024))
        } else {
            throw try await JSONDecoder().decode(ErrorResponse.self, from: response.body.collect(upTo: 1024 * 1024))
        }
    }

    /// Creates a JWT token, which is auth token in this context.
    ///
    /// - Parameters:
    ///   - teamID: A 10-character Team ID obtained from your Apple Developer account.
    ///   - keyID: A 10-character key identifier that provides the ID of the private key that you obtain from your Apple Developer account.
    ///   - key: A MapKit JS private key.
    ///
    /// - Returns: A JWT token represented as `String`.
    fileprivate func createJWT(teamID: String, keyID: String, key: String) async throws -> String {
        let keys = try await JWTKeyCollection().add(ecdsa: ES256PrivateKey(pem: key))

        var header = JWTHeader()
        header.alg = "ES256"
        header.kid = keyID
        header.typ = "JWT"

        struct Payload: JWTPayload {
            let iss: IssuerClaim
            let iat: IssuedAtClaim
            let exp: ExpirationClaim

            func verify(using key: some JWTAlgorithm) throws {
                try self.exp.verifyNotExpired()
            }
        }

        let payload = Payload(
            iss: IssuerClaim(value: teamID),
            iat: IssuedAtClaim(value: Date()),
            exp: ExpirationClaim(value: Date().addingTimeInterval(30 * 60))
        )

        return try await keys.sign(payload, header: header)
    }
}
