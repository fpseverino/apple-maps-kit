# AppleMapsKit

🗺️ Integrate the [Apple Maps Server API](https://developer.apple.com/documentation/applemapsserverapi) into Swift server applications

## Overview

### Getting Started

Use the SPM string to easily include the dependendency in your `Package.swift` file

```swift
.package(url: "https://github.com/fpseverino/apple-maps-kit.git", from: "0.1.0")
```

and add it to your target's dependencies:

```swift
.product(name: "AppleMapsKit", package: "apple-maps-kit")
```

### Geocode an address

Returns the latitude and longitude of the address you specify.

```swift
import AppleMapsKit
import AsyncHTTPClient

let client = try await AppleMapsClient(
    httpClient: HTTPClient(...),
    teamID: "DEF123GHIJ",
    keyID: "ABC123DEFG",
    key: """
    -----BEGIN PRIVATE KEY-----
    ...
    -----END PRIVATE KEY-----
    """
)

let places = try await client.geocode(address: "1 Apple Park, Cupertino, CA")
```

### Reverse geocode a location

Returns an array of addresses present at the coordinates you provide.

```swift
import AppleMapsKit
import AsyncHTTPClient

let client = try await AppleMapsClient(
    httpClient: HTTPClient(...),
    teamID: "DEF123GHIJ",
    keyID: "ABC123DEFG",
    key: """
    -----BEGIN PRIVATE KEY-----
    ...
    -----END PRIVATE KEY-----
    """
)

let places = try await client.reverseGeocode(latitude: 37.33182, longitude: -122.03118)
```
