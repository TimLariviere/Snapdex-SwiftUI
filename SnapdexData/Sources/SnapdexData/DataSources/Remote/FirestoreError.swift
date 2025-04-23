import FirebaseFirestore

enum FirestoreError: Error {
    case firestoreNetworkError
    case firestore(FirestoreErrorCode.Code)
    case unknown(Error)
    
    static func from(_ error: Error) -> FirestoreError {
        if let err = error as NSError?,
           err.domain == FirestoreErrorDomain,
           let code = FirestoreErrorCode.Code(rawValue: err.code) {
            
            return switch code {
                case .unavailable, .deadlineExceeded, .aborted, .cancelled: .firestoreNetworkError
                default: .firestore(code)
            }
        } else {
            return .unknown(error)
        }
    }
}
