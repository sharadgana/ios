//
//  TweetTableViewCell.m
//  twitter
//
//  Created by Sharad Ganapathy on 7/2/14.
//  Copyright (c) 2014 Sharad Ganapathy. All rights reserved.
//

#import "TweetCell.h"
#import <UIImageView+AFNetworking.h>

@implementation TweetCell


- (void)awakeFromNib
{
    // Initialization code
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)onretweetButton:(id)sender {
    
    NSLog(@"Retweet Pressed");
}

-(void)setTweets:(NSDictionary *) tweet {
    
    //NSLog (@"%@",tweet);
    self.tweetLabel.text = tweet[@"tweet"];
    self.nameLabel.font=[UIFont fontWithName:@"AvenirNext-Bold" size:12];
    self.nameLabel.text =tweet[@"name"];
    self.handleLabel.text = [NSString stringWithFormat:@"@%@",tweet[@"screen_name"]];
    self.timeLabel.text = @"1d";
    [self.tweetPoster setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tweet[@"profile_url"]]] placeholderImage: NULL success:NULL failure:NULL];
    
}



@end
