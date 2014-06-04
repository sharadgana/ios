//
//  SettingsViewController.m
//  tipdemo
//
//  Created by Sharad Ganapathy on 6/4/14.
//  Copyright (c) 2014 Sharad Ganapathy. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *currencyPicker;

- (IBAction)currencyValueChanged:(id)sender;

@end

@implementation SettingsViewController



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


- (IBAction)currencyValueChanged:(id)sender {
    NSLog(@"Vlaue Changed");
    NSArray *curArray = @[@("$"),@("£"),@("¥"),@("₹") ];
    
    NSString *curSym = curArray[self.currencyPicker.selectedSegmentIndex];
    
    NSLog(@"%@",curSym);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:curSym forKey:@"curSym"];
    [defaults synchronize];
}
@end
