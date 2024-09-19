/// An object that contains details about an estimated time of arrival (ETA).
public struct Eta: Decodable, Sendable {
    /// The destination as a ``Location``.
    public let destination: Location?

    /// The distance in meters to the destination.
    public let distanceMeters: Int?

    /// The estimated travel time in seconds, including delays due to traffic.
    public let expectedTravelTimeSeconds: Int?

    /// The expected travel time, in seconds, without traffic.
    public let staticTravelTimeSeconds: Int?

    /// A string that represents the mode of transportation for this ETA.
    public let transportType: EtaTransportType?
}

/// An object that contains an array of one or more estimated times of arrival (ETAs).
struct EtaResponse: Decodable, Sendable {
    /// An array of one or more ``EtaResponse/Eta`` objects.
    public let etas: [Eta]?
}

public enum EtaTransportType: String, Decodable, Sendable {
    case automobile = "Automobile"
    case walking = "Walking"
    case transit = "Transit"
}