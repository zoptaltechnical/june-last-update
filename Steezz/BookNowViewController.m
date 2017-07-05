//
//  BookNowViewController.m
//  Steezz
//
//  Created by Apple on 23/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "BookNowViewController.h"
#import "PayPalMobile.h"
#import "PayPalConfiguration.h"
#import "PayPalPaymentViewController.h"

@interface BookNowViewController ()<PayPalPaymentDelegate>
{
    NSString *mystring;
    
    NSString* paypalId;
    NSString *create_time;
    
    NSDecimalNumber *totalAmountToPay;
    
    NSDictionary *dict;
}

@property (nonatomic, retain) NSDate * curDate;
@property (nonatomic, retain) NSDateFormatter * formatter;
@property (nonatomic, strong) PayPalConfiguration *PayPalPaymentConfig;
@end

@implementation BookNowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dict=  [[NSUserDefaults standardUserDefaults]objectForKey:@"loginData"];
    NSLog(@"%@ login data = ",dict);
    
    [backGroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.81]];
    popUpView.layer.cornerRadius = 8.0;
    
    startDate.text = [NSString stringWithFormat:@"%@",_availabelDate];
    [endDateBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f)];
    
    self.curDate = [NSDate date];
    self.formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy-MM-dd"];
    
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:startDate ,nil]];
  
    
    _PayPalPaymentConfig = [[PayPalConfiguration alloc]init];
    _PayPalPaymentConfig.acceptCreditCards = YES;
    _PayPalPaymentConfig.merchantName = @"PrinceMehra";
    _PayPalPaymentConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _PayPalPaymentConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    _PayPalPaymentConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    _PayPalPaymentConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    
    
    
    
    // Do any additional setup after loading the view.
}

- (IBAction)BookingBtnAction:(id)sender {
    
    [self bookingValidation];
    
}


- (IBAction)crossBtnPressed:(id)sender {
    
    backGroundView.hidden = YES;
}




- (IBAction)backBtnPressed:(id)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}





- (IBAction)endDateBtnPressed:(id)sender {
    
    mystring = nil;
    
    if(!self.datePicker)
        self.datePicker = [THDatePickerViewController datePicker];
    self.datePicker.date = self.curDate;
    self.datePicker.delegate = self;
    [self.datePicker setAllowClearDate:NO];
    [self.datePicker setClearAsToday:YES];
    [self.datePicker setAutoCloseOnSelectDate:NO];
    
     [self.datePicker setAllowSelectionOfSelectedDate:YES];
    
    [self.datePicker setDisableYearSwitch:YES];
    [self.datePicker setDisableFutureSelection:YES];
    [self.datePicker setDaysInHistorySelection:0];
    [self.datePicker setDaysInFutureSelection:0];
    
    
    
    [self.datePicker setAllowMultiDaySelection:YES];
    // [self.datePicker setDateTimeZoneWithName:@"UTC"];
    // [self.datePicker setAutoCloseCancelDelay:5.0];
    [self.datePicker setSelectedBackgroundColor:[UIColor colorWithRed:125/255.0 green:208/255.0 blue:0/255.0 alpha:1.0]];
    [self.datePicker setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];
    [self.datePicker setCurrentDateColorSelected:[UIColor yellowColor]];
    
    [self.datePicker setDateHasItemsCallback:^BOOL(NSDate *date) {
        int tmp = (arc4random() % 30)+1;
        return (tmp % 5 == 0);
    }];
    [self presentSemiViewController:self.datePicker withOptions:@{
                                                                  KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                                  KNSemiModalOptionKeys.animationDuration : @(0.3),
                                                                  KNSemiModalOptionKeys.shadowOpacity     : @(1.0),
                                                                  }];
}



-(void)bookingValidation
{
    if ([mystring length]==0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please Select End Date!"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationZoom
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
    }
    
    
    else
    {
        [self callBookProductAPI];
    }
}



#pragma Call Book Product API

-(void)callBookProductAPI
{
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"],
                                   @"product_id":_ProdctID,
                                   @"start_date":_availabelDate,
                                   @"end_date":mystring
                                   };
    McomLOG(@"%@",registerInfo);
    [API BookProductWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
     {
         
         [Appdelegate stopLoader:nil];
         
         NSDictionary *dict_response = [[NSDictionary alloc]initWithDictionary:responseDict];
         
         if ([responseDict[@"result"]boolValue]==0)
         {
             NSString * errormessage = [NSString stringWithFormat:@"%@",[dict_response valueForKey:@"message"]];
             
             [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                            message:errormessage
                                    leftActionTitle:@"OK"
                                   rightActionTitle:@""
                                     animationStyle:AlertViewAnimationRightToCenterSpring
                                       selectAction:^(AlertViewActionType actionType) {
                                           NSLog(@"%zd", actionType);
                                       }];
             
             [endDateBtn setTitle:nil forState:UIControlStateNormal];
             mystring = nil;
             
             [self.navigationController popViewControllerAnimated:YES];
             
             
         }
         else if ([responseDict[@"result"]boolValue]==1)
         {
             NSLog(@"sign_up%@", responseDict);
             
             backGroundView.hidden = NO;
             dummyAmount.hidden = NO;
             dummyDay.hidden = NO;
             daysLabel.hidden = NO;
             amountLabel.hidden = NO;
             daysLabel.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"] valueForKey:@"num_of_days"]];
             amountLabel.text = [NSString stringWithFormat:@"$%@",[[responseDict valueForKey:@"data"] valueForKey:@"total_amount"]];
             
             amountToPay.text = [NSString stringWithFormat:@"$%@",[[responseDict valueForKey:@"data"] valueForKey:@"total_amount"]];
             
             totalAmountToPay = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"] valueForKey:@"total_amount"]]];
             NSLog(@"%@",totalAmountToPay);
             
             numberofDay.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"] valueForKey:@"num_of_days"]];
             
             perDayPrice.text = [NSString stringWithFormat:@"$ %@/Day",_PerDayAmount];
         }
     }];
}

- (IBAction)creditBtnAction:(id)sender {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    paymentFromViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"paymentFromViewController"];

    homeObj.PaymentFromstartDateString = _availabelDate;
    homeObj.PaymentFromEndDateString = mystring;
    homeObj.BookProductId = _ProdctID;
    
    [self.navigationController pushViewController:homeObj animated:YES];
  
}


- (IBAction)payPalBtnAction:(id)sender {
    
    PayPalItem *item1 = [PayPalItem itemWithName:@"skateboard" withQuantity:1 withPrice:totalAmountToPay withCurrency:@"USD" withSku:@"SKU-Skateboard"];
        
    PayPalItem *item2 = [PayPalItem itemWithName:@"Steezz Product" withQuantity:1 withPrice:[NSDecimalNumber decimalNumberWithString:@"00.00"] withCurrency:@"USD" withSku:@"SKU-Steezz-Product"];
    NSArray*items = @[item1,item2];
        
    NSDecimalNumber *subtotal =[PayPalItem totalPriceForItems:items];
        
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc]initWithString:@"0.0"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc]initWithString:@"0"];
        
    PayPalPaymentDetails *payDetail = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal withShipping:shipping withTax:tax];
        
    NSDecimalNumber *totallPayableCharge = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
        
    PayPalPayment *payment = [[PayPalPayment alloc]init];
        
    payment.amount = totallPayableCharge;
    payment.currencyCode = @"USD";
    payment.shortDescription  =@"Steezz Payment";
    payment.items = items;
    payment.paymentDetails = payDetail;
    
    if (! payment.processable)
    {
    }
    PayPalPaymentViewController *payVC = [[PayPalPaymentViewController alloc]initWithPayment:payment configuration:self.PayPalPaymentConfig delegate:self];
        
    [self presentViewController:payVC animated:YES completion:nil];
}

#pragma mark - THDatePickerDelegate

- (void)datePickerDonePressed:(THDatePickerViewController *)datePicker {
    self.curDate = datePicker.date;
    
    
    NSComparisonResult result = [_availabelDate compare:mystring];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
    
    
    switch (result)
    {
        case NSOrderedAscending:
        {
            [endDateBtn setTitle:mystring forState:UIControlStateNormal];
        }
            
        break;
        case NSOrderedDescending:
        {
            mystring = nil;
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"date's Selected" message:@"Please select Future Date " preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
            
            mystring = nil;
            dummyDay.hidden = YES;
            dummyAmount.hidden = YES;
            amountLabel.hidden = YES;
            daysLabel.hidden = YES;
            [endDateBtn setTitle:nil forState:UIControlStateNormal];
            [self dismissSemiModalView];
        }
         
            break;
        
        default:
           // NSLog(@"erorr dates %@, %@", [df stringFromDate:_availabelDate], [df stringFromDate:mystring]);
            break;
    }
    
    
    
    
    if ([mystring length]==0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"date's Selected" message:@"nothing is selected " preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        [self dismissSemiModalView];
        
        
    }
    else
    {
        [self dismissSemiModalView];
        
    }
}

- (void)datePickerCancelPressed:(THDatePickerViewController *)datePicker {
  
    NSLog(@"randomDateSelection after cancle button pressed = %@",mystring);
    [self dismissSemiModalView];
}

- (void)datePicker:(THDatePickerViewController *)datePicker selectedDate:(NSDate *)selectedDate
{
    mystring = @"SelectedString";
    NSLog(@"Date selected: %@",[_formatter stringFromDate:selectedDate]);
    NSLog(@"selectedDate = %@",selectedDate);
    
    mystring  = [_formatter stringFromDate:selectedDate];
    NSLog(@"myString = %@",mystring);
    
}


-(void)datePicker:(THDatePickerViewController *)datePicker deselectedDate:(NSDate *)deselectedDate
{
    
    NSLog(@"Date selected: %@",[_formatter stringFromDate:deselectedDate]);
    NSLog(@"de_selectedDate = %@",deselectedDate);
    mystring =  nil;
    
  /*  if ([randomDateSelection containsObject:[_formatter stringFromDate:deselectedDate]])
    {
        [randomDateSelection removeObject:[_formatter stringFromDate:deselectedDate]];
        NSLog(@"my array = %@",randomDateSelection);
        
        // convert array into string and seperated the date's with ","
        //    NSString * myString = [randomDateSelection componentsJoinedByString:@", "];
        //    NSLog(@"%@",myString);
        
    }
   
   */
    
}





#pragma paypal apyment Delegate



-(void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController
{
    NSLog(@" Paypal Payment Cancel.....");
    
    backGroundView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}


-(void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment
{
    NSLog(@"completedPayment = %@",completedPayment);
    paypalId=[[completedPayment.confirmation valueForKey:@"response"]valueForKey:@"id"];
    create_time=[[completedPayment.confirmation valueForKey:@"response"]valueForKey:@"create_time"];
    NSLog(@"%@",create_time);
    
    backGroundView.hidden = YES;
    
    NSLog(@" Paypal Payment SuccessFull");
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self PaymentSucessAPI];
    
    
}


-(void)PaymentSucessAPI
{
    
   
    
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"],
                                   @"product_id":_ProdctID,
                                   @"start_date":_availabelDate,
                                   @"end_date":mystring,
                                   @"txd_id":paypalId,
                                   @"create_time":create_time
                                   };
    McomLOG(@"%@",registerInfo);
    [API paypalPaymentSucessWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
     {
         
         [Appdelegate stopLoader:nil];
         
         NSDictionary *dict_response = [[NSDictionary alloc]initWithDictionary:responseDict];
         
         if ([responseDict[@"result"]boolValue]==0)
         {
             NSString * errormessage = [NSString stringWithFormat:@"%@",[dict_response valueForKey:@"message"]];
             
             [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                            message:errormessage
                                    leftActionTitle:@"OK"
                                   rightActionTitle:@""
                                     animationStyle:AlertViewAnimationRightToCenterSpring
                                       selectAction:^(AlertViewActionType actionType) {
                                           NSLog(@"%zd", actionType);
                                       }];
             
           
             
             
         }
         else if ([responseDict[@"result"]boolValue]==1)
         {
             NSLog(@"sign_up%@", responseDict);
             
             [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                            message:@""
                                    leftActionTitle:@"OK"
                                   rightActionTitle:@""
                                     animationStyle:AlertViewAnimationRightToCenterSpring
                                       selectAction:^(AlertViewActionType actionType) {
                                           NSLog(@"%zd", actionType);
                                       }];

             
             
         }
     }];

    
    
}


@end
