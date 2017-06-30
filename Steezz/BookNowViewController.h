//
//  BookNowViewController.h
//  Steezz
//
//  Created by Apple on 23/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THDatePickerViewController.h"

@interface BookNowViewController : UIViewController<THDatePickerDelegate>

{
    IBOutlet UIButton *crossBtn;
    IBOutlet UILabel *numberofDay;
    IBOutlet UIView *backGroundView;
    
    IBOutlet UIView *popUpView;
    IBOutlet UILabel *amountToPay;
    IBOutlet UIButton *creditCard;
    
    IBOutlet UILabel *perDayPrice;
    
    IBOutlet UIButton *payPal;
    IBOutlet UIButton *backBtn;
    IBOutlet UITextField *startDate;
    
    IBOutlet UILabel *dummyAmount;
    IBOutlet UILabel *daysLabel;
    
    IBOutlet UILabel *dummyDay;
    IBOutlet UILabel *amountLabel;
    IBOutlet UIButton *endDateBtn;
    
    IBOutlet UIButton *booking;
    
}

@property (nonatomic, strong) THDatePickerViewController * datePicker;
@property(nonatomic,strong) NSString * availabelDate;

@property(nonatomic,strong) NSString * ProdctID;
@property(nonatomic,strong) NSString * PerDayAmount;
@end
