//
//  DVDViewController.m
//  rottentomatoes
//
//  Created by Sharad Ganapathy on 6/6/14.
//  Copyright (c) 2014 Sharad Ganapathy. All rights reserved.
//

#import "DVDViewController.h"
#import <UIImageView+AFNetworking.h>
#import "MovieCell.h"
#import "MovieDetailedViewController.h"
#import "MBProgressHUD.h"




@interface DVDViewController ()

@property (weak, nonatomic) IBOutlet UITableView *movieTblView;
@property (strong,nonatomic) NSArray *movies;
@property (strong,nonatomic) MBProgressHUD *hud;

@end

@implementation DVDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            self.title = @"DVD";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.movieTblView;
    
    self.movieTblView.delegate = self;
    self.movieTblView.dataSource =self;
    
    [self.movieTblView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    
    
    self.movieTblView.rowHeight = 175;
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc]init];
    refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"Pull to refresh..."];
    
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    
    tableViewController.refreshControl = refresh;

    
    // Do any additional setup after loading the view from its nib.
}

- (void) getData {
    
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.movies = object[@"movies"];
        [self.movieTblView reloadData];
    }];
    
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