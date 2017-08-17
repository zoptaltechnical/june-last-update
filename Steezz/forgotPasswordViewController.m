//
//  forgotPasswordViewController.m
//  Steezz
//
//  Created by Apple on 08/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "forgotPasswordViewController.h"

@interface forgotPasswordViewController ()

@end

@implementation forgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    forgotSendBtn.layer.cornerRadius =20;
    forgotSendBtn.clipsToBounds = YES;
    
    
    forgotEmailTxtFld.borderStyle = UITextBorderStyleLine;
    forgotEmailTxtFld.layer.borderWidth = 2;
    forgotEmailTxtFld.layer.cornerRadius = 15.0;
    
   // forgotEmailTxtFld.layer.borderColor = [[UIColor lightGrayColor] CGColor];

    
    // Do any additional setup after loading the view.
}
- (IBAction)forgotSendBtnPressed:(id)sender
{
    
    [self forgotPasswordValidation];
    
}

- (IBAction)forgotBackBtnPressed:(id)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)forgotPasswordValidation

{
    if ([[forgotEmailTxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
    {
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter your Email"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationTopToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        [forgotEmailTxtFld resignFirstResponder];
    }
    
    else if (![Utility NSStringIsValidEmail:forgotEmailTxtFld.text])
    {
        [SRAlertView sr_showAlertViewWithTitle:@""
                                       message:@"Please enter Valid Email"
                               leftActionTitle:@"OK"
                              rightActionTitle:@""
                                animationStyle:AlertViewAnimationTopToCenterSpring
                                  selectAction:^(AlertViewActionType actionType) {
                                      NSLog(@"%zd", actionType);
                                  }];
        
        [forgotEmailTxtFld resignFirstResponder];

    }
    
    else
    {
        [self callForgotPasswordAPI];
    }
}


# pragma forgot Password API.

-(void)callForgotPasswordAPI
{
    
    NSDictionary* registerInfo;
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    registerInfo = @{
                     @"email":forgotEmailTxtFld.text
                     };
    
    McomLOG(@"%@",registerInfo);
    [API ForgotPasswrodWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
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
             NSLog(@"Home Feed Data =  %@",responseDict);
             NSString * errormessage = [NSString stringWithFormat:@"%@",[dict_response valueForKey:@"message"]];
             
             
             [forgotEmailTxtFld resignFirstResponder];

             
             [SRAlertView sr_showAlertViewWithTitle:@""
                                            message:errormessage
                                    leftActionTitle:@"OK"
                                   rightActionTitle:@""
                                     animationStyle:AlertViewAnimationRightToCenterSpring
                                       selectAction:^(AlertViewActionType actionType) {
                                           NSLog(@"%zd", actionType);
                                       }];
         }
         
     }];
}



@end

