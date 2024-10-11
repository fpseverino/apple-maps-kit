/// An object that describes a place in terms of a variety of spatial, administrative, and qualitative properties.
public struct Place: Codable, Sendable {
    /// The country or region of the place.
    public let country: String?

    /// The 2-letter country code of the place.
    public let countryCode: String?

    /// The geographic region associated with the place.
    ///
    /// This is a rectangular region on a map expressed as south-west and north-east points.
    /// Specifically south latitude, west longitude, north latitude, and east longitude.
    public let displayMapRegion: MapRegion?

    /// The address of the place, formatted using its conventions of its country or region.
    public let formattedAddressLines: [String]?

    /// A place name that you can use for display purposes.
    public let name: String?

    /// The latitude and longitude of this place.
    public let coordinate: Location?

    /// A ``StructuredAddress`` object that describes details of the place’s address.
    public let structuredAddress: StructuredAddress?

    /// A list of alternate Place IDs for the `id`.
    public let alternateIds: [String]?

    /// An opaque string that identifies a place.
    public let id: String?

    /// A string that describes a specific place of interest (POI) category.
    public let poiCategory: PoiCategory?
}

/// An object that describes a location in terms of its longitude and latitude.
public struct Location: Codable, Sendable {
    /// A double value that describes the latitude of the coordinate.
    public let latitude: Double?

    /// A double value that describes the longitude of the coordinate.
    public let longitude: Double?
}

/// An object that describes the detailed address components of a place.
public struct StructuredAddress: Codable, Sendable {
    /// The state or province of the place.
    public let administrativeArea: String?

    /// The short code for the state or area.
    public let administrativeAreaCode: String?

    /// Common names of the area in which the place resides.
    public let areasOfInterest: [String]?

    /// Common names for the local area or neighborhood of the place.
    public let dependentLocalities: [String]?

    /// A combination of thoroughfare and subthoroughfare.
    public let fullThoroughfare: String?

    /// The city of the place.
    public let locality: String?

    /// The postal code of the place.
    public let postCode: String?

    /// The name of the area within the locality.
    public let subLocality: String?

    /// The number on the street at the place.
    public let subThoroughfare: String?

    /// The street name at the place.
    public let thoroughfare: String?
}

/// An object that contains an array of places.
struct PlaceResults: Codable {
    /// An array of one or more ``Place`` objects.
    let results: [Place]?
}
