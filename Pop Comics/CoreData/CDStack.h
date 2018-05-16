//
//  CDStack.h
//  Pop Comics
//
//  Created by Justin Oakes on 15/5/18.
//  Copyright © 2018 Oklasoft LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

@interface Stack : NSObject

+ (Stack *)sharedInstance;

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

@end
