# Geocode an address

Returns the latitude and longitude of the address you specify.

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

let places = try await client.geocode(address: "1 Apple Park, Cupertino, CA")
```
