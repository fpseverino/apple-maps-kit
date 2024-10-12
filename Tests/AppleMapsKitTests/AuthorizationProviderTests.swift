//
//  AuthorizationProviderTests.swift
//  apple-maps-kit
//
//  Created by FarouK on 12/10/2024.
//

import Testing

@testable import AppleMapsKit

@Suite("AuthorizationProvider Tests")
struct AuthorizationProviderTests {
    // It's actually 1 second due to the expiration buffer on the token.
    let token = TokenResponse(accessToken: "test", expiresInSeconds: 11)

    @Test("Invalid Access Token") func invalidToken() async throws {
        try await Task.sleep(for: .seconds(2))
        #expect(!token.isValid)
    }

    @Test("Valid Access Token") func validToken() {
        #expect(token.isValid)
    }
}
