//
//  paymentFromViewController.m
//  Steezz
//
//  Created by Apple on 26/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "paymentFromViewController.h"

@interface paymentFromViewController ()

@end

@implementation paymentFromViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)newCardBtnAction:(id)sender {
    
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    CreditCardViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"CreditCardViewController"];
    
    
    
    homeObj.startDateString = _PaymentFromstartDateString;
    homeObj.EndDateString   = _PaymentFromEndDateString;
    homeObj.bookingProductIDString=_BookProductId;
    
    [self.navigationController pushViewController:homeObj animated:YES];
}

- (IBAction)savedCardBtnAction:(id)sender {
    
    [Utility setValue:@"2" forKey:CreditCardCheck];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    CreditCardListingViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"CreditCardListingViewController"];
    
    homeObj.startDateString = _PaymentFromstartDateString;
    homeObj.endDateString   = _PaymentFromEndDateString;
    homeObj.ProductIdStringString=_BookProductId;
    [self.navigationController pushViewController:homeObj animated:YES];
    
    
    
}


- (IBAction)saveBtnAction:(id)sender {
}


@end
