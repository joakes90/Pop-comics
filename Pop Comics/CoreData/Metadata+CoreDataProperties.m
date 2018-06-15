//
//  Metadata+CoreDataProperties.m
//  
//
//  Created by Justin Oakes on 14/6/18.
//
//

#import "Metadata+CoreDataProperties.h"

@implementation Metadata (CoreDataProperties)

+ (NSFetchRequest<Metadata *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Metadata"];
}

@dynamic coverImage;
@dynamic name;
@dynamic openPage;
@dynamic read;
@dynamic url;
@dynamic uuid;

@end
