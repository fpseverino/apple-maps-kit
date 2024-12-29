/// Information about an error that occurs while processing a request.
public struct ErrorResponse: Error, Codable, Sendable {
    /// An array of strings with additional details about the error.
    public let details: [String]?

    /// A message that provides details about the error.
    public let message: String?
}

extension ErrorResponse: CustomStringConvertible {
    /// A textual representation of this error response.
    public var description: String {
        var result = #"AppleMapsError(message: \#(self.message ?? "nil")"#

        if let details, !details.isEmpty {
            result.append(", details: [")

            for (index, detail) in details.enumerated() {
                result.append(#""\#(detail)""#)

                if index < details.count - 1 {
                    result.append(", ")
                }
            }

            result.append("]")
        }

        result.append(")")

        return result
    }
}

struct ErrorResponseJSON: Codable {
    let error: ErrorResponse
}
