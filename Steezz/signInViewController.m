//
//  signInViewController.m
//  Steezz
//
//  Created by Apple on 05/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "signInViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface signInViewController ()
{
    
    NSString *facebookIDString;
    NSString *profilePictureString;
    NSString *firstname;
    NSString *lastName;
    NSString *emailString;
    
        NSString *checkString;
}

@end

@implementation signInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    SignInButton.layer.cornerRadius =20;
    SignInButton.clipsToBounds = YES;
    
    
    signInEmailTxtFld.borderStyle = UITextBorderStyleLine;
    signInEmailTxtFld.layer.borderWidth = 2;
    signInEmailTxtFld.layer.cornerRadius = 15.0;

    signInPasswrdTxtFld.borderStyle = UITextBorderStyleLine;
    signInPasswrdTxtFld.layer.borderWidth = 2;
    signInPasswrdTxtFld.layer.cornerRadius = 15.0;
    
    
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:signInEmailTxtFld ,nil]];
    [Utility addHorizontalPadding:[NSMutableArray arrayWithObjects:signInPasswrdTxtFld ,nil]];

}


-(void)viewWillAppear:(BOOL)animated{
   
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"DataSaved"] isEqualToString:@"Yes"])
    {
        signInEmailTxtFld.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"email"];
        signInPasswrdTxtFld.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
        
    }
    
         else   if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"DataSaved"] isEqualToString:@"No"])
         {
             signInEmailTxtFld.text = nil;
             signInPasswrdTxtFld.text = nil;
         }
}



- (IBAction)faceBookBtnAction:(id)sender {

        FBSDKLoginManager *loginManger = [[FBSDKLoginManager alloc] init];
        
        [loginManger logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
    {
        if (error)
        {
                 // Process error
        }
             else if (result.isCancelled)
             {
                 // Handle cancellations
             }
             else
             {
                 // If you ask for multiple permissions at once, you
                 // should check if specific permissions missing
                 if ([FBSDKAccessToken currentAccessToken])
                 {
                     [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday,location ,friends ,hometown , friendlists"}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
                      {
                          if (!error)
                          {
                              NSLog(@"%@",result);
  
                              if ([result valueForKey:@"picture"]) {
                                  
                                  if ([[result valueForKey:@"picture"]valueForKey:@"data"]) {
                                      
                                      if ([[[[result valueForKey:@"picture"]valueForKey:@"data"]valueForKey:@"url"]length]>0) {
                                          
                                          profilePictureString=[[[result valueForKey:@"picture"]valueForKey:@"data"]valueForKey:@"url"];
                                      }
                                  }

                                  if ([[result valueForKey:@"email"]length]>0) {
                                      
                                      emailString=[NSString stringWithFormat:@"%@",[result valueForKey:@"email"]];
                                  }
                                  
                                  if ([[result valueForKey:@"first_name"]length]>0) {
                                      
                                      firstname=[NSString stringWithFormat:@"%@",[result valueForKey:@"first_name"]];
                                      
                                      facebookIDString = [NSString stringWithFormat:@"%@",[result valueForKey:@"id"]];
                                  }
                                  
                                  if ([[result valueForKey:@"last_name"]length]>0) {
                                      
                                      lastName=[NSString stringWithFormat:@"%@",[result valueForKey:@"last_name"]];
                                  }
                              }
                              
                              [self callFacebookLoginAPI];
                          
                          }
                          else
                          {
                                                   return ;
                          }
                      }];
                 }
             }
         }];
    
}


- (IBAction)signInBtnPressed:(id)sender {
    
    
    [self signInValidation];
//    
//    UIViewController *popUpController = ViewControllerIdentifier(@"LenderNavigateID");
//    [self.view.window setRootViewController:popUpController];
//    
    
    
}

- (IBAction)keepMrSignInBtnPressed:(id)sender {
    
    if ([keepMeSignInBtn.currentImage isEqual:[UIImage imageNamed:@"cricle"]])
    {
        checkString = @"1";
        [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"DataSaved"];
        [keepMeSignInBtn setImage:[UIImage imageNamed:@"select_icon-1"] forState:UIControlStateNormal];
    }
        else
        {
        checkString = @"0";
        [[NSUserDefaults standardUserDefaults] setValue:@"No" forKey:@"DataSaved"];
        [keepMeSignInBtn setImage:[UIImage imageNamed:@"cricle"] forState:UIControlStateNormal];
        }
}

- (IBAction)forgotPasswordBtnPressed:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    forgotPasswordViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"forgotPasswordViewController"];
    [self.navigationController pushViewController:homeObj animated:YES];
   
}



- (IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}




-(void)signInValidation
{
    if ([[signInEmailTxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter your Email"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationTopToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        [signInEmailTxtFld resignFirstResponder];
        [signInPasswrdTxtFld resignFirstResponder];
    }
    
    else if ([[signInPasswrdTxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter your Password"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationZoom
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        [signInEmailTxtFld resignFirstResponder];
        [signInPasswrdTxtFld resignFirstResponder];
        
    }
    
    else
    {
        [self callSignInAPI];
    }
}

#pragma Sign in API

-(void)callSignInAPI
{
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSLog(@"device %@",[Utility valueForKey:DeviceToken]);
    
    NSDictionary* registerInfo = @{
                                   @"username":signInEmailTxtFld.text,
                                   @"password":signInPasswrdTxtFld.text,
                                   @"device_token":[Utility valueForKey:DeviceToken],
                                   @"device_type":@"iPhone"
                                   };
    
    McomLOG(@"%@",registerInfo);
    [API signInUserWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
     {
         
         [Appdelegate stopLoader:nil];
         
         NSDictionary *dict_response = [[NSDictionary alloc]initWithDictionary:responseDict];
         
         if ([responseDict[@"result"]boolValue]==0)
         {
             NSString * errormessage = [NSString stringWithFormat:@"%@",[dict_response valueForKey:@"message"]];
             
             [signInPasswrdTxtFld resignFirstResponder];
             [signInEmailTxtFld resignFirstResponder];
             
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
             [signInEmailTxtFld resignFirstResponder];
             [signInPasswrdTxtFld resignFirstResponder];
             
             NSLog(@"sign_up%@", responseDict);
             
             
             
               [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"logedIn"];
             
             if ([checkString isEqualToString:@"1"]) {
                 
                 [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"DataSaved"];
                 
                 [[NSUserDefaults standardUserDefaults]setValue:signInEmailTxtFld.text forKey:@"email"];
                 [[NSUserDefaults standardUserDefaults]setValue:signInPasswrdTxtFld.text forKey:@"password"];
             }
             else
             {
                 [[NSUserDefaults standardUserDefaults] setValue:@"No" forKey:@"DataSaved"];
                 [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"email"];
                 [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"password"];
             }
             
             [[NSUserDefaults standardUserDefaults] setObject:[responseDict objectForKey:@"data"]forKey:@"loginData"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             
             if ([[[responseDict valueForKey:@"data"] valueForKey:@"user_type"] isEqualToString:@"2"]) {
                 
                 LenderTabBarViewController *secondView = [self.storyboard instantiateViewControllerWithIdentifier:@"LenderTabBarViewController"];
                 [self.navigationController pushViewController:secondView animated:YES];
             }
             
             else if ([[[responseDict valueForKey:@"data"] valueForKey:@"user_type"] isEqualToString:@"1"])
             {
                
                 LendeeTabBarViewController *secondView = [self.storyboard instantiateViewControllerWithIdentifier:@"LendeeTabBarViewController"];
                 [self.navigationController pushViewController:secondView animated:YES];
             }
         }
     }];
}

-(void) callFacebookLoginAPI
{
    NSLog(@"%@",facebookIDString);
    NSLog(@"%@",profilePictureString);
    NSLog(@"%@",firstname);
    NSLog(@"%@",lastName);
    NSLog(@"%@",emailString);
    
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    
    // facebook_id, first_name, last_name, email, profile_pic, device_token, device_type
    
    NSDictionary* registerInfo = @{
                                   @"facebook_id":facebookIDString,
                                   @"first_name":firstname,
                                   @"device_token":DeviceToken,
                                   @"device_type":@"iPhone",
                                   @"last_name":lastName,
                                   @"email":emailString,
                                   @"profile_pic":profilePictureString
                                   };
    
    McomLOG(@"%@",registerInfo);
    [API FaceBookSignInWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
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
             
             [[NSUserDefaults standardUserDefaults] setObject:[responseDict objectForKey:@"data"]forKey:@"loginData"];
             [[NSUserDefaults standardUserDefaults] synchronize];
           
             
             if ([[[responseDict valueForKey:@"data"] valueForKey:@"user_type"] isEqualToString:@"2"]) {
                 
                 LenderTabBarViewController *secondView = [self.storyboard instantiateViewControllerWithIdentifier:@"LenderTabBarViewController"];
                 [self.navigationController pushViewController:secondView animated:YES];
             }
             
             else if ([[[responseDict valueForKey:@"data"] valueForKey:@"user_type"] isEqualToString:@"1"])
             {
                 
                 LendeeTabBarViewController *secondView = [self.storyboard instantiateViewControllerWithIdentifier:@"LendeeTabBarViewController"];
                 [self.navigationController pushViewController:secondView animated:YES];
             }
         }
     }];
}
@end
