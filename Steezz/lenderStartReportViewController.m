//
//  lenderStartReportViewController.m
//  Steezz
//
//  Created by Apple on 08/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "lenderStartReportViewController.h"
#import "FTPopOverMenu.h"
@interface lenderStartReportViewController ()

{
    NSString *categoryString;
    NSString *categoryID;
    NSMutableArray *categoriesListArray;
    NSMutableArray *categoriesIdArray;
    
    NSMutableArray *emailListArray;
    NSString *base64EncodedP;
    NSDictionary *dict;
    NSString *emailString;
}

@end

@implementation lenderStartReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dict=  [[NSUserDefaults standardUserDefaults]objectForKey:@"loginData"];
    NSLog(@"%@ login data = ",dict);
    
    startReportTextView.placeholderText = @"       Description";
    startReportTextView.placeholderColor = [UIColor lightGrayColor];
    [selectCategoryBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f)];
    [selectEmail setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f)];
    
    selectCategoryBtn.layer.borderWidth = 1;
    selectCategoryBtn.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    selectCategoryBtn.layer.cornerRadius = 8.0;
    
    
    selectEmail.layer.borderWidth = 1;
    selectEmail.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    selectEmail.layer.cornerRadius = 8.0;
    
    startReportTextView.layer.borderWidth = 1;
    startReportTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    startReportTextView.layer.cornerRadius = 8.0;
    
    
     [self callGetAllCategories];
    
    [self callAllHosterEmailCategories];
    
    // Do any additional setup after loading the view.
}

- (IBAction)cameraBtnPressed:(id)sender {
    
    [self ActionSheetImage];
    
}

- (IBAction)submitBtnPressed:(id)sender {
    
    [self startReportValidation];
    
}

- (IBAction)reportDetailBtnAction:(id)sender {
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LenderReportDetailViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"LenderReportDetailViewController"];
    [self.navigationController pushViewController:homeObj animated:YES];

    
}




- (IBAction)startReportBackBtnPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)startReportSettingBtnPressed:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LenderSettingsViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"LenderSettingsViewController"];
    [self.navigationController pushViewController:homeObj animated:YES];
    
}




- (IBAction)selectCategoryBtnPressed:(id)sender {
    
    
    NSMutableArray*array=[[NSMutableArray alloc]init];
    
    NSMutableArray *IdsArray = [[NSMutableArray alloc]init];
    
    [array addObjectsFromArray:categoriesListArray ];
    
    [IdsArray addObjectsFromArray:categoriesIdArray ];
    
    [FTPopOverMenuConfiguration defaultConfiguration].menuWidth=130;
    
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


- (IBAction)selectEmailBtnPressed:(id)sender {
    
    
    NSMutableArray*array=[[NSMutableArray alloc]init];
    
    if (emailListArray.count>0) {
        
        
        [array addObjectsFromArray:emailListArray ];
        
        
        
        [FTPopOverMenuConfiguration defaultConfiguration].menuWidth=180;
        
        [FTPopOverMenu showForSender:sender withMenu:array doneBlock:^(NSInteger selectedIndex)
         {
             emailString= [NSString stringWithFormat:@"%@",[array objectAtIndex:selectedIndex]];
             [selectEmail setTitle:emailString forState:UIControlStateNormal];
             
             NSLog(@"3u294509645604 =====%@",emailString);
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
    
    size =CGSizeMake(startImage.frame.size.width,startImage.frame.size.height);
    data = UIImagePNGRepresentation(image);
    base64EncodedP = [[NSString alloc] initWithString:[Base64 encode:data]];
    [startImage setImage:image];
    
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


-(void)startReportValidation
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
        
        [startReportTextView resignFirstResponder];
        
        
        return;
    }
    
    if ([emailString length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please Select Hoster Email"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        [startReportTextView resignFirstResponder];

        return;
    }
    
    
    
    else if ([base64EncodedP length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please Add Image"
                                       leftActionTitle:@"OK"
                                       rightActionTitle:@""
                                       animationStyle:AlertViewAnimationDownToCenterSpring
                                       selectAction:^(AlertViewActionType actionType) {
                                        NSLog(@"%zd", actionType);
                                       }];
        
        [startReportTextView resignFirstResponder];

        
        return;
    }
    
    else if ([[startReportTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please Enter Report Description"
                                       leftActionTitle:@"OK"
                                       rightActionTitle:@""
                                       animationStyle:AlertViewAnimationDownToCenterSpring
                                       selectAction:^(AlertViewActionType actionType) {
                                       NSLog(@"%zd", actionType);
                                  }];
        [startReportTextView resignFirstResponder];
        return;
    }
    
    
    if ([categoryID length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please Select Category"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        [startReportTextView resignFirstResponder];

        return;
    }
 
    
    else
    {
        [self callStartReportAPICategories];
    }
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



#pragma Start Report  API
-(void)callStartReportAPICategories
{
    
    NSLog(@"%@",categoryID);
    NSLog(@"email%@",emailString);
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    NSDictionary* registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"],
                                   @"cat_id":categoryID,
                                   @"description":startReportTextView.text,
                                   @"report_type":@"start",
                                   @"product_image":base64EncodedP,
                                   @"host_email":emailString
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
             
             startReportTextView.text= nil;
             [selectCategoryBtn setTitle:nil forState:UIControlStateNormal];
             base64EncodedP = nil;
             
             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
             LenderReportDetailViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"LenderReportDetailViewController"];
             [self.navigationController pushViewController:homeObj animated:YES];
             
              [Utility showAlertWithTitleText:[responseDict valueForKey:@"message"] messageText:nil delegate:nil];
         }
     }];
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
                 emailListArray =[[NSMutableArray alloc]initWithArray:[responseDict[@"data"] valueForKey:@"email"]];
              
                 NSLog(@"categories List = %@", emailListArray);
                
             }
         }
     }];
}

@end
