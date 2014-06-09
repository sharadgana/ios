//
//  HomeScreen.m
//  rottentomatoes
//
//  Created by Sharad Ganapathy on 6/5/14.
//  Copyright (c) 2014 Sharad Ganapathy. All rights reserved.
//

#import "BoxOffice.h"
#import "MovieCell.h"
#import <UIImageView+AFNetworking.h>
#import <ALAlertBanner.h>
#import "MovieDetailedViewController.h"
#import "MBProgressHUD.h"

@interface BoxOffice ()

@property (weak, nonatomic) IBOutlet UITableView *homeScreenTblView;
@property (strong,nonatomic) NSArray *movies;
@property (strong,nonatomic) MBProgressHUD *hud;

@end

@implementation BoxOffice

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Box Office";
    }
    return self;
}


- (void)showAlertBannerInView {
    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.view style:ALAlertBannerStyleFailure position:ALAlertBannerPositionTop title:@"Error" subtitle:@"Network Error" tappedBlock:^(ALAlertBanner *alertBanner) {
        NSLog(@"tapped!");
        [alertBanner hide];
    }];
    [banner show];
}

-(void)viewWillAppear:(BOOL)animated {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"loading";
    [self.hud show:YES];
}


- (void)viewDidAppear:(BOOL)animated{
    [self getData];
    [self.hud hide:YES];
    
}


- (void)getData {
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError != nil) {
            [self showAlertBannerInView];
        }
        else{
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.movies = object[@"movies"];
            [self.homeScreenTblView reloadData];
        }}];
    
    
}

- (void) refreshView:(UIRefreshControl *) refresh {
    
    refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"Refreshing Data...."];
    NSLog(@"Refreshing Data");
    [self getData];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *lastUpdate = [NSString stringWithFormat:@"Last updated on %@",[formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdate];
    [refresh endRefreshing];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.homeScreenTblView;
    
    self.homeScreenTblView.delegate = self;
    self.homeScreenTblView.dataSource =self;
    [self getData];
    
    [self.homeScreenTblView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    self.homeScreenTblView.rowHeight = 175;
    UIRefreshControl *refresh = [[UIRefreshControl alloc]init];
    refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"Pull to refresh..."];
    
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    
    tableViewController.refreshControl = refresh;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.movies.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    NSDictionary *movie = self.movies[indexPath.row];
    cell.movieTitleLabel.text = movie[@"title"];
    cell.movieSynopsisLabel.text = movie[@"synopsis"];
    NSString *movieThumbnailURL = movie[@"posters"][@"original"];
    NSLog(@"Thumbnail %@",movieThumbnailURL);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:movieThumbnailURL]];
    [cell.moviePosterView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"Default_Image"] success:NULL failure:NULL];
    
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.movies[indexPath.row] forKey:@"movieDict"];
    [defaults synchronize];

    
    MovieDetailedViewController *mdvc = [[MovieDetailedViewController alloc]initWithNibName:@"MovieDetailedViewController" bundle:nil];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Movies" style:UIBarButtonItemStylePlain target:nil action:nil];

    [self.navigationController pushViewController:mdvc animated:YES];
    

}

@end
