/// An enumerated string that indicates the result type for the search autocomplete request.
public enum SearchResultType: String, Sendable {
    /// A physical feature or a point of interest.
    case poi

    /// An address such as a street address, suburb, city, state, or country.
    case address

    /// A natural physical feature, such as a river, mountain, or delta.
    case physicalFeature

    /// A point of interest such as a cafe or grocery store.
    case pointOfInterest

    /// A search query string.
    ///
    /// > Note: This result type is only available for auto complete search requests.
    case query
}

/// A value that indicates the importance of the configured region.
public enum SearchRegionPriority: String, Sendable {
    case `default`
    case required
}

/// Search categories related to political geographical boundaries.
public enum AddressCategory: String, Sendable {
    /// Countries and regions.
    case country = "Country"

    /// The primary administrative divisions of countries or regions.
    case administrativeArea = "AdministrativeArea"

    /// The secondary administrative divisions of countries or regions.
    case subAdministrativeArea = "SubAdministrativeArea"

    /// Local administrative divisions, postal cities and populated places.
    case locality = "Locality"

    /// Local administrative sub-divisions, postal city sub-districts, and neighborhoods.
    case subLocality = "SubLocality"

    /// A code assigned to addresses for mail sorting and delivery.
    case postalCode = "PostalCode"
}
