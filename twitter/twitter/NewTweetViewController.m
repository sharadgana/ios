//
//  NewTweetViewController.m
//  twitter
//
//  Created by Sharad Ganapathy on 7/2/14.
//  Copyright (c) 2014 Sharad Ganapathy. All rights reserved.
//

#import "NewTweetViewController.h"
#import "TwitterClient.h"
#import <UIImageView+AFNetworking.h>


@interface NewTweetViewController ()

@property (weak, nonatomic) IBOutlet UILabel *ProfileUserName;

@property (weak, nonatomic) IBOutlet UILabel *ProfileScreenName;

@property (weak, nonatomic) IBOutlet UIImageView *ProfilePoster;
@property (weak, nonatomic) IBOutlet UITextField *tweetTextField;

@end

@implementation NewTweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self.tweetTextField setBorderStyle:UITextBorderStyleNone];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Tweet", nil]];
    [segmentedControl addTarget:self action:@selector(onTweetButton) forControlEvents:UIControlEventValueChanged];
    segmentedControl.frame = CGRectMake(0, 0, 60, 25);
    segmentedControl.momentary = YES;
    
    UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc]initWithCustomView:segmentedControl];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.rightBarButtonItem =segmentBarItem;

    
    TwitterClient *client = [TwitterClient instance];
    
    [client get_profilewithSucess:^(AFHTTPRequestOperation *operation, NSDictionary *userProfileDict) {
        NSLog(@"Inside New Tweet%@",userProfileDict);
        
        self.ProfileScreenName.text = [NSString stringWithFormat:@"@%@",userProfileDict[@"screen_name"]];
        self.ProfileUserName.text = userProfileDict[@"name"];
        [self.ProfilePoster setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:userProfileDict[@"profile_url"]]] placeholderImage: NULL success:NULL failure:NULL];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[New Tweet Error : %@", error.description);
    }];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *reply_handle  = [defaults objectForKey:@"reply_to"];
    
    if ( reply_handle != nil ){
        self.tweetTextField.text = reply_handle;
        [defaults setObject:nil forKey:@"reply_to"];
        [defaults synchronize];
        
    }
    
}

-(void) viewDidAppear:(BOOL)animated {
    
    [self.tweetTextField becomeFirstResponder];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onTweetButton
{
   
    //post tweet
    NSLog(@"post tweet");
    NSString *tweet = self.tweetTextField.text;
    TwitterClient *client = [TwitterClient instance];
    [client tweetWithText:tweet
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      NSLog(@"Tweet posted with success");
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"Tweet not posted %@", [error description]);
                      //alert error
                  }];
    
     [self.navigationController popViewControllerAnimated:YES];
    
    
}

@end
