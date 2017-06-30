//
//  lenderHomePageViewController.m
//  Steezz
//
//  Created by Apple on 08/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "lenderHomePageViewController.h"
#import "FTPopOverMenu.h"

@interface lenderHomePageViewController ()<UIGestureRecognizerDelegate,PlaceSearchTextFieldDelegate>

{
    NSString *ownerUserName;
    NSString *ProductId;
    NSString *dateString;
    NSString *categoryString;
    
    NSString *GetUserId;
    
    NSString *categoryID;
    
    NSMutableArray *homeFeedArray;
    
    
    NSDictionary *dict;
    NSMutableArray *categoriesListArray;
    NSMutableArray *categoriesIdArray;
    
    
    UIDatePicker *DatePicker;
}

@end

@implementation lenderHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:selectDateTxtFld ,nil]];

    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:locationTextField ,nil]];

    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:priceTextFld ,nil]];

    dict=  [[NSUserDefaults standardUserDefaults]objectForKey:@"loginData"];
    NSLog(@"%@ login data = ",dict);
    
    locationTextField.layer.borderWidth = 1;
    locationTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    locationTextField.layer.cornerRadius = 8.0;
    locationTextField.placeSearchDelegate = self;
    locationTextField.strApiKey = @"AIzaSyCDi2dklT-95tEHqYoE7Tklwzn3eJP-MtM";
    locationTextField.superViewOfList = self.view;
    locationTextField.autoCompleteShouldHideOnSelection   = YES;
    locationTextField.maximumNumberOfAutoCompleteRows     = 5;
    
    priceTextFld.borderStyle = UITextBorderStyleLine;
    priceTextFld.layer.borderWidth = 1;
    priceTextFld.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    priceTextFld.layer.cornerRadius = 8.0;
    
    selectDateTxtFld.borderStyle = UITextBorderStyleLine;
    selectDateTxtFld.layer.borderWidth = 1;
    selectDateTxtFld.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    selectDateTxtFld.layer.cornerRadius = 8.0;

    selectCategoryBtn.layer.borderWidth = 1;
    selectCategoryBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    selectCategoryBtn.layer.cornerRadius = 8.0;
    [selectCategoryBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f)];
    
    searchPopUpView.layer.cornerRadius = 8.0;
     [backgroudView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.41]];
    
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
 
    
 //  DatePicker.maximumDate =[[NSDate date] dateByAddingTimeInterval:60*60*24*6];

    DatePicker.minimumDate=[NSDate date];

    UIToolbar *toolbarstate1 =[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *doneBtnstate1=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(removedatePicker)];
    [toolbarstate1 setItems:[NSArray arrayWithObjects:doneBtnstate1, nil]];
    [selectDateTxtFld setInputView:DatePicker];
    [selectDateTxtFld setInputAccessoryView:toolbarstate1];
    
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    singleFingerTap.delegate = self;
    [backgroudView addGestureRecognizer:singleFingerTap];
    

     [self callGetAllCategories];
    

   
}

-(void)viewWillAppear:(BOOL)animated
{
    noProductLabel.hidden = YES;
    
   [self callLendeerHomeFeedAPI];
    
}



-(void)viewDidAppear:(BOOL)animated{
    
    //Optional Properties
    locationTextField.autoCompleteRegularFontName =  @"HelveticaNeue-Bold";
    locationTextField.autoCompleteBoldFontName = @"HelveticaNeue";
    locationTextField.autoCompleteTableCornerRadius=0.0;
    locationTextField.autoCompleteRowHeight=35;
    locationTextField.autoCompleteTableCellTextColor=[UIColor colorWithWhite:0.131 alpha:1.000];
    locationTextField.autoCompleteFontSize=14;
    locationTextField.autoCompleteTableBorderWidth=1.0;
    locationTextField.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=YES;
    locationTextField.autoCompleteShouldHideOnSelection=YES;
    locationTextField.autoCompleteShouldHideClosingKeyboard=YES;
    locationTextField.autoCompleteShouldSelectOnExactMatchAutomatically = YES;
    
    NSLog(@"%@",locationTextField.text);
    
    locationTextField.autoCompleteTableFrame = CGRectMake((self.view.frame.size.width-locationTextField.frame.size.width)*0.5, locationTextField.frame.size.height+100.0, locationTextField.frame.size.width, 200.0);
}



-(void)removedatePicker
{
    selectDateTxtFld.text = [self timetofill:DatePicker.date];
    [selectDateTxtFld resignFirstResponder];
 
}



-(NSString *)timetofill:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *formatted_time = [ formatter stringFromDate:date];
    NSLog(@"Today's Date and Time: %@", formatted_time  );
    return formatted_time;
}




- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    backgroudView.hidden = YES;
    
    [locationTextField resignFirstResponder];
   [priceTextFld resignFirstResponder];
    [selectDateTxtFld resignFirstResponder];
    
    
    
}




- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:searchPopUpView]) {
        
        return NO;
    }
    return YES;
}



- (IBAction)selectCatgoryBtnPressed:(id)sender {
    
    
    NSMutableArray*array=[[NSMutableArray alloc]init];
    
    NSMutableArray *IdsArray = [[NSMutableArray alloc]init];
    
    [array addObjectsFromArray:categoriesListArray ];
    
    [IdsArray addObjectsFromArray:categoriesIdArray ];
    
    [FTPopOverMenuConfiguration defaultConfiguration].menuWidth=110;
    
    [FTPopOverMenu showForSender:sender withMenu:array doneBlock:^(NSInteger selectedIndex)
    {
        categoryString = [NSString stringWithFormat:@"%@",[array objectAtIndex:selectedIndex]];
        [selectCategoryBtn setTitle:categoryString forState:UIControlStateNormal];
        categoryID = [NSString stringWithFormat:@"%@",[IdsArray objectAtIndex:selectedIndex]];
        NSLog(@"3u294509645604 =====%@",categoryID);
    }
                    dismissBlock:^{
                    }];

    
    
}

- (IBAction)searchNowBtnPressed:(id)sender {
    
    [self Searchvalidations ];
    
  
}

- (IBAction)settingBtnPressed:(id)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LenderSettingsViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"LenderSettingsViewController"];
    [self.navigationController pushViewController:homeObj animated:YES];
    
    
}

- (IBAction)filterBtnPressed:(id)sender {
    
    backgroudView.hidden = NO;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return homeFeedArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"LenderHomePageCell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LenderHomePageCell"];
    }

    UILabel *Productname=(UILabel *)[cell.contentView viewWithTag:1000];
    Productname.text= [NSString stringWithFormat:@"%@",   [[homeFeedArray valueForKey:@"product_name"]objectAtIndex:indexPath.row]];
    
    UILabel *price=(UILabel *)[cell.contentView viewWithTag:1001];
    price.text= [NSString stringWithFormat:@"%@",   [[homeFeedArray valueForKey:@"product_price"]objectAtIndex:indexPath.row]];
    
    UILabel *location=(UILabel *)[cell.contentView viewWithTag:1002];
    location.text= [NSString stringWithFormat:@"%@",[[homeFeedArray valueForKey:@"product_desc"]objectAtIndex:indexPath.row]];
    
    UIImageView *ImageMy = (UIImageView *)[cell.contentView viewWithTag:1003];
    
    [ImageMy sd_setImageWithURL:[NSURL URLWithString: [[homeFeedArray valueForKey:@"product_image"] objectAtIndex:indexPath.row] ]placeholderImage:[UIImage imageNamed:@"1"] options:SDWebImageRefreshCached];
  
    UIButton *SaveBtn =(UIButton *)[cell.contentView viewWithTag:1004];
    [SaveBtn addTarget:self
                        action:@selector(SaveBtnPressed:)
              forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *BookBtn =(UIButton *)[cell.contentView viewWithTag:1005];
    [BookBtn addTarget:self
                action:@selector(BookBtnPressed:)
      forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *MessageBtn =(UIButton *)[cell.contentView viewWithTag:1006];
    [MessageBtn addTarget:self
                action:@selector(messageBtnPressed:)
      forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LenderProductDetailViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"LenderProductDetailViewController"];
    homeObj.ProductDetail = [[homeFeedArray valueForKey:@"id"]objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:homeObj animated:YES];
    
    
    
}


-(void)SaveBtnPressed:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:homeFeedTableView];
    NSIndexPath *indexPath = [homeFeedTableView indexPathForRowAtPoint:buttonPosition];
    McomLOG(@"like-indexPath--%ld",(long)indexPath.row);
    ProductId = [NSString stringWithFormat:@"%@",[[homeFeedArray valueForKey:@"id"]objectAtIndex:indexPath.row]];
    [self callSaveProductAPI];
}





-(void)messageBtnPressed:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:homeFeedTableView];
    NSIndexPath *indexPath = [homeFeedTableView indexPathForRowAtPoint:buttonPosition];
    McomLOG(@"like-indexPath--%ld",(long)indexPath.row);
  NSString *reciverString = [NSString stringWithFormat:@"%@",[[homeFeedArray valueForKey:@"id"]objectAtIndex:indexPath.row]];
    
    GetUserId = [NSString stringWithFormat:@"%@",[[homeFeedArray valueForKey:@"user_id"]objectAtIndex:indexPath.row]];
    ownerUserName = [NSString stringWithFormat:@"%@",[[homeFeedArray valueForKey:@"user_name"]objectAtIndex:indexPath.row]];
    
    NSLog(@" reciverString = %@",reciverString);
    
    [self callGetConversationIDAPI];
    
 
    
}



-(void)BookBtnPressed:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:homeFeedTableView];
    NSIndexPath *indexPath = [homeFeedTableView indexPathForRowAtPoint:buttonPosition];
    McomLOG(@"like-indexPath--%ld",(long)indexPath.row);
    ProductId = [NSString stringWithFormat:@"%@",[[homeFeedArray valueForKey:@"id"]objectAtIndex:indexPath.row]];
    
    dateString = [NSString stringWithFormat:@"%@",[[homeFeedArray valueForKey:@"available_date"]objectAtIndex:indexPath.row]];
    
    
    

    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    BookNowViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"BookNowViewController"];
    
    homeObj.ProdctID = ProductId;
    homeObj.availabelDate = dateString;
    homeObj.PerDayAmount = [NSString stringWithFormat:@"%@",[[homeFeedArray valueForKey:@"price"]objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:homeObj animated:YES];
    
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




#pragma  Lendeer Home Feed List API
-(void)callLendeerHomeFeedAPI
{
    
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"]
                                   };
    
    McomLOG(@"%@",registerInfo);
    [API LenderHomeFeedWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
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
             
             NSLog(@"%@", responseDict);
             
             homeFeedArray =[[NSMutableArray alloc]initWithArray:responseDict[@"data"]];
             NSLog(@"tabel list Data%@", homeFeedArray);
             
             if (homeFeedArray.count ==0)
             {
                  noProductLabel.hidden = NO;
                 filterBtn.hidden = YES;
             }
             
             [homeFeedTableView reloadData];
             
         }
     }];
}




#pragma Product call Save Product  API " which we have to save"
-(void)callSaveProductAPI
{
    
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"],
                                   @"product_id":ProductId
                                   };
    
    McomLOG(@"%@",registerInfo);
    [API SaveProductWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
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
             NSLog(@"save product = %@",responseDict);
             
        
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





-(void)Searchvalidations
{
    
    if ([categoryString length] == 0)
    {
        
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please Select Category"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
       
        
        
    }
    
    else if ([[selectDateTxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        
        
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please Select Date"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [selectDateTxtFld resignFirstResponder];}
    
    else if ([[locationTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please enter Location"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [locationTextField resignFirstResponder];    }
    
    
    else if ([[priceTextFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please enter Price"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [priceTextFld resignFirstResponder];    }
    
    
    else
    {
        [self callSearchAPI];
        
    }
}





-(void)callSearchAPI
{
    
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSDictionary* registerInfo;

    
    registerInfo= @{
                    @"access_token":[dict valueForKey:@"access_token"],
                    @"cat_id":categoryID,
                    @"available_date":selectDateTxtFld.text,
                    @"location":locationTextField.text,
                    @"price":priceTextFld.text,
                  
                    };
    
    McomLOG(@"%@",registerInfo);
    [API LenderSearchProductWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
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
             
             
             
             homeFeedArray =[[NSMutableArray alloc]initWithArray:responseDict[@"data"]];
             NSLog(@"tabel list Data%@", homeFeedArray);
             
             backgroudView.hidden = YES;
               [homeFeedTableView reloadData];
              //  backgroudView.hidden = YES;
         }
     }];
}


-(void)callGetConversationIDAPI
{
    
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSDictionary* registerInfo;
    
    
    registerInfo= @{
                    @"access_token":[dict valueForKey:@"access_token"],
                    @"receiver_id":GetUserId                    
                    };
    McomLOG(@"%@",registerInfo);
    [API GetConversationIDWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
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
             
             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
             chatViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"chatViewController"];
             homeObj.reciverID_string =[NSString stringWithFormat:@"%@",GetUserId] ;
             homeObj.ConversationID_string = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"]valueForKey:@"conversation_id"]];
             
              homeObj.ReciverName_string = [NSString stringWithFormat:@"%@",ownerUserName];
             
             [self.navigationController pushViewController:homeObj animated:YES];
         
         
         
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



@end
