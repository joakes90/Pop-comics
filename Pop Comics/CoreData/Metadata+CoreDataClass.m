//
//  Metadata+CoreDataClass.m
//  
//
//  Created by Justin Oakes on 14/6/18.
//
//

#import "Metadata+CoreDataClass.h"
#import "Pop_Comics-Swift.h"

@implementation Metadata

@synthesize delegate, processingCover;

- (void) populateCoverPage {
    if (self.coverImage) {
        return;
    } else if (self.processingCover != YES) {
        CoverExtractOperation *operation = [[CoverExtractOperation alloc] initWithMetaData:self];
        [operation setCompletionBlock:^{
            if (QueueProvider.shared.coverQueue.operationCount <= 0) {
                [ComicManager saveCDStack];
            }
        }];
        [QueueProvider.shared.coverQueue addOperation:operation];
        
    }
}

@end
