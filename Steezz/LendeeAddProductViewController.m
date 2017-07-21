//
//  LendeeAddProductViewController.m
//  Steezz
//
//  Created by Apple on 10/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "LendeeAddProductViewController.h"
#import "FTPopOverMenu.h"
@interface LendeeAddProductViewController ()<PlaceSearchTextFieldDelegate>
{
    NSMutableArray *randomDateSelection;
    NSString *myString;
    
    NSString *availableDateString;
    
    NSString *base64EncodedP;
    
    NSDictionary *dict;
    
      NSString *categoryString;
    
    
    NSString *categoryID;
    NSMutableArray *categoriesListArray;
    NSMutableArray *categoriesIdArray;
    
    UIDatePicker *DatePicker;
}


@property (nonatomic, retain) NSDate * curDate;
@property (nonatomic, retain) NSDateFormatter * formatter;
@end

@implementation LendeeAddProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.curDate = [NSDate date];
    self.formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy/MM/dd"];
    
    
    
    dict=  [[NSUserDefaults standardUserDefaults]objectForKey:@"loginData"];
    NSLog(@"%@ login data = ",dict);
    
    selectCategoryBtn.layer.borderWidth = 1;
    selectCategoryBtn.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    selectCategoryBtn.layer.cornerRadius = 15.0;
    [selectCategoryBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f)];

    
    calanderBtn.layer.borderWidth = 1;
    calanderBtn.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    calanderBtn.layer.cornerRadius = 15.0;
    
    dateCountBtn.layer.cornerRadius=dateCountBtn.frame.size.width/2;
    dateCountBtn.clipsToBounds= YES;
    

    
    pricetxtFld.borderStyle = UITextBorderStyleLine;
    pricetxtFld.layer.borderWidth = 1;
    pricetxtFld.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    pricetxtFld.layer.cornerRadius = 15.0;
    
   
    locationTxtFld.layer.borderWidth = 1;
    locationTxtFld.layer.cornerRadius =15.0;
    locationTxtFld.placeSearchDelegate                 = self;
    locationTxtFld.strApiKey                           = @"AIzaSyCDi2dklT-95tEHqYoE7Tklwzn3eJP-MtM";
    locationTxtFld.superViewOfList                     = self.view;
    locationTxtFld.autoCompleteShouldHideOnSelection   = YES;
    locationTxtFld.maximumNumberOfAutoCompleteRows     = 5;
    
    

    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:pricetxtFld ,nil]];
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:locationTxtFld ,nil]];
    
    description.layer.borderWidth = 1;
    description.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    description.layer.cornerRadius = 15.0;
    
    description.placeholderText = @"       Description...";
    description.placeholderColor = [UIColor lightGrayColor];
    
    
    
    
    
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-18];
    NSDate *minDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    [comps setYear:-150];
    NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
  
    
   DatePicker.minimumDate = minDate;
   DatePicker.maximumDate = maxDate;
    
    DatePicker = [[UIDatePicker alloc]init];
    [DatePicker setDate:[NSDate date]];
    [DatePicker setDatePickerMode:UIDatePickerModeDate];
    DatePicker.minimumDate=[NSDate date];
    
   // DatePicker.maximumDate =[[NSDate date] dateByAddingTimeInterval:60*60*24*6];
    
   // DatePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:-568024668];
 
    
    [self callGetAllCategories];
    
}
- (IBAction)calanderBtnAction:(id)sender
{
    
    randomDateSelection =  [[NSMutableArray alloc] init];
    
    [randomDateSelection removeAllObjects];
    
    //  if ([myString isEqualToString:@"SelectedString"]) {
    
    if(!self.datePicker)
        self.datePicker = [THDatePickerViewController datePicker];
    self.datePicker.date = self.curDate;
    self.datePicker.delegate = self;
    [self.datePicker setAllowClearDate:NO];
    [self.datePicker setClearAsToday:YES];
    [self.datePicker setAutoCloseOnSelectDate:NO];
    
    // [self.datePicker setAllowSelectionOfSelectedDate:YES];
    
    [self.datePicker setDisableYearSwitch:YES];
    //[self.datePicker setDisableFutureSelection:NO];
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
    //[self.datePicker slideUpInView:self.view withModalColor:[UIColor lightGrayColor]];
    [self presentSemiViewController:self.datePicker withOptions:@{
                                                                  KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                                  KNSemiModalOptionKeys.animationDuration : @(0.5),
                                                                  KNSemiModalOptionKeys.shadowOpacity     : @(1.0),
                                                                  }];
    

    
    
    
}



- (IBAction)dateCountBtnAction:(id)sender {
    
    
    NSMutableArray*array=[[NSMutableArray alloc]init];
    
    
    [array addObjectsFromArray:randomDateSelection ];
    

    
    [FTPopOverMenuConfiguration defaultConfiguration].menuWidth=130;
    
    [FTPopOverMenu showForSender:sender withMenu:array doneBlock:^(NSInteger selectedIndex) {
        
    categoryString = [NSString stringWithFormat:@"%@",[array objectAtIndex:selectedIndex]];
       
        
        NSLog(@"3u294509645604 =====%@",categoryID);
    }
                    dismissBlock:^{
                    }];

    
    
    
    
    
    
}



-(void)viewDidAppear:(BOOL)animated{
    
    //Optional Properties
    locationTxtFld.autoCompleteRegularFontName =  @"HelveticaNeue-Bold";
    locationTxtFld.autoCompleteBoldFontName = @"HelveticaNeue";
    locationTxtFld.autoCompleteTableCornerRadius=0.0;
    locationTxtFld.autoCompleteRowHeight=35;
    locationTxtFld.autoCompleteTableCellTextColor=[UIColor colorWithWhite:0.131 alpha:1.000];
    locationTxtFld.autoCompleteFontSize=14;
    locationTxtFld.autoCompleteTableBorderWidth=1.0;
    locationTxtFld.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=YES;
    locationTxtFld.autoCompleteShouldHideOnSelection=YES;
    locationTxtFld.autoCompleteShouldHideClosingKeyboard=YES;
    locationTxtFld.autoCompleteShouldSelectOnExactMatchAutomatically = YES;
    
    NSLog(@"%@",locationTxtFld.text);
    
    locationTxtFld.autoCompleteTableFrame = CGRectMake((self.view.frame.size.width-locationTxtFld.frame.size.width)*0.5, locationTxtFld.frame.size.height+100.0, locationTxtFld.frame.size.width, 200.0);
}





-(NSString *)timetofill:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *formatted_time = [ formatter stringFromDate:date];
    NSLog(@"Today's Date and Time: %@", formatted_time  );
    return formatted_time;
}


- (IBAction)backBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (IBAction)selectCategoryBtnPressed:(id)sender {
     
    NSMutableArray*array=[[NSMutableArray alloc]init];
    
    NSMutableArray *IdsArray = [[NSMutableArray alloc]init];
    
    [array addObjectsFromArray:categoriesListArray ];
    
    [IdsArray addObjectsFromArray:categoriesIdArray ];
    
    [FTPopOverMenuConfiguration defaultConfiguration].menuWidth=130;
    
    [FTPopOverMenu showForSender:sender withMenu:array doneBlock:^(NSInteger selectedIndex) {
        
        categoryString = [NSString stringWithFormat:@"%@",[array objectAtIndex:selectedIndex]];
        categoryID = [NSString stringWithFormat:@"%@",[IdsArray objectAtIndex:selectedIndex]];
        [selectCategoryBtn setTitle:categoryString forState:UIControlStateNormal];
        
        if ([categoryString isEqualToString:@"All"]) {
            
            categoryID = @"All";
        }
        else
        {
            categoryID = [NSString stringWithFormat:@"%@",[IdsArray objectAtIndex:selectedIndex]];
        }
        
        NSLog(@"3u294509645604 =====%@",categoryID);
    }
                    dismissBlock:^{
                    }];

    
}

- (IBAction)cameraBtnPressed:(id)sender {
    
    [self ActionSheetImage];
}


- (IBAction)submitBtnPressed:(id)sender {
    
    [self validations];
    
    
}




-(void)validations
{
    
    
    if ([[locationTxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please enter Location Field"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [description resignFirstResponder];
        [pricetxtFld resignFirstResponder];
        [locationTxtFld resignFirstResponder];
           }
    
    
    else if ([[pricetxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please enter Price/Day of product"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [description resignFirstResponder];
        [pricetxtFld resignFirstResponder];
        [locationTxtFld resignFirstResponder];
         }
    
    else if ([base64EncodedP length] == 0)
    {
        
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please enter Product Image"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        [description resignFirstResponder];
        [pricetxtFld resignFirstResponder];
        [locationTxtFld resignFirstResponder];
    }
    
    
    else if ([[description.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please enter Product Description"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        [description resignFirstResponder];
        [pricetxtFld resignFirstResponder];
        [locationTxtFld resignFirstResponder];
           }
    

    
    else
    {
        [self callAddProductAPI];
    }
}

-(void)ActionSheetImage
{
    
    UIActionSheet *popup;
    
    popup = [[UIActionSheet alloc] initWithTitle:@"Choose Photo:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Camera",
             @"Photos Album",
             nil];
    
    
    [popup showInView:self.view];
}

#pragma mark - UIImagePickerController Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.navigationBar.barStyle = UIBarStyleBlack; // Or whatever style.
    // or
    picker.navigationBar.tintColor = [UIColor redColor];
    
    picker.delegate  = self;
    picker.allowsEditing = YES;
    switch (buttonIndex) {
        case 0:
            
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                
                UIAlertView*  myAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                
                [myAlertView show];
                
            }
            else
            {
                
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                [self presentViewController:picker animated:YES completion:Nil];
            }
            
            break;
        case 1:
            
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:NULL];
        default:
            break;
    }
}


#pragma mark IMAGE PICKER DELEGATES
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    NSData* data;
    CGSize size;
    
            while (data.length / 1000 >= 200)
            {
                image = [Utility imageWithEditImage:image andWidth:image.size.width/2 andHeight:image.size.height/2];
                data = UIImagePNGRepresentation(image);
            }
          data = UIImagePNGRepresentation(image);
    
    size =CGSizeMake(productImage.frame.size.width,productImage.frame.size.height);
    data = UIImagePNGRepresentation(image);
    base64EncodedP = [[NSString alloc] initWithString:[Base64 encode:data]];
    [productImage setImage:image];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


#pragma  Category List API
-(void)callGetAllCategories
{
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"]
                                   };
    
    McomLOG(@"%@",registerInfo);
    [API getCategoriesList:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
     {
         
         [Appdelegate stopLoader:nil];
         NSDictionary *dict_response = [[NSDictionary alloc]initWithDictionary:responseDict];
         NSLog(@"%@",dict_response);
         
         if ([responseDict[@"result"]boolValue]==0)
         {
             [Utility showAlertWithTitleText:[responseDict valueForKey:@"message"] messageText:nil delegate:nil];
         }
         
         else if ([responseDict[@"result"]boolValue]==1)
         {
             NSLog(@"category List  = %@",responseDict);
             
             if ([responseDict[@"data"] count]>0)
             {
                 categoriesListArray =[[NSMutableArray alloc]initWithArray:[responseDict[@"data"] valueForKey:@"cat_name"]];
                 categoriesIdArray =[[NSMutableArray alloc]initWithArray:[responseDict[@"data"] valueForKey:@"id"]];
                 NSLog(@"categories List = %@", categoriesListArray);
                 NSLog(@"categories List = %@", categoriesIdArray);
             }
         }
     }];
}

-(void)callAddProductAPI
{
    
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSDictionary* registerInfo;
    registerInfo= @{
                    @"cat_id":categoryID,
                    @"access_token":[dict valueForKey:@"access_token"],
                    @"product_name":categoryString,
                    @"product_desc":description.text,
                    @"unavailable_dates":availableDateString,
                    @"is_available":@"Yes",
                    @"price":pricetxtFld.text,
                    @"product_image":base64EncodedP,
                    @"location":locationTxtFld.text
                    };
    
    McomLOG(@"%@",registerInfo);
    [API AddProductWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
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
             
             NSLog(@"sign_up responce Data%@", responseDict);
             
             pricetxtFld.text = nil;
             locationTxtFld.text = nil;
             description.text = nil;
             productImage.image = nil;
             [pricetxtFld resignFirstResponder];
             [description resignFirstResponder];
             [locationTxtFld resignFirstResponder];
             
             [self.navigationController popViewControllerAnimated:YES];
             [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                            message:[responseDict valueForKey:@"message"]
                                    leftActionTitle:@"OK"
                                   rightActionTitle:@""
                                     animationStyle:AlertViewAnimationZoom
                                       selectAction:^(AlertViewActionType actionType) {
                                           NSLog(@"%zd", actionType);
                                       }];
         }
     }];
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



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return textView.text.length + (text.length - range.length) <= 40;
}


#pragma  DATE PICKER DELGATES :-

#pragma mark - THDatePickerDelegate

- (void)datePickerDonePressed:(THDatePickerViewController *)datePicker {
    self.curDate = datePicker.date;
    
    if (randomDateSelection.count==0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"date's Selected" message:@"nothing is selected " preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        [self dismissSemiModalView];
    }
    
    else
    {
        
        dateCountBtn.hidden = NO;
        
        [dateCountBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)randomDateSelection.count] forState:UIControlStateNormal];
        
        availableDateString = [randomDateSelection componentsJoinedByString:@","];
        
        [calanderBtn setTitle: [NSString stringWithFormat:@"%@",availableDateString] forState:UIControlStateNormal];
        
        [self dismissSemiModalView];
        
    }
}

- (void)datePickerCancelPressed:(THDatePickerViewController *)datePicker {
    [randomDateSelection removeAllObjects];
    NSLog(@"randomDateSelection after cancle button pressed = %@",randomDateSelection);
    [self dismissSemiModalView];
}

- (void)datePicker:(THDatePickerViewController *)datePicker selectedDate:(NSDate *)selectedDate
{
    
    myString = @"SelectedString";
    NSLog(@"Date selected: %@",[_formatter stringFromDate:selectedDate]);
    NSLog(@"selectedDate = %@",selectedDate);
    [randomDateSelection addObject:[_formatter stringFromDate:selectedDate]];
    NSLog(@"randomDateSelection array%@",randomDateSelection);
}


-(void)datePicker:(THDatePickerViewController *)datePicker deselectedDate:(NSDate *)deselectedDate
{
    
    NSLog(@"Date selected: %@",[_formatter stringFromDate:deselectedDate]);
    NSLog(@"de_selectedDate = %@",deselectedDate);
    
    if ([randomDateSelection containsObject:[_formatter stringFromDate:deselectedDate]])
    {
        [randomDateSelection removeObject:[_formatter stringFromDate:deselectedDate]];
        NSLog(@"my array = %@",randomDateSelection);
    }
    
}




@end
