/// An object that contains an access token and an expiration time in seconds.
struct TokenResponse: Decodable {
    /// A string that represents the access token.
    let accessToken: String
    
    /// An integer that indicates the time, in seconds from now until the token expires.
    let expiresInSeconds: Int
}