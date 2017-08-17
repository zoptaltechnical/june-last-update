//
//  LenderHistoryViewController.m
//  Steezz
//
//  Created by Apple on 31/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "LenderHistoryViewController.h"

@interface LenderHistoryViewController ()
{
    BOOL _myBool;
    NSMutableArray *histroyListingArray;
    NSMutableArray *myOrderArray;
    NSDictionary *dict;
    
    
    NSString *ownerUserName;
    NSString *GetUserId;
}

@end

@implementation LenderHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     _myBool = YES;
    
    dict=  [[NSUserDefaults standardUserDefaults]objectForKey:@"loginData"];
    NSLog(@"%@ login data = ",dict);
    
    
    [self callHistoryDetailAPI];
  
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    //
    UIImage *colorimage = [UIImage imageNamed:@"active"];
    [historyBtn setBackgroundImage:colorimage forState:UIControlStateNormal];
    
    
    UIImage *colorimage1 = [UIImage imageNamed:@"disable"];
    [myOrderBtn setBackgroundImage:colorimage1 forState:UIControlStateNormal];
    
    
      historylabel.hidden = YES;
}

- (IBAction)myOrderBtnAction:(id)sender {
    
    _myBool = NO;
    historylabel.hidden = YES;    
     historyBtn.titleLabel.textColor = [UIColor whiteColor];
    
    UIImage *colorimage = [UIImage imageNamed:@"disable"];
    [historyBtn setBackgroundImage:colorimage forState:UIControlStateNormal];
   
    
    
    UIImage *colorimage1 = [UIImage imageNamed:@"active"];
    [myOrderBtn setBackgroundImage:colorimage1 forState:UIControlStateNormal];
    
 
    [self callMyOrderDetailAPI];
    
    
}

- (IBAction)historyBtnAction:(id)sender {
    
     _myBool = YES;
     historylabel.hidden = YES;
    
    
    UIImage *colorimage = [UIImage imageNamed:@"active"];
    [historyBtn setBackgroundImage:colorimage forState:UIControlStateNormal];
    
    
    UIImage *colorimage1 = [UIImage imageNamed:@"disable"];
    [myOrderBtn setBackgroundImage:colorimage1 forState:UIControlStateNormal];
    
     [self callHistoryDetailAPI];
    
}

- (IBAction)historyBackBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    if (_myBool ==YES)
    {
        return histroyListingArray.count;
    }
    
    else if (_myBool ==NO)
    {
        return myOrderArray.count;
    }
    
    return YES;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"LenderHistoryCell"];
    UITableViewCell *cell1=[tableView dequeueReusableCellWithIdentifier:@"MyOrders"];
    
    if (_myBool ==YES) {
    
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LenderHistoryCell"];
    }
    
    
    UILabel *ProductName=(UILabel *)[cell.contentView viewWithTag:4511001];
    ProductName.text= [NSString stringWithFormat:@"%@",[[histroyListingArray valueForKey:@"product_name"]objectAtIndex:indexPath.row]];
    
    UILabel *Price=(UILabel *)[cell.contentView viewWithTag:4511002];
    Price.text= [NSString stringWithFormat:@"$%@",[[histroyListingArray valueForKey:@"paid_amount"]objectAtIndex:indexPath.row]];
    
    UILabel *description=(UILabel *)[cell.contentView viewWithTag:4511003];
    description.text= [NSString stringWithFormat:@"%@",[[histroyListingArray valueForKey:@"product_desc"]objectAtIndex:indexPath.row]];
    
    UIImageView *ImageMy = (UIImageView *)[cell.contentView viewWithTag:4511004];
    
    [ImageMy sd_setImageWithURL:[NSURL URLWithString: [[histroyListingArray valueForKey:@"product_image"] objectAtIndex:indexPath.row] ]placeholderImage:[UIImage imageNamed:@"2"] options:SDWebImageRefreshCached];
    
    
    UILabel *StartDate=(UILabel *)[cell.contentView viewWithTag:4511005];
    StartDate.text= [NSString stringWithFormat:@"%@",[[histroyListingArray valueForKey:@"start_date"]objectAtIndex:indexPath.row]];
    
    UILabel *EndDate=(UILabel *)[cell.contentView viewWithTag:4511006];
    EndDate.text= [NSString stringWithFormat:@"%@",[[histroyListingArray valueForKey:@"end_date"]objectAtIndex:indexPath.row]];

    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return  cell;
        
    }
    
    else if (_myBool == NO)
    {
        UILabel *ProductName=(UILabel *)[cell1.contentView viewWithTag:45711001];
        ProductName.text= [NSString stringWithFormat:@"%@",[[myOrderArray valueForKey:@"product_name"]objectAtIndex:indexPath.row]];
        
        UILabel *Price=(UILabel *)[cell1.contentView viewWithTag:45711002];
        Price.text= [NSString stringWithFormat:@"$%@",[[myOrderArray valueForKey:@"price"]objectAtIndex:indexPath.row]];
        
        UILabel *description=(UILabel *)[cell1.contentView viewWithTag:45711003];
        description.text= [NSString stringWithFormat:@"%@",[[myOrderArray valueForKey:@"product_desc"]objectAtIndex:indexPath.row]];
        
        UIImageView *ImageMy = (UIImageView *)[cell1.contentView viewWithTag:45711004];
        
        [ImageMy sd_setImageWithURL:[NSURL URLWithString: [[myOrderArray valueForKey:@"product_image"] objectAtIndex:indexPath.row] ]placeholderImage:[UIImage imageNamed:@"2"] options:SDWebImageRefreshCached];
        
        
        UILabel *StartDate=(UILabel *)[cell1.contentView viewWithTag:45711005];
        StartDate.text= [NSString stringWithFormat:@"%@",[[myOrderArray valueForKey:@"start_date"]objectAtIndex:indexPath.row]];
        
        UILabel *EndDate=(UILabel *)[cell1.contentView viewWithTag:45711006];
        EndDate.text= [NSString stringWithFormat:@"%@",[[myOrderArray valueForKey:@"end_date"]objectAtIndex:indexPath.row]];
        
        
        
        UIButton *MessageBtn =(UIButton *)[cell1.contentView viewWithTag:457110012];
        [MessageBtn addTarget:self
                       action:@selector(messageBtnPressed:)
             forControlEvents:UIControlEventTouchUpInside];
        
        
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
        return  cell1;
 
        
        
        
        
    }
    
    return cell;
    return cell1;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_myBool ==YES) {
  
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        PaymentDetailViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"PaymentDetailViewController"];
        homeObj.Status = [[histroyListingArray valueForKey:@"status"]objectAtIndex:indexPath.row];
        homeObj.TotalAmountString = [[histroyListingArray valueForKey:@"total_amount"]objectAtIndex:indexPath.row];
        homeObj.AmountPaidString = [[histroyListingArray valueForKey:@"receiver_amount"]objectAtIndex:indexPath.row];
        homeObj.AdminChargesString = [[histroyListingArray valueForKey:@"admin_charges"]objectAtIndex:indexPath.row];
        homeObj.PaypalIdString = [[histroyListingArray valueForKey:@"transaction_id"]objectAtIndex:indexPath.row];
        homeObj.startDateStrig = [[histroyListingArray valueForKey:@"booking_dates_count"]objectAtIndex:indexPath.row];
        homeObj.EndDateStrings = [[histroyListingArray valueForKey:@"end_date"]objectAtIndex:indexPath.row];
        homeObj.ProductNAmeString = [[histroyListingArray valueForKey:@"product_name"]objectAtIndex:indexPath.row];
        homeObj.Status = [[histroyListingArray valueForKey:@"status"]objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:homeObj animated:YES];
        
    }
    
    else if (_myBool ==NO)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        PaymentDetailViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"PaymentDetailViewController"];
        homeObj.Status = [[myOrderArray valueForKey:@"status"]objectAtIndex:indexPath.row];
        homeObj.TotalAmountString = [[myOrderArray valueForKey:@"total_amount"]objectAtIndex:indexPath.row];
        homeObj.AmountPaidString = [[myOrderArray valueForKey:@"receiver_amount"]objectAtIndex:indexPath.row];
        homeObj.AdminChargesString = [[myOrderArray valueForKey:@"admin_charges"]objectAtIndex:indexPath.row];
        homeObj.PaypalIdString = [[myOrderArray valueForKey:@"transaction_id"]objectAtIndex:indexPath.row];
        
        homeObj.startDateStrig = [[myOrderArray valueForKey:@"booking_dates_count"]objectAtIndex:indexPath.row];
        
        homeObj.EndDateStrings = [[myOrderArray valueForKey:@"end_date"]objectAtIndex:indexPath.row];
        
        homeObj.ProductNAmeString = [[myOrderArray valueForKey:@"product_name"]objectAtIndex:indexPath.row];
        homeObj.Status = [[myOrderArray valueForKey:@"status"]objectAtIndex:indexPath.row];
        
        [self.navigationController pushViewController:homeObj animated:YES];
        
    }
    
}

-(void)messageBtnPressed:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:historytableView];
    NSIndexPath *indexPath = [historytableView indexPathForRowAtPoint:buttonPosition];
    McomLOG(@"like-indexPath--%ld",(long)indexPath.row);
    NSString *reciverString = [NSString stringWithFormat:@"%@",[[myOrderArray valueForKey:@"id"]objectAtIndex:indexPath.row]];
    
    GetUserId = [NSString stringWithFormat:@"%@",[[myOrderArray valueForKey:@"owner_user_id"]objectAtIndex:indexPath.row]];
    ownerUserName = [NSString stringWithFormat:@"%@",[[myOrderArray valueForKey:@"owner_first_name"]objectAtIndex:indexPath.row]];
    
    NSLog(@" reciverString = %@",reciverString);
    
    [self callGetConversationIDAPI];
    
    
    
}




#pragma  Hoster Email List API
-(void)callHistoryDetailAPI
{
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"]
                                   };
    
    McomLOG(@"%@",registerInfo);
    [API BookingHistoryWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
     {
         
         [Appdelegate stopLoader:nil];
         NSDictionary *dict_response = [[NSDictionary alloc]initWithDictionary:responseDict];
         NSLog(@"%@",dict_response);
         
         if ([responseDict[@"response"]boolValue]==0)
         {
             //[Utility showAlertWithTitleText:[responseDict valueForKey:@"message"] messageText:nil delegate:nil];
             
               historylabel.hidden = NO;
         }

         else if ([responseDict[@"response"]boolValue]==1)
         {
             _myBool =YES;
             
             NSLog(@"category List  = %@",responseDict);
             
             if ([responseDict[@"data"] count]>0)
             {
                 histroyListingArray =[[NSMutableArray alloc]initWithArray:[responseDict valueForKey:@"data"]];
                 NSLog(@"categories List = %@", histroyListingArray);
                 [historytableView reloadData];
             }
             

         }
     }];
}



#pragma  Hoster Email List API
-(void)callMyOrderDetailAPI
{
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"]
                                   };
    
    McomLOG(@"%@",registerInfo);
    [API MyOrderWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
     {
         
         [Appdelegate stopLoader:nil];
         NSDictionary *dict_response = [[NSDictionary alloc]initWithDictionary:responseDict];
         NSLog(@"%@",dict_response);
         
         if ([responseDict[@"response"]boolValue]==0)
         {
             //[Utility showAlertWithTitleText:[responseDict valueForKey:@"message"] messageText:nil delegate:nil];
             [historytableView reloadData];
             historyBtn.titleLabel.textColor = [UIColor darkGrayColor];

             historylabel.hidden = NO;
         }
         
         else if ([responseDict[@"response"]boolValue]==1)
         {
             _myBool = NO;
             NSLog(@"My Current Oder  List  = %@",responseDict);
             historyBtn.titleLabel.textColor = [UIColor darkGrayColor];

             
             if ([responseDict[@"data"] count]>0)
             {
                 myOrderArray =[[NSMutableArray alloc]initWithArray:[responseDict valueForKey:@"data"]];
                 NSLog(@"categories List = %@", myOrderArray);
                 [historytableView reloadData];
             }
             
             
         }
     }];
}



-(void)callGetConversationIDAPI
{
    
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSDictionary* registerInfo;
    
    
    registerInfo= @{
                    @"access_token":[dict valueForKey:@"access_token"],
                    @"receiver_id":GetUserId
                    };
    McomLOG(@"%@",registerInfo);
    [API GetConversationIDWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
     {
         [Appdelegate stopLoader:nil];
         NSDictionary *dict_response = [[NSDictionary alloc]initWithDictionary:responseDict];
         
         if ([responseDict[@"result"]boolValue]==0)
         {
             NSString * errormessage = [NSString stringWithFormat:@"%@",[dict_response valueForKey:@"message"]];
             
             [Utility showAlertWithTitleText:errormessage messageText:nil delegate:nil];
         }
         else if ([responseDict[@"result"]boolValue]==1)
         {
             NSLog(@"sign_up responce Data%@", responseDict);
             
             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
             chatViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"chatViewController"];
             homeObj.reciverID_string =[NSString stringWithFormat:@"%@",GetUserId] ;
             homeObj.ConversationID_string = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"]valueForKey:@"conversation_id"]];
             
             homeObj.ReciverName_string = [NSString stringWithFormat:@"%@",ownerUserName];
             
             [self.navigationController pushViewController:homeObj animated:YES];
             
             
             
         }
     }];
}



@end
