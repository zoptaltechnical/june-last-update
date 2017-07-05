//
//  LoginScreenViewController.m
//  Steezz
//
//  Created by Apple on 07/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "LoginScreenViewController.h"

@interface LoginScreenViewController ()
{
   
    NSDictionary *dict;
}

@end

@implementation LoginScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    signUpBtn.layer.cornerRadius =20;
    signUpBtn.clipsToBounds = YES;
    loginBtn.layer.cornerRadius = 20;
    loginBtn.clipsToBounds = YES;
    loginBtn.layer.borderColor = [UIColor blackColor].CGColor;
    loginBtn.layer.borderWidth = 1;
    

}


-(void)viewWillAppear:(BOOL)animated
{
    
    dict=  [[NSUserDefaults standardUserDefaults]objectForKey:@"loginData"];
    NSLog(@"%@ login data = ",dict);
    
    
    if ([[dict  valueForKey:@"user_type"] isEqualToString:@"2"]) {
        
        LenderTabBarViewController *secondView = [self.storyboard instantiateViewControllerWithIdentifier:@"LenderTabBarViewController"];
        [self.navigationController pushViewController:secondView animated:YES];
    }
    
    else if ([[dict  valueForKey:@"user_type"] isEqualToString:@"1"])
    {
        
        LendeeTabBarViewController *secondView = [self.storyboard instantiateViewControllerWithIdentifier:@"LendeeTabBarViewController"];
        [self.navigationController pushViewController:secondView animated:YES];
    }
    
    else
    {
        
        NSLog(@"do nothing ");
    }
    
}

- (IBAction)signUpBtnPressed:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    signupViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"signupViewController"];
    [self.navigationController pushViewController:homeObj animated:YES];
    
}

- (IBAction)loginBtnPressed:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    signInViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"signInViewController"];
    [self.navigationController pushViewController:homeObj animated:YES];
}

@end
