//
//  BookNowViewController.h
//  Steezz
//
//  Created by Apple on 23/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THDatePickerViewController.h"
#import "CZPickerView.h"
@interface BookNowViewController : UIViewController<THDatePickerDelegate, CZPickerViewDataSource, CZPickerViewDelegate>

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
    
  
    
    IBOutlet UIButton *bookNowBtn;
    
    
    IBOutlet UIButton *selectedDateCount;
    
    
    IBOutlet UIView *myCalnderView;
    
    
}

@property (nonatomic, strong) THDatePickerViewController * datePicker;
@property(nonatomic,strong) NSString * availabelDate;

@property(nonatomic,strong) NSString * ProdctID;
@property(nonatomic,strong) NSString * PerDayAmount;
@end
