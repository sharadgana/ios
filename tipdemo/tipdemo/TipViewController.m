//
//  TipViewController.m
//  tipdemo
//
//  Created by Sharad Ganapathy on 6/3/14.
//  Copyright (c) 2014 Sharad Ganapathy. All rights reserved.
//

#import "TipViewController.h"
#import "SettingsViewController.h"

@interface TipViewController ()

@property (weak, nonatomic) IBOutlet UITextField *billAmountField;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;


- (IBAction)onTap:(id)sender;

- (void)updateValues;
@end

@implementation TipViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Tip Calculator";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"Did Appear");
    [self updateValues ];
}

- (void)onSettingsButton {
        [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(id)sender{
    [self.view endEditing:YES];
    [self updateValues];
}
- (void)updateValues {
    
    float billAmt = [self.billAmountField.text floatValue];
    NSArray *tipValues = @[@(0.1),@(0.15),@(0.2)];
    float tipAmt = billAmt *[tipValues[self.tipControl.selectedSegmentIndex] floatValue];
    float totalAmt = billAmt + tipAmt;

    //Get the currency format
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *curSym = [defaults objectForKey:@"curSym"];
    
    
    self.tipLabel.text = [NSString stringWithFormat:@"%@ %0.2f",curSym,tipAmt];
    self.totalLabel.text = [NSString stringWithFormat:@"%@ %0.2f",curSym,totalAmt];
}

@end
