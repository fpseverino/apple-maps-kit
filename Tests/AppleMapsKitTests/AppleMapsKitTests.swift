import Testing
import Foundation
import AsyncHTTPClient
import AppleMapsKit

struct AppleMapsKitTests {
    var client: AppleMapsClient

    init() async throws {
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

    @Test(arguments: zip([(37.78, -122.42), nil], [nil, (38, -122.1, 37.5, -122.5)]))
    func geocode(
        searchLocation: (latitude: Double, longitude: Double)?,
        searchRegion: (northLatitude: Double, eastLongitude: Double, southLatitude: Double, westLongitude: Double)?
    ) async throws {
        let places = try await client.geocode(
            address: "1 Apple Park, Cupertino, CA",
            limitToCountries: ["US", "CA"],
            lang: "en-US",
            searchLocation: searchLocation,
            searchRegion: searchRegion,
            userLocation: (latitude: 37.78, longitude: -122.42)
        )
        #expect(!places.isEmpty)
    }

    @Test func reverseGeocode() async throws {
        let places = try await client.reverseGeocode(latitude: 37.33182, longitude: -122.03118, lang: "en-US")
        #expect(!places.isEmpty)
    }

    @Test(arguments: zip([(37.7857, -122.4011), nil], [nil, (38, -122.1, 37.5, -122.5)]))
    func directions(
        searchLocation: (latitude: Double, longitude: Double)?,
        searchRegion: (northLatitude: Double, eastLongitude: Double, southLatitude: Double, westLongitude: Double)?
    ) async throws {
        let arrivalDirections = try await client.directions(
            from: "37.7857,-122.4011",
            to: "San Francisco City Hall, CA",
            arrivalDate: Date(timeIntervalSinceNow: 3600),
            avoid: [.tolls],
            lang: "en-US",
            requestsAlternateRoutes: true,
            searchLocation: searchLocation,
            searchRegion: searchRegion,
            transportType: .walking,
            userLocation: (latitude: 37.78, longitude: -122.42)
        )
        let arrivalRoutes = try #require(arrivalDirections.routes)
        #expect(!arrivalRoutes.isEmpty)

        let departureDirections = try await client.directions(
            from: "37.7857,-122.4011",
            to: "San Francisco City Hall, CA",
            avoid: [.tolls],
            departureDate: Date(timeIntervalSinceNow: 3600),
            lang: "en-US",
            requestsAlternateRoutes: true,
            searchLocation: searchLocation,
            searchRegion: searchRegion,
            transportType: .walking,
            userLocation: (latitude: 37.78, longitude: -122.42)
        )
        let departureRoutes = try #require(departureDirections.routes)
        #expect(!departureRoutes.isEmpty)
    }

    @Test(arguments: zip([Date(timeIntervalSinceNow: 3600), nil], [nil, Date(timeIntervalSinceNow: 3600)]))
    func eta(arrivalDate: Date?, departureDate: Date?) async throws {
        let etaResponse = try await client.eta(
            from: (latitude: 37.331423, longitude: -122.030503),
            to: [
                (latitude: 37.32556561130194, longitude: -121.94635203581443),
                (latitude: 37.44176585512703, longitude: -122.17259315798667)
            ],
            transportType: .transit,
            departureDate: departureDate,
            arrivalDate: arrivalDate
        )
        let etas = try #require(etaResponse.etas)
        #expect(!etas.isEmpty)
    }

    @Test(arguments: zip([Date(timeIntervalSinceNow: 3600), nil], [nil, Date(timeIntervalSinceNow: 3600)]))
    func etaBetweenAddresses(arrivalDate: Date?, departureDate: Date?) async throws {
        let etaResponse = try await client.etaBetweenAddresses(
            from: "San Francisco City Hall, CA",
            to: ["Golden Gate Park, San Francisco"],
            transportType: .transit,
            departureDate: departureDate,
            arrivalDate: arrivalDate
        )
        let etas = try #require(etaResponse.etas)
        #expect(!etas.isEmpty)
    }
}
