//
//  Metadata+CoreDataClass.h
//  
//
//  Created by Justin Oakes on 14/6/18.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MetadataUpdateDelegate;

@interface Metadata : NSManagedObject

@property (nonatomic, weak) id<MetadataUpdateDelegate> delegate;

-(void) populateCoverPage;

@end

@protocol MetadataUpdateDelegate<NSObject>

-(void) didUpdateCoverFor: (Metadata *)object;

@end
NS_ASSUME_NONNULL_END

#import "Metadata+CoreDataProperties.h"
