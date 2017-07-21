//
//  BookNowViewController.m
//  Steezz
//
//  Created by Apple on 23/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//


#import "CZPickerView.h"
#import "BookNowViewController.h"
#import "PayPalMobile.h"
#import "PayPalConfiguration.h"
#import "PayPalPaymentViewController.h"


#import <CoreGraphics/CoreGraphics.h>



#import "FTPopOverMenu.h"

#import "FIMultipleSelectionCalendarView.h"




@interface BookNowViewController ()<PayPalPaymentDelegate,FIMultipleSelectionCalendarViewDelegate>
{
    NSString *mystring;
    
    NSString *AvailableDatesString;
    
    NSMutableArray * detailDataArray;
    
    NSMutableArray *aviDateArray;
    
    CZPickerView *IndividualCZPicker,*MultipleCZPicker;
    
    BOOL startBtnSelected;
    
    NSString *startDateString;
    
    NSString* paypalId;
    NSString *create_time;
    
    NSDecimalNumber *totalAmountToPay;
    
    NSDictionary *dict;
    
    NSMutableArray *disableDates;
    
    
    NSMutableArray *randomDateSelection;
}



@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;
@property (nonatomic, retain) NSDate * curDate;
@property (nonatomic, retain) NSDateFormatter * formatter;
@property (nonatomic, strong) PayPalConfiguration *PayPalPaymentConfig;
@end

@implementation BookNowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     randomDateSelection =  [[NSMutableArray alloc] init];
    
    
    selectedDateCount.layer.cornerRadius=selectedDateCount.frame.size.width/2;
    selectedDateCount.clipsToBounds= YES;
    
    
    bookNowBtn.layer.cornerRadius = 4;
    bookNowBtn.clipsToBounds = YES;
    
   
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.minimumDate =  [self.dateFormatter dateFromString:@"2017-07-01"];
    
  
    
 
    
    
   // self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
    

    
    dict=  [[NSUserDefaults standardUserDefaults]objectForKey:@"loginData"];
    NSLog(@"%@ login data = ",dict);
    
    [backGroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.81]];
    popUpView.layer.cornerRadius = 8.0;
  
    
    self.curDate = [NSDate date];
    self.formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy-MM-dd"];
    
   // [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:startDate ,nil]];
  
    
    _PayPalPaymentConfig = [[PayPalConfiguration alloc]init];
    _PayPalPaymentConfig.acceptCreditCards = YES;
    _PayPalPaymentConfig.merchantName = @"PrinceMehra";
    _PayPalPaymentConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _PayPalPaymentConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    _PayPalPaymentConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    _PayPalPaymentConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    
    
    
   
     [self callProductDetailAPI];
    
    
    // Do any additional setup after loading the view.
}



- (IBAction)selectedDateCountBtnActn:(id)sender {
    
    
    
    NSMutableArray*array=[[NSMutableArray alloc]init];
    
    
    [array addObjectsFromArray:randomDateSelection ];
    
    
    
    [FTPopOverMenuConfiguration defaultConfiguration].menuWidth=130;
    
    [FTPopOverMenu showForSender:sender withMenu:array doneBlock:^(NSInteger selectedIndex) {
        
      //  categoryString = [NSString stringWithFormat:@"%@",[array objectAtIndex:selectedIndex]];
        
        
       // NSLog(@"3u294509645604 =====%@",categoryID);
    }
                    dismissBlock:^{
                    }];

    
    
}


- (IBAction)BookNowBtnActn:(id)sender
{
    
    [self bookingValidation];
    
}





- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}



- (BOOL)dateIsDisabled:(NSDate *)date {
    for (NSDate *disabledDate in self.disabledDates) {
        if ([disabledDate isEqualToDate:date]) {
            return YES;
        }
    }
    return NO;
}



- (IBAction)BookingBtnAction:(id)sender {
    
    [self bookingValidation];
    
}


- (IBAction)crossBtnPressed:(id)sender {
    
    backGroundView.hidden = YES;
    
    [self.navigationController popViewControllerAnimated:YES];
}




- (IBAction)backBtnPressed:(id)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



-(void)bookingValidation
{
    
    if ([AvailableDatesString length]==0)
    {
        
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please Select Booking Dates!"
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
                                   @"booking_dates":AvailableDatesString,
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
             
           
             mystring = nil;
             
             [self.navigationController popViewControllerAnimated:YES];
             
             
         }
         else if ([responseDict[@"result"]boolValue]==1)
         {
             NSLog(@"sign_up%@", responseDict);
             
             backGroundView.hidden = NO;
             
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

    homeObj.PaymentFromstartDateString = AvailableDatesString;
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


- (void)datePickerCancelPressed:(THDatePickerViewController *)datePicker {
  
    NSLog(@"randomDateSelection after cancle button pressed = %@",mystring);
    [self dismissSemiModalView];
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
    NSLog(@"%@",AvailableDatesString);
    
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"],
                                   @"product_id":_ProdctID,
                                   @"booking_dates":AvailableDatesString,
                                   @"txd_id":paypalId,
                                   @"create_time":create_time,
                                   @"amount":_PerDayAmount
                                   };
    McomLOG(@"%@",registerInfo);
    [API paypalPaymentSucessWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
     {
         
         [Appdelegate stopLoader:nil];
         
         NSDictionary *dict_response = [[NSDictionary alloc]initWithDictionary:responseDict];
         
         if ([responseDict[@"response"]boolValue]==0)
         {
             NSString * errormessage = [NSString stringWithFormat:@"%@",[dict_response valueForKey:@"message"]];
             
              [self.navigationController popViewControllerAnimated:YES];
             
             [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                            message:errormessage
                                    leftActionTitle:@"OK"
                                   rightActionTitle:@""
                                     animationStyle:AlertViewAnimationRightToCenterSpring
                                       selectAction:^(AlertViewActionType actionType) {
                                           NSLog(@"%zd", actionType);
                                       }];
             
           
             
             
         }
         else if ([responseDict[@"response"]boolValue]==1)
         {
             NSLog(@"sign_up%@", responseDict);
             
             [self.navigationController popViewControllerAnimated:YES];
             
             
             
             [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                            message:@"Product booked successfully!"
                                    leftActionTitle:@"OK"
                                   rightActionTitle:@""
                                     animationStyle:AlertViewAnimationRightToCenterSpring
                                       selectAction:^(AlertViewActionType actionType) {
                                           NSLog(@"%zd", actionType);
                                       }];
         }
     }];
    
    
}



#pragma Product Detail API
-(void)callProductDetailAPI
{
    
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"],
                                   @"product_id":_ProdctID
                                   };
    
    McomLOG(@"%@",registerInfo);
    
    [API ProductDetailWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
     {
         
         [Appdelegate stopLoader:nil];
         NSDictionary *dict_response = [[NSDictionary alloc]initWithDictionary:responseDict];
         NSLog(@"%@",dict_response);
         
         if ([responseDict[@"result"]boolValue]==0)
         {
             [self.navigationController popViewControllerAnimated:YES];
             [Utility showAlertWithTitleText:[responseDict valueForKey:@"message"] messageText:nil delegate:nil];
         }
         
         else if ([responseDict[@"result"]boolValue]==1)
         {
             //NSLog(@"Home Feed List  = %@",responseDict);
             
             if ([responseDict valueForKey:@"product"])
             {
                 
                 if ([[responseDict[@"product"] valueForKey:@"unavailable_dates"] isKindOfClass:[NSString class]])
                 {
                     
                     [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                                    message:@"Product is not Available"
                                            leftActionTitle:@"OK"
                                           rightActionTitle:@""
                                             animationStyle:AlertViewAnimationZoom
                                               selectAction:^(AlertViewActionType actionType) {
                                                   NSLog(@"%zd", actionType);
                                               }];
                     
                     [self.navigationController popViewControllerAnimated:YES];
                 }
                 
                 else if ([[responseDict[@"product"] valueForKey:@"unavailable_dates"] isKindOfClass:[NSArray class]])
                 {
                 
                 detailDataArray =[[responseDict[@"product"] valueForKey:@"unavailable_dates"] valueForKey:@"unavailable_date"];
                 
               //  NSLog(@"count = %lu",(unsigned long)detailDataArray.count);
                 
                 disableDates = [[responseDict[@"product"] valueForKey:@"unavailable_dates"] valueForKey:@"unavailable_date"];
                     
                     
                     NSMutableArray*datesArray=[[NSMutableArray alloc]init];
                     [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
                     for (int i=0; i<disableDates.count; i++)
                     {
                         NSDate*date=[self.dateFormatter dateFromString:[disableDates objectAtIndex:i]];
                         NSString*date1=[self.formatter stringFromDate:date];
                         
                         [datesArray addObject:date1];
                     }
                     
                     
                     NSLog(@"datesArray = %@",datesArray);
                     
                     NSCalendar* cal = [NSCalendar currentCalendar];
                     
                     FIMultipleSelectionCalendarView* view = [[FIMultipleSelectionCalendarView alloc]initWithFrame:CGRectMake(0, 0, myCalnderView.frame.size.width,myCalnderView.frame.size.height ) calendar:cal singleSelectionOnly:NO disableDates:datesArray];
                     view.calViewDelegate = self;
                     [myCalnderView addSubview:view];
                     
 
                     if (detailDataArray.count ==0)
                 {
                     [self.navigationController popViewControllerAnimated:YES];
                 }
                 
                 }
             }
         }
     }];
}

#pragma Fimultiple Date Selection Delegates

-(BOOL)calendarView:(FIMultipleSelectionCalendarView *)calView shouldSelectDate:(NSDate *)date
{
    BOOL isPresent=NO;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    for (int i=0; i<disableDates.count; i++)
    {
        if ([stringFromDate isEqualToString:[disableDates objectAtIndex:i]])
        {
            isPresent=YES;
        }
        else
        {
            
        }
        
    }
    
    if (isPresent)
    {
        
        return NO;
        
    }
    else
    {
        
        NSLog(@"Add this date");
        
        [randomDateSelection addObject:[formatter stringFromDate:date]];
        NSLog(@"randomDateSelection array%@",randomDateSelection);
        
        
          AvailableDatesString = [randomDateSelection componentsJoinedByString:@","];
        
        return YES;
        
    }
    
    
    
    
}
-(BOOL)calendarView:(FIMultipleSelectionCalendarView*)calView shouldDeselectDate:(NSDate*)date
{
    BOOL isPresent=NO;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    for (int i=0; i<disableDates.count; i++)
    {
        if ([stringFromDate isEqualToString:[disableDates objectAtIndex:i]])
        {
            isPresent=YES;
        }
        else
        {
            
        }
        
    }
    
    if (isPresent)
    {
        
        return NO;
        
    }
    else
    {
        if ([randomDateSelection containsObject:[formatter stringFromDate:date]])
        {
            [randomDateSelection removeObject:[formatter stringFromDate:date]];
            NSLog(@"my array = %@",randomDateSelection);
        }
        
         AvailableDatesString = [randomDateSelection componentsJoinedByString:@","];
        return YES;
        
    }
    
    
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
