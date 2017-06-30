//
//  LenderEndReportViewController.m
//  Steezz
//
//  Created by Apple on 31/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "LenderEndReportViewController.h"

#import "FTPopOverMenu.h"

@interface LenderEndReportViewController ()<UIActionSheetDelegate>

{
    
    NSDictionary *dict;
    
    NSString *endEmailString ,*categoryString,*categoryID;
    NSString *base64EncodedP;
    NSMutableArray *categoriesListArray;
    NSMutableArray *categoriesIdArray;
    
    NSMutableArray *endEmailListingArray;
}

@end

@implementation LenderEndReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    dict=  [[NSUserDefaults standardUserDefaults]objectForKey:@"loginData"];
    NSLog(@"%@ login data = ",dict);
    
    discriptionView.placeholderText = @"      Report Description";
    discriptionView.placeholderColor = [UIColor lightGrayColor];
    
    [endReportSelectEmail setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f)];
    [endReportSelectCategoryBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f)];
    
    endReportSelectCategoryBtn.layer.borderWidth = 1;
    endReportSelectCategoryBtn.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    endReportSelectCategoryBtn.layer.cornerRadius = 8.0;
    
    
    endReportSelectEmail.layer.borderWidth = 1;
    endReportSelectEmail.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    endReportSelectEmail.layer.cornerRadius = 8.0;
    
    discriptionView.layer.borderWidth = 1;
    discriptionView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    discriptionView.layer.cornerRadius = 8.0;
    
    
    [self callGetAllCategories];
    
    [self callAllHosterEmailCategories];
    // Do any additional setup after loading the view.
}



- (IBAction)endSelectEmailBtnAction:(id)sender {
    
    
    
    NSMutableArray*array=[[NSMutableArray alloc]init];
    
    if (endEmailListingArray.count>0) {
        
        
        [array addObjectsFromArray:endEmailListingArray ];

        [FTPopOverMenuConfiguration defaultConfiguration].menuWidth=180;
        
        [FTPopOverMenu showForSender:sender withMenu:array doneBlock:^(NSInteger selectedIndex)
         {
             endEmailString= [NSString stringWithFormat:@"%@",[array objectAtIndex:selectedIndex]];
             [endReportSelectEmail setTitle:endEmailString forState:UIControlStateNormal];
             
             NSLog(@"endEmailString =====%@",endEmailString);
         }
                        dismissBlock:^{
                        }];
    }
    
    else
    {
        
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Sorry you don't have book any"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        
    }

    
    
}

- (IBAction)endReportReviewBtnAction:(id)sender {
    
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LenderReportDetailViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"LenderReportDetailViewController"];
    [self.navigationController pushViewController:homeObj animated:YES];
    
    
}





- (IBAction)endSelectCategoryBtnAction:(id)sender {
    
    
    
    NSMutableArray*array=[[NSMutableArray alloc]init];
    
    NSMutableArray *IdsArray = [[NSMutableArray alloc]init];
    
    [array addObjectsFromArray:categoriesListArray ];
    
    [IdsArray addObjectsFromArray:categoriesIdArray ];
    
    [FTPopOverMenuConfiguration defaultConfiguration].menuWidth=110;
    
    [FTPopOverMenu showForSender:sender withMenu:array doneBlock:^(NSInteger selectedIndex)
     {
         categoryString = [NSString stringWithFormat:@"%@",[array objectAtIndex:selectedIndex]];
         [endReportSelectCategoryBtn setTitle:categoryString forState:UIControlStateNormal];
         categoryID = [NSString stringWithFormat:@"%@",[IdsArray objectAtIndex:selectedIndex]];
         NSLog(@"3u294509645604 =====%@",categoryID);
     }
                    dismissBlock:^{
                    }];

    
    
    
}


- (IBAction)endReportCameraBtnActn:(id)sender {
    
    
    
     [self ActionSheetImage];
}


- (IBAction)sumbitBtnAction:(id)sender {
    
    
    [self EndReportValidation];
    
    
    
    
}


- (IBAction)endBackBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    data = UIImageJPEGRepresentation(image,0.2f);
    
    
    size =CGSizeMake(endReportImageView.frame.size.width,endReportImageView.frame.size.height);
    data = UIImagePNGRepresentation(image);
    base64EncodedP = [[NSString alloc] initWithString:[Base64 encode:data]];
    [endReportImageView setImage:image];
    
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







#pragma  Hoster Email List API
-(void)callAllHosterEmailCategories
{
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"]
                                   };
    
    McomLOG(@"%@",registerInfo);
    [API LenderEmailsWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
     {
         
         [Appdelegate stopLoader:nil];
         NSDictionary *dict_response = [[NSDictionary alloc]initWithDictionary:responseDict];
         NSLog(@"%@",dict_response);
         
         if ([responseDict[@"response"]boolValue]==0)
         {
             [Utility showAlertWithTitleText:[responseDict valueForKey:@"message"] messageText:nil delegate:nil];
         }
         
         else if ([responseDict[@"response"]boolValue]==1)
         {
             NSLog(@"category List  = %@",responseDict);
             
             if ([responseDict[@"data"] count]>0)
             {
                 endEmailListingArray =[[NSMutableArray alloc]initWithArray:[responseDict[@"data"] valueForKey:@"email"]];
                 
                 NSLog(@"categories List = %@", endEmailListingArray);
                 
             }
         }
     }];
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

-(void)EndReportValidation
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
    
    if ([endEmailString length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please Select Hoster Email"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
    }
    
    
    
    else if ([base64EncodedP length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please Add report Image"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
    }
    
    else if ([[discriptionView.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please Enter Report Description"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        [discriptionView resignFirstResponder];
    }
    else
    {
        [self callEndReportAPICategories];
    }
}




#pragma Start Report  API
-(void)callEndReportAPICategories
{
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    NSDictionary* registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"],
                                   @"cat_id":categoryID,
                                   @"description":discriptionView.text,
                                   @"report_type":@"End",
                                   @"product_image":base64EncodedP,
                                   @"host_email":endEmailString
                                   };
    
    McomLOG(@"%@",registerInfo);
    [API StartReportWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
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
             NSLog(@"report detail = %@",responseDict);
             
             discriptionView.text= nil;
             [endReportSelectEmail setTitle:nil forState:UIControlStateNormal];
             [endReportSelectCategoryBtn setTitle:nil forState:UIControlStateNormal];

             base64EncodedP = nil;
             
             [Utility showAlertWithTitleText:[responseDict valueForKey:@"message"] messageText:nil delegate:nil];
         }
     }];
}









@end
