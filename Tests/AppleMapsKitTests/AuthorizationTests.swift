//
//  AuthorizationProviderTests.swift
//  apple-maps-kit
//
//  Created by FarouK on 12/10/2024.
//

import Foundation
import Testing

@testable import AppleMapsKit

@Suite("Authorization Tests")
struct AuthorizationTests {
    // It's actually 1 second due to the expiration buffer on the token.
    let token = TokenResponse(accessToken: "test", expiresInSeconds: 11)

    @Test("Invalid Access Token") func invalidToken() async throws {
        try await Task.sleep(for: .seconds(2))
        #expect(!token.isValid)
    }

    @Test("Valid Access Token") func validToken() {
        #expect(token.isValid)
    }

    @Test("Decoding TokenResponse") func decodingTokenResponse() async throws {
        let jsonToken = """
            {
                "accessToken": "test",
                "expiresInSeconds": 11
            }
            """
        let token = try JSONDecoder().decode(TokenResponse.self, from: jsonToken.data(using: .utf8)!)
        #expect(token.accessToken == "test")
        #expect(token.expiresInSeconds == 11)
        #expect(token.isValid)
    }
}