//
//  ComicSearch.swift
//  Pop Comics
//
//  Created by justin on 6/7/18.
//  Copyright © 2018 Oklasoft LLC. All rights reserved.
//

import Foundation
import CoreSpotlight


extension Metadata {
    public static let domainIdentifier = "com.oakes.Pop-Comics.book"
    
    public var userActivityUserInfo: [NSObject: AnyObject] {
        return ["uuid" as NSString: (uuid ?? "") as NSString]
    }
    
    public var userActivity: NSUserActivity {
        let activity = NSUserActivity(activityType: Metadata.domainIdentifier)
        activity.title = name
        activity.userInfo = userActivityUserInfo
        activity.keywords = [name ?? "comic", "comic", "comics", "comic book"]
        activity.isEligibleForSearch = true
        return activity
    }
}
