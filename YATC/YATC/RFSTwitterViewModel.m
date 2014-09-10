//
//  RFSTwitterViewModel.m
//  YATC
//
//  Created by Josh Brown on 9/5/14.
//  Copyright (c) 2014 Roadfire Software. All rights reserved.
//

#import "RFSTwitterViewModel.h"

@import Accounts;
@import Social;

@interface RFSTwitterViewModel ()

@property ACAccountStore *accountStore;
@property ACAccountType *accountType;
@property NSArray *tweets;

@end

@implementation RFSTwitterViewModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.accountStore = [[ACAccountStore alloc] init];
        self.tweets = @[];
    }
    return self;
}

- (void)fetchTweetsWithSuccess:(void (^)())success failure:(void (^)())failure
{
    if ([self userHasAccessToTwitter])
    {
        self.accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        [self.accountStore
         requestAccessToAccountsWithType:self.accountType
         options:nil
         completion:^(BOOL granted, NSError *error)
         {
             if (granted)
             {
                 [self
                  loadTweetsWithSuccess:^(NSArray *tweets)
                  {
                      self.tweets = tweets;
                      if (success)
                      {
                          success();
                      }
                  }
                  failure:^
                  {
                      if (failure)
                      {
                          failure();
                      }
                  }];
             }
             else
             {
                 if (failure)
                 {
                     failure();
                 }
             }
         }];
    }
}

- (BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

- (void)loadTweetsWithSuccess:(void (^)(NSArray *tweets))success failure:(void (^)())failure
{
    NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:self.accountType];
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
    NSDictionary *params = @{@"count": @"100",
                             @"exclude_replies": @"false"};
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:params];
    request.account = twitterAccounts.firstObject;
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (responseData)
        {
            if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300)
            {
                NSError *jsonError;
                NSArray *tweets =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingAllowFragments
                                                  error:&jsonError];
                if (!jsonError && tweets)
                {
                    if (success)
                    {
                        success(tweets);
                    }
                }
                else
                {
                    if (failure)
                    {
                        failure();
                    }
                }
            }
        }
    }];
}

- (NSInteger)numberOfSections
{
    return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (NSString *)usernameForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *username = [self.tweets[indexPath.row] valueForKeyPath:@"user.screen_name"];
    return [NSString stringWithFormat:@"@%@", username];
}

- (NSString *)tweetForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.tweets[indexPath.row] valueForKeyPath:@"text"];
}

@end
