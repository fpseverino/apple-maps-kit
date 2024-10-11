# Search for places using identifiers

Obtain a set of ``Place`` objects for a given set of Place IDs or get a list of alternate Place IDs given one or more Place IDs.

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

let place = try await client.place(id: "I7C250D2CDCB364A")

let placesResponse = try await client.places(ids: ["ICFA2FAE5487B94AF", "IA6FD1E86A544F69D"])

let alternateIDsResponse = try await client.alternatePlaceIDs(ids: ["I7C250D2CDCB364A", "ICFA2FAE5487B94AF"])
```
