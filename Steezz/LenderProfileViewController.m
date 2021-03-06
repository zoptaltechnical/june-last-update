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
    
   
    cityTextField.layer.borderWidth = 1;
    cityTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    cityTextField.layer.cornerRadius = 15.0;
    
    stateTextField.layer.borderWidth = 1;
    stateTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    stateTextField.layer.cornerRadius = 15.0;
    
    zipcodeTextField.layer.borderWidth = 1;
    zipcodeTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    zipcodeTextField.layer.cornerRadius = 15.0;
    
    payPalIDTxtFld.layer.borderWidth = 1;
    payPalIDTxtFld.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    payPalIDTxtFld.layer.cornerRadius = 15.0;
    
    aboutTxtView.layer.borderWidth = 1;
    aboutTxtView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    aboutTxtView.layer.cornerRadius = 15.0;
    
    userProfilePic.layer.cornerRadius=userProfilePic.frame.size.width/2;
    userProfilePic.clipsToBounds= YES;
    
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:nameTextFld ,nil]];
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:cityTextField ,nil]];
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:lastNameTextField ,nil]];
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:emailTxtFld ,nil]];
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:phoneNumbertxtFld ,nil]];
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:addressTxtFld ,nil]];
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:payPalIDTxtFld ,nil]];
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:zipcodeTextField ,nil]];
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:stateTextField ,nil]];
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:cityTextField ,nil]];

    
    
    editBtn.hidden = YES;
    
    
    // Code commented to avoid the zoom effect of profile pic.
    
    
//    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
//    [tapRecognizer addTarget:self action:@selector(bigButtonTapped:)];
//    [userProfilePic addGestureRecognizer:tapRecognizer];
//    
//    userProfilePic.userInteractionEnabled=YES;
    
}



-(void)viewWillAppear:(BOOL)animated
{
    
    if ([[Utility valueForKey:backArrow] isEqualToString:@"2"])
    {
        myProfileBackBtn.hidden = NO;
        
        
    }
    
    else{
        
        myProfileBackBtn.hidden = YES;
        
    }
    
    
    if ([base64EncodedP length]>0)
    {
        
    }
    
    else
    {
       [self callMyProfileAPI];
    }
    
    
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
    [nameTextFld becomeFirstResponder];
    
    
    nameTextFld.userInteractionEnabled = YES;
    lastNameTextField.userInteractionEnabled = YES;
    emailTxtFld.userInteractionEnabled = YES;
    phoneNumbertxtFld.userInteractionEnabled = YES;
    addressTxtFld.userInteractionEnabled = YES;
    cityTextField.userInteractionEnabled = YES;
    stateTextField.userInteractionEnabled = YES;
    zipcodeTextField.userInteractionEnabled = YES;

    aboutTxtView.userInteractionEnabled = YES;
    payPalIDTxtFld.userInteractionEnabled = YES;
    editBtn.hidden = NO;
    
}




- (IBAction)myProfileBackBtnPressed:(id)sender {
    
    [Utility setValue:@"1" forKey:backArrow];
    
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
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter your First name"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        [nameTextFld resignFirstResponder];
        [lastNameTextField resignFirstResponder];
        [phoneNumbertxtFld resignFirstResponder];
        [aboutTxtView resignFirstResponder];
        [addressTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
        [cityTextField resignFirstResponder];
        [stateTextField resignFirstResponder];
        [zipcodeTextField resignFirstResponder];

        [payPalIDTxtFld resignFirstResponder];
        [payPalIDTxtFld resignFirstResponder];
        
        
    }
    
    else if ([[lastNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        
        
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter your Last Name"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [nameTextFld resignFirstResponder];
        [lastNameTextField resignFirstResponder];
        [phoneNumbertxtFld resignFirstResponder];
        [aboutTxtView resignFirstResponder];
        [addressTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
        [cityTextField resignFirstResponder];
        [stateTextField resignFirstResponder];
        [zipcodeTextField resignFirstResponder];
        [payPalIDTxtFld resignFirstResponder];
    }
    
    else if ([[emailTxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter your Password"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [nameTextFld resignFirstResponder];
        [lastNameTextField resignFirstResponder];
        [phoneNumbertxtFld resignFirstResponder];
        [aboutTxtView resignFirstResponder];
        [addressTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
        [cityTextField resignFirstResponder];
        [stateTextField resignFirstResponder];
        [zipcodeTextField resignFirstResponder];
        [payPalIDTxtFld resignFirstResponder];
    }
    
    
//    else if ([[usernametxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
//    {
//        [SRAlertView sr_showAlertViewWithTitle:@"Alert"
//                                       message:@"Please enter your Email"
//                               leftActionTitle:@"OK"
//                              rightActionTitle:@""
//                                animationStyle:AlertViewAnimationDownToCenterSpring
//                                  selectAction:^(AlertViewActionType actionType) {
//                                      NSLog(@"%zd", actionType);
//                                  }];
//        
//        
//        [nameTextFld resignFirstResponder];
//        [lastNameTextField resignFirstResponder];
//        [phoneNumbertxtFld resignFirstResponder];
//        [aboutTxtView resignFirstResponder];
//        [addressTxtFld resignFirstResponder];
//        [emailTxtFld resignFirstResponder];
//        [locationtextFld resignFirstResponder];
//        [payPalIDTxtFld resignFirstResponder];
//        [usernametxtFld resignFirstResponder];
//    }
    
    else if ([[phoneNumbertxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter your phone Number"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [nameTextFld resignFirstResponder];
        [lastNameTextField resignFirstResponder];
        [phoneNumbertxtFld resignFirstResponder];
        [aboutTxtView resignFirstResponder];
        [addressTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];

        [cityTextField resignFirstResponder];
        [stateTextField resignFirstResponder];
        [zipcodeTextField resignFirstResponder];
        [payPalIDTxtFld resignFirstResponder];
    }
    
    
    
    else if ([[addressTxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter your address"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [nameTextFld resignFirstResponder];
        [lastNameTextField resignFirstResponder];
        [phoneNumbertxtFld resignFirstResponder];
        [aboutTxtView resignFirstResponder];
        [addressTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
        [cityTextField resignFirstResponder];
        [stateTextField resignFirstResponder];
        [zipcodeTextField resignFirstResponder];
        [payPalIDTxtFld resignFirstResponder];
    }
    
    else if ([[cityTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter your city"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [nameTextFld resignFirstResponder];
        [lastNameTextField resignFirstResponder];
        [phoneNumbertxtFld resignFirstResponder];
        [aboutTxtView resignFirstResponder];
        [addressTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
        [cityTextField resignFirstResponder];
        [stateTextField resignFirstResponder];
        [zipcodeTextField resignFirstResponder];
        [payPalIDTxtFld resignFirstResponder];
    }
    
    
    
    else if ([[stateTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter your state"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [nameTextFld resignFirstResponder];
        [lastNameTextField resignFirstResponder];
        [phoneNumbertxtFld resignFirstResponder];
        [aboutTxtView resignFirstResponder];
        [addressTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
        [cityTextField resignFirstResponder];
        [stateTextField resignFirstResponder];
        [zipcodeTextField resignFirstResponder];
        [payPalIDTxtFld resignFirstResponder];
    }
    
    
    
    
    else if ([[zipcodeTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter your Zip code"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [nameTextFld resignFirstResponder];
        [lastNameTextField resignFirstResponder];
        [phoneNumbertxtFld resignFirstResponder];
        [aboutTxtView resignFirstResponder];
        [addressTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
        [cityTextField resignFirstResponder];
        [stateTextField resignFirstResponder];
        [zipcodeTextField resignFirstResponder];
        [payPalIDTxtFld resignFirstResponder];
    }
    
    
    else if ([[payPalIDTxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"You cannot Update your Profile without adding Paypal ID!"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [nameTextFld resignFirstResponder];
        [lastNameTextField resignFirstResponder];
        [phoneNumbertxtFld resignFirstResponder];
        [aboutTxtView resignFirstResponder];
        [addressTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
        [cityTextField resignFirstResponder];
        [stateTextField resignFirstResponder];
        [zipcodeTextField resignFirstResponder];
        [payPalIDTxtFld resignFirstResponder];
    }


            
        else if ( ![Utility NSStringIsValidEmail:payPalIDTxtFld.text])
            {
              
                [SRAlertView sr_showAlertViewWithTitle:@""
                                               message:@"Please enter your Valid Paypal ID."
                                       leftActionTitle:@"OK"
                                      rightActionTitle:@""
                                        animationStyle:AlertViewAnimationRightToCenterSpring
                                          selectAction:^(AlertViewActionType actionType) {
                                              NSLog(@"%zd", actionType);
                                          }];
                
                [nameTextFld resignFirstResponder];
                [lastNameTextField resignFirstResponder];
                [phoneNumbertxtFld resignFirstResponder];
                [aboutTxtView resignFirstResponder];
                [addressTxtFld resignFirstResponder];
                [emailTxtFld resignFirstResponder];
                [cityTextField resignFirstResponder];
                [stateTextField resignFirstResponder];
                [zipcodeTextField resignFirstResponder];
                [payPalIDTxtFld resignFirstResponder];
            }
    
    
    

    else if (![Utility NSStringIsValidEmail:emailTxtFld.text])
    {
        
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter Valid Email"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationRightToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        
        [nameTextFld resignFirstResponder];
        [lastNameTextField resignFirstResponder];
        [phoneNumbertxtFld resignFirstResponder];
        [aboutTxtView resignFirstResponder];
        [addressTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
        [cityTextField resignFirstResponder];
        [stateTextField resignFirstResponder];
        [zipcodeTextField resignFirstResponder];
        [payPalIDTxtFld resignFirstResponder];
        
    }
    
    
    else if ([[payPalIDTxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        
        
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter your Paypal ID"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationDownToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
         
                                  
                                  }];
        
        [nameTextFld resignFirstResponder];
        [lastNameTextField resignFirstResponder];
        [phoneNumbertxtFld resignFirstResponder];
        [aboutTxtView resignFirstResponder];
        [addressTxtFld resignFirstResponder];
        [emailTxtFld resignFirstResponder];
        [cityTextField resignFirstResponder];
        [stateTextField resignFirstResponder];
        [zipcodeTextField resignFirstResponder];
        [payPalIDTxtFld resignFirstResponder];
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
    
    picker.navigationBar.barStyle = UIBarStyleBlack;
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
                 
                  cityTextField.text = [NSString stringWithFormat:@"%@", [[responseDict valueForKey:@"data"] valueForKey:@"city"]];
                 
                 stateTextField.text = [NSString stringWithFormat:@"%@", [[responseDict valueForKey:@"data"] valueForKey:@"state"]];
                 
                 zipcodeTextField.text = [NSString stringWithFormat:@"%@", [[responseDict valueForKey:@"data"] valueForKey:@"zip_code"]];
                 
                 emailTxtFld.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"] valueForKey:@"email"]];
                 
                 phoneNumbertxtFld.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"] valueForKey:@"phone"]];
                 
                 aboutTxtView.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"] valueForKey:@"about_user"]];
                 
                 addressTxtFld.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"] valueForKey:@"address"]];
                 
                 
                  payPalIDTxtFld.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"] valueForKey:@"paypal_id"]];
               
                 
                 [userProfilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"] valueForKey:@"profile_pic"]]] placeholderImage:[UIImage imageNamed:@"profile_icon"] options:SDWebImageRefreshCached];
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
    
    
    if ([aboutTxtView.text length]==0) {
        aboutTxtView.text = @"";
    }
        
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
                      @"city":cityTextField.text,
                      @"state":stateTextField.text,
                      @"zip_code":zipcodeTextField.text,
                      @"address":addressTxtFld.text,
                      @"device_type":@"Iphone",
                      @"device_token":DeviceToken,
                      @"about_user":aboutTxtView.text,
                      @"phone":phoneNumbertxtFld.text,
                      @"paypal_id":payPalIDTxtFld.text
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
             
             stateTextField.text = [NSString stringWithFormat:@"%@", [[responseDict valueForKey:@"data"] valueForKey:@"state"]];
             
             cityTextField.text = [NSString stringWithFormat:@"%@", [[responseDict valueForKey:@"data"] valueForKey:@"city"]];
             
             
             zipcodeTextField.text = [NSString stringWithFormat:@"%@", [[responseDict valueForKey:@"data"] valueForKey:@"zip_code"]];
             
             emailTxtFld.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"] valueForKey:@"email"]];
             
             phoneNumbertxtFld.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"] valueForKey:@"phone"]];
             
             aboutTxtView.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"] valueForKey:@"about_user"]];
             
             addressTxtFld.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"] valueForKey:@"address"]];
            
             payPalIDTxtFld.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"] valueForKey:@"paypal_id"]];
             
             [userProfilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"] valueForKey:@"profile_pic"]]] placeholderImage:[UIImage imageNamed:@"profile_icon"] options:SDWebImageRefreshCached];
          
             [aboutTxtView resignFirstResponder];
             cameraBtn.hidden = YES;
             nameTextFld.userInteractionEnabled = NO;
             lastNameTextField.userInteractionEnabled = NO;
             emailTxtFld.userInteractionEnabled = NO;
             phoneNumbertxtFld.userInteractionEnabled = NO;
             addressTxtFld.userInteractionEnabled = NO;
             cityTextField.userInteractionEnabled = NO;
              stateTextField.userInteractionEnabled = NO;
              zipcodeTextField.userInteractionEnabled = NO;
             aboutTxtView.userInteractionEnabled = NO;
             payPalIDTxtFld.userInteractionEnabled = NO;
             editBtn.hidden = YES;
         }
     }];
}
@end
