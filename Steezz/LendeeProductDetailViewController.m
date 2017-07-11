//
//  LendeeProductDetailViewController.m
//  Steezz
//
//  Created by Apple on 10/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "LendeeProductDetailViewController.h"
#import "FTPopOverMenu.h"


#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
@interface LendeeProductDetailViewController ()<PlaceSearchTextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

{
    NSString *categoryString;
    NSString *base64EncodedP;
    NSString *check;
    NSString *category_name;
    NSString *product_id;
    
    NSString *categoryID;
    NSDictionary *dict;
    NSMutableArray *categoriesListArray;
    NSMutableArray *categoriesIdArray;
    
     UIDatePicker *DatePicker;
}

@end

@implementation LendeeProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dict=  [[NSUserDefaults standardUserDefaults]objectForKey:@"loginData"];
    NSLog(@"%@ login data = ",dict);
    
//    productDetailTextView.placeholderText = @"       Message";
//    productDetailTextView.placeholderColor = [UIColor lightGrayColor];
//    productDetailTextView.layer.borderWidth = 1;
//    productDetailTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    productDetailTextView.layer.cornerRadius = 8.0;
    
    profilePic.layer.cornerRadius=profilePic.frame.size.width/2;
    profilePic.clipsToBounds= YES;
    
    
    locationTxtFld.placeSearchDelegate                 = self;
    locationTxtFld.strApiKey                           = @"AIzaSyCDi2dklT-95tEHqYoE7Tklwzn3eJP-MtM";
    locationTxtFld.superViewOfList                     = self.view;
    locationTxtFld.autoCompleteShouldHideOnSelection   = YES;
    locationTxtFld.maximumNumberOfAutoCompleteRows     = 5;
    
    
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-18];
    NSDate *minDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    [comps setYear:-150];
    NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    DatePicker.minimumDate=minDate;
    DatePicker.maximumDate = maxDate;
    
    DatePicker = [[UIDatePicker alloc]init];
    [DatePicker setDate:[NSDate date]];
    [DatePicker setDatePickerMode:UIDatePickerModeDate];
    DatePicker.minimumDate=[NSDate date];
    
    // DatePicker.maximumDate =[[NSDate date] dateByAddingTimeInterval:60*60*24*6];
    
    
    
    UIToolbar *toolbarstate1 =[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *doneBtnstate1=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(removedatePicker)];
    [toolbarstate1 setItems:[NSArray arrayWithObjects:doneBtnstate1, nil]];
    [dateTextFld setInputView:DatePicker];
    [dateTextFld setInputAccessoryView:toolbarstate1];
    
    
    
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
    dateTextFld.text = [self timetofill:DatePicker.date];
    [dateTextFld resignFirstResponder];
   
}



-(NSString *)timetofill:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *formatted_time = [ formatter stringFromDate:date];
    return formatted_time;
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
    
    categoryBtn.userInteractionEnabled = YES;
    dateTextFld.userInteractionEnabled = YES;
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
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Device has no camera" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
  
                
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
    
    
 
    
    size =CGSizeMake(productImage.frame.size.width-100,productImage.frame.size.height-100);
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
                 
                 dateTextFld.text =[NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"product"] valueForKey:@"available_date"]] ;
                 
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
                                   @"available_date":dateTextFld.text,
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
             
             
             
             [self.navigationController popViewControllerAnimated:YES];
             
         }
     }];
}


#pragma 
#pragma EDIT Product Validation

-(void)EditProductValidations
{
    if ([[dateTextFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        
        
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please enter date"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [dateTextFld resignFirstResponder];}
    
    else if ([[locationTxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
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
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
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
        
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
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




@end
