//
//  PaymentDetailViewController.m
//  Steezz
//
//  Created by Apple on 10/07/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "PaymentDetailViewController.h"

@interface PaymentDetailViewController ()

@end

@implementation PaymentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sucessLabel.text = [NSString stringWithFormat:@"%@",_Status];
    paypalMailIDLable.text = [NSString stringWithFormat:@"%@",_PaypalIdString];
    productNameLble.text = [NSString stringWithFormat:@"%@",_ProductNAmeString];
    AmountPaid.text = [NSString stringWithFormat:@"$ %@",_AmountPaidString];
    totalAmountLabel.text = [NSString stringWithFormat:@"$ %@",_TotalAmountString];
    startDateLble.text = [NSString stringWithFormat:@"%@",_startDateStrig];
    endDateLble.text = [NSString stringWithFormat:@"%@",_EndDateStrings];
    
    adminCharges.text = [NSString stringWithFormat:@"$ %@",_AdminChargesString];
    
    // Do any additional setup after loading the view.
}
- (IBAction)paymntDetailBackBtnAction:(id)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
