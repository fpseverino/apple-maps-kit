# Search for directions and estimated travel time between locations

Find directions by specific criteria.

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

let directions = try await client.directions(
    origin: "37.7857,-122.4011",
    destination: "San Francisco City Hall, CA"
)
```
