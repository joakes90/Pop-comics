//
//  Metadata+CoreDataProperties.h
//  
//
//  Created by Justin Oakes on 15/5/18.
//
//

#import "Metadata+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Metadata (CoreDataProperties)

+ (NSFetchRequest<Metadata *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *filePath;
@property (nonatomic) BOOL read;
@property (nonatomic) int16_t openPage;
@property (nullable, nonatomic, retain) NSData *coverImage;

@end

NS_ASSUME_NONNULL_END
