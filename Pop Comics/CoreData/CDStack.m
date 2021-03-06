//
//  CDStack.m
//  Pop Comics
//
//  Created by Justin Oakes on 15/5/18.
//  Copyright © 2018 Oklasoft LLC. All rights reserved.
//


#import "CDStack.h"

@interface CDStack ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation CDStack

+ (CDStack *)sharedInstance {
    static CDStack *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CDStack alloc] init];
    });
    return sharedInstance;
    
}

- (id)init {
    self = [super init];
    if (self) {
        [self setupManagedObjectContext];
    }
    return self;
}

- (void)setupManagedObjectContext
{
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    NSError* error;
    [self.managedObjectContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                       configuration:nil
                                                                                 URL:self.storeURL
                                                                             options:nil
                                                                               error:&error];
    if (error) {
        NSLog(@"error: %@", error);
    }
    
    self.managedObjectContext.undoManager = [[NSUndoManager alloc] init];
}

- (NSURL*)storeURL
{
    NSURL* dataStoreDirectory = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
    return [dataStoreDirectory URLByAppendingPathComponent:@"db.sqlite"];
}

- (NSURL*)modelURL
{
    return [[NSBundle mainBundle] URLForResource:@"Metadata" withExtension:@"momd"];
}

- (NSManagedObjectModel*)managedObjectModel
{
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
}

@end
