//
//  HomeViewController.m
//  rottentomatoes
//
//  Created by Sharad Ganapathy on 6/5/14.
//  Copyright (c) 2014 Sharad Ganapathy. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *homeScrTblView;

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Really Rotten Tomatoes";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.homeScrTblView.delegate = self;
    self.homeScrTblView.dataSource = self;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = @"Sharad";
    
    return cell;
}



@end
