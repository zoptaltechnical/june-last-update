//
//  PaymentDetailViewController.h
//  Steezz
//
//  Created by Apple on 10/07/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentDetailViewController : UIViewController

{
    
    IBOutlet UILabel *startDateLble;
    
    IBOutlet UILabel *endDateLble;
    
    IBOutlet UILabel *paypalMailIDLable;
    
    IBOutlet UIButton *PaymntDetailbackBtn;
    
    IBOutlet UILabel *AmountPaid;
    
    IBOutlet UILabel *productNameLble;
    
    IBOutlet UILabel *sucessLabel;
    
    IBOutlet UILabel *adminCharges;
    IBOutlet UILabel *totalAmountLabel;
}


@property(nonatomic,strong) NSString * Status;
@property(nonatomic,strong) NSString * TotalAmountString;
@property(nonatomic,strong) NSString * AdminChargesString;
@property(nonatomic,strong) NSString * AmountPaidString;
@property(nonatomic,strong) NSString * PaypalIdString;
@property(nonatomic,strong) NSString * ProductNAmeString;
@property(nonatomic,strong) NSString * ProductImage;
@property(nonatomic,strong) NSString * FirstName;
@property(nonatomic,strong) NSString * startDateStrig;
@property(nonatomic,strong) NSString * EndDateStrings;

@end
