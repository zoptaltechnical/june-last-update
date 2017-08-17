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
    
    sucessView.layer.cornerRadius = 8;
    
    sucessLabel.text = [NSString stringWithFormat:@"%@",_Status];
    paypalMailIDLable.text = [NSString stringWithFormat:@"%@",_PaypalIdString];
    productNameLble.text = [NSString stringWithFormat:@"%@",_ProductNAmeString];
    
    if ([_ProductNAmeString isEqualToString:@"Skateboards"]) {
        
        productNameLble.text = @"Skateboard";
    }
    
    
    else if ([_ProductNAmeString isEqualToString:@"Wakeboards"])
    {
        productNameLble.text = @"Wakeboard";
    }
    
    
    else if ([_ProductNAmeString isEqualToString:@"Skimboards"])
    {
        productNameLble.text = @"Skimboard";
        
    }
    
    else if ([_ProductNAmeString isEqualToString:@"Rock Climb"])
    {
        productNameLble.text = @"Rock Climb";
        
    }
    
    else if ([_ProductNAmeString isEqualToString:@"Surfboards"])
    {
        productNameLble.text = @"Surfboard";
        
    }
    
    else if ([_ProductNAmeString isEqualToString:@"Bicycles"])
    {
        productNameLble.text = @"Bicycle";
        
    }
    
    
    else
        
    { productNameLble.text = @"miscellaneous";
        
    }
    

    
    
    AmountPaid.text = [NSString stringWithFormat:@"$ %@",_AmountPaidString];
    totalAmountLabel.text = [NSString stringWithFormat:@"$ %@",_TotalAmountString];
    startDateLble.text = [NSString stringWithFormat:@"%@ Days",_startDateStrig];
    endDateLble.text = [NSString stringWithFormat:@"%@",_EndDateStrings];
    adminCharges.text = [NSString stringWithFormat:@"$ %@",_AdminChargesString];
    
    // Do any additional setup after loading the view.
}
- (IBAction)paymntDetailBackBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
