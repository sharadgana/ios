//
//  TwitterClient.m
//  twitter
//
//  Created by Sharad Ganapathy on 7/2/14.
//  Copyright (c) 2014 Sharad Ganapathy. All rights reserved.
//

#import "TwitterClient.h"
//#import <JSONKit.h>



@implementation TwitterClient


+ (TwitterClient * ) instance {
    static TwitterClient *instance = nil;
    
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com"] consumerKey:@"uFKyG6G0i5YhPro8OnvQv69iZ" consumerSecret:
                    @"ZiZ81C2b5Om2llmjBLao0QNQJtypio6SVTPwWX7NZc7HM94OoD"];
    });
    
        return instance;
}
-(void) login {
    
    [self.requestSerializer removeAccessToken];
    
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"sgtwitter://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSLog(@"Got Request Token");
        NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
    } failure:^(NSError *error) {
        NSLog(@"Failed to get Request Token");
        NSLog(@"Error: %@", error.localizedDescription);
    }];
    
    }

-(AFHTTPRequestOperation *)verify_credentialswithSucess:(void (^)(AFHTTPRequestOperation *operation, bool status))success
                                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    return [self GET:@"/1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        success(operation,TRUE);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
    
}



-(AFHTTPRequestOperation *)get_profilewithSucess:(void (^)(AFHTTPRequestOperation *operation, NSDictionary  *userProfileDict))success
                                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    return [self GET:@"/1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        
    
        NSString *name = responseObject[@"name"];
        NSString *screen_name = responseObject[@"screen_name"] ;
        NSString *profile_url = responseObject[@"profile_image_url"];
        
        NSDictionary *userProfileDict = [[NSDictionary alloc] initWithObjectsAndKeys:name,@"name",screen_name,@"screen_name",profile_url,@"profile_url",nil];
            success(operation,userProfileDict);
    
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
    
}



- (AFHTTPRequestOperation *)tweetWithText: (NSString *)tweetText
                                  success: (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *parameters = @{@"status": tweetText};
    return [self POST:@"https://api.twitter.com/1.1/statuses/update.json"
           parameters:parameters
              success:success
              failure:failure
            ];
}


- (AFHTTPRequestOperation *)retweetwithTweet: (NSString *)tweetId
                                     success: (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                     failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/retweet/%@.json",tweetId];
    
    return [self POST:url parameters:nil success:success failure:failure];
    }



-(AFHTTPRequestOperation *) homeTimelineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray *tweets))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
{
    
    
    //return [self GET:@"/1.1/statuses/home_timeline.json" parameters:nil success:success failure:failure];
    
    return [self GET:@"/1.1/statuses/home_timeline.json"  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSMutableArray *jsonArray = [NSMutableArray arrayWithArray:responseObject];

        NSMutableArray *arr = [[NSMutableArray alloc]init];
        
        for (NSMutableDictionary *dict in jsonArray){
            
            NSString *name = dict[@"user"][@"name"];
            NSString *screen_name = dict[@"user"][@"screen_name"] ;
            NSString *tweet_text = dict[@"text"];
            NSString *fav_count = dict[@"favorite_count"];
            NSString *retweet_count = dict[@"retweet_count"];
            NSString *profile_url = dict[@"user"][@"profile_image_url"];
            NSString *cdate = dict[@"created_at"];
            NSString *id_str = dict[@"id_str"];
            
            
            NSDictionary *td = [[NSDictionary alloc] initWithObjectsAndKeys:name,@"name",screen_name,@"screen_name",tweet_text,@"tweet", profile_url,@"profile_url",fav_count, @"favourite_count",retweet_count,@"retweet_count",cdate,@"cdate",id_str,@"id_str",nil];
            [arr addObject:td];
        }
        
        NSLog(@"Arr:%@",arr);
        
        success(operation,arr);
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    
    }];
    
}

@end

