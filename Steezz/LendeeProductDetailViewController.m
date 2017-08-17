//
//  LendeeProductDetailViewController.m
//  Steezz
//
//  Created by Apple on 10/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "LendeeProductDetailViewController.h"
#import "FTPopOverMenu.h"

#import "PECropViewController.h"


#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
@interface LendeeProductDetailViewController ()<PlaceSearchTextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,PECropViewControllerDelegate>

{
     NSMutableArray *randomDateSelection;
     NSString *availableDateString;
    NSString *categoryString;
    NSString *base64EncodedP;
    NSString *check;
    NSString *category_name;
    NSString *product_id;
    NSData *data;

    UIImage* image;

    NSString *categoryID;
    NSDictionary *dict;
    NSMutableArray *categoriesListArray;
    NSMutableArray *categoriesIdArray;
    
    
 
    
     
}


@property (nonatomic) UIPopoverController *popover;

@end

@implementation LendeeProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.curDate = [NSDate date];
    self.formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy/MM/dd"];
    
    dict=  [[NSUserDefaults standardUserDefaults]objectForKey:@"loginData"];
    NSLog(@"%@ login data = ",dict);
    
//    productDetailTextView.placeholderText = @"       Message";
//    productDetailTextView.placeholderColor = [UIColor lightGrayColor];
//    productDetailTextView.layer.borderWidth = 1;
//    productDetailTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    productDetailTextView.layer.cornerRadius = 8.0;
    
    profilePic.layer.cornerRadius=profilePic.frame.size.width/2;
    profilePic.clipsToBounds= YES;
    
    countBtn.layer.cornerRadius=countBtn.frame.size.width/2;
    countBtn.clipsToBounds= YES;
    
    locationTxtFld.placeSearchDelegate                 = self;
    locationTxtFld.strApiKey                           = @"AIzaSyCDi2dklT-95tEHqYoE7Tklwzn3eJP-MtM";
    locationTxtFld.superViewOfList                     = self.view;
    locationTxtFld.autoCompleteShouldHideOnSelection   = YES;
    locationTxtFld.maximumNumberOfAutoCompleteRows     = 5;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
    [tapRecognizer addTarget:self action:@selector(bigButtonTapped:)];
    [productImage addGestureRecognizer:tapRecognizer];
    
    productImage.userInteractionEnabled=YES;
    [self callGetAllCategories];
    [self callProductDetailAPI];
    
    // Do any additional setup after loading the view.
}



- (void)bigButtonTapped:(UITapGestureRecognizer*)sender
{
    UIImageView*seletedImage;
    if (sender.view==productImage)
    {
        seletedImage=productImage;
        // editProfileButtonNew.hidden=NO;
    }
    
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = seletedImage.image;
    
    imageInfo.referenceRect = seletedImage.frame;
    
    imageInfo.referenceView = seletedImage.superview;
    imageInfo.referenceContentMode = seletedImage.contentMode;
    imageInfo.referenceCornerRadius = seletedImage.layer.cornerRadius;
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc] initWithImageInfo:imageInfo mode:JTSImageViewControllerMode_Image backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
    
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



-(void)removedatePicker
{
 
   
}




-(NSString *)timetofill:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *formatted_time = [ formatter stringFromDate:date];
    return formatted_time;
}


- (IBAction)countBtnActn:(id)sender {
    
    NSMutableArray*array=[[NSMutableArray alloc]init];
    
    
    [array addObjectsFromArray:[randomDateSelection valueForKey:@"unavailable_date"] ];
    
    [FTPopOverMenuConfiguration defaultConfiguration].menuWidth=130;
    [FTPopOverMenu showForSender:sender withMenu:array doneBlock:^(NSInteger selectedIndex)
    {
        categoryString = [NSString stringWithFormat:@"%@",[array objectAtIndex:selectedIndex]];
        NSLog(@"3u294509645604 =====%@",categoryID);
    }
                    dismissBlock:^{
                    }];
}

- (IBAction)availableDateBtnAction:(id)sender {
    

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




- (IBAction)landeeBackBtnPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}
- (IBAction)addBtnPressed:(id)sender {
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LendeeAddProductViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"LendeeAddProductViewController"];
    [self.navigationController pushViewController:homeObj animated:YES];
    
    
}

- (IBAction)categoryBtnPressed:(id)sender
{
    
    NSMutableArray*array=[[NSMutableArray alloc]init];
    
    NSMutableArray *IdsArray = [[NSMutableArray alloc]init];
    
    [array addObjectsFromArray:categoriesListArray ];
    
    [IdsArray addObjectsFromArray:categoriesIdArray ];
    
    [FTPopOverMenuConfiguration defaultConfiguration].menuWidth=130;
    
    [FTPopOverMenu showForSender:sender withMenu:array doneBlock:^(NSInteger selectedIndex)
     {
         categoryString = [NSString stringWithFormat:@"%@",[array objectAtIndex:selectedIndex]];[categoryBtn setTitle:categoryString forState:UIControlStateNormal];
      categoryID = [NSString stringWithFormat:@"%@",[IdsArray objectAtIndex:selectedIndex]];
        
        
        NSLog(@"3u294509645604 =====%@",categoryID);
    }
                    dismissBlock:^{
                    }];
}

- (IBAction)editBtnPressed:(id)sender
{
    countBtn.hidden = YES;
    
    categoryBtn.userInteractionEnabled = YES;
    availableDatebtn.userInteractionEnabled = YES;
    locationTxtFld.userInteractionEnabled = YES;
    priceTxtFld.userInteractionEnabled = YES;
    descriptnTxtView.userInteractionEnabled = YES;
    cameraBtn.hidden = NO;
    
    
    check = @"0";
    
    
        [editBtn setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    
    UIImage *btnImage = [UIImage imageNamed:@"update"];
    [deleteBtn setImage:btnImage forState:UIControlStateNormal];
    
}


- (IBAction)deleteBtnPressed:(id)sender {
    
    if ([check isEqualToString:@"0"])
    {
        [self EditProductValidations];
    }
    else
    {
        [self callDeleteProductAPI];
    }
    
}

- (IBAction)cameraBtnPressed:(id)sender {
    
    [self ActionSheetImage];
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
             
             else
             {
             }
             
         }
     }];
}





#pragma
#pragma  Product Detail API
-(void)callProductDetailAPI
{
    
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"],
                                   @"product_id":_LendeeProductID
                                   };
    
    McomLOG(@"%@",registerInfo);
    
    [API ProductDetailWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
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
             NSLog(@"Home Feed List  = %@",responseDict);
             
             if ([responseDict valueForKey:@"product"])
             {
                 
                 countBtn.hidden = NO;                 
                 
                 if ([[[responseDict valueForKey:@"product"]valueForKey:@"unavailable_dates"]isKindOfClass:[NSString class]])
                 {
                  
                     availableDateString = [[randomDateSelection valueForKey:@"total_unavailable_dates"] componentsJoinedByString:@","];
                     countBtn.hidden = YES;
                  
                     
                     [availableDatebtn setTitle:@"Not Available" forState:UIControlStateNormal];
                     
                     locationTxtFld.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"product"] valueForKey:@"location"]];
                     
                     descriptnTxtView.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"product"] valueForKey:@"product_desc"]];
                     
                     name.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"product"] valueForKey:@"first_name"]];
                     
                     priceTxtFld.text =[NSString stringWithFormat:@"$%@/Day",[[responseDict valueForKey:@"product"] valueForKey:@"price"]];
                     
                     [categoryBtn setTitle:[NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"product"] valueForKey:@"product_name"]] forState:UIControlStateNormal];

                     [productImage sd_setImageWithURL:[NSURL URLWithString: [[responseDict valueForKey:@"product"] valueForKey:@"product_image"] ]placeholderImage:[UIImage imageNamed:@"1"] options:SDWebImageRefreshCached];
                     
                     [profilePic sd_setImageWithURL:[NSURL URLWithString: [[responseDict valueForKey:@"product"] valueForKey:@"profile_pic"] ]placeholderImage:[UIImage imageNamed:@"1"] options:SDWebImageRefreshCached];
                     
                     product_id = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"product"] valueForKey:@"cat_id"]];
                     
                     category_name = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"product"] valueForKey:@"cat_name"]];
                     
                     
                 }
                 
                 else
                 {
                     
                     randomDateSelection =[[NSMutableArray alloc]initWithArray:[[responseDict valueForKey:@"product"] valueForKey:@"unavailable_dates"]];
                     
                     
                     // [randomDateSelection addObject:[[responseDict valueForKey:@"product"] valueForKey:@"available_dates"]];
                     
                     
                     [countBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)randomDateSelection.count] forState:UIControlStateNormal];
                     
                     
                     availableDateString = [[randomDateSelection valueForKey:@"unavailable_date"] componentsJoinedByString:@","];
                     
                     NSLog(@"availableDateString = %@",availableDateString);
                     
                     [availableDatebtn setTitle: [NSString stringWithFormat:@"Not Available for %@ Days",[[responseDict valueForKey:@"product"] valueForKey:@"total_unavailable_dates"]] forState:UIControlStateNormal];
                     
                     locationTxtFld.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"product"] valueForKey:@"location"]];
                     
                     descriptnTxtView.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"product"] valueForKey:@"product_desc"]];
                     
                     name.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"product"] valueForKey:@"first_name"]];
                     
                     priceTxtFld.text =[NSString stringWithFormat:@"$%@/Day",[[responseDict valueForKey:@"product"] valueForKey:@"price"]];
                     
                     [categoryBtn setTitle:[NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"product"] valueForKey:@"product_name"]] forState:UIControlStateNormal];
                     
                     
                     [productImage sd_setImageWithURL:[NSURL URLWithString: [[responseDict valueForKey:@"product"] valueForKey:@"product_image"] ]placeholderImage:[UIImage imageNamed:@"1"] options:SDWebImageRefreshCached];
                     
                     [profilePic sd_setImageWithURL:[NSURL URLWithString: [[responseDict valueForKey:@"product"] valueForKey:@"profile_pic"] ]placeholderImage:[UIImage imageNamed:@"1"] options:SDWebImageRefreshCached];
                     
                     product_id = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"product"] valueForKey:@"cat_id"]];
                     
                     category_name = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"product"] valueForKey:@"cat_name"]];
                     
                     
                     
                 }
                 
               
                 
             }
             
             
             
         }
     }];
}


#pragma API
#pragma  DELETE Product API


-(void)callDeleteProductAPI
{
    [Appdelegate startLoader:nil withTitle:@"Loading..."];

    
    NSDictionary* registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"],
                                   @"product_id":_LendeeProductID
                                   };
    
    McomLOG(@"%@",registerInfo);
    [API LendeeDeleteProductWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
     {
         
         [Appdelegate stopLoader:nil];
         
         NSDictionary *dict_response = [[NSDictionary alloc]initWithDictionary:responseDict];
         
         if ([responseDict[@"result"]boolValue]==0)
         {
             NSString * errormessage = [NSString stringWithFormat:@"%@",[dict_response valueForKey:@"message"]];
             
             [SRAlertView sr_showAlertViewWithTitle:@""
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
             
             [self.navigationController popViewControllerAnimated:YES];
             
         }
     }];
}

#pragma 
#pragma EDIT Product API

-(void)callEditProductAPI
{
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    NSDictionary* registerInfo;
    NSString *Price ;
    
    NSString *string= [NSString stringWithFormat:@"%@",priceTxtFld.text];
    if ([string rangeOfString:@"\""].location == NSNotFound) {
        
        NSCharacterSet *trim = [NSCharacterSet characterSetWithCharactersInString:@"$/Day"];
        Price = [[priceTxtFld.text componentsSeparatedByCharactersInSet:trim] componentsJoinedByString:@""];
        NSLog(@"%@", Price);

    } else {
        Price = [NSString stringWithFormat:@"%@",priceTxtFld.text];
      
    }
    
    
    if ([base64EncodedP length]==0)
    {
        base64EncodedP=@"";
    }
    
    if ([categoryString length]==0)
    {
        NSLog(@"%@",product_id);
        NSLog(@"%@",category_name);
       categoryID =  product_id;
       categoryString =category_name;
    }
    
                  registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"],
                                   @"product_id":_LendeeProductID,
                                   @"cat_id":categoryID,
                                   @"product_name":categoryString,
                                   @"product_desc":descriptnTxtView.text,
                                   @"location":locationTxtFld.text,
                                   @"unavailable_dates":availableDateString,
                                   @"is_available":@"yes",
                                   @"price":Price,
                                   @"product_image":base64EncodedP
                                   };
    
    McomLOG(@"%@",registerInfo);
    [API EditProductWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
     {
         
         [Appdelegate stopLoader:nil];
         
         NSDictionary *dict_response = [[NSDictionary alloc]initWithDictionary:responseDict];
         
         if ([responseDict[@"result"]boolValue]==0)
         {
             NSString * errormessage = [NSString stringWithFormat:@"%@",[dict_response valueForKey:@"message"]];
             
             [SRAlertView sr_showAlertViewWithTitle:@""
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
             
             
             
             [self.navigationController popViewControllerAnimated:YES];
             
         }
     }];
}


#pragma 
#pragma EDIT Product Validation

-(void)EditProductValidations
{
    
     if ([[locationTxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter Location"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [locationTxtFld resignFirstResponder];    }
    
    
    else if ([[priceTxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter Price"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [priceTxtFld resignFirstResponder];    }
    
    else if ([[descriptnTxtView.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter Description of product"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
    }
    
    
    
    
    else
    {
        [self callEditProductAPI];
        
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


#pragma  DATE PICKER DELGATES :-


#pragma mark - THDatePickerDelegate

- (void)datePickerDonePressed:(THDatePickerViewController *)datePicker {
    self.curDate = datePicker.date;
    //[self refreshTitle];
    
    if (randomDateSelection.count==0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"date's Selected" message:@"nothing is selected " preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        [self dismissSemiModalView];
        
        
    }
    
    
    else
    {
     
        countBtn.hidden = NO;
       // [availableDatebtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)randomDateSelection.count] forState:UIControlStateNormal];
        
        availableDateString = [randomDateSelection componentsJoinedByString:@","];
        
      //  [availableDatebtn setTitle: [NSString stringWithFormat:@"%@",availableDateString] forState:UIControlStateNormal];
        
        [countBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)randomDateSelection.count] forState:UIControlStateNormal];
        

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
    
  
    NSLog(@"Date selected: %@",[_formatter stringFromDate:selectedDate]);
    NSLog(@"selectedDate = %@",selectedDate);
    [randomDateSelection addObject:[_formatter stringFromDate:selectedDate]];
    NSLog(@"randomDateSelection array%@",randomDateSelection);
    // convert array into string and seperated the date's with ","
    //    NSString * myString = [randomDateSelection componentsJoinedByString:@", "];
    //    NSLog(@"%@",myString);
    
    
}


-(void)datePicker:(THDatePickerViewController *)datePicker deselectedDate:(NSDate *)deselectedDate
{
    
    NSLog(@"Date selected: %@",[_formatter stringFromDate:deselectedDate]);
    NSLog(@"de_selectedDate = %@",deselectedDate);
    
    if ([randomDateSelection containsObject:[_formatter stringFromDate:deselectedDate]])
    {
        [randomDateSelection removeObject:[_formatter stringFromDate:deselectedDate]];
        NSLog(@"my array = %@",randomDateSelection);
        
        // convert array into string and seperated the date's with ","
        //    NSString * myString = [randomDateSelection componentsJoinedByString:@", "];
        //    NSLog(@"%@",myString);
        
    }
    
}

// i have changed the code for  editing product image , "" comment it .




#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    productImage.image = croppedImage;
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
    
 //   data = UIImagePNGRepresentation(image);
    
    data = UIImageJPEGRepresentation(image,1.0);
    
    UIImage *imageObj = [UIImage imageWithData:data];
    
    base64EncodedP = [[NSString alloc] initWithString:[Base64 encode:data]];
    
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

@end
