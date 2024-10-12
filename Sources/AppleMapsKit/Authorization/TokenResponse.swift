import Foundation

/// An object that contains an access token and an expiration time in seconds.
internal struct TokenResponse: Codable {
    /// A string that represents the access token.
    let accessToken: String

    /// An integer that indicates the time, in seconds from now until the token expires.
    let expiresInSeconds: Int

    /// A date that indicates when then token will expire.
    let expirationDate: Date

    internal init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.accessToken = try container.decode(String.self, forKey: .accessToken)
        self.expiresInSeconds = try container.decode(Int.self, forKey: .expiresInSeconds)
        self.expirationDate = Date.now.addingTimeInterval(TimeInterval(expiresInSeconds))
    }

    internal init(accessToken: String, expiresInSeconds: Int) {
        self.accessToken = accessToken
        self.expiresInSeconds = expiresInSeconds
        self.expirationDate = Date.now.addingTimeInterval(TimeInterval(expiresInSeconds))
    }

}

extension TokenResponse {

    /// A boolean indicates whether to token is valid 10 seconds before it's actual expiry time.
    var isValid: Bool {
        let currentDate = Date.now
        // we consider a token invalid 10 seconds before it actual expiry time, so we have some time to refresh it.
        let expirationBuffer: TimeInterval = 10
        return currentDate < (expirationDate - expirationBuffer)
    }
}
