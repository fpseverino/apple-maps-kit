# Reverse geocode a location

Returns an array of addresses present at the coordinates you provide.

## Overview

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
