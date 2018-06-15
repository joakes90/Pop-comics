//
//  Metadata+CoreDataProperties.h
//  
//
//  Created by Justin Oakes on 14/6/18.
//
//

#import "Metadata+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Metadata (CoreDataProperties)

+ (NSFetchRequest<Metadata *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSData *coverImage;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int16_t openPage;
@property (nonatomic) BOOL read;
@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, copy) NSString *uuid;

@end

NS_ASSUME_NONNULL_END
