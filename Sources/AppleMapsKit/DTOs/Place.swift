/// An object that describes a place in terms of a variety of spatial, administrative, and qualitative properties.
public struct Place: Decodable, Sendable {
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
}

/// An object that describes a map region in terms of its upper-right and lower-left corners as a pair of geographic points.
public struct MapRegion: Decodable, Sendable {
    /// A double value that describes the east longitude of the map region.
    public let eastLongitude: Double?

    /// A double value that describes the north latitude of the map region.
    public let northLatitude: Double?

    /// A double value that describes the south latitude of the map region.
    public let southLatitude: Double?

    /// A double value that describes the west longitude of the map region.
    public let westLongitude: Double?
}

/// An object that describes a location in terms of its longitude and latitude.
public struct Location: Decodable, Sendable {
    /// A double value that describes the latitude of the coordinate.
    public let latitude: Double?

    /// A double value that describes the longitude of the coordinate.
    public let longitude: Double?
}

/// An object that describes the detailed address components of a place.
public struct StructuredAddress: Decodable, Sendable {
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
struct PlaceResults: Decodable {
    /// An array of one or more ``Place`` objects.
    let results: [Place]?
}