//
//  LoginViewController.m
//  twitter
//
//  Created by Sharad Ganapathy on 7/2/14.
//  Copyright (c) 2014 Sharad Ganapathy. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"


@interface LoginViewController ()
- (IBAction)onLoginButton:(id)sender;

@end

@implementation LoginViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginButton:(id)sender {
    
    [[TwitterClient instance] login];
}
@end
