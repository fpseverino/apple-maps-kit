import AsyncHTTPClient
import Foundation
import JWTKit
import NIOCore
import NIOFoundationCompat
import NIOHTTP1

/// Methods to make calls to APIs such as geocode, search, and so on.
public struct AppleMapsClient: Sendable {
    static let apiServer = "https://maps-api.apple.com"
    private let httpClient: HTTPClient
    private let accessToken: String

    private let decoder = JSONDecoder()

    /// Initializes a new `AppleMapsClient` instance.
    ///
    /// > Note: The Maps access token is valid for 30 minutes.
    ///
    /// - Parameters:
    ///   - httpClient: The HTTP client to use.
    ///   - teamID: A 10-character Team ID obtained from your Apple Developer account.
    ///   - keyID: A 10-character key identifier that provides the ID of the private key that you obtain from your Apple Developer account.
    ///   - key: A MapKit JS private key.
    public init(httpClient: HTTPClient, teamID: String, keyID: String, key: String) async throws {
        self.httpClient = httpClient
        self.accessToken = try await Self.getAccessToken(
            httpClient: httpClient,
            authToken: Self.createJWT(teamID: teamID, keyID: keyID, key: key)
        )
    }

    /// Returns the latitude and longitude of the address you specify.
    ///
    /// > Note: You can't specify both `searchLocation` and `searchRegion` in the same request.
    ///
    /// - Parameters:
    ///   - address: Address to geocode.
    ///   - limitToCountries: A list of two-letter ISO 3166-1 codes to limit the results to.
    ///   - lang: The language the server should use when returning the response, specified using a BCP 47 language code.
    ///   - searchLocation: A location defined by the application as a hint.
    ///   - searchRegion: A region the app defines as a hint.
    ///   - userLocation: The location of the user.
    ///
    /// - Returns: An array of ``Place`` objects.
    public func geocode(
        address: String,
        limitToCountries: [String]? = nil,
        lang: String? = nil,
        searchLocation: (latitude: Double, longitude: Double)? = nil,
        searchRegion: MapRegion? = nil,
        userLocation: (latitude: Double, longitude: Double)? = nil
    ) async throws -> [Place] {
        var url = URL(string: "\(Self.apiServer)/v1/geocode")!
        var queries: [URLQueryItem] = [URLQueryItem(name: "q", value: address)]
        if let limitToCountries {
            queries.append(URLQueryItem(name: "limitToCountries", value: limitToCountries.joined(separator: ",")))
        }
        if let lang {
            queries.append(URLQueryItem(name: "lang", value: lang))
        }
        if let searchLocation {
            queries.append(URLQueryItem(name: "searchLocation", value: "\(searchLocation.latitude),\(searchLocation.longitude)"))
        }
        if let searchRegion, let searchRegionString = searchRegion.toString {
            queries.append(URLQueryItem(name: "searchRegion", value: searchRegionString))
        }
        if let userLocation {
            queries.append(URLQueryItem(name: "userLocation", value: "\(userLocation.latitude),\(userLocation.longitude)"))
        }
        url.append(queryItems: queries)
        return try await decoder.decode(PlaceResults.self, from: httpGet(url: url)).results ?? []
    }

    /// Returns an array of addresses present at the coordinates you provide.
    ///
    /// - Parameters:
    ///   - latitude: Latitude value for the coordinate.
    ///   - longitude: Longitude value for the coordinate.
    ///   - lang: The language the server uses when returning the response, specified using a BCP 47 language code.
    ///
    /// - Returns: An array of one or more ``Place`` objects.
    public func reverseGeocode(latitude: Double, longitude: Double, lang: String? = nil) async throws -> [Place] {
        var url = URL(string: "\(Self.apiServer)/v1/reverseGeocode")!
        var queries: [URLQueryItem] = [URLQueryItem(name: "loc", value: "\(latitude),\(longitude)")]
        if let lang {
            queries.append(URLQueryItem(name: "lang", value: lang))
        }
        url.append(queryItems: queries)
        return try await decoder.decode(PlaceResults.self, from: httpGet(url: url)).results ?? []
    }

    /// Find places by name or by specific search criteria.
    ///
    /// > Note: You can't specify both `searchLocation` and `searchRegion` in the same request.
    ///
    /// - Parameters:
    ///   - place: The place to search for. For example, `eiffel tower`.
    ///   - excludePoiCategories: A list of the points of interest to exclude from the search results.
    ///   - includePoiCategories: A list of the points of interest to include in the search results.
    ///   - limitToCountries: A list of two-letter ISO 3166-1 codes of the countries to limit the results to.
    ///   - resultTypeFilter: A list of strings that describes the kind of result types to include in the response.
    ///   - lang: The language the server should use when returning the response, specified using a BCP 47 language code.
    ///   - searchLocation: A location defined by the application as a hint.
    ///   - searchRegion: A region the app defines as a hint.
    ///   - userLocation: The location of the user.
    ///   - searchRegionPriority: A value that indicates the importance of the configured region.
    ///   - enablePagination: A value that tells the server that we expect paginated results.
    ///   - pageToken: A value that indicates which page of results to return.
    ///   - includeAddressCategories: A list of strings that describes the addresses to include in the search results.
    ///   - excludeAddressCategories: A list of strings that describes the addresses to exclude in the search results.
    ///
    /// - Returns: Returns a ``MapRegion`` that describes a region that encloses the results, and an array of ``SearchResponse`` objects that describes the results of the search.
    public func search(
        for place: String,
        excludePoiCategories: [PoiCategory]? = nil,
        includePoiCategories: [PoiCategory]? = nil,
        limitToCountries: [String]? = nil,
        resultTypeFilter: [SearchResultType]? = nil,
        lang: String? = nil,
        searchLocation: (latitude: Double, longitude: Double)? = nil,
        searchRegion: MapRegion? = nil,
        userLocation: (latitude: Double, longitude: Double)? = nil,
        searchRegionPriority: SearchRegionPriority? = nil,
        enablePagination: Bool? = nil,
        pageToken: String? = nil,
        includeAddressCategories: [AddressCategory]? = nil,
        excludeAddressCategories: [AddressCategory]? = nil
    ) async throws -> SearchResponse {
        var url = URL(string: "\(Self.apiServer)/v1/search")!
        var queries: [URLQueryItem] = [URLQueryItem(name: "q", value: place)]
        if let excludePoiCategories {
            queries.append(
                URLQueryItem(name: "excludePoiCategories", value: excludePoiCategories.map { $0.rawValue }.joined(separator: ","))
            )
        }
        if let includePoiCategories {
            queries.append(
                URLQueryItem(name: "includePoiCategories", value: includePoiCategories.map { $0.rawValue }.joined(separator: ","))
            )
        }
        if let limitToCountries {
            queries.append(URLQueryItem(name: "limitToCountries", value: limitToCountries.joined(separator: ",")))
        }
        if let resultTypeFilter {
            try queries.append(
                URLQueryItem(
                    name: "resultTypeFilter",
                    value: resultTypeFilter.map {
                        guard $0 != .query else {
                            throw AppleMapsKitError.invalidSearchResultType
                        }
                        return $0.rawValue
                    }
                    .joined(separator: ",")
                )
            )
        }
        if let lang {
            queries.append(URLQueryItem(name: "lang", value: lang))
        }
        if let searchLocation {
            queries.append(URLQueryItem(name: "searchLocation", value: "\(searchLocation.latitude),\(searchLocation.longitude)"))
        }
        if let searchRegion, let searchRegionString = searchRegion.toString {
            queries.append(URLQueryItem(name: "searchRegion", value: searchRegionString))
        }
        if let userLocation {
            queries.append(URLQueryItem(name: "userLocation", value: "\(userLocation.latitude),\(userLocation.longitude)"))
        }
        if let searchRegionPriority {
            queries.append(URLQueryItem(name: "searchRegionPriority", value: searchRegionPriority.rawValue))
        }
        if let enablePagination {
            queries.append(URLQueryItem(name: "enablePagination", value: "\(enablePagination)"))
        }
        if let pageToken {
            queries.append(URLQueryItem(name: "pageToken", value: pageToken))
        }
        if let includeAddressCategories {
            queries.append(
                URLQueryItem(name: "includeAddressCategories", value: includeAddressCategories.map { $0.rawValue }.joined(separator: ","))
            )
        }
        if let excludeAddressCategories {
            queries.append(
                URLQueryItem(name: "excludeAddressCategories", value: excludeAddressCategories.map { $0.rawValue }.joined(separator: ","))
            )
        }
        url.append(queryItems: queries)
        return try await decoder.decode(SearchResponse.self, from: httpGet(url: url))
    }

    /// Find results that you can use to autocomplete searches.
    ///
    /// > Note: You can't specify both `searchLocation` and `searchRegion` in the same request.
    ///
    /// - Parameters:
    ///   - place: The place to search for. For example, `eiffel`.
    ///   - excludePoiCategories: A list of the points of interest to exclude from the search results.
    ///   - includePoiCategories: A list of the points of interest to include in the search results.
    ///   - limitToCountries: A list of two-letter ISO 3166-1 codes of the countries to limit the results to.
    ///   - resultTypeFilter: A list of strings that describes the kind of result types to include in the response.
    ///   - lang: The language the server should use when returning the response, specified using a BCP 47 language code.
    ///   - searchLocation: A location defined by the application as a hint.
    ///   - searchRegion: A region the app defines as a hint.
    ///   - userLocation: The location of the user.
    ///   - searchRegionPriority: A value that indicates the importance of the configured region.
    ///   - includeAddressCategories: A list of strings that describes the addresses to include in the search results.
    ///   - excludeAddressCategories: A list of strings that describes the addresses to exclude in the search results.
    ///
    /// - Returns: Returns a list of ``AutocompleteResult``.
    public func searchAutoComplete(
        for place: String,
        excludePoiCategories: [PoiCategory]? = nil,
        includePoiCategories: [PoiCategory]? = nil,
        limitToCountries: [String]? = nil,
        resultTypeFilter: [SearchResultType]? = nil,
        lang: String? = nil,
        searchLocation: (latitude: Double, longitude: Double)? = nil,
        searchRegion: MapRegion? = nil,
        userLocation: (latitude: Double, longitude: Double)? = nil,
        searchRegionPriority: SearchRegionPriority? = nil,
        includeAddressCategories: [AddressCategory]? = nil,
        excludeAddressCategories: [AddressCategory]? = nil
    ) async throws -> [AutocompleteResult] {
        var url = URL(string: "\(Self.apiServer)/v1/searchAutocomplete")!
        var queries: [URLQueryItem] = [URLQueryItem(name: "q", value: place)]
        if let excludePoiCategories {
            queries.append(
                URLQueryItem(name: "excludePoiCategories", value: excludePoiCategories.map { $0.rawValue }.joined(separator: ","))
            )
        }
        if let includePoiCategories {
            queries.append(
                URLQueryItem(name: "includePoiCategories", value: includePoiCategories.map { $0.rawValue }.joined(separator: ","))
            )
        }
        if let limitToCountries {
            queries.append(URLQueryItem(name: "limitToCountries", value: limitToCountries.joined(separator: ",")))
        }
        if let resultTypeFilter {
            queries.append(URLQueryItem(name: "resultTypeFilter", value: resultTypeFilter.map { $0.rawValue }.joined(separator: ",")))
        }
        if let lang {
            queries.append(URLQueryItem(name: "lang", value: lang))
        }
        if let searchLocation {
            queries.append(URLQueryItem(name: "searchLocation", value: "\(searchLocation.latitude),\(searchLocation.longitude)"))
        }
        if let searchRegion, let searchRegionString = searchRegion.toString {
            queries.append(URLQueryItem(name: "searchRegion", value: searchRegionString))
        }
        if let userLocation {
            queries.append(URLQueryItem(name: "userLocation", value: "\(userLocation.latitude),\(userLocation.longitude)"))
        }
        if let searchRegionPriority {
            queries.append(URLQueryItem(name: "searchRegionPriority", value: searchRegionPriority.rawValue))
        }
        if let includeAddressCategories {
            queries.append(
                URLQueryItem(name: "includeAddressCategories", value: includeAddressCategories.map { $0.rawValue }.joined(separator: ","))
            )
        }
        if let excludeAddressCategories {
            queries.append(
                URLQueryItem(name: "excludeAddressCategories", value: excludeAddressCategories.map { $0.rawValue }.joined(separator: ","))
            )
        }
        url.append(queryItems: queries)
        return try await decoder.decode(SearchAutocompleteResponse.self, from: httpGet(url: url)).results ?? []
    }

    /// Find directions by specific criteria.
    ///
    /// > Note: You can't specify both `searchLocation` and `searchRegion` in the same request.
    ///
    /// > Note: You can't specify both `arrivalDate` and `departureDate` in the same request.
    ///
    /// - Parameters:
    ///   - origin: The starting location as an address, or coordinates you specify as latitude, longitude.
    ///   - destination: The destination as an address, or coordinates you specify as latitude, longitude.
    ///   - arrivalDate: The date and time to arrive at the destination.
    ///   - avoid: A list of the features to avoid when calculating direction routes.
    ///   - departureDate: The date and time to depart from the origin.
    ///   - lang: The language the server uses when returning the response, specified using a BCP 47 language code.
    ///   - requestsAlternateRoutes: When you set this to `true`, the server returns additional routes, when available.
    ///   - searchLocation: A `searchLocation` the app defines as a hint for the query input for `origin` or `destination`.
    ///   - searchRegion: A region the app defines as a hint for the query input for `origin` or `destination`.
    ///   - transportType: The mode of transportation the server returns directions for.
    ///   - userLocation: The location of the user.
    ///
    /// - Returns: Returns a ``DirectionsResponse`` result that describes the steps and routes from the origin to the destination.
    public func directions(
        from origin: String,
        to destination: String,
        arrivalDate: Date? = nil,
        avoid: [DirectionsAvoid]? = nil,
        departureDate: Date? = nil,
        lang: String? = nil,
        requestsAlternateRoutes: Bool? = nil,
        searchLocation: (latitude: Double, longitude: Double)? = nil,
        searchRegion: MapRegion? = nil,
        transportType: DirectionsTransportType? = nil,
        userLocation: (latitude: Double, longitude: Double)? = nil
    ) async throws -> DirectionsResponse {
        var url = URL(string: "\(Self.apiServer)/v1/directions")!
        var queries: [URLQueryItem] = [
            URLQueryItem(name: "origin", value: origin),
            URLQueryItem(name: "destination", value: destination),
        ]
        if let arrivalDate {
            queries.append(
                URLQueryItem(
                    name: "arrivalDate",
                    value: arrivalDate.formatted(
                        .iso8601
                            .year()
                            .month()
                            .day()
                            .timeZone(separator: .omitted)
                            .time(includingFractionalSeconds: true)
                            .timeSeparator(.colon)
                    )
                )
            )
        }
        if let avoid {
            queries.append(URLQueryItem(name: "avoid", value: avoid.map { $0.rawValue }.joined(separator: ",")))
        }
        if let departureDate {
            queries.append(
                URLQueryItem(
                    name: "departureDate",
                    value: departureDate.formatted(
                        .iso8601
                            .year()
                            .month()
                            .day()
                            .timeZone(separator: .omitted)
                            .time(includingFractionalSeconds: true)
                            .timeSeparator(.colon)
                    )
                )
            )
        }
        if let lang {
            queries.append(URLQueryItem(name: "lang", value: lang))
        }
        if let requestsAlternateRoutes {
            queries.append(
                URLQueryItem(name: "requestsAlternateRoutes", value: "\(requestsAlternateRoutes)"))
        }
        if let searchLocation {
            queries.append(URLQueryItem(name: "searchLocation", value: "\(searchLocation.latitude),\(searchLocation.longitude)"))
        }
        if let searchRegion, let searchRegionString = searchRegion.toString {
            queries.append(URLQueryItem(name: "searchRegion", value: searchRegionString))
        }
        if let transportType {
            queries.append(URLQueryItem(name: "transportType", value: transportType.rawValue))
        }
        if let userLocation {
            queries.append(URLQueryItem(name: "userLocation", value: "\(userLocation.latitude),\(userLocation.longitude)"))
        }
        url.append(queryItems: queries)
        return try await decoder.decode(DirectionsResponse.self, from: httpGet(url: url))
    }

    /// Returns the estimated time of arrival (ETA) and distance between starting and ending locations.
    ///
    /// > Note: You can't specify both `arrivalDate` and `departureDate` in the same request.
    ///
    /// - Parameters:
    ///   - origin: The starting point for estimated arrival time requests.
    ///   - destinations: Destination coordinates represented as pairs of latitude and longitude.
    ///   - transportType: The mode of transportation to use when estimating arrival times.
    ///   - departureDate: The time of departure to use in an estimated arrival time request.
    ///   - arrivalDate: The intended time of arrival.
    ///
    /// - Returns: An array of ``Eta`` objects that contain distance and time from the origin to each destination.
    public func eta(
        from origin: (latitude: Double, longitude: Double),
        to destinations: [(latitude: Double, longitude: Double)],
        transportType: EtaTransportType? = nil,
        departureDate: Date? = nil,
        arrivalDate: Date? = nil
    ) async throws -> [Eta] {
        var url = URL(string: "\(Self.apiServer)/v1/etas")!
        var queries: [URLQueryItem] = [
            URLQueryItem(name: "origin", value: "\(origin.latitude),\(origin.longitude)"),
            URLQueryItem(
                name: "destinations",
                value: destinations.map { "\($0.latitude),\($0.longitude)" }.joined(separator: "|")),
        ]
        if let transportType {
            queries.append(URLQueryItem(name: "transportType", value: transportType.rawValue))
        }
        if let departureDate {
            queries.append(
                URLQueryItem(
                    name: "departureDate",
                    value: departureDate.formatted(
                        .iso8601
                            .year()
                            .month()
                            .day()
                            .timeZone(separator: .omitted)
                            .time(includingFractionalSeconds: true)
                            .timeSeparator(.colon)
                    )
                )
            )
        }
        if let arrivalDate {
            queries.append(
                URLQueryItem(
                    name: "arrivalDate",
                    value: arrivalDate.formatted(
                        .iso8601
                            .year()
                            .month()
                            .day()
                            .timeZone(separator: .omitted)
                            .time(includingFractionalSeconds: true)
                            .timeSeparator(.colon)
                    )
                )
            )
        }
        url.append(queryItems: queries)
        return try await decoder.decode(EtaResponse.self, from: httpGet(url: url)).etas ?? []
    }

    /// Returns the estimated time of arrival (ETA) and distance between starting and ending locations.
    ///
    /// > Note: You can't specify both `arrivalDate` and `departureDate` in the same request.
    ///
    /// - Parameters:
    ///   - origin: The starting address for estimated arrival time requests.
    ///   - destinations: Destination coordinates represented as a list of addresses.
    ///   - transportType: The mode of transportation to use when estimating arrival times.
    ///   - departureDate: The time of departure to use in an estimated arrival time request.
    ///   - arrivalDate: The intended time of arrival.
    ///
    /// - Returns: An array of ``Eta`` objects that contain distance and time from the origin to each destination.
    public func etaBetweenAddresses(
        from origin: String,
        to destinations: [String],
        transportType: EtaTransportType? = nil,
        departureDate: Date? = nil,
        arrivalDate: Date? = nil
    ) async throws -> [Eta] {
        var destinationCoordinates: [(latitude: Double, longitude: Double)] = []
        for destination in destinations {
            try await destinationCoordinates.append(self.getCoordinate(from: destination))
        }

        return try await self.eta(
            from: self.getCoordinate(from: origin),
            to: destinationCoordinates,
            transportType: transportType,
            departureDate: departureDate,
            arrivalDate: arrivalDate
        )
    }

    /// Makes an HTTP GET request.
    ///
    /// - Parameter url: URL for the request.
    ///
    /// - Returns: HTTP response object.
    ///
    /// - Throws: Error response object.
    private func httpGet(url: URL) async throws -> ByteBuffer {
        var headers = HTTPHeaders()
        headers.add(name: "Authorization", value: "Bearer \(accessToken)")

        var request = HTTPClientRequest(url: url.absoluteString)
        request.headers = headers

        let response = try await httpClient.execute(request, timeout: .seconds(30))

        if response.status == .ok {
            return try await response.body.collect(upTo: 1024 * 1024)
        } else {
            throw try await decoder.decode(ErrorResponse.self, from: response.body.collect(upTo: 1024 * 1024))
        }
    }

    /// Converts an address to a coordinate.
    ///
    /// - Parameter address: Address for which coordinate should be found.
    ///
    /// - Throws: ``AppleMapsKitError/noPlacesFound`` if no places are found.
    ///
    /// - Returns: A tuple representing coordinate.
    private func getCoordinate(from address: String) async throws -> (latitude: Double, longitude: Double) {
        let places = try await geocode(address: address)
        guard let coordinate = places.first?.coordinate,
            let latitude = coordinate.latitude,
            let longitude = coordinate.longitude
        else {
            throw AppleMapsKitError.noPlacesFound
        }
        return (latitude, longitude)
    }
}

// MARK: - auth/c & auth/z
extension AppleMapsClient {
    /// Creates a JWT token, which is auth token in this context.
    ///
    /// - Parameters:
    ///   - teamID: A 10-character Team ID obtained from your Apple Developer account.
    ///   - keyID: A 10-character key identifier that provides the ID of the private key that you obtain from your Apple Developer account.
    ///   - key: A MapKit JS private key.
    ///
    /// - Returns: A JWT token represented as `String`.
    private static func createJWT(teamID: String, keyID: String, key: String) async throws -> String {
        let keys = try await JWTKeyCollection().add(ecdsa: ES256PrivateKey(pem: key))

        var header = JWTHeader()
        header.alg = "ES256"
        header.kid = keyID
        header.typ = "JWT"

        struct Payload: JWTPayload {
            let iss: IssuerClaim
            let iat: IssuedAtClaim
            let exp: ExpirationClaim

            func verify(using key: some JWTAlgorithm) throws {
                try self.exp.verifyNotExpired()
            }
        }

        let payload = Payload(
            iss: IssuerClaim(value: teamID),
            iat: IssuedAtClaim(value: Date()),
            exp: .init(value: Date().addingTimeInterval(30 * 60))
        )

        return try await keys.sign(payload, header: header)
    }

    /// Makes an HTTP request to exchange Auth token for Access token.
    ///
    /// - Parameters:
    ///   - httpClient: The HTTP client to use.
    ///   - authToken: The authorization token.
    ///
    /// - Throws: Error response object.
    ///
    /// - Returns: An access token.
    private static func getAccessToken(httpClient: HTTPClient, authToken: String) async throws -> String {
        var headers = HTTPHeaders()
        headers.add(name: "Authorization", value: "Bearer \(authToken)")

        var request = HTTPClientRequest(url: "\(apiServer)/v1/token")
        request.headers = headers

        let response = try await httpClient.execute(request, timeout: .seconds(30))

        if response.status == .ok {
            return try await JSONDecoder()
                .decode(TokenResponse.self, from: response.body.collect(upTo: 1024 * 1024))
                .accessToken
        } else {
            throw try await JSONDecoder().decode(ErrorResponse.self, from: response.body.collect(upTo: 1024 * 1024))
        }
    }
}
