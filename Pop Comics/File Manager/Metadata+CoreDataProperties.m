//
//  Metadata+CoreDataProperties.m
//  
//
//  Created by Justin Oakes on 15/5/18.
//
//

#import "Metadata+CoreDataProperties.h"

@implementation Metadata (CoreDataProperties)

+ (NSFetchRequest<Metadata *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Metadata"];
}

@dynamic filePath;
@dynamic read;
@dynamic openPage;
@dynamic coverImage;

@end
