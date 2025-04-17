import FirebaseFirestore

enum RemoteDataSourceError: Error {
    case firestore(FirestoreErrorCode.Code)
    case unknown(Error)
    
    init(error: Error) {
        if let err = error as NSError?,
           err.domain == FirestoreErrorDomain,
           let code = FirestoreErrorCode.Code(rawValue: err.code) {
            self = .firestore(code)
        } else {
            self = .unknown(error)
        }
    }
}
