//
//  SaveCreditCardViewController.m
//  Steezz
//
//  Created by Apple on 03/07/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "SaveCreditCardViewController.h"
#import "FTPopOverMenu.h"
@interface SaveCreditCardViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray *MonthArray;
    NSMutableArray *YearArray;
    NSMutableArray *ATMCard;
    NSDictionary *dict;
    NSString *myText, *CardString ,*saveCardString;
    UIPickerView *UiPickerView,*UIpickerMonth;
}

@end

@implementation SaveCreditCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dict=  [[NSUserDefaults standardUserDefaults]objectForKey:@"loginData"];
    NSLog(@"%@ login data = ",dict);
    
    ATMCard=[[NSMutableArray alloc]initWithObjects:@"VISA",@"MasterCard",@"American Express",@"Discover",nil];
    
    MonthArray=[[NSMutableArray alloc]initWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",nil];
    
    YearArray=[[NSMutableArray alloc]initWithObjects:@"2017",@"2018",@"2019",@"2020",@"2021",@"2022",@"2022",@"2023",@"2024",@"2025",@"2026",@"2027",@"2028",@"2029",@"2030",@"2031",@"2032",@"2033",@"2034",@"2035",@"2036",@"2037",@"2038",@"2039",@"2040",@"2041",@"2042",@"2043",@"2044",@"2045",@"2046",@"2047",@"2048",@"2049",@"2050",nil];
    
    
    UIpickerMonth = [[ UIPickerView alloc] initWithFrame:CGRectMake(0.0f, 386.0f, 250.0f, 100.0f)];
    UIpickerMonth.delegate = self;
    UIpickerMonth.dataSource =self;
    UIpickerMonth.showsSelectionIndicator = YES;
    UIToolbar *comptoolbar1=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *flex1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *genderdoneButton1=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hidePickerMonth)];
    
    [comptoolbar1 setItems:[NSArray arrayWithObjects:genderdoneButton1, nil]];
    comptoolbar1.items = @[flex1, genderdoneButton1];
    [expiryMnth setInputView:UIpickerMonth];
    [expiryMnth setInputAccessoryView:comptoolbar1];
    genderdoneButton1.tintColor = [UIColor blackColor];
    
    UiPickerView = [[ UIPickerView alloc] initWithFrame:CGRectMake(0.0f, 320.0f, 250.0f, 130.0f)];
    UiPickerView.delegate = self;
    UiPickerView.dataSource =self;
    UiPickerView.showsSelectionIndicator = YES;
    UIToolbar *toolbarstate =[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *doneBtnstate=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hidejob)];
    [toolbarstate setItems:[NSArray arrayWithObjects:doneBtnstate, nil]];
    
    [expryYrTxtFld setInputView:UiPickerView];
    [expryYrTxtFld setInputAccessoryView:toolbarstate];
    doneBtnstate.tintColor = [UIColor blackColor];
    

    
//    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:startDate ,nil]];
//    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:endDate ,nil]];
    
    
    // Do any additional setup after loading the view.
}


-(void)hidePickerMonth
{
    [self.view endEditing:YES];
}


-(void)hidejob
{
    [self.view endEditing:YES];
    [UiPickerView endEditing:YES];
}

- (IBAction)saveBackBtnActin:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)saveBtnActn:(id)sender {
    [self validations];
    
}

- (IBAction)cardTypeBtnAction:(id)sender {

    
    NSMutableArray*array=[[NSMutableArray alloc]init];
    [array addObjectsFromArray:ATMCard ];
    
    //  [IdsArray addObjectsFromArray:categoriesIdArray ];
    
    [FTPopOverMenuConfiguration defaultConfiguration].menuWidth=130;
    [FTPopOverMenu showForSender:sender withMenu:array doneBlock:^(NSInteger selectedIndex)
     {
         
         CardString = [NSString stringWithFormat:@"%@",[array objectAtIndex:selectedIndex]];
         [cardTypeBtn setTitle:CardString forState:UIControlStateNormal];
         
     }
                    dismissBlock:^{
                    }];

}

-(void)validations
{
    
    if ([[firstName.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please enter your First Name"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [firstName resignFirstResponder];
        [lastNAme resignFirstResponder];
        [accountNmberTxtFld resignFirstResponder];
        [CvvNmberTxtFld resignFirstResponder];
        [expiryMnth resignFirstResponder];
        [expryYrTxtFld resignFirstResponder];
        
    }
    
    else if ([[lastNAme.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please enter Last name"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        [firstName resignFirstResponder];
        [lastNAme resignFirstResponder];
        [accountNmberTxtFld resignFirstResponder];
        [CvvNmberTxtFld resignFirstResponder];
        [expiryMnth resignFirstResponder];
        [expryYrTxtFld resignFirstResponder];
    }
    
    
    else if ([[accountNmberTxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please enter your Account Number"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        [firstName resignFirstResponder];
        [lastNAme resignFirstResponder];
        [accountNmberTxtFld resignFirstResponder];
        [CvvNmberTxtFld resignFirstResponder];
        [expiryMnth resignFirstResponder];
        [expryYrTxtFld resignFirstResponder];
    }
    
    else if ([[CvvNmberTxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please enter Your Cvv Number"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        [firstName resignFirstResponder];
        [lastNAme resignFirstResponder];
        [accountNmberTxtFld resignFirstResponder];
        [CvvNmberTxtFld resignFirstResponder];
        [expiryMnth resignFirstResponder];
        [expryYrTxtFld resignFirstResponder];
        
        
        
    }
    
    else if ([[expiryMnth.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please enter exp. month"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        [firstName resignFirstResponder];
        [lastNAme resignFirstResponder];
        [accountNmberTxtFld resignFirstResponder];
        [CvvNmberTxtFld resignFirstResponder];
        [expiryMnth resignFirstResponder];
        [expryYrTxtFld resignFirstResponder];
    }
    
    
    else if ([[expryYrTxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please enter exp. Year"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [firstName resignFirstResponder];
        [lastNAme resignFirstResponder];
        [accountNmberTxtFld resignFirstResponder];
        [CvvNmberTxtFld resignFirstResponder];
        [expiryMnth resignFirstResponder];
        [expryYrTxtFld resignFirstResponder];
    }
    else if (CardString==nil)
    {
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please enter your card type"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [firstName resignFirstResponder];
        [lastNAme resignFirstResponder];
        [accountNmberTxtFld resignFirstResponder];
        [CvvNmberTxtFld resignFirstResponder];
        [expiryMnth resignFirstResponder];
        [expryYrTxtFld resignFirstResponder];
        
        
    }
    else
    {
        [self callSaveCreditCardApi];
    }


}


-(void)callSaveCreditCardApi
{
    
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSDictionary* registerInfo;
    
    if ((saveCardString=@""))
    {
        saveCardString = @"0";
        
    }
    
    registerInfo= @{
                    @"cc_fname":firstName.text,
                    @"cc_lname":lastNAme.text,
                    @"cc_number":accountNmberTxtFld.text,
                    @"card_type":CardString,
                    @"exp_month":expiryMnth.text,
                    @"exp_year":expryYrTxtFld.text,
                    @"cvv":CvvNmberTxtFld.text,
                    @"access_token":[dict valueForKey:@"access_token"],
                    };
    
    McomLOG(@"%@",registerInfo);
    [API NewCardSavingWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
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
             [self.navigationController popViewControllerAnimated:YES];
             NSLog(@"sign_up responce Data%@", responseDict);
         }
     }];
}


#pragma mark UIpicker view Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView == UiPickerView)
    {
        return  [NSString stringWithFormat:@"%@",[YearArray objectAtIndex:row]];
    }
    else if(pickerView == UIpickerMonth)
    {
        return  [NSString stringWithFormat:@"%@",[MonthArray objectAtIndex:row]];
        
    }
    
    return 0;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if(pickerView == UiPickerView)
    {
        myText = [NSString stringWithFormat:@"%@",[YearArray objectAtIndex:row]];
        expryYrTxtFld.text=myText;
        
        UiPickerView.hidden = NO;
    }
    else if(pickerView == UIpickerMonth)
    {
        myText = [NSString stringWithFormat:@"%@",[MonthArray objectAtIndex:row]];
        expiryMnth.text=myText;
        
        UIpickerMonth.hidden = NO;
    }
    
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView == UiPickerView)
    {
        return [YearArray  count];
        
    }
    else  if(pickerView == UIpickerMonth)
    {
        return [MonthArray  count];
    }
    
    UiPickerView.hidden = NO;
    UIpickerMonth.hidden = NO;
    return 0;
}

#pragma TextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([accountNmberTxtFld.text length]<17)
    {
        return YES;
    }
    return NO;
}
@end
