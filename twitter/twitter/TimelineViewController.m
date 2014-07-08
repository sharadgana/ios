    //
//  TimelineViewController.m
//  twitter
//
//  Created by Sharad Ganapathy on 7/2/14.
//  Copyright (c) 2014 Sharad Ganapathy. All rights reserved.
//

#import "TimelineViewController.h"
#import "TweetCell.h"
#import "NewTweetViewController.h"
#import "DetailedTweetViewController.h"
#import "TwitterClient.h"
@interface TimelineViewController ()
@property (weak, nonatomic) IBOutlet UITableView *TLTblView;
@property (strong  , nonatomic) NSArray *tweets;
@property (strong , nonatomic) TwitterClient *client;

@end

@implementation TimelineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.client = [TwitterClient instance];
        
        
        
        
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.TLTblView;
    
    self.TLTblView.delegate = self;
    self.TLTblView.dataSource = self;
    self.TLTblView.rowHeight = 120;
    
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"New", nil]];
    [segmentedControl addTarget:self action:@selector(onNewButton) forControlEvents:UIControlEventValueChanged];
    segmentedControl.frame = CGRectMake(0, 0, 60, 25);
    segmentedControl.momentary = YES;

    UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc]initWithCustomView:segmentedControl];

    //[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:121.0 green:202.0 blue:252.0 alpha:0.0]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:(121/255.0) green:(202/255.0) blue:(252/255.0) alpha:1]];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.rightBarButtonItem =segmentBarItem;
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    
    
    [self.TLTblView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    
    [self getTimelineTweets];
    
    
    //Refresh
    
    
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc]init];
    refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"Pull to refresh..."];
    
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    
    tableViewController.refreshControl = refresh;
    
    
}

- (void) refreshView:(UIRefreshControl *) refresh {
    
    refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"Getting new tweets...."];
    NSLog(@"Refreshing Data");
    [self getTimelineTweets];
    [self.TLTblView reloadData];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *lastUpdate = [NSString stringWithFormat:@"Last updated on %@",[formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdate];
    [refresh endRefreshing];
    
}



-(void) getTimelineTweets {
    
    [self.client homeTimelineWithSuccess:^(AFHTTPRequestOperation *operation, NSMutableArray *tweets) {
        
        self.tweets = tweets;
        NSLog(@"Self.tweet %@",self.tweets);
        [self.TLTblView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[TimeLine Error : %@", error.description);
    }];

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    [cell setTweets:self.tweets[indexPath.row]];
    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.tweets[indexPath.row] forKey:@"tweetDict"];
    [defaults synchronize];

    
    DetailedTweetViewController *detailTweetVC = [[DetailedTweetViewController alloc]initWithNibName:@"DetailedTweetViewController" bundle:nil];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self.navigationController pushViewController:detailTweetVC animated:YES];

    
}


#pragma mark new tweet

- (void)onNewButton {
    [self.navigationController pushViewController:[[NewTweetViewController alloc] init] animated:YES];
}



#pragma mark tweet gestures

/*
- (IBAction)onFavourite:(id)sender {
    
    NSLog (@"Favourited %@",sender);
    
}*/


@end
