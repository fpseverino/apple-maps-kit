# Search for places that meet specific criteria to autocomplete a place search

Find results that you can use to autocomplete searches.

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

let results = try await client.searchAutoComplete(for: "eiffel")
```
