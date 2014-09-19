//
//  RFSTwitterViewModel.h
//  YATC
//
//  Created by Josh Brown on 9/5/14.
//  Copyright (c) 2014 Roadfire Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RFSTwitterViewModel : NSObject

- (void)fetchTweetsWithSuccess:(void (^)())success failure:(void (^)())failure;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (NSString *)usernameForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)tweetForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)fetchImageForIndexPath:(NSIndexPath *)indexPath success:(void (^)(UIImage *image))success;

@end
