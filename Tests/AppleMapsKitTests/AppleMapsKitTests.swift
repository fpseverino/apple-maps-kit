import AsyncHTTPClient
import Foundation
import Testing

@testable import AppleMapsKit

@Suite("AppleMapsKit Tests")
struct AppleMapsKitTests {
    var client: AppleMapsClient
    // TODO: Replace with `false` when you have valid credentials.
    var credentialsAreInvalid = true

    init() async throws {
        // TODO: Replace the following values with valid ones.
        client = AppleMapsClient(
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
    func geocode(searchLocation: (latitude: Double, longitude: Double)?, searchRegion: MapRegion?) async throws {
        try await withKnownIssue {
            let places = try await client.geocode(
                address: "1 Apple Park, Cupertino, CA",
                limitToCountries: ["US", "CA"],
                lang: "en-US",
                searchLocation: searchLocation,
                searchRegion: searchRegion,
                userLocation: (latitude: 37.78, longitude: -122.42)
            )
            #expect(!places.isEmpty)
        } when: {
            credentialsAreInvalid
        }
    }

    @Test("Reverse geocode")
    func reverseGeocode() async throws {
        try await withKnownIssue {
            let places = try await client.reverseGeocode(latitude: 37.33182, longitude: -122.03118, lang: "en-US")
            #expect(!places.isEmpty)
        } when: {
            credentialsAreInvalid
        }
    }

    @Test(
        "Search",
        arguments: zip(
            [(37.78, -122.42), nil],
            [nil, MapRegion(northLatitude: 38, eastLongitude: -122.1, southLatitude: 37.5, westLongitude: -122.5)]
        )
    )
    func search(searchLocation: (latitude: Double, longitude: Double)?, searchRegion: MapRegion?) async throws {
        try await withKnownIssue {
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
        } when: {
            credentialsAreInvalid
        }
    }

    @Test("Search with invalid Result Type") func searchWithInvalidResultType() async throws {
        await #expect {
            try await client.search(
                for: "eiffel tower",
                resultTypeFilter: [.pointOfInterest, .physicalFeature, .poi, .address, .query]
            )
        } throws: { error in
            guard let error = error as? AppleMapsKitError else { return false }
            return error.errorType.base == .invalidSearchResultType
        }
    }

    @Test("Search with Page Token") func searchWithPageToken() async throws {
        await withKnownIssue {
            let searchResponse = try await client.search(
                for: "eiffel tower",
                resultTypeFilter: [.pointOfInterest, .physicalFeature, .poi, .address],
                lang: "en-US",
                enablePagination: true,
                pageToken: "test"
            )
            let results = try #require(searchResponse.results)
            #expect(!results.isEmpty)
        }
    }

    @Test(
        "Search Auto Complete",
        arguments: zip(
            [(37.78, -122.42), nil],
            [nil, MapRegion(northLatitude: 38, eastLongitude: -122.1, southLatitude: 37.5, westLongitude: -122.5)]
        )
    )
    func searchAutoComplete(searchLocation: (latitude: Double, longitude: Double)?, searchRegion: MapRegion?) async throws {
        try await withKnownIssue {
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
        } when: {
            credentialsAreInvalid
        }
    }

    @Test(
        "Directions",
        arguments: zip(
            [(37.7857, -122.4011), nil],
            [nil, MapRegion(northLatitude: 38, eastLongitude: -122.1, southLatitude: 37.5, westLongitude: -122.5)]
        )
    )
    func directions(searchLocation: (latitude: Double, longitude: Double)?, searchRegion: MapRegion?) async throws {
        try await withKnownIssue {
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
        } when: {
            credentialsAreInvalid
        }

        try await withKnownIssue {
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
        } when: {
            credentialsAreInvalid
        }
    }

    @Test("ETA", arguments: zip([Date(timeIntervalSinceNow: 3600), nil], [nil, Date(timeIntervalSinceNow: 3600)]))
    func eta(arrivalDate: Date?, departureDate: Date?) async throws {
        try await withKnownIssue {
            let etas = try await client.eta(
                from: (latitude: 37.331423, longitude: -122.030503),
                to: [
                    (latitude: 37.32556561130194, longitude: -121.94635203581443),
                    (latitude: 37.44176585512703, longitude: -122.17259315798667),
                ],
                transportType: .transit,
                departureDate: departureDate,
                arrivalDate: arrivalDate
            )
            #expect(!etas.isEmpty)
        } when: {
            credentialsAreInvalid
        }
    }

    @Test("ETA between addresses", arguments: zip([Date(timeIntervalSinceNow: 3600), nil], [nil, Date(timeIntervalSinceNow: 3600)]))
    func etaBetweenAddresses(arrivalDate: Date?, departureDate: Date?) async throws {
        try await withKnownIssue {
            let etas = try await client.etaBetweenAddresses(
                from: "San Francisco City Hall, CA",
                to: ["Golden Gate Park, San Francisco"],
                transportType: .transit,
                departureDate: departureDate,
                arrivalDate: arrivalDate
            )
            #expect(!etas.isEmpty)
        } when: {
            credentialsAreInvalid
        }
    }

    @Test("Place") func place() async throws {
        try await withKnownIssue {
            let place = try await client.place(id: "I7C250D2CDCB364A", lang: "en-US")
            #expect(place != nil)
        } when: {
            credentialsAreInvalid
        }
    }

    @Test("Places") func places() async throws {
        try await withKnownIssue {
            let placesResponse = try await client.places(ids: ["ICFA2FAE5487B94AF", "IA6FD1E86A544F69D"], lang: "en-US")
            let errors = try #require(placesResponse.errors)
            #expect(!errors.isEmpty)
        } when: {
            credentialsAreInvalid
        }
    }

    @Test("Alternate Place IDs") func alternatePlaceIDs() async throws {
        try await withKnownIssue {
            let alternateIDsResponse = try await client.alternatePlaceIDs(ids: ["I7C250D2CDCB364A", "ICFA2FAE5487B94AF"])
            let results = try #require(alternateIDsResponse.results)
            #expect(!results.isEmpty)
        } when: {
            credentialsAreInvalid
        }
    }

    @Test("AppleMapsKitError") func appleMapsKitError() {
        #expect(AppleMapsKitError.noPlacesFound.description == "AppleMapsKitError(errorType: noPlacesFound)")
        #expect(AppleMapsKitError.invalidSearchResultType.description == "AppleMapsKitError(errorType: invalidSearchResultType)")
    }

    @Test("MapRegion.toString") func mapRegionToString() throws {
        let mapRegion = MapRegion(northLatitude: 38, eastLongitude: -122.1, southLatitude: 37.5, westLongitude: -122.5)
        #expect(mapRegion.toString == "38.0,-122.1,37.5,-122.5")

        let jsonMapRegionWithNil = """
            {
                "northLatitude": 38.0,
                "eastLongitude": -122.1,
                "southLatitude": 37.5
            }
            """
        let mapRegionWithNil = try JSONDecoder().decode(MapRegion.self, from: jsonMapRegionWithNil.data(using: .utf8)!)
        #expect(mapRegionWithNil.northLatitude == 38.0)
        #expect(mapRegionWithNil.eastLongitude == -122.1)
        #expect(mapRegionWithNil.southLatitude == 37.5)
        #expect(mapRegionWithNil.westLongitude == nil)
        #expect(mapRegionWithNil.toString == nil)
    }

    @Test("ErrorResponse.description") func errorResponseDescription() {
        let errorResponse = ErrorResponse(details: ["detail1", "detail2"], message: "message")
        #expect(errorResponse.description == #"AppleMapsKitError(message: message, details: ["detail1", "detail2"])"#)
    }
}
