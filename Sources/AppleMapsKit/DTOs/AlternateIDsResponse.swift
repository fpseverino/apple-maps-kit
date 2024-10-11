/// A list of alternate Place IDs and associated errors.
public struct AlternateIDsResponse: Codable, Sendable {
    /// A list of ``PlacesResponse/PlaceLookupError`` results.
    public let errors: [PlacesResponse.PlaceLookupError]?

    /// A list of ``AlternateIDsResponse/AlternateIDs`` results.
    public let results: [AlternateIDs]?
}

extension AlternateIDsResponse {
    /// Contains a list of alternate ``Place`` IDs for a given Place ID.
    public struct AlternateIDs: Codable, Sendable {
        /// The ``Place`` ID.
        public let id: String?

        /// A list of alternate ``Place`` IDs for `id`.
        public let alternateIds: [String]?
    }
}
