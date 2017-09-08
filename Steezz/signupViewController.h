//
//  signupViewController.h
//  Steezz
//
//  Created by Apple on 05/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVPlaceSearchTextField.h"
#import "LPlaceholderTextView.h"
@interface signupViewController : UIViewController

{
    IBOutlet UIView *termOfServicePopView;
    
    IBOutlet UIButton *termsOkButton;
    
    IBOutlet UIWebView *myTermsWebView;
    
    IBOutlet UIButton *signUpBackBtn;
    
    IBOutlet UITextField *firstnameTxtFld;
    
    IBOutlet UITextField *lastnameTxtFld;
    
    IBOutlet UITextField *cityTxtFlr;

    IBOutlet UITextField *statetxtFld;
    
    IBOutlet UITextField *emailTxtFld;
    
    IBOutlet UITextField *zipcodeTxtFld;
    
    IBOutlet UIDatePicker *age_picker;
    
    IBOutlet UIView *datePickerView;
    
    IBOutlet UIButton *dateOfBirthBtn;
    
    IBOutlet UIButton *pickerCancelBtn;
    
    IBOutlet UIButton *pickerDoneBtn;
    
 
    IBOutlet UIButton *termsOfServicesBtn;
   
    
    IBOutlet UITextField *passwordTxtFld;
    
    IBOutlet UITextField *cnfirmPasswrdTxtFld;
    IBOutlet UITextField *mobileTxtFld;
    
    
    IBOutlet MVPlaceSearchTextField *areaTxtFld;
    
    IBOutlet UITextField *addressTxtFld;
    
    IBOutlet UIButton *signUpBtn;
    
    IBOutlet UIButton *signInBtn;
}

@end
