//
//  LendeeProductDetailViewController.h
//  Steezz
//
//  Created by Apple on 10/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LendeeProductDetailViewController : UIViewController<THDatePickerDelegate>
{
    
    IBOutlet UIButton *categoryBtn;
    
    IBOutlet LPlaceholderTextView *productDetailTextView;
    IBOutlet UIButton *AddBtn;
    
  //  IBOutlet UITextField *dateTextFld;
    
    IBOutlet UIButton *lendeeBackBtn;
    
    IBOutlet MVPlaceSearchTextField *locationTxtFld;
    
    IBOutlet UITextField *priceTxtFld;
    
    IBOutlet LPlaceholderTextView *descriptnTxtView;
    
    IBOutlet UIButton *cameraBtn;
    
    IBOutlet UILabel *name;
    
    IBOutlet UIButton *countBtn;
    
    IBOutlet UIButton *editBtn;
    
    IBOutlet UIImageView *profilePic;
    
    IBOutlet UIButton *availableDatebtn;
    
    IBOutlet UIImageView *productImage;
    
    IBOutlet UIButton *deleteBtn;
}

@property (nonatomic, retain) NSDate * curDate;
@property (nonatomic, retain) NSDateFormatter * formatter;
@property (nonatomic, strong) THDatePickerViewController * datePicker;
@property(nonatomic,strong) NSString * LendeeProductID;

@end
