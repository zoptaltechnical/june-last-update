//
//  LenderProfileViewController.m
//  Steezz
//
//  Created by Apple on 09/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "LenderProfileViewController.h"

#import "JTSImageViewController.h"
#import "JTSImageInfo.h"

@interface LenderProfileViewController ()<UIImagePickerControllerDelegate>
{
     NSString *base64EncodedP;
    NSDictionary *dict;
}

@end

@implementation LenderProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    aboutTxtView.placeholderColor = [UIColor lightGrayColor];
    
    usernametxtFld.borderStyle = UITextBorderStyleLine;
    usernametxtFld.layer.borderWidth = 1;
    usernametxtFld.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    usernametxtFld.layer.cornerRadius = 15.0;
    
    nameTextFld.borderStyle = UITextBorderStyleLine;
    nameTextFld.layer.borderWidth = 1;
    nameTextFld.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    nameTextFld.layer.cornerRadius = 15.0;
    
    addressTxtFld.borderStyle = UITextBorderStyleLine;
    addressTxtFld.layer.borderWidth = 1;
    addressTxtFld.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    addressTxtFld.layer.cornerRadius = 15.0;
    
    lastNameTextField.borderStyle = UITextBorderStyleLine;
    lastNameTextField.layer.borderWidth = 1;
    lastNameTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    lastNameTextField.layer.cornerRadius = 15.0;
    
    phoneNumbertxtFld.borderStyle = UITextBorderStyleLine;
    phoneNumbertxtFld.layer.borderWidth = 1;
    phoneNumbertxtFld.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    phoneNumbertxtFld.layer.cornerRadius = 15.0;
    
    emailTxtFld.borderStyle = UITextBorderStyleLine;
    emailTxtFld.layer.borderWidth = 1;
    emailTxtFld.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    emailTxtFld.layer.cornerRadius = 15.0;
    
   
    locationtextFld.layer.borderWidth = 1;
    locationtextFld.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    locationtextFld.layer.cornerRadius = 15.0;
    
    aboutTxtView.layer.borderWidth = 1;
    aboutTxtView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    aboutTxtView.layer.cornerRadius = 15.0;
    
    userProfilePic.layer.cornerRadius=userProfilePic.frame.size.width/2;
    userProfilePic.clipsToBounds= YES;
    
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:usernametxtFld ,nil]];
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:nameTextFld ,nil]];
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:locationtextFld ,nil]];
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:lastNameTextField ,nil]];
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:emailTxtFld ,nil]];
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:phoneNumbertxtFld ,nil]];
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:addressTxtFld ,nil]];
    
    editBtn.hidden = YES;
    
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
    [tapRecognizer addTarget:self action:@selector(bigButtonTapped:)];
    [userProfilePic addGestureRecognizer:tapRecognizer];
    
    userProfilePic.userInteractionEnabled=YES;
        [self callMyProfileAPI];
}


- (void)bigButtonTapped:(UITapGestureRecognizer*)sender
{
    UIImageView*seletedImage;
    if (sender.view==userProfilePic)
    {
        seletedImage=userProfilePic;
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


- (IBAction)firstEditBtnAction:(id)sender {
    
    
    cameraBtn.hidden = NO;
    nameTextFld.userInteractionEnabled = YES;
    lastNameTextField.userInteractionEnabled = YES;
    emailTxtFld.userInteractionEnabled = YES;
    usernametxtFld.userInteractionEnabled = YES;
    phoneNumbertxtFld.userInteractionEnabled = YES;
    addressTxtFld.userInteractionEnabled = YES;
    locationtextFld.userInteractionEnabled = YES;
    aboutTxtView.userInteractionEnabled = YES;

    editBtn.hidden = NO;
    
}




- (IBAction)myProfileBackBtnPressed:(id)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)cameraBtnPressed:(id)sender {
    
    [self ActionSheetImage];
}




- (IBAction)editBtnPressed:(id)sender
{
    
    
    
    [self updateProfileValidation];
    
   
    
}


-(void)updateProfileValidation
{
    
    if ([[nameTextFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please enter your First name"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [nameTextFld resignFirstResponder];
        
        
    }
    
    else if ([[lastNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        
        
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please enter your Last Name"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [lastNameTextField resignFirstResponder];}
    
    else if ([[emailTxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please enter your Password"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [emailTxtFld resignFirstResponder];    }
    
    
    else if ([[usernametxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please enter your Email"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [usernametxtFld resignFirstResponder];    }
    
    else if ([[phoneNumbertxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please enter your Address"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [phoneNumbertxtFld resignFirstResponder];    }
    
    
    
    else if ([[addressTxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please enter your area"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [addressTxtFld resignFirstResponder];    }
    
    else if ([[locationtextFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please Fill About User Field"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [locationtextFld resignFirstResponder];    }
    
    
    
    else if ([[aboutTxtView.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please enter your Phone Number"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [aboutTxtView resignFirstResponder];    }
    

    else if (![Utility NSStringIsValidEmail:emailTxtFld.text])
    {
        
        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                       message:@"Please enter Valid Email"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationRightToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [emailTxtFld resignFirstResponder];
        
    }
    
    else
    {
      [self CallUpdateMyProfileAPI];
        
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
    
    
    
    
    size =CGSizeMake(userProfilePic.frame.size.width,userProfilePic.frame.size.height);
    data = UIImagePNGRepresentation(image);
    base64EncodedP = [[NSString alloc] initWithString:[Base64 encode:data]];
    [userProfilePic setImage:image];
    
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









#pragma  My Profile
#pragma My Profile API
-(void)callMyProfileAPI
{
    
    dict=  [[NSUserDefaults standardUserDefaults]objectForKey:@"loginData"];
    NSLog(@"%@ login data = ",dict);
    
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"]
                                   };
    
    McomLOG(@"%@",registerInfo);
    [API myProfileWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
     {
         [Appdelegate stopLoader:nil];
         
         NSDictionary *dict_response = [[NSDictionary alloc]initWithDictionary:responseDict];
         
         if ([responseDict[@"result"]boolValue]==0)
         {
             NSLog(@"%@",dict_response);
             
         }
         else if ([responseDict[@"result"]boolValue]==1)
         {
             NSLog(@"sign_up%@", responseDict);
             
             if ([responseDict valueForKey:@"data"])
             {
                 nameTextFld.text = [NSString stringWithFormat:@"%@", [[responseDict valueForKey:@"data"] valueForKey:@"first_name"]];
                 
                 lastNameTextField.text = [NSString stringWithFormat:@"%@", [[responseDict valueForKey:@"data"] valueForKey:@"last_name"]];
                 
                  locationtextFld.text = [NSString stringWithFormat:@"%@", [[responseDict valueForKey:@"data"] valueForKey:@"location"]];
                 
                 emailTxtFld.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"] valueForKey:@"email"]];
                 
                 phoneNumbertxtFld.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"] valueForKey:@"phone"]];
                 
                 aboutTxtView.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"] valueForKey:@"about_user"]];
                 
                 addressTxtFld.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"] valueForKey:@"address"]];
                 
                 usernametxtFld.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"] valueForKey:@"username"]];
                 
                 [userProfilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"] valueForKey:@"profile_pic"]]] placeholderImage:[UIImage imageNamed:@"1"] options:SDWebImageRefreshCached];
                 
             }
         }
     }];
}



# pragma update
#pragma Update Profile API
-(void)CallUpdateMyProfileAPI
{
    [Appdelegate startLoader:nil withTitle:@"Loding..."];
    NSDictionary* MyProfileInfo;
    
    if ([base64EncodedP length]==0)
    {
        base64EncodedP=@"";
    }
    MyProfileInfo = @{
                      @"access_token":[dict valueForKey:@"access_token"],
                      @"email":emailTxtFld.text,
                      @"first_name":nameTextFld.text,
                      @"profile_pic":base64EncodedP,
                      @"last_name":lastNameTextField.text,
                      @"location":locationtextFld.text,
                      @"address":addressTxtFld.text,
                      @"device_type":@"Iphone",
                      @"device_token":@"12345678",
                      @"about_user":aboutTxtView.text,
                      @"phone":phoneNumbertxtFld.text,
                      @"username":usernametxtFld.text
                      };
    
    McomLOG(@"%@",MyProfileInfo);
    [API UpdateProfileWithInfo:[MyProfileInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
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
             [Utility showAlertWithTitleText:[responseDict valueForKey:@"message"] messageText:nil delegate:nil];
             
             nameTextFld.text = [NSString stringWithFormat:@"%@", [[responseDict valueForKey:@"data"] valueForKey:@"first_name"]];
             
             lastNameTextField.text = [NSString stringWithFormat:@"%@", [[responseDict valueForKey:@"data"] valueForKey:@"last_name"]];
             
             locationtextFld.text = [NSString stringWithFormat:@"%@", [[responseDict valueForKey:@"data"] valueForKey:@"location"]];
             
             emailTxtFld.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"] valueForKey:@"email"]];
             
             phoneNumbertxtFld.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"] valueForKey:@"phone"]];
             
             aboutTxtView.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"] valueForKey:@"about_user"]];
             
             addressTxtFld.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"] valueForKey:@"address"]];
             
             usernametxtFld.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"] valueForKey:@"username"]];
             
             [userProfilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"] valueForKey:@"profile_pic"]]] placeholderImage:[UIImage imageNamed:@"1"] options:SDWebImageRefreshCached];
             
          
             [aboutTxtView resignFirstResponder];
             cameraBtn.hidden = YES;
             nameTextFld.userInteractionEnabled = NO;
             lastNameTextField.userInteractionEnabled = NO;
             emailTxtFld.userInteractionEnabled = NO;
             usernametxtFld.userInteractionEnabled = NO;
             phoneNumbertxtFld.userInteractionEnabled = NO;
             addressTxtFld.userInteractionEnabled = NO;
             locationtextFld.userInteractionEnabled = NO;
             aboutTxtView.userInteractionEnabled = NO;
             
             editBtn.hidden = NO;
             
             [self.navigationController popViewControllerAnimated:YES];
             
             
             
             
             
            
         }
     }];
}



@end
