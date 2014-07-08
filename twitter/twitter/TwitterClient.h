//
//  TwitterClient.h
//  twitter
//
//  Created by Sharad Ganapathy on 7/2/14.
//  Copyright (c) 2014 Sharad Ganapathy. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient * ) instance ;

-(void) login;

-(AFHTTPRequestOperation *) homeTimelineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray *tweets))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
-(AFHTTPRequestOperation *)verify_credentialswithSucess:(void (^)(AFHTTPRequestOperation *operation, bool status))success
                                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


-(AFHTTPRequestOperation *)get_profilewithSucess:(void (^)(AFHTTPRequestOperation *operation, NSDictionary  *userProfileDict))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


- (AFHTTPRequestOperation *)tweetWithText: (NSString *)tweetText
                                  success: (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure ;

- (AFHTTPRequestOperation *)retweetwithTweet:(NSString *)tweetId
                                     success: (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                     failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
