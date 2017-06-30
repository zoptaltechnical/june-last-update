//
//  lenderConditionlReportViewController.m
//  Steezz
//
//  Created by Apple on 08/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "lenderConditionlReportViewController.h"

@interface lenderConditionlReportViewController ()

@end

@implementation lenderConditionlReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)startReportBtnPressed:(id)sender {
    
     
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    lenderStartReportViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"lenderStartReportViewController"];
    [self.navigationController pushViewController:homeObj animated:YES];
    

    
    
}


- (IBAction)endReportBtnPressed:(id)sender {
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LenderEndReportViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"LenderEndReportViewController"];
    [self.navigationController pushViewController:homeObj animated:YES];
    
    
}

- (IBAction)conditionSettingBtnPressed:(id)sender {
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LenderSettingsViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"LenderSettingsViewController"];
    [self.navigationController pushViewController:homeObj animated:YES];
    
    
}



@end
