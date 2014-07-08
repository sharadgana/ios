//
//  DetailedTweetViewController.m
//  twitter
//
//  Created by Sharad Ganapathy on 7/6/14.
//  Copyright (c) 2014 Sharad Ganapathy. All rights reserved.
//

#import "DetailedTweetViewController.h"
#import <UIImageView+AFNetworking.h>
#import "NewTweetViewController.h"
#import "TwitterClient.h"


@interface DetailedTweetViewController ()

@property (weak, nonatomic) IBOutlet UILabel *TweetUserName;

@property (weak, nonatomic) IBOutlet UILabel *TweetScreenName;

@property (weak, nonatomic) IBOutlet UIImageView *TweetProfilePoster;

@property (weak, nonatomic) IBOutlet UILabel *TweetText;

@property (weak, nonatomic) IBOutlet UILabel *TweetDate;

@property (weak, nonatomic) IBOutlet UILabel *TweetRetweetCount;

@property (weak, nonatomic) IBOutlet UILabel *TweetFavouriteCount;

@property (strong,nonatomic) NSString *Tweet_id;

@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;








@end

@implementation DetailedTweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [self.favouriteButton setBackgroundImage:[UIImage imageNamed:@"reply"] forState:UIControlStateNormal];
        
    }
    return self;
}
- (IBAction)onReplyButton:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: self.TweetScreenName.text forKey:@"reply_to"];
    [defaults synchronize];
    
    NewTweetViewController *newTweetVC = [[NewTweetViewController alloc]initWithNibName:@"NewTweetViewController" bundle:nil];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:newTweetVC animated:YES];

    
    
}
- (IBAction)onRetweetButton:(id)sender {
    
    TwitterClient *client = [TwitterClient instance];
    
    [client retweetwithTweet:self.Tweet_id success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Retweet Success!");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Retweet failure : %@",error.description);
    }];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *tweet  = [defaults objectForKey:@"tweetDict"];
    
    self.TweetUserName.text = tweet[@"name"];
    self.TweetScreenName.text = [NSString stringWithFormat:@"@%@",tweet[@"screen_name"]];
    self.TweetRetweetCount.text = [NSString stringWithFormat:@"%@",tweet[@"retweet_count"]];
    self.TweetFavouriteCount.text = [NSString stringWithFormat:@"%@",tweet[@"favourite_count"]];
    [self.TweetProfilePoster setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tweet[@"profile_url"]]] placeholderImage: NULL success:NULL failure:NULL];

    self.TweetText.text = tweet[@"tweet"];
    
    self.TweetDate.text = tweet[@"cdate"];
    self.Tweet_id = tweet[@"id_str"];
    
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Reply", nil]];
    [segmentedControl addTarget:self action:@selector(onReplyButton:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.frame = CGRectMake(0, 0, 60, 25);
    segmentedControl.momentary = YES;
    
    UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc]initWithCustomView:segmentedControl];
    
    self.navigationItem.rightBarButtonItem =segmentBarItem;
    
    self.navigationItem.title = @"Tweet";

    


    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
