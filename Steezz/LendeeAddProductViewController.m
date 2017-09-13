//
//  LendeeAddProductViewController.m
//  Steezz
//
//  Created by Apple on 10/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "LendeeAddProductViewController.h"
#import "FTPopOverMenu.h"
#import "PECropViewController.h"


@interface LendeeAddProductViewController ()<PlaceSearchTextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, PECropViewControllerDelegate>
{
    NSMutableArray *randomDateSelection;
    NSString *myString;
    
    NSData *data;
    
    UIImage* image;
    
    NSString *availableDateString;
    
    NSString *base64EncodedP;
    
    NSDictionary *dict;
    
      NSString *categoryString;
    
    
    NSString *categoryID;
    NSMutableArray *categoriesListArray;
    NSMutableArray *categoriesIdArray;
    
    UIDatePicker *DatePicker;
}

@property (nonatomic) UIPopoverController *popover;
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
    [calanderBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 16.0f, 0.0f, 0.0f)];
    
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
    
    description.placeholderText = @"   Description...";
    description.placeholderColor = [UIColor darkGrayColor];
    
    
    
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
 
    
    
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [self callGetAllCategories];
    
    [self updateEditButtonEnabled];
    
}




#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
    
    
    CGSize  size  = {400, 400};
    UIImage*image1 = [self scaleImage:croppedImage toSize:size];
    
    data = UIImageJPEGRepresentation(image1,1.0);
    base64EncodedP = [[NSString alloc] initWithString:[Base64 encode:data]];
    productImage.image = image1;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self updateEditButtonEnabled];
    }
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self updateEditButtonEnabled];
    }
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}



- (void)updateEditButtonEnabled
{
    //self.editButton.enabled = !!productImage.image;
}





#pragma mark - Private methods

- (void)showCamera
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (self.popover.isPopoverVisible) {
            [self.popover dismissPopoverAnimated:NO];
        }
        
        self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    
    } else {
        [self presentViewController:controller animated:YES completion:NULL];
    }
}

- (void)openPhotoAlbum
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (self.popover.isPopoverVisible) {
            [self.popover dismissPopoverAnimated:NO];
        }
        
        self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
//        [self.popover presentPopoverFromBarButtonItem:self.cameraButton
//                             permittedArrowDirections:UIPopoverArrowDirectionAny
//                                             animated:YES];
    } else {
        [self presentViewController:controller animated:YES completion:NULL];
    }
}


#pragma mark - UIActionSheetDelegate methods

/*
 Open camera or photo album.
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:NSLocalizedString(@"Photo Album", nil)]) {
        [self openPhotoAlbum];
    } else if ([buttonTitle isEqualToString:NSLocalizedString(@"Camera", nil)]) {
        [self showCamera];
    }
}

#pragma mark - UIImagePickerControllerDelegate methods

/*
 Open PECropViewController automattically when image selected.
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
 
    image = info[UIImagePickerControllerOriginalImage];
    
    
    
    productImage.image = image;
    
  //  data = UIImagePNGRepresentation(image);
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (self.popover.isPopoverVisible) {
            [self.popover dismissPopoverAnimated:NO];
        }
        
        [self updateEditButtonEnabled];
        [self openEditor:nil];
    } else {
        [picker dismissViewControllerAnimated:YES completion:^{
            [self openEditor:nil];
        }];
    }
}



- (UIImage*) scaleImage:(UIImage*)image1 toSize:(CGSize)newSize {
    CGSize scaledSize = newSize;
    float scaleFactor = 1.0;
    if( image1.size.width > image1.size.height ) {
        scaleFactor = image1.size.width / image1.size.height;
        scaledSize.width = newSize.width;
        scaledSize.height = newSize.height / scaleFactor;
    }
    else {
        scaleFactor = image1.size.height / image1.size.width;
        scaledSize.height = newSize.height;
        scaledSize.width = newSize.width / scaleFactor;
    }
    
    UIGraphicsBeginImageContextWithOptions( scaledSize, NO, 0.0 );
    CGRect scaledImageRect = CGRectMake( 0.0, 0.0, scaledSize.width, scaledSize.height );
    [image1 drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}
#pragma mark - Action methods

- (IBAction)openEditor:(id)sender
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = productImage.image;
    
    image = productImage.image;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);
    controller.imageCropRect = CGRectMake((width - length) / 2,
                                          (height - length) / 2,
                                          length,
                                          length);
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentViewController:navigationController animated:YES completion:NULL];
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
    [self.datePicker setSelectedBackgroundColor:[UIColor redColor]];
    [self.datePicker setCurrentDateColor:[UIColor greenColor]];
    [self.datePicker setCurrentDateColorSelected:[UIColor greenColor]];
    
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
    
    if (array.count==0) {
        
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Sorry Categories are not Loaded!"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType)
        {
                                      [self callGetAllCategories];
        }];
        
    }
    else
    {
        
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
        [SRAlertView sr_showAlertViewWithTitle:@""
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
        [SRAlertView sr_showAlertViewWithTitle:@""
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
        
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please Add your Product Image"
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
    
    else if ([categoryID length]==0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter Product Category"
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
        [SRAlertView sr_showAlertViewWithTitle:@""
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
    
    if ([availableDateString length]==0) {
        availableDateString = @"";
    }
    
    NSDictionary* registerInfo;
    registerInfo= @{
                    @"cat_id":categoryID,
                    @"access_token":[dict valueForKey:@"access_token"],
                    @"product_name":categoryString,
                    @"product_desc":description.text,
                    @"unavailable_dates":availableDateString,
                    @"is_available":@"Yes",
                    @"price":pricetxtFld.text,
                    @"location":locationTxtFld.text,
                    @"product_image":base64EncodedP
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
             [SRAlertView sr_showAlertViewWithTitle:@""
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
        
   //  [calanderBtn setTitle: [NSString stringWithFormat:@"%@",availableDateString] forState:UIControlStateNormal];
        
        
        [calanderBtn setTitle:@"Mark Unavailable Dates. " forState:UIControlStateNormal];
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
