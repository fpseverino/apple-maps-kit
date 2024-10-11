/// Information about an error that occurs while processing a request.
public struct ErrorResponse: Error, Codable, Sendable {
    /// An array of strings with additional details about the error.
    public let details: [String]?

    /// A message that provides details about the error.
    public let message: String?
}

extension ErrorResponse: CustomStringConvertible {
    public var description: String {
        var result = #"AppleMapsKitError(message: \#(self.message ?? "nil")"#

        if let details {
            result.append(", details: \(details)")
        }

        result.append(")")

        return result
    }
}
