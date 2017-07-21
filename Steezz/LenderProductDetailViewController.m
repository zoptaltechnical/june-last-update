//
//  LenderProductDetailViewController.m
//  Steezz
//
//  Created by Apple on 08/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "LenderProductDetailViewController.h"

#import "JTSImageViewController.h"
#import "JTSImageInfo.h"

@interface LenderProductDetailViewController ()
{
    NSString *ownerName;
    NSString *GetUserId;
    NSString *product_id;
    NSString *User_id;
    NSDictionary *dict;
    NSString *perdayAmountString;
    NSString *dateString;
    
}

@end

@implementation LenderProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    dateCountLabel.layer.cornerRadius = dateCountLabel.frame.size.width / 2;
    dateCountLabel.clipsToBounds = YES;
    
    userImage.layer.borderWidth=5;
    userImage.layer.cornerRadius=userImage.frame.size.width/2;;
    userImage.clipsToBounds= YES;
    
    userImage.layer.borderColor=[UIColor whiteColor].CGColor;
    
    dict=  [[NSUserDefaults standardUserDefaults]objectForKey:@"loginData"];
    NSLog(@"%@ login data = ",dict);
    
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
    [tapRecognizer addTarget:self action:@selector(bigButtonTapped:)];
    [productImage addGestureRecognizer:tapRecognizer];
    productImage.userInteractionEnabled=YES;
    
    
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


- (IBAction)detailBackBtnPressed:(id)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (IBAction)favouriteBtnPressed:(id)sender
{
    
    
    [self callSaveProductAPI ];
    
}


- (IBAction)BookBtnPressed:(id)sender {
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    BookNowViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"BookNowViewController"];
    
   homeObj.ProdctID = product_id;
   homeObj.availabelDate = dateString;
    
    homeObj.PerDayAmount =perdayAmountString;
    
    [self.navigationController pushViewController:homeObj animated:YES];

    
}


- (IBAction)messageBtnAction:(id)sender {
    
     [self callGetConversationIDAPI];
    
    
}








- (IBAction)usernameBtnPressed:(id)sender {
    
    LenderBookingListViewController *secondView = [self.storyboard instantiateViewControllerWithIdentifier:@"LenderBookingListViewController"];
    
    secondView.other_user_ID = User_id;
    [self.navigationController pushViewController:secondView animated:YES];
    
}
- (IBAction)settingBtnPressed:(id)sender {
    
    LenderSettingsViewController *secondView = [self.storyboard instantiateViewControllerWithIdentifier:@"LenderSettingsViewController"];
    [self.navigationController pushViewController:secondView animated:YES];
    
}

#pragma Product Detail API
-(void)callProductDetailAPI
{
    
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"],
                                   @"product_id":_ProductDetail
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
             NSLog(@"Home Feed List  = %@",responseDict);
             
             if ([responseDict valueForKey:@"product"])
             {
                 
                 dateCountLabel.hidden = NO;
             //    date.text =[NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"product"] valueForKey:@"available_date"]] ;
                 
                 location.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"product"] valueForKey:@"location"]];
                 
                 descriptionTextView.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"product"] valueForKey:@"product_desc"]];
                 
                 categoryName.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"product"] valueForKey:@"cat_name"]];
                 
                   dateCountLabel.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"product"] valueForKey:@"total_unavailable_dates"]];
                 
                 price.text =[NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"product"] valueForKey:@"product_price"]];
                 
                 [usernameBtn setTitle:[NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"product"] valueForKey:@"first_name"]] forState:UIControlStateNormal];
                 
                 
                 [productImage sd_setImageWithURL:[NSURL URLWithString: [[responseDict valueForKey:@"product"] valueForKey:@"product_image"] ]placeholderImage:[UIImage imageNamed:@"1"] options:SDWebImageRefreshCached];
                 
                 
                 [userImage sd_setImageWithURL:[NSURL URLWithString: [[responseDict valueForKey:@"product"] valueForKey:@"profile_pic"] ]placeholderImage:[UIImage imageNamed:@"1"] options:SDWebImageRefreshCached];
                 
                 product_id = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"product"] valueForKey:@"id"]];
                 
                User_id = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"product"] valueForKey:@"user_id"]];
                 
                 dateString = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"product"] valueForKey:@"available_date"]];
                 
                 perdayAmountString = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"product"] valueForKey:@"price"]];
                 
                 GetUserId= [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"product"] valueForKey:@"user_id"]];
                 
                 
                 ownerName = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"product"] valueForKey:@"first_name"]];

             }
             
            }
     }];
}


-(void)callSaveProductAPI
{
    
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"],
                                   @"product_id":product_id
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
             homeObj.ReciverName_string = [NSString stringWithFormat:@"%@",ownerName];
             homeObj.ConversationID_string = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"]valueForKey:@"conversation_id"]];
             [self.navigationController pushViewController:homeObj animated:YES];
             
         }
     }];
}




@end
