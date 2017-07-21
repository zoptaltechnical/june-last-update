//
//  CreditCardListingViewController.m
//  Steezz
//
//  Created by Apple on 07/06/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "CreditCardListingViewController.h"


@interface CreditCardListingViewController ()
{
    NSString *cardID;
    NSMutableArray *cardListArray;
    NSDictionary *dict;
}

@end

@implementation CreditCardListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dict=  [[NSUserDefaults standardUserDefaults]objectForKey:@"loginData"];
    NSLog(@"%@ login data = ",dict);
    
    
    [self CreditCardListingAPI];
    
    // Do any additional setup after loading the view.
}

- (IBAction)savedCardBackBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)addCardBtnAction:(id)sender {
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SaveCreditCardViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"SaveCreditCardViewController"];
    [self.navigationController pushViewController:homeObj animated:YES];
    
    
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cardListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CreditCardCell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CreditCardCell"];
    }
    
    UILabel *CardType=(UILabel *)[cell.contentView viewWithTag:960000001];
    CardType.text= [NSString stringWithFormat:@"%@",   [[cardListArray valueForKey:@"card_type"]objectAtIndex:indexPath.row]];
    
    UILabel *Cardnumber=(UILabel *)[cell.contentView viewWithTag:960000002];
    Cardnumber.text= [NSString stringWithFormat:@"%@",   [[cardListArray valueForKey:@"card_number"]objectAtIndex:indexPath.row]];

  
    UIImageView *ImageMy = (UIImageView *)[cell.contentView viewWithTag:960000000];
    
    if ([[[cardListArray valueForKey:@"card_type"]objectAtIndex:indexPath.row] isEqualToString:@"visa"])
    {
        [ImageMy setImage:[UIImage imageNamed:@"visa"]];
        
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    cardID = [[cardListArray valueForKey:@"card_id"]objectAtIndex:indexPath.row];
    
     if ([[Utility valueForKey:CreditCardCheck] isEqualToString:@"2"])
    {
        [Utility setValue:@"1" forKey:CreditCardCheck];
        
        [self callCreditCardPaymentAPI];
       
        NSLog(@" want to pay");
    }

    else
    {
        NSLog(@"dont want to pay");
    }
//
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    LenderProductDetailViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"LenderProductDetailViewController"];

//    [self.navigationController pushViewController:homeObj animated:YES];
//    
    
    
}

-(void)CreditCardListingAPI
{
    
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"]
                                   };
    McomLOG(@"%@",registerInfo);
    [API SavedCreditCardWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
     {
         
         [Appdelegate stopLoader:nil];
         NSDictionary *dict_response = [[NSDictionary alloc]initWithDictionary:responseDict];
         NSLog(@"%@",dict_response);
         
         if ([responseDict[@"response"]boolValue]==0)
         {
             [Utility showAlertWithTitleText:[responseDict valueForKey:@"message"] messageText:nil delegate:nil];
             
           //  [self.navigationController popViewControllerAnimated:YES];
             
         }
         
         else if ([responseDict[@"response"]boolValue]==1)
         {
             NSLog(@"Home Feed List  = %@",responseDict);
             
             NSLog(@"%@", responseDict);
             
             cardListArray =[[NSMutableArray alloc]initWithArray:responseDict[@"data"]];
             NSLog(@"tabel list Data%@", cardListArray);
             
             if (cardListArray.count ==0)
             {
               
             }
             
             [cardListingTableView reloadData];
             
         }
     }];

    
    
}


-(void)callCreditCardPaymentAPI
{
    
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSLog(@"%@",cardID);
    
    NSLog(@"saved Card _startDateString = %@",_startDateString);
    
    NSDictionary* registerInfo;
    
    registerInfo= @{
                    @"cc_fname":@"",
                    @"cc_lname":@"",
                    @"cc_number":@"",
                    @"card_type":@"",
                    @"exp_month":@"",
                    @"exp_year":@"",
                    @"cvv":@"",
                    @"save_credit_card":@"",
                    @"access_token":[dict valueForKey:@"access_token"],
                    @"product_id":_ProductIdStringString,
                    @"booking_dates":_startDateString,
                    @"payment_by":@"saved_card",
                    @"save_cc_id":cardID
                    };
    
    McomLOG(@"%@",registerInfo);
    [API CreditCardPaymnetWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
     {
         [Appdelegate stopLoader:nil];
         NSDictionary *dict_response = [[NSDictionary alloc]initWithDictionary:responseDict];
         
         if ([responseDict[@"response"]boolValue]==0)
         {
             UIStoryboard *sb = [self storyboard];
             
             UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LenderTabBarViewController"];
             Appdelegate.window.rootViewController = vc;
           
             [Utility showAlertWithTitleText:@"Please Provide paypal transaction id." messageText:nil delegate:nil];
         }
         else if ([responseDict[@"response"]boolValue]==1)
         {
             
               [Utility showAlertWithTitleText:@"Product Booked Succesfully!" messageText:nil delegate:nil];
    
             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             LenderTabBarViewController* tabBarController = (LenderTabBarViewController*)[storyboard instantiateViewControllerWithIdentifier:@"LenderTabBarViewController"];
           
             [self.navigationController pushViewController:tabBarController animated:YES];
             
            
     

         }
     }];
    
    
    
}

@end
