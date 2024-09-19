/// AppleMapsKit error type.
public struct AppleMapsKitError: Error, Sendable {
    public struct ErrorType: Sendable, Hashable, CustomStringConvertible {
        enum Base: String, Sendable {
            case noPlacesFound
            case invalidSearchResultType
        }

        let base: Base

        private init(_ base: Base) {
            self.base = base
        }

        public static let noPlacesFound = Self(.noPlacesFound)
        public static let invalidSearchResultType = Self(.invalidSearchResultType)

        public var description: String {
            base.rawValue
        }
    }

    private struct Backing: Sendable {
        fileprivate let errorType: ErrorType

        init(errorType: ErrorType) {
            self.errorType = errorType
        }
    }

    private var backing: Backing

    public var errorType: ErrorType { backing.errorType }

    private init(backing: Backing) {
        self.backing = backing
    }

    private init(errorType: ErrorType) {
        self.backing = .init(errorType: errorType)
    }

    public static let noPlacesFound = Self(errorType: .noPlacesFound)
    public static let invalidSearchResultType = Self(errorType: .invalidSearchResultType)
}

extension AppleMapsKitError: CustomStringConvertible {
    public var description: String {
        "AppleMapsKitError(errorType: \(self.errorType)"
    }
}