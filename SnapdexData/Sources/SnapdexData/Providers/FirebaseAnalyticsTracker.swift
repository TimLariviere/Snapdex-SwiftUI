import FirebaseAnalytics
import FirebaseCrashlyticsSwift
import SnapdexDomain

public final class FirebaseAnalyticsTracker : AnalyticsTracker {
    public init() {}
    
    public func setUserId(userId: UserId?) {
        Analytics.setUserID(userId)
    }
    
    public func logEvent(name: String, parameters: [String : String]?) {
        Analytics.logEvent(name, parameters: parameters)
    }
}
