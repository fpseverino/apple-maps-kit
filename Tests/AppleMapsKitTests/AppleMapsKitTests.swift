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

    @Test(
        "Geocode",
        arguments: zip(
            [(37.78, -122.42), nil],
            [nil, MapRegion(northLatitude: 38, eastLongitude: -122.1, southLatitude: 37.5, westLongitude: -122.5)]
        )
    )
    func geocode(
        searchLocation: (latitude: Double, longitude: Double)?,
        searchRegion: MapRegion?
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

    @Test("Reverse geocode")
    func reverseGeocode() async throws {
        let places = try await client.reverseGeocode(latitude: 37.33182, longitude: -122.03118, lang: "en-US")
        #expect(!places.isEmpty)
    }

    @Test(
        "Search",
        arguments: zip(
            [(37.78, -122.42), nil],
            [nil, MapRegion(northLatitude: 38, eastLongitude: -122.1, southLatitude: 37.5, westLongitude: -122.5)]
        )
    )
    func search(
        searchLocation: (latitude: Double, longitude: Double)?,
        searchRegion: MapRegion?
    ) async throws {
        let searchResponse = try await client.search(
            for: "eiffel tower",
            excludePoiCategories: [.airport],
            includePoiCategories: [.landmark],
            limitToCountries: ["US", "CA"],
            resultTypeFilter: [.pointOfInterest, .physicalFeature, .poi, .address],
            lang: "en-US",
            searchLocation: searchLocation,
            searchRegion: searchRegion,
            userLocation: (latitude: 37.78, longitude: -122.42),
            searchRegionPriority: .default,
            enablePagination: false,
            includeAddressCategories: [.postalCode],
            excludeAddressCategories: [.administrativeArea]
        )
        let results = try #require(searchResponse.results)
        #expect(!results.isEmpty)
    }

    @Test(
        "Search Auto Complete",
        arguments: zip(
            [(37.78, -122.42), nil],
            [nil, MapRegion(northLatitude: 38, eastLongitude: -122.1, southLatitude: 37.5, westLongitude: -122.5)]
        )
    )
    func searchAutoComplete(
        searchLocation: (latitude: Double, longitude: Double)?,
        searchRegion: MapRegion?
    ) async throws {
        let results = try await client.searchAutoComplete(
            for: "eiffel",
            excludePoiCategories: [.airport],
            includePoiCategories: [.landmark],
            limitToCountries: ["US", "CA"],
            resultTypeFilter: [.pointOfInterest, .physicalFeature, .poi, .address, .query],
            lang: "en-US",
            searchLocation: searchLocation,
            searchRegion: searchRegion,
            userLocation: (latitude: 37.78, longitude: -122.42),
            searchRegionPriority: .default,
            includeAddressCategories: [.postalCode],
            excludeAddressCategories: [.administrativeArea]
        )
        #expect(!results.isEmpty)
    }

    @Test(
        "Directions",
        arguments: zip(
            [(37.7857, -122.4011), nil],
            [nil, MapRegion(northLatitude: 38, eastLongitude: -122.1, southLatitude: 37.5, westLongitude: -122.5)]
        )
    )
    func directions(
        searchLocation: (latitude: Double, longitude: Double)?,
        searchRegion: MapRegion?
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

    @Test(
        "ETA",
        arguments: zip(
            [Date(timeIntervalSinceNow: 3600), nil],
            [nil, Date(timeIntervalSinceNow: 3600)]
        )
    )
    func eta(arrivalDate: Date?, departureDate: Date?) async throws {
        let etas = try await client.eta(
            from: (latitude: 37.331423, longitude: -122.030503),
            to: [
                (latitude: 37.32556561130194, longitude: -121.94635203581443),
                (latitude: 37.44176585512703, longitude: -122.17259315798667)
            ],
            transportType: .transit,
            departureDate: departureDate,
            arrivalDate: arrivalDate
        )
        #expect(!etas.isEmpty)
    }

    @Test(
        "ETA between addresses",
        arguments: zip(
            [Date(timeIntervalSinceNow: 3600), nil],
            [nil, Date(timeIntervalSinceNow: 3600)]
        )
    )
    func etaBetweenAddresses(arrivalDate: Date?, departureDate: Date?) async throws {
        let etas = try await client.etaBetweenAddresses(
            from: "San Francisco City Hall, CA",
            to: ["Golden Gate Park, San Francisco"],
            transportType: .transit,
            departureDate: departureDate,
            arrivalDate: arrivalDate
        )
        #expect(!etas.isEmpty)
    }
}
