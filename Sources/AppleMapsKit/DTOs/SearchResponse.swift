/// An object that contains the search region and an array of place descriptions that a search returns.
public struct SearchResponse: Decodable, Sendable {
    /// Represents a rectangular region on a map expressed as south-west and north-east points.
    ///
    /// More specifically south latitude, west longitude, north latitude and east longitude.
    public let displayMapRegion: MapRegion?

    public let paginationInfo: PaginationInfo?

    /// An array of ``Place`` results.
    public let results: [Place]?
}

extension SearchResponse {
    /// An object that returns a page of search responses.
    public struct PaginationInfo: Decodable, Sendable {
        /// An opaque string that the server uses to fetch the next page of search responses.
        public let nextPageToken: String?

        /// An opaque string that the server uses to fetch the previous page of search responses.
        public let prevPageToken: String?

        /// The total number of pages for the request.
        public let totalPageCount: Int?

        /// The total number of results for the request.
        public let totalResults: Int?
    }
}
