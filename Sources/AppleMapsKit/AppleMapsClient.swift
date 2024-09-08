import Foundation
import NIOHTTP1
import NIOCore
import NIOFoundationCompat
import AsyncHTTPClient
import JWTKit

/// Methods to make calls to APIs such as geocode, search, and so on.
public struct AppleMapsClient: Sendable {
    static let apiServer = "https://maps-api.apple.com"
    private let httpClient: HTTPClient
    private let accessToken: String

    public init(httpClient: HTTPClient, teamID: String, keyID: String, key: String) async throws {
        self.httpClient = httpClient
        self.accessToken = try await Self.getAccessToken(
            httpClient: httpClient,
            authToken: Self.createJWT(teamID: teamID, keyID: keyID, key: key)
        )
    }

    /// Makes a geocoding request.
    /// 
    /// - Parameters: 
    ///   - address: Address to geocode.
    ///   - limitToCountries: A list of two-letter ISO 3166-1 codes to limit the results to.
    ///   - lang: The language the server should use when returning the response, specified using a BCP 47 language code.
    ///   - searchLocation: A location defined by the application as a hint.
    ///   - searchRegion: A region the app defines as a hint.
    ///   - userLocation: The location of the user.
    /// 
    /// - Returns: An array of ``Place`` objects.
    public func geocode(
        address: String,
        limitToCountries: [String]? = nil,
        lang: String? = nil,
        searchLocation: (latitude: Double, longitude: Double)? = nil,
        searchRegion: (northLatitude: Double, eastLongitude: Double, southLatitude: Double, westLongitude: Double)? = nil,
        userLocation: (latitude: Double, longitude: Double)? = nil
    ) async throws -> [Place] {
        var url = URL(string: "\(Self.apiServer)/v1/geocode")!
        var queries: [URLQueryItem] = [URLQueryItem(name: "q", value: address)]
        if let limitToCountries {
            queries.append(URLQueryItem(name: "limitToCountries", value: limitToCountries.joined(separator: ",")))
        }
        if let lang {
            queries.append(URLQueryItem(name: "lang", value: lang))
        }
        if let searchLocation {
            queries.append(URLQueryItem(name: "searchLocation", value: "\(searchLocation.latitude),\(searchLocation.longitude)"))
        }
        if let searchRegion {
            queries.append(URLQueryItem(name: "searchRegion", value: "\(searchRegion.northLatitude),\(searchRegion.eastLongitude),\(searchRegion.southLatitude),\(searchRegion.westLongitude)"))
        }
        if let userLocation {
            queries.append(URLQueryItem(name: "userLocation", value: "\(userLocation.latitude),\(userLocation.longitude)"))
        }
        url.append(queryItems: queries)
        print(url)

        let data = try await self.httpGet(url: url)
        return try JSONDecoder().decode(PlaceResults.self, from: data).results ?? []
    }

    /// Makes a reverse geocoding request.
    /// 
    /// - Parameters:
    ///   - latitude: Latitude value for the coordinate.
    ///   - longitude: Longitude value for the coordinate.
    ///   - lang: The language the server uses when returning the response, specified using a BCP 47 language code.
    /// 
    /// - Returns: An array of one or more ``Place`` objects.
    public func reverseGeocode(latitude: Double, longitude: Double, lang: String? = nil) async throws -> [Place] {
        var url = URL(string: "\(Self.apiServer)/v1/reverseGeocode")!
        var queries: [URLQueryItem] = [URLQueryItem(name: "loc", value: "\(latitude),\(longitude)")]
        if let lang {
            queries.append(URLQueryItem(name: "lang", value: lang))
        }
        url.append(queryItems: queries)

        let data = try await self.httpGet(url: url)
        return try JSONDecoder().decode(PlaceResults.self, from: data).results ?? []
    }

    /// Makes an HTTP GET request.
    /// 
    /// - Parameter url: URL for the request.
    /// 
    /// - Returns: HTTP response object.
    /// 
    /// - Throws: Error response object.
    private func httpGet(url: URL) async throws -> ByteBuffer {
        var headers = HTTPHeaders()
        headers.add(name: "Authorization", value: "Bearer \(self.accessToken)")

        var request = HTTPClientRequest(url: url.absoluteString)
        request.headers = headers

        let response = try await self.httpClient.execute(request, timeout: .seconds(30))

        if response.status == .ok {
            return try await response.body.collect(upTo: 1024 * 1024)
        } else {
            throw try await JSONDecoder().decode(ErrorResponse.self, from: response.body.collect(upTo: 1024 * 1024))
        }
    }
}

extension AppleMapsClient {
    /// Creates a JWT token, which is auth token in this context.
    /// 
    /// - Parameters:
    ///   - teamID: A 10-character Team ID obtained from your Apple Developer account.
    ///   - keyID: A 10-character key identifier that provides the ID of the private key that you obtain from your Apple Developer account.
    ///   - key: A MapKit JS private key.
    /// 
    /// - Returns: A JWT token represented as `String`.
    private static func createJWT(teamID: String, keyID: String, key: String) async throws -> String {
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
            exp: .init(value: Date().addingTimeInterval(30 * 60))
        )

        return try await keys.sign(payload, header: header)
    }

    /// Makes an HTTP request to exchange Auth token for Access token.
    /// 
    /// - Parameters:
    ///   - httpClient: The HTTP client to use.
    ///   - authToken: The authorization token.
    ///
    /// - Throws: Error response object.
    ///
    /// - Returns: An access token.
    private static func getAccessToken(httpClient: HTTPClient, authToken: String) async throws -> String {
        var headers = HTTPHeaders()
        headers.add(name: "Authorization", value: "Bearer \(authToken)")

        var request = HTTPClientRequest(url: "\(apiServer)/v1/token")
        request.headers = headers

        let response = try await httpClient.execute(request, timeout: .seconds(30))

        if response.status == .ok {
            return try await JSONDecoder()
                .decode(TokenResponse.self, from: response.body.collect(upTo: 1024 * 1024))
                .accessToken
        } else {
            throw try await JSONDecoder().decode(ErrorResponse.self, from: response.body.collect(upTo: 1024 * 1024))
        }
    }
}