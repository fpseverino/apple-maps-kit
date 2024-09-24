/// An object that contains information you can use to suggest addresses and further refine search results.
public struct AutocompleteResult: Decodable, Sendable {
    /// The relative URI to the `search` endpoint to use to fetch more details pertaining to the result.
    ///
    /// If available, the framework encodes opaque data about the autocomplete result in the completion URL’s `metadata` parameter.
    ///
    /// If clients need to fetch the search result in a certain language,
    /// they’re responsible for specifying the `lang` parameter in the request.
    public let completionUrl: String?

    /// A JSON string array to use to create a long form of display text for the completion result.
    public let displayLines: [String]?

    /// A ``Location`` object that specifies the location of the result in terms of its latitude and longitude.
    public let location: Location?

    /// A ``StructuredAddress`` object that describes the detailed address components of a place.
    public let structuredAddress: StructuredAddress?
}

/// An array of autocomplete results.
struct SearchAutocompleteResponse: Decodable, Sendable {
    /// An array of ``AutocompleteResult`` objects.
    public let results: [AutocompleteResult]?
}
