/// An object that describes an area to search in terms of its upper-right and lower-left corners as a pair of geographic points.
public struct MapRegion: Codable, Sendable {
    /// A double value that describes the east longitude of the map region.
    public let eastLongitude: Double?

    /// A double value that describes the north latitude of the map region.
    public let northLatitude: Double?

    /// A double value that describes the south latitude of the map region.
    public let southLatitude: Double?

    /// A double value that describes the west longitude of the map region.
    public let westLongitude: Double?

    public init(
        northLatitude: Double,
        eastLongitude: Double,
        southLatitude: Double,
        westLongitude: Double
    ) {
        self.northLatitude = northLatitude
        self.eastLongitude = eastLongitude
        self.southLatitude = southLatitude
        self.westLongitude = westLongitude
    }

    var toString: String? {
        guard let northLatitude,
            let eastLongitude,
            let southLatitude,
            let westLongitude
        else {
            return nil
        }
        return "\(northLatitude),\(eastLongitude),\(southLatitude),\(westLongitude)"
    }
}
