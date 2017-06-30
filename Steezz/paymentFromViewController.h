//
//  paymentFromViewController.h
//  Steezz
//
//  Created by Apple on 26/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface paymentFromViewController : UIViewController

{
    
    IBOutlet UIButton *back;
    
    IBOutlet UIButton *newCardBtn;
    
    IBOutlet UIButton *savedCardBtn;
    
    IBOutlet UIButton *saveBtn;
    
}


@property(nonatomic,strong) NSString * PaymentFromstartDateString;
@property(nonatomic,strong) NSString * PaymentFromEndDateString;
@property(nonatomic,strong) NSString * BookProductId;
@end
