# Determine estimated arrival times and distances to one or more destinations

Returns the estimated time of arrival (ETA) and distance between starting and ending locations.

## Overview

```swift
import AppleMapsKit
import AsyncHTTPClient

let client = AppleMapsClient(
    httpClient: HTTPClient(...),
    teamID: "DEF123GHIJ",
    keyID: "ABC123DEFG",
    key: """
        -----BEGIN PRIVATE KEY-----
        ...
        -----END PRIVATE KEY-----
        """
)

let coordinateEtas = try await client.eta(
    from: (latitude: 37.331423, longitude: -122.030503),
    to: [
        (latitude: 37.32556561130194, longitude: -121.94635203581443),
        (latitude: 37.44176585512703, longitude: -122.17259315798667)
    ]
)

let addressEtas = try await client.etaBetweenAddresses(
    from: "San Francisco City Hall, CA",
    to: ["Golden Gate Park, San Francisco"],
)
```
