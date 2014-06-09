//
//  MovieDetailedViewController.m
//  rottentomatoes
//
//  Created by Sharad Ganapathy on 6/5/14.
//  Copyright (c) 2014 Sharad Ganapathy. All rights reserved.
//

#import "MovieDetailedViewController.h"
#import <UIImageView+AFNetworking.h>

@interface MovieDetailedViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *movieDetailedPosterView;

@property (weak, nonatomic) IBOutlet UITextView *movieDetailedDescView;

@end

@implementation MovieDetailedViewController

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

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *movie  = [defaults objectForKey:@"movieDict"];
    
     NSString *moviePosterUrl = movie[@"posters"][@"original"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:moviePosterUrl]];
    [self.movieDetailedPosterView setImageWithURLRequest:request placeholderImage:NULL success:NULL failure:NULL];
    self.movieDetailedDescView.text = movie[@"synopsis"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
