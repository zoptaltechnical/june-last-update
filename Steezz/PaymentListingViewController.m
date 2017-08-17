//
//  PaymentListingViewController.m
//  Steezz
//
//  Created by Apple on 10/07/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "PaymentListingViewController.h"

@interface PaymentListingViewController ()
{NSString *categoryType;
    NSDictionary *dict;
    NSMutableArray *paymentListingArray;
}

@end

@implementation PaymentListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dict=  [[NSUserDefaults standardUserDefaults]objectForKey:@"loginData"];
     [self callPaymentListingAPI];
   
}

- (IBAction)listingBckBtnPressed:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
 
    return paymentListingArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PaymentListingCell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PaymentListingCell"];
    }
    
    UILabel *Productname=(UILabel *)[cell.contentView viewWithTag:70001000100];
    
    Productname.text = [NSString stringWithFormat:@"%@", [[paymentListingArray valueForKey:@"msg_string"]objectAtIndex:indexPath.row]];
    
    UILabel *StartDate=(UILabel *)[cell.contentView viewWithTag:70001000101];
    StartDate.text= [NSString stringWithFormat:@"From %@",[[paymentListingArray valueForKey:@"start_date"]objectAtIndex:indexPath.row]];
    
    UILabel *endDate=(UILabel *)[cell.contentView viewWithTag:70001000104];
    endDate.text= [NSString stringWithFormat:@"To %@",   [[paymentListingArray valueForKey:@"end_date"]objectAtIndex:indexPath.row]];
    
    UILabel *AmountPaid=(UILabel *)[cell.contentView viewWithTag:70001000108];
    AmountPaid.text= [NSString stringWithFormat:@"$ %@",   [[paymentListingArray valueForKey:@"amount"]objectAtIndex:indexPath.row]];
    
    UILabel *name=(UILabel *)[cell.contentView viewWithTag:70001000102];
    name.text= [NSString stringWithFormat:@"%@",[[paymentListingArray valueForKey:@"first_name"]objectAtIndex:indexPath.row]];
    
    UIImageView *ImageMy = (UIImageView *)[cell.contentView viewWithTag:70001000103];
    ImageMy.layer.cornerRadius = ImageMy.frame.size.width/2;
    ImageMy.clipsToBounds= YES;
    [ImageMy sd_setImageWithURL:[NSURL URLWithString: [[paymentListingArray valueForKey:@"profile_pic"] objectAtIndex:indexPath.row] ]placeholderImage:[UIImage imageNamed:@"1"] options:SDWebImageRefreshCached];
    
    
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    PaymentDetailViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"PaymentDetailViewController"];
    homeObj.Status = [[paymentListingArray valueForKey:@"status"]objectAtIndex:indexPath.row];
    homeObj.TotalAmountString = [[paymentListingArray valueForKey:@"total_amount"]objectAtIndex:indexPath.row];
    homeObj.AmountPaidString = [[paymentListingArray valueForKey:@"amount"]objectAtIndex:indexPath.row];
    homeObj.AdminChargesString = [[paymentListingArray valueForKey:@"admin_charges"]objectAtIndex:indexPath.row];
    homeObj.PaypalIdString = [[paymentListingArray valueForKey:@"paypal_id"]objectAtIndex:indexPath.row];
    
    homeObj.startDateStrig = [[paymentListingArray valueForKey:@"booking_dates_count"]objectAtIndex:indexPath.row];
    
    homeObj.EndDateStrings = [[paymentListingArray valueForKey:@"end_date"]objectAtIndex:indexPath.row];
    
    homeObj.ProductNAmeString = [[paymentListingArray valueForKey:@"product_name"]objectAtIndex:indexPath.row];
    homeObj.Status = [[paymentListingArray valueForKey:@"status"]objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:homeObj animated:YES];


}


-(void)callPaymentListingAPI
{
    
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"],
                                   };
    
    McomLOG(@"%@",registerInfo);
    [API paymentListingWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
     {
         [Appdelegate stopLoader:nil];
         NSDictionary *dict_response = [[NSDictionary alloc]initWithDictionary:responseDict];
         NSLog(@"%@",dict_response);
         if ([responseDict[@"result"]boolValue]==0)
         {
             
             
            // paymentlistLabel.hidden = NO;
             
                        
             //             NSString * errormessage = [NSString stringWithFormat:@"%@",[dict_response valueForKey:@"message"]];
             //             [SRAlertView sr_showAlertViewWithTitle:@"Alert"
             //                                            message:errormessage
             //                                    leftActionTitle:@"OK"
             //                                   rightActionTitle:@""
             //                                     animationStyle:AlertViewAnimationRightToCenterSpring
             //                                       selectAction:^(AlertViewActionType actionType) {
             //                                           NSLog(@"%zd", actionType);
             //                                       }];
         }
         else if ([responseDict[@"result"]boolValue]==1)
         {
             NSLog(@"sign_up%@", responseDict);
             paymentListingArray =[[NSMutableArray alloc]initWithArray:responseDict[@"data"]];
             
             
             [paymentListingTbleView reloadData];
             
             NSLog(@"Dashboard list Data%@",paymentListingArray);
         }
     }];
}



@end
