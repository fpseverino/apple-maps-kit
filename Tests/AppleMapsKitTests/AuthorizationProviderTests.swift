//
//  AuthorizationProviderTests.swift
//  apple-maps-kit
//
//  Created by FarouK on 12/10/2024.
//

import Testing

@testable import AppleMapsKit

struct AuthorizationProviderTests {

    struct TokenValidityTests {
        // It's 1 second actually due to the expiration buffer on the token.
        let token = TokenResponse(accessToken: "some token", expiresInSeconds: 11)

        @Test func tokenInvalidCheck() async {
            try? await Task.sleep(for: .seconds(2))
            #expect(token.isValid == false)
        }

        @Test func tokenValidCheck() async {
            #expect(token.isValid)
        }
    }

}
