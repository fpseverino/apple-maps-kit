/// An object that describes the directions from a starting location to a destination in terms routes, steps, and a series of waypoints.
public struct DirectionsResponse: Decodable, Sendable {
    /// A ``Place`` object that describes the destination.
    public let destination: Place?

    /// A ``Place`` result that describes the origin.
    public let origin: Place?

    /// An array of routes.
    /// 
    /// Each route references steps based on indexes into the steps array.
    public let routes: [Route]?

    /// An array of step paths across all steps across all routes.
    /// 
    /// Each step path is a single polyline represented as an array of points.
    /// You reference the step paths by index into the array.
    public let stepPaths: [[Location]]?

    /// An array of all steps across all routes.
    /// 
    /// You reference the route steps by index into this array.
    /// Each step in turn references its path based on indexes into the `stepPaths` array.
    public let steps: [Step]?
}

public enum DirectionsTransportType: String, Decodable, Sendable {
    case automobile = "Automobile"
    case walking = "Walking"
}

/// A list of the features you can request to avoid when calculating directions.
public enum DirectionsAvoid: String, Decodable, Sendable {
    /// When you set `avoid=Tolls`, routes without tolls are higher up in the list of returned routes.
    case tolls = "Tolls"
}

extension DirectionsResponse {
    /// An object that represent the components of a single route.
    public struct Route: Decodable, Sendable {
        /// Total distance that the route covers, in meters.
        public let distanceMeters: Int?

        /// The estimated time to traverse this route in seconds.
        /// 
        /// If you’ve specified a departureDate or arrivalDate,
        /// then the estimated time includes traffic conditions assuming user departs or arrives at that time.
        /// 
        /// If you set neither departureDate or arrivalDate,
        /// then estimated time represents current traffic conditions assuming user departs “now” from the point of origin.
        public let durationSeconds: Int?

        /// When `true`, this route has tolls;
        /// if `false`, this route has no tolls.
        /// 
        /// If the value isn’t defined (”undefined”), the route may or may not have tolls.
        public let hasTolls: Bool?

        /// The route name that you can use for display purposes.
        public let name: String?

        /// An array of integer values that you can use to determine the number steps along this route.
        /// 
        /// Each value in the array corresponds to an index into the steps array.
        public let stepIndexes: [Int]?

        /// A string that represents the mode of transportation the service used to estimate the arrival time.
        /// 
        /// Same as the input query param `transportType` or ``DirectionsTransportType/automobile`` if the input query didn’t specify a transportation type.
        public let transportType: DirectionsTransportType?
    }

    /// An object that represents a step along a route.
    public struct Step: Decodable, Sendable {
        /// Total distance covered by the step, in meters.
        public let distanceMeters: Int?

        /// The estimated time to traverse this step, in seconds.
        public let durationSeconds: Int?

        /// The localized instruction string for this step that you can use for display purposes.
        ///
        /// You can specify the language to receive the response in using the `lang` parameter.
        public let instructions: String?

        /// A pointer to this step’s path. 
        /// 
        /// The pointer is in the form of an index into the stepPaths array contained in a Route.
        /// 
        /// Step paths are self-contained which implies that the last point of a previous step path along a route
        /// is the same as the first point of the next step path.
        /// Clients are responsible for avoiding duplication when rendering the point.
        public let stepPathIndex: Int?

        /// A string indicating the transport type for this step if it’s different from the `transportType` in the route.
        public let transportType: DirectionsTransportType?
    }
}