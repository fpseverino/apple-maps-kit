# ``AppleMapsKit``

🗺️ Integrate the Apple Maps Server API into Swift server applications

## Overview

Use this web-based service to streamline your app’s API by moving georelated searches for places, points of interest, geocoding, directions, possible autocompletions for searches, and estimated time of arrival (ETA) calculations from inside your app to your server.

### Getting Started

Use the SPM string to easily include the dependendency in your `Package.swift` file

```swift
.package(url: "https://github.com/fpseverino/apple-maps-kit.git", from: "1.0.0-rc.1")
```

and add it to your target's dependencies:

```swift
.product(name: "AppleMapsKit", package: "apple-maps-kit")
```

## Topics

### Essentials

- ``AppleMapsClient``
- ``MapRegion``
- ``Location``
- ``StructuredAddress``
- ``Place``

### Geocoding

- <doc:Geocode>
- <doc:ReverseGeocode>

### Searching

- <doc:Search>
- <doc:SearchAutoComplete>
- ``SearchResponse``
- ``AutocompleteResult``
- ``PoiCategory``
- ``SearchResultType``
- ``SearchRegionPriority``
- ``AddressCategory``

### Directions

- <doc:GettingDirections>
- ``DirectionsResponse``
- ``DirectionsTransportType``
- ``DirectionsAvoid``

### ETAs

- <doc:GettingETAs>
- ``Eta``
- ``EtaTransportType``

### Places

- <doc:GettingPlaces>
- ``PlacesResponse``
- ``AlternateIDsResponse``

### Errors

- ``ErrorResponse``
- ``AppleMapsKitError``
