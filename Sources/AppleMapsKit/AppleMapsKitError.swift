/// AppleMapsKit error type.
public struct AppleMapsKitError: Error, Sendable, Equatable {
    /// The type of the errors that can be thrown by AppleMapsKit.
    public struct ErrorType: Sendable, Hashable, CustomStringConvertible, Equatable {
        enum Base: String, Sendable, Equatable {
            case noPlacesFound
            case invalidSearchResultType
        }

        let base: Base

        private init(_ base: Base) {
            self.base = base
        }
        
        /// No places were found for the given query.
        public static let noPlacesFound = Self(.noPlacesFound)
        /// The search result type is invalid.
        public static let invalidSearchResultType = Self(.invalidSearchResultType)

        /// A textual representation of this error.
        public var description: String {
            self.base.rawValue
        }
    }

    private struct Backing: Sendable, Equatable {
        fileprivate let errorType: ErrorType

        init(errorType: ErrorType) {
            self.errorType = errorType
        }

        static func == (lhs: AppleMapsKitError.Backing, rhs: AppleMapsKitError.Backing) -> Bool {
            lhs.errorType == rhs.errorType
        }
    }

    private var backing: Backing

    /// The type of this error.
    public var errorType: ErrorType { backing.errorType }

    private init(errorType: ErrorType) {
        self.backing = .init(errorType: errorType)
    }

    /// No places were found for the given query.
    public static let noPlacesFound = Self(errorType: .noPlacesFound)

    /// The search result type is invalid.
    public static let invalidSearchResultType = Self(errorType: .invalidSearchResultType)

    public static func == (lhs: AppleMapsKitError, rhs: AppleMapsKitError) -> Bool {
        lhs.backing == rhs.backing
    }
}

extension AppleMapsKitError: CustomStringConvertible {
    /// A textual representation of this error.
    public var description: String {
        "AppleMapsKitError(errorType: \(self.errorType))"
    }
}
