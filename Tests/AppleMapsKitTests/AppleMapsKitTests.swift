import XCTest
import AsyncHTTPClient
import AppleMapsKit

final class AppleMapsKitTests: XCTestCase {
    private var client: AppleMapsClient!

    override func setUp() async throws {
        // TODO: Replace the following values with valid ones.
        client = try await AppleMapsClient(
            httpClient: HTTPClient.shared,
            teamID: "DEF123GHIJ",
            keyID: "ABC123DEFG",
            key: """
            -----BEGIN PRIVATE KEY-----
            MIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQgevZzL1gdAFr88hb2
            OF/2NxApJCzGCEDdfSp6VQO30hyhRANCAAQRWz+jn65BtOMvdyHKcvjBeBSDZH2r
            1RTwjmYSi9R/zpBnuQ4EiMnCqfMPWiZqB4QdbAd0E7oH50VpuZ1P087G
            -----END PRIVATE KEY-----
            """
        )
    }

    func testGeocode() async throws {
        let locationPlaces = try await client.geocode(
            address: "1 Apple Park, Cupertino, CA",
            limitToCountries: ["US", "CA"],
            lang: "en-US",
            searchLocation: (latitude: 37.78, longitude: -122.42),
            userLocation: (latitude: 37.78, longitude: -122.42)
        )
        XCTAssertFalse(locationPlaces.isEmpty)

        let regionPlaces = try await client.geocode(
            address: "1 Apple Park, Cupertino, CA",
            limitToCountries: ["US", "CA"],
            lang: "en-US",
            searchRegion: (northLatitude: 38, eastLongitude: -122.1, southLatitude: 37.5, westLongitude: -122.5),
            userLocation: (latitude: 37.78, longitude: -122.42)
        )
        XCTAssertFalse(regionPlaces.isEmpty)
    }

    func testReverseGeocode() async throws {
        let places = try await client.reverseGeocode(latitude: 37.33182, longitude: -122.03118, lang: "en-US")
        XCTAssertFalse(places.isEmpty)
    }

    func testDirections() async throws {
        let locationArrivalDirections = try await client.directions(
            origin: "37.7857,-122.4011",
            destination: "San Francisco City Hall, CA",
            arrivalDate: Date(timeIntervalSinceNow: 3600),
            avoid: ["Tolls"],
            lang: "en-US",
            requestsAlternateRoutes: true,
            searchLocation: (latitude: 37.7857, longitude: -122.4011),
            transportType: .walking,
            userLocation: (latitude: 37.78, longitude: -122.42)
        )
        XCTAssertFalse(locationArrivalDirections.routes!.isEmpty)

        let regionArrivalDirections = try await client.directions(
            origin: "37.7857,-122.4011",
            destination: "San Francisco City Hall, CA",
            arrivalDate: Date(timeIntervalSinceNow: 3600),
            avoid: ["Tolls"],
            lang: "en-US",
            requestsAlternateRoutes: true,
            searchRegion: (northLatitude: 38, eastLongitude: -122.1, southLatitude: 37.5, westLongitude: -122.5),
            transportType: .walking,
            userLocation: (latitude: 37.78, longitude: -122.42)
        )
        XCTAssertFalse(regionArrivalDirections.routes!.isEmpty)

        let locationDepartureDirections = try await client.directions(
            origin: "37.7857,-122.4011",
            destination: "San Francisco City Hall, CA",
            avoid: ["Tolls"],
            departureDate: Date(timeIntervalSinceNow: 3600),
            lang: "en-US",
            requestsAlternateRoutes: true,
            searchLocation: (latitude: 37.7857, longitude: -122.4011),
            transportType: .walking,
            userLocation: (latitude: 37.78, longitude: -122.42)
        )
        XCTAssertFalse(locationDepartureDirections.routes!.isEmpty)

        let regionDepartureDirections = try await client.directions(
            origin: "37.7857,-122.4011",
            destination: "San Francisco City Hall, CA",
            avoid: ["Tolls"],
            departureDate: Date(timeIntervalSinceNow: 3600),
            lang: "en-US",
            requestsAlternateRoutes: true,
            searchRegion: (northLatitude: 38, eastLongitude: -122.1, southLatitude: 37.5, westLongitude: -122.5),
            transportType: .walking,
            userLocation: (latitude: 37.78, longitude: -122.42)
        )
        XCTAssertFalse(regionDepartureDirections.routes!.isEmpty)
    }
}
