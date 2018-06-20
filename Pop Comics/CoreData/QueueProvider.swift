//
//  QueueProvider.swift
//  Pop Comics
//
//  Created by Justin Oakes on 19/6/18.
//  Copyright © 2018 Oklasoft LLC. All rights reserved.
//

import Foundation

@objc class QueueProvider: NSObject {
    @objc static let shared = QueueProvider()
    
    @objc var coverQueue: OperationQueue {
        let queue = OperationQueue()
        queue.name = "com.oakes.popcomics.coverqueue"
        queue.maxConcurrentOperationCount = 4
        return queue
    }
}
