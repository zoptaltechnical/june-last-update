//
//  EditReportViewController.m
//  Steezz
//
//  Created by Apple on 09/06/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "EditReportViewController.h"
#import "FTPopOverMenu.h"
@interface EditReportViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSString *categoryString;
    NSString *categoryID;
    NSMutableArray *categoriesListArray;
    NSMutableArray *categoriesIdArray;
      NSString *base64EncodedP;
    
    NSDictionary *dict;
}

@end

@implementation EditReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dict=  [[NSUserDefaults standardUserDefaults]objectForKey:@"loginData"];
    NSLog(@"%@ login data = ",dict);
    
    [selectCategory setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f)];
    [emailBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f)];
    
     [reportImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_ReportImage] ]placeholderImage:[UIImage imageNamed:@"1"] options:SDWebImageRefreshCached];
    
    discriptionTxtView.text= [NSString stringWithFormat:@"%@",_Report_Discription];
  
    [selectCategory setTitle:[NSString stringWithFormat:@"%@",_Report_Category_Name] forState:UIControlStateNormal];
    
    [emailBtn setTitle:[NSString stringWithFormat:@"%@",_HostEmail_Id] forState:UIControlStateNormal];
    
     [self callGetAllCategories];
}

- (IBAction)reportBackBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)reportCameraBtnAction:(id)sender
{
    
        [self ActionSheetImage];
}

- (IBAction)selectCategoryBtnAction:(id)sender
{
  
    NSMutableArray*array=[[NSMutableArray alloc]init];
    
    NSMutableArray *IdsArray = [[NSMutableArray alloc]init];
    
    [array addObjectsFromArray:categoriesListArray ];
    
    [IdsArray addObjectsFromArray:categoriesIdArray ];
    
    [FTPopOverMenuConfiguration defaultConfiguration].menuWidth=110;
    
    [FTPopOverMenu showForSender:sender withMenu:array doneBlock:^(NSInteger selectedIndex)
     {
         categoryString = [NSString stringWithFormat:@"%@",[array objectAtIndex:selectedIndex]];
         [selectCategory setTitle:categoryString forState:UIControlStateNormal];
         categoryID = [NSString stringWithFormat:@"%@",[IdsArray objectAtIndex:selectedIndex]];
         NSLog(@"CategoryID =====%@",categoryID);
     }
                    dismissBlock:^{
                    }];

    
}


- (IBAction)submitBtnAction:(id)sender
{
    [self EditReportvalidations];
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
    
    
    size =CGSizeMake(reportImageView.frame.size.width,reportImageView.frame.size.height);
    data = UIImagePNGRepresentation(image);
    base64EncodedP = [[NSString alloc] initWithString:[Base64 encode:data]];
    [reportImageView setImage:image];
    
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
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
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


-(void)EditReportvalidations
{
    
    if ([[discriptionTxtView.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please enter Discription of report."
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
      
        [discriptionTxtView resignFirstResponder];
        
    }
    
    
    else
    {
        [self callEditReportAPI];
        
    }
}


-(void)callEditReportAPI
{
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
        if (base64EncodedP ==nil) {
            
            base64EncodedP = _ReportImage;
        }
    
           if (categoryID ==nil) {
               
               categoryID =_report_cat_ID;
           }
    
    
    NSDictionary* registerInfo;
    
    registerInfo= @{
                    @"access_token":[dict valueForKey:@"access_token"],
                    @"report_id":_Reportid,
                    @"cat_id":categoryID,
                    @"description":discriptionTxtView.text,
                    @"report_type":@"start",
                    @"product_image":base64EncodedP,
                    @"host_email":_HostEmail_Id,
                    };
    
    McomLOG(@"%@",registerInfo);
    [API EditReportWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
     {
         [Appdelegate stopLoader:nil];
         NSDictionary *dict_response = [[NSDictionary alloc]initWithDictionary:responseDict];
         NSLog(@"%@",dict_response);
         if ([responseDict[@"result"]boolValue]==0)
         {
             
             NSString * errormessage = [NSString stringWithFormat:@"%@",[dict_response valueForKey:@"message"]];
             [Utility showAlertWithTitleText:errormessage messageText:nil delegate:nil];
         }
         else if ([responseDict[@"result"]boolValue]==1)
         {
             
             [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                            message:[responseDict valueForKey:@"message"]
                                    leftActionTitle:@"OK"
                                   rightActionTitle:@""
                                     animationStyle:AlertViewAnimationDownToCenterSpring
                                       selectAction:^(AlertViewActionType actionType) {
                                           NSLog(@"%zd", actionType);
                                       }];
             [self.navigationController popViewControllerAnimated:YES];
         }
     }];
}

@end
