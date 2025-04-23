import FirebaseCrashlyticsSwift
import SnapdexDomain

public final class FirebaseCrashReporter : CrashReporter {
    public init() {}
    
    public func recordException(error: any Error, metadata: [String : String]?) {
        //Crashlytics.crashlytics().record(error: error, userInfo: metadata)
    }
}
