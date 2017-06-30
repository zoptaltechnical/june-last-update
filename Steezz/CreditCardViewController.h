//
//  CreditCardViewController.h
//  Steezz
//
//  Created by Apple on 25/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditCardViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
{
    
    IBOutlet UITextField *firstName;
    
    IBOutlet UITextField *lastName;
    
    
    IBOutlet UITextField *startDate;
    
    IBOutlet UITextField *endDate;
    
    IBOutlet UITextField *accountNumberTxtFld;
    
    
    IBOutlet UITextField *cvvNumberTxtFld;
    
    IBOutlet UIButton *cardTypeBtn;
    
    
    IBOutlet UITextField *expMnth;
    
    IBOutlet UIButton *saveCard;
    
    IBOutlet UITextField *expYrTxtFld;
    
    IBOutlet UIButton *backBtn;
    
    IBOutlet UIButton *payBtn;
    
 }


@property(nonatomic,strong) NSString * startDateString;
@property(nonatomic,strong) NSString * EndDateString;


@property(nonatomic,strong) NSString * bookingProductIDString;
@end
