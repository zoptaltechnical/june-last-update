//
//  signupViewController.m
//  Steezz
//
//  Created by Apple on 05/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "signupViewController.h"

@interface signupViewController ()<PlaceSearchTextFieldDelegate>

{
    NSString *termOfSerivecs;
    
    NSString *MyDateOfBirth;
    
      UIDatePicker *DatePicker;
}

@end

@implementation signupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     termOfSerivecs = @"0";
    
    termOfServicePopView.layer.cornerRadius = 8.0;

     [dateOfBirthBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 15.0f, 0.0f, 0.0f)];
    
    firstnameTxtFld.borderStyle = UITextBorderStyleLine;
    firstnameTxtFld.layer.borderWidth = 1;
    firstnameTxtFld.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    firstnameTxtFld.layer.cornerRadius = 15.0;
    
    
    cnfirmPasswrdTxtFld.borderStyle = UITextBorderStyleLine;
    cnfirmPasswrdTxtFld.layer.borderWidth = 1;
    cnfirmPasswrdTxtFld.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    cnfirmPasswrdTxtFld.layer.cornerRadius = 15.0;
    
    statetxtFld.borderStyle = UITextBorderStyleLine;
    statetxtFld.layer.borderWidth = 1;
    statetxtFld.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    statetxtFld.layer.cornerRadius = 15.0;
    
    dateOfBirthBtn.layer.borderWidth = 1;
    dateOfBirthBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    dateOfBirthBtn.layer.cornerRadius = 15.0;
    
    cityTxtFlr.borderStyle = UITextBorderStyleLine;
    cityTxtFlr.layer.borderWidth = 1;
    cityTxtFlr.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    cityTxtFlr.layer.cornerRadius = 15.0;
    
    zipcodeTxtFld.borderStyle = UITextBorderStyleLine;
    zipcodeTxtFld.layer.borderWidth = 1;
    zipcodeTxtFld.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    zipcodeTxtFld.layer.cornerRadius = 15.0;
    
    lastnameTxtFld.borderStyle = UITextBorderStyleLine;
    lastnameTxtFld.layer.borderWidth = 1;
    lastnameTxtFld.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    lastnameTxtFld.layer.cornerRadius = 15.0;

    passwordTxtFld.borderStyle = UITextBorderStyleLine;
    passwordTxtFld.layer.borderWidth = 1;
    passwordTxtFld.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    passwordTxtFld.layer.cornerRadius = 15.0;

    emailTxtFld.borderStyle = UITextBorderStyleLine;
    emailTxtFld.layer.borderWidth = 1;
    emailTxtFld.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    emailTxtFld.layer.cornerRadius = 15.0;

    addressTxtFld.borderStyle = UITextBorderStyleLine;
    addressTxtFld.layer.borderWidth = 1;
    addressTxtFld.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    addressTxtFld.layer.cornerRadius = 15.0;

    mobileTxtFld.borderStyle = UITextBorderStyleLine;
    mobileTxtFld.layer.borderWidth = 1;
    mobileTxtFld.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    mobileTxtFld.layer.cornerRadius = 15.0;
    
    areaTxtFld.placeSearchDelegate                 = self;
    areaTxtFld.strApiKey                           = @"AIzaSyCDi2dklT-95tEHqYoE7Tklwzn3eJP-MtM";
    areaTxtFld.superViewOfList                     = self.view;
    areaTxtFld.autoCompleteShouldHideOnSelection   = YES;
    areaTxtFld.maximumNumberOfAutoCompleteRows     = 5;
   
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:firstnameTxtFld ,nil]];
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:lastnameTxtFld ,nil]];
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:passwordTxtFld ,nil]];
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:mobileTxtFld ,nil]];
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:areaTxtFld ,nil]];
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:addressTxtFld ,nil]];
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:emailTxtFld ,nil]];
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:zipcodeTxtFld ,nil]];
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:statetxtFld ,nil]];
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:cityTxtFlr ,nil]];
     [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:cnfirmPasswrdTxtFld ,nil]];
    
    // Do any additional setup after loading the view.
}


- (IBAction)pickerCancelBtnAction:(id)sender
{
    datePickerView.hidden = YES;
}


- (IBAction)pickerDoneBtnAction:(id)sender {
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];
    NSString *currentTime = [dateFormatter stringFromDate:age_picker.date];
    [dateOfBirthBtn setTitle:currentTime forState:UIControlStateNormal];
    [dateOfBirthBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    MyDateOfBirth = currentTime;
    
    datePickerView.hidden = YES;
    
    
    
    
}






- (IBAction)dateOfBirthbtnAction:(id)sender
{
    
    datePickerView.hidden = NO;
    [statetxtFld resignFirstResponder];
    [cityTxtFlr resignFirstResponder];
    [zipcodeTxtFld resignFirstResponder];
    [emailTxtFld resignFirstResponder];
    [firstnameTxtFld resignFirstResponder];
    [lastnameTxtFld resignFirstResponder];
    [passwordTxtFld resignFirstResponder];
    [addressTxtFld resignFirstResponder];
    [areaTxtFld resignFirstResponder];
    [mobileTxtFld resignFirstResponder];
    [emailTxtFld resignFirstResponder];
    
    [self validateAge];
}





-(void)validateAge {
    
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger day = [today day];
    NSInteger month = [today month];
    NSInteger year = [today year];
    
    int correctYear = year - 18;
    
    NSDateComponents *correctAge = [[NSDateComponents alloc] init];
    [correctAge setDay:day];
    [correctAge setMonth:month];
    [correctAge setYear:correctYear];
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    [age_picker setDatePickerMode:UIDatePickerModeDate];
    [age_picker setMaximumDate:[calendar dateFromComponents:correctAge]];
    
    return;
}


-(void)viewDidAppear:(BOOL)animated{
    
    //Optional Properties
    areaTxtFld.autoCompleteRegularFontName =  @"HelveticaNeue-Bold";
    areaTxtFld.autoCompleteBoldFontName = @"HelveticaNeue";
    areaTxtFld.autoCompleteTableCellTextColor=[UIColor colorWithWhite:0.131 alpha:1.000];
    areaTxtFld.autoCompleteFontSize=14;
  //  areaTxtFld.autoCompleteTableBorderWidth=1.0;
    areaTxtFld.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=YES;
    areaTxtFld.autoCompleteShouldHideOnSelection=YES;
    areaTxtFld.autoCompleteShouldHideClosingKeyboard=YES;
    areaTxtFld.autoCompleteShouldSelectOnExactMatchAutomatically = YES;
    
    NSLog(@"%@",areaTxtFld.text);
    
    areaTxtFld.autoCompleteTableFrame = CGRectMake((self.view.frame.size.width-areaTxtFld.frame.size.width)*0.5, areaTxtFld.frame.size.height+100.0, areaTxtFld.frame.size.width, 200.0);
}


- (IBAction)myTermsOkBtnAction:(id)sender {
    
    [UIView transitionWithView:termOfServicePopView
                      duration:1.4
                       options:UIViewAnimationOptionTransitionFlipFromBottom
                    animations:^{
                        termOfServicePopView.hidden = YES;
                    }
                    completion:NULL];
    
    
    
}


- (IBAction)termsOfServicesBtnAction:(id)sender {

        
        if ([termsOfServicesBtn.currentImage isEqual:[UIImage imageNamed:@"cricle"]])
        {

            termOfSerivecs = @"1";
            [termsOfServicesBtn setImage:[UIImage imageNamed:@"select_icon-1"] forState:UIControlStateNormal];            
            [UIView transitionWithView:termOfServicePopView
                              duration:1.4
                               options:UIViewAnimationOptionTransitionFlipFromTop
                            animations:^{
                                termOfServicePopView.hidden = NO;
                            }
                            completion:NULL];
            
            
            NSURL *url = [NSURL URLWithString:@"https://zoptal.com/demo/steezz/terms"];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
            [myTermsWebView loadRequest:requestObj];
  
        }
        else
        {

          termOfSerivecs = @"0";
            [termsOfServicesBtn setImage:[UIImage imageNamed:@"cricle"] forState:UIControlStateNormal];
        }
 
    
}




#pragma mark - 
#pragma -> Place search Textfield Delegates
-(void)placeSearchResponseForSelectedPlace:(NSMutableDictionary*)responseDict{
    [self.view endEditing:YES];
    NSLog(@"%@",responseDict);
    
    NSDictionary *aDictLocation=[[[responseDict objectForKey:@"result"] objectForKey:@"geometry"] objectForKey:@"location"];
    NSLog(@"SELECTED ADDRESS :%@",aDictLocation);
}
-(void)placeSearchWillShowResult{
    
}
-(void)placeSearchWillHideResult{
    
}
-(void)placeSearchResultCell:(UITableViewCell *)cell withPlaceObject:(PlaceObject *)placeObject atIndex:(NSInteger)index{
    if(index%2==0){
        cell.contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
}




- (IBAction)signUpBtnPressed:(id)sender {
    
    

    
    [self validations];
    
}




- (IBAction)signInBtnPressed:(id)sender {
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    signInViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"signInViewController"];
    [self.navigationController pushViewController:homeObj animated:YES];
}

- (IBAction)signupBackBtnPressed:(id)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}




-(void)validations
{
    
    if ([[firstnameTxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter your First name"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        [emailTxtFld resignFirstResponder];
        [firstnameTxtFld resignFirstResponder];
          [lastnameTxtFld resignFirstResponder];
        [passwordTxtFld resignFirstResponder];
        [addressTxtFld resignFirstResponder];
        [areaTxtFld resignFirstResponder];
        [mobileTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
        [statetxtFld resignFirstResponder];
        [cityTxtFlr resignFirstResponder];
        [zipcodeTxtFld resignFirstResponder];
        
        
    }
    
    else if ([[lastnameTxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {

    
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter your Last Name"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [emailTxtFld resignFirstResponder];
        [firstnameTxtFld resignFirstResponder];
        [lastnameTxtFld resignFirstResponder];
        [passwordTxtFld resignFirstResponder];
        [addressTxtFld resignFirstResponder];
        [areaTxtFld resignFirstResponder];
        [mobileTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
        [statetxtFld resignFirstResponder];
        [cityTxtFlr resignFirstResponder];
        [zipcodeTxtFld resignFirstResponder];
    }
    
    
    else if (![passwordTxtFld.text isEqualToString:cnfirmPasswrdTxtFld.text])
    {
        
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please confirm your password"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [emailTxtFld resignFirstResponder];
        [firstnameTxtFld resignFirstResponder];
        [lastnameTxtFld resignFirstResponder];
        [passwordTxtFld resignFirstResponder];
        [addressTxtFld resignFirstResponder];
        [areaTxtFld resignFirstResponder];
        [mobileTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
        [cnfirmPasswrdTxtFld resignFirstResponder];
        [statetxtFld resignFirstResponder];
        [cityTxtFlr resignFirstResponder];
        [zipcodeTxtFld resignFirstResponder];
        
    }
    
    
    else if ([[passwordTxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter your Password"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [emailTxtFld resignFirstResponder];
        [firstnameTxtFld resignFirstResponder];
        [lastnameTxtFld resignFirstResponder];
        [passwordTxtFld resignFirstResponder];
        [addressTxtFld resignFirstResponder];
        [areaTxtFld resignFirstResponder];
        [mobileTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
        
        [statetxtFld resignFirstResponder];
        [cityTxtFlr resignFirstResponder];
        [zipcodeTxtFld resignFirstResponder];
    }
    
    
    else if ([[emailTxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter your Email"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        [statetxtFld resignFirstResponder];
        [cityTxtFlr resignFirstResponder];
        [zipcodeTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
        [firstnameTxtFld resignFirstResponder];
        [lastnameTxtFld resignFirstResponder];
        [passwordTxtFld resignFirstResponder];
        [addressTxtFld resignFirstResponder];
        [areaTxtFld resignFirstResponder];
        [mobileTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
    }
    
    else if ([[addressTxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter your Address"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        [statetxtFld resignFirstResponder];
        [cityTxtFlr resignFirstResponder];
        [zipcodeTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
        [firstnameTxtFld resignFirstResponder];
        [lastnameTxtFld resignFirstResponder];
        [passwordTxtFld resignFirstResponder];
        [addressTxtFld resignFirstResponder];
        [areaTxtFld resignFirstResponder];
        [mobileTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
    }
 
    
    else if ([[mobileTxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter your Phone Number"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        [statetxtFld resignFirstResponder];
        [cityTxtFlr resignFirstResponder];
        [zipcodeTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
        [firstnameTxtFld resignFirstResponder];
        [lastnameTxtFld resignFirstResponder];
        [passwordTxtFld resignFirstResponder];
        [addressTxtFld resignFirstResponder];
        [areaTxtFld resignFirstResponder];
        [mobileTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
    }
    
    
    else if ([[statetxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter your State"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        [statetxtFld resignFirstResponder];
        [cityTxtFlr resignFirstResponder];
        [zipcodeTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
        [firstnameTxtFld resignFirstResponder];
        [lastnameTxtFld resignFirstResponder];
        [passwordTxtFld resignFirstResponder];
        [addressTxtFld resignFirstResponder];
        [areaTxtFld resignFirstResponder];
        [mobileTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
    }
    
    
    
    
    else if ([[cityTxtFlr.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter your City"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        [statetxtFld resignFirstResponder];
        [cityTxtFlr resignFirstResponder];
        [zipcodeTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
        [firstnameTxtFld resignFirstResponder];
        [lastnameTxtFld resignFirstResponder];
        [passwordTxtFld resignFirstResponder];
        [addressTxtFld resignFirstResponder];
        [areaTxtFld resignFirstResponder];
        [mobileTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
    }
    
    
    
    else if ([[zipcodeTxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter your Zip Code"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        [statetxtFld resignFirstResponder];
        [cityTxtFlr resignFirstResponder];
        [zipcodeTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
        [firstnameTxtFld resignFirstResponder];
        [lastnameTxtFld resignFirstResponder];
        [passwordTxtFld resignFirstResponder];
        [addressTxtFld resignFirstResponder];
        [areaTxtFld resignFirstResponder];
        [mobileTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
    }
    
    else if (![Utility NSStringIsValidEmail:emailTxtFld.text])
    {
        
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter Valid Email"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationRightToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        [statetxtFld resignFirstResponder];
        [cityTxtFlr resignFirstResponder];
        [zipcodeTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
        [firstnameTxtFld resignFirstResponder];
        [lastnameTxtFld resignFirstResponder];
        [passwordTxtFld resignFirstResponder];
        [addressTxtFld resignFirstResponder];
        [areaTxtFld resignFirstResponder];
        [mobileTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
        
    }
    
    else if ([MyDateOfBirth length]==0)
    {
        
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter your date of birth."
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationRightToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        [statetxtFld resignFirstResponder];
        [cityTxtFlr resignFirstResponder];
        [zipcodeTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
        [firstnameTxtFld resignFirstResponder];
        [lastnameTxtFld resignFirstResponder];
        [passwordTxtFld resignFirstResponder];
        [addressTxtFld resignFirstResponder];
        [areaTxtFld resignFirstResponder];
        [mobileTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
        
    }
    
    
  else if ([termOfSerivecs isEqualToString:@"0"])
    {
        
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please agree to terms & conditions."
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationRightToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        [statetxtFld resignFirstResponder];
        [cityTxtFlr resignFirstResponder];
        [zipcodeTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
        [firstnameTxtFld resignFirstResponder];
        [lastnameTxtFld resignFirstResponder];
        [passwordTxtFld resignFirstResponder];
        [addressTxtFld resignFirstResponder];
        [areaTxtFld resignFirstResponder];
        [mobileTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
        
    }
    
    
    
    
    
    
    
    
    
     else
    {
        [self callSignUpAPI];
        
    }
}

-(void)callSignUpAPI
{
    
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSDictionary* registerInfo;
    
            registerInfo= @{
                            @"first_name":firstnameTxtFld.text,
                            @"last_name":lastnameTxtFld.text,
                            @"email":emailTxtFld.text,
                            @"password":passwordTxtFld.text,
                            @"address":addressTxtFld.text,
                            @"cpassword":passwordTxtFld.text,
                            @"phone":mobileTxtFld.text,
                            @"password":passwordTxtFld.text,
                            @"device_token":[Utility valueForKey:DeviceToken],
                            @"device_type":@"IOS",
                            @"city":cityTxtFlr.text,
                            @"state":statetxtFld.text,
                            @"zip_code":zipcodeTxtFld.text,
                            @"date_of_birth":MyDateOfBirth
                            };
    
    McomLOG(@"%@",registerInfo);
    [API signUpUserWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
     {
         [Appdelegate stopLoader:nil];
         NSDictionary *dict_response = [[NSDictionary alloc]initWithDictionary:responseDict];
         
         if ([responseDict[@"result"]boolValue]==0)
         {
             NSString * errormessage = [NSString stringWithFormat:@"%@",[dict_response valueForKey:@"message"]];
             
             [Utility showAlertWithTitleText:errormessage messageText:nil delegate:nil];
         }
         else if ([responseDict[@"result"]boolValue]==1)
         {
             
             //  [Utility setValue:[responseDict valueForKey:@"access_token"] forKey:access_token];
             
             
             NSLog(@"sign_up responce Data%@", responseDict);
             
             
             [[NSUserDefaults standardUserDefaults] setObject:[responseDict objectForKey:@"data"]forKey:@"loginData"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             
            UIViewController *popUpController = ViewControllerIdentifier(@"LenderNavigateID");
            [self.view.window setRootViewController:popUpController];
             

         }
     }];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [Appdelegate stopLoader:nil];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"webview error:%@",[error localizedDescription]);
}


@end
