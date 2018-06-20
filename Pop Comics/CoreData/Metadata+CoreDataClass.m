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
        [QueueProvider.shared.coverQueue addOperation:operation];
        
    }
}
//-(void) populateCoverPage {
//    if (self.coverImage) {
//        return;
//    } else if (self.processingCover != YES) {
//        self.processingCover = YES;
//        dispatch_queue_t coverQueue = dispatch_queue_create("com.oakes.popcomics.coverqueue",
//                                                            nil);
//
//        __block Metadata *blockSafeSelf = self;
//        dispatch_async(coverQueue, ^{
//            NSURL *comicURL = [[NSURL alloc] initWithString:blockSafeSelf.url];
//            NSArray *images = [ComicManager openComicAt:[comicURL path]];
//            if (images.count > 0) {
//                UIImage *image = images[0];
//                NSData *imageData = UIImagePNGRepresentation(image);
//                blockSafeSelf.coverImage = imageData;
//                if (blockSafeSelf.delegate && [blockSafeSelf.delegate respondsToSelector:@selector(didUpdateCoverFor:)]) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [blockSafeSelf.delegate didUpdateCoverFor:blockSafeSelf];
//                    });
//                }
//            }
//        });
//    }
//}
@end
