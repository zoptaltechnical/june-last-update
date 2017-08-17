//
//  LENDEEProductsViewController.m
//  Steezz
//
//  Created by Apple on 10/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "LENDEEProductsViewController.h"

@interface LENDEEProductsViewController ()

{
    NSString *MyPayPalID;
    NSDictionary *dict;
    NSString *lendeeProductID;
    
    NSMutableArray *LendeeProductArray;
    
}

@end

@implementation LENDEEProductsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    dict=  [[NSUserDefaults standardUserDefaults]objectForKey:@"loginData"];
    NSLog(@"%@ login data = ",dict);
    
   
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
     NoProductAddedLabel.hidden = YES;
    [self callMyProfileAPI];
    
     [self callLendeeProductListAPI];
    
}

- (IBAction)productAddBtnPressed:(id)sender {
    
    
   
        if ([MyPayPalID length]==0)
        {
            [SRAlertView sr_showAlertViewWithTitle:@""
                                           message:@"You have to Add Paypal Id in order to add Products."
                                   leftActionTitle:@"OK"
                                  rightActionTitle:@""
                                    animationStyle:AlertViewAnimationTopToCenterSpring
                                      selectAction:^(AlertViewActionType actionType) {
                                          NSLog(@"%zd", actionType);
                                      }];

            
        }
        else
        {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            LendeeAddProductViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"LendeeAddProductViewController"];
            [self.navigationController pushViewController:homeObj animated:YES];
            
        }
        
        
    
   
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return LendeeProductArray.count ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"LendeeProductCell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LendeeProductCell"];
    }
    
    
    UILabel *Productname=(UILabel *)[cell.contentView viewWithTag:6000];
    Productname.text= [NSString stringWithFormat:@"%@",   [[LendeeProductArray valueForKey:@"product_name"]objectAtIndex:indexPath.row]];
    
    UILabel *price=(UILabel *)[cell.contentView viewWithTag:6001];
    price.text= [NSString stringWithFormat:@"%@",   [[LendeeProductArray valueForKey:@"product_price"]objectAtIndex:indexPath.row]];
    
    UILabel *Description=(UILabel *)[cell.contentView viewWithTag:6002];
    Description.text= [NSString stringWithFormat:@"%@",[[LendeeProductArray valueForKey:@"product_desc"]objectAtIndex:indexPath.row]];
    
    UIImageView *ImageMy = (UIImageView *)[cell.contentView viewWithTag:6003];
    
    [ImageMy sd_setImageWithURL:[NSURL URLWithString: [[LendeeProductArray valueForKey:@"product_image"] objectAtIndex:indexPath.row] ]placeholderImage:[UIImage imageNamed:@"1"] options:SDWebImageRefreshCached];
    
  //  UIButton *DeleteProductBtn =(UIButton *)[cell.contentView viewWithTag:6004];
   // [DeleteProductBtn addTarget:self
            //    action:@selector(DeleteBtnPressed:)
     // forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *date=(UILabel *)[cell.contentView viewWithTag:6005];
    date.text= [NSString stringWithFormat:@"%@",   [[LendeeProductArray valueForKey:@"total_unavailable_dates"]objectAtIndex:indexPath.row]];
    
    UILabel *location=(UILabel *)[cell.contentView viewWithTag:6006];
    location.text= [NSString stringWithFormat:@"%@",[[LendeeProductArray valueForKey:@"location"]objectAtIndex:indexPath.row]];
    
    
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LendeeProductDetailViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"LendeeProductDetailViewController"];
    
    homeObj.LendeeProductID = [[LendeeProductArray valueForKey:@"id"]objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:homeObj animated:YES];



}

//-(void)DeleteBtnPressed:(id)sender
//{
//    
//    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:lendeeProductTableView];
//    NSIndexPath *indexPath = [lendeeProductTableView indexPathForRowAtPoint:buttonPosition];
//    McomLOG(@"like-indexPath--%ld",(long)indexPath.row);
//    
//    lendeeProductID = [NSString stringWithFormat:@"%@",[[LendeeProductArray valueForKey:@"id"]objectAtIndex:indexPath.row]];
//    [self callLendeeDeleteProductAPI];
//    
//    
//}





#pragma  Lendeer Home Feed List API
-(void)callLendeeProductListAPI
{
    
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"]
                                   };
    
    McomLOG(@"%@",registerInfo);
    [API LendeeProductListingWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
     {
         
         [Appdelegate stopLoader:nil];
         NSDictionary *dict_response = [[NSDictionary alloc]initWithDictionary:responseDict];
         NSLog(@"%@",dict_response);
         
         if ([responseDict[@"result"]boolValue]==0)
         {
             if ([[responseDict valueForKey:@"message"]isEqualToString:@"Access token incorrect."])
             {
                 [Utility showAlertWithTitleText:@"Sorry This user is already logged in from other device!" messageText:nil delegate:nil];
                 UIViewController *popUpController = ViewControllerIdentifier(@"LoginScreennavigateID");
                 [self.view.window setRootViewController:popUpController];
                 
             }
         }
         
         else if ([responseDict[@"result"]boolValue]==1)
         {
             NSLog(@"Home Feed List  = %@",responseDict);
             
             NSLog(@"%@", responseDict);
             
             LendeeProductArray =[[NSMutableArray alloc]initWithArray:responseDict[@"products"]];
             NSLog(@"tabel list Data%@", LendeeProductArray);
             
             NSLog(@"%lu",(unsigned long)LendeeProductArray.count);
             

             if (LendeeProductArray.count>0)
             {
                 NoProductAddedLabel.hidden = YES;
                                  
             }
             
             else
             {
                 NoProductAddedLabel.hidden = NO;
             }
             
             [lendeeProductTableView reloadData];
             
         }
     }];
}





#pragma  Lendeer Home Feed List API
-(void)callLendeeDeleteProductAPI
{
    
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"],
                                   @"product_id":lendeeProductID
                                   };
    
    McomLOG(@"%@",registerInfo);
    [API LendeeDeleteProductWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
     {
         
         [Appdelegate stopLoader:nil];
         NSDictionary *dict_response = [[NSDictionary alloc]initWithDictionary:responseDict];
         NSLog(@"%@",dict_response);
         
         if ([responseDict[@"result"]boolValue]==0)
         {
             [Utility showAlertWithTitleText:[responseDict valueForKey:@"message"]    messageText:nil delegate:nil];
         }
         
         else if ([responseDict[@"result"]boolValue]==1)
         {
             NSLog(@"Home Feed List  = %@",responseDict);
             [self callLendeeProductListAPI];
         }
     }];
}



#pragma  CALL MY PROFILE API FOR LENDER

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
                 MyPayPalID  = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"]valueForKey:@"paypal_id"]];
             }
         }
     }];
}



@end
