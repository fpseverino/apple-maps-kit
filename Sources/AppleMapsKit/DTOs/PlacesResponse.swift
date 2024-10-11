/// A list of ``Place`` IDs and errors.
public struct PlacesResponse: Codable, Sendable {
    /// A list of ``PlacesResponse/PlaceLookupError`` results.
    public let errors: [PlaceLookupError]?

    /// A list of ``Place`` results.
    public let places: [Place]?
}

extension PlacesResponse {
    /// An error associated with a lookup call.
    public struct PlaceLookupError: Codable, Sendable {
        /// The ``Place`` ID.
        public let id: String?

        /// An error code that indicates whether an ``Place`` ID is invalid because it’s malformed, not found, or resulted in any other error.
        public let errorCode: String?
    }
}
