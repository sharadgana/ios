//
//  TweetTableViewCell.h
//  twitter
//
//  Created by Sharad Ganapathy on 7/2/14.
//  Copyright (c) 2014 Sharad Ganapathy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tweetPoster;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *replyImg;
@property (weak, nonatomic) IBOutlet UIImageView *retweetImg;

@property (weak, nonatomic) IBOutlet UIImageView *favouriteImg;
-(void)setTweets:(NSDictionary *) tweet;
-(void)oneTap;
@end
