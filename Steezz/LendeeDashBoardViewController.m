//
//  LendeeDashBoardViewController.m
//  Steezz
//
//  Created by Apple on 10/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "LendeeDashBoardViewController.h"

@interface LendeeDashBoardViewController ()
{
    NSDictionary *dict;
    NSMutableArray *array;
    NSMutableArray *imagesArray;
    
    NSString *categoryType;
    NSString *GetUserId;
    NSString *ownerUserName;
    
    
    NSMutableArray *DashBoardArray;
    
}

@end

@implementation LendeeDashBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dict=  [[NSUserDefaults standardUserDefaults]objectForKey:@"loginData"];
    NSLog(@"%@ login data = ",dict);
    
   // array = [[NSMutableArray alloc] initWithObjects:@"Today",
     //                        @"26,may,2017",
      //                       nil];
    
    imagesArray = [[NSMutableArray alloc] initWithObjects:@"date_icon-2",
             @"date_icon-1",
             nil];
    
   
    [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(reloadTable) userInfo:nil repeats:YES];
    
    // Do any additional setup after loading the view.
}


-(void) reloadTable
{
     [self MycallDashBoardAPI];
    
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    noDashBoardLabel.hidden = YES;
     [self callDashBoardAPI];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
//    if (section==0)
//    {
//        return 5;
//    }
//    else{
        return DashBoardArray.count;
   // }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DashBoardCell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DashBoardCell"];
    }
    
    UILabel *Productname=(UILabel *)[cell.contentView viewWithTag:10001000100];
    Productname.text= [NSString stringWithFormat:@"%@",   [[DashBoardArray valueForKey:@"msg_string"]objectAtIndex:indexPath.row]];
    
//    categoryType = [NSString stringWithFormat:@"%@",   [[DashBoardArray valueForKey:@"product_name"]objectAtIndex:indexPath.row]];
//    NSLog(@"%@",categoryType);
//    
//    if ([categoryType isEqualToString:@"Rock Climb"])
//    {
//         //categoryType = [NSString stringWithFormat:@"Your  %@ gear is booked",   [[DashBoardArray valueForKey:@"product_name"]objectAtIndex:indexPath.row]];
//        Productname.text = [NSString stringWithFormat:@"Your %@ing gear is booked",categoryType] ;
//
//        
//    }
//    
// else if ([categoryType isEqualToString:@" Bicycles"])
//    {
//        categoryType = [categoryType substringToIndex:[categoryType length] - 1];
//        Productname.text = [NSString stringWithFormat:@"Your %@ is booked",categoryType] ;
//        
//    }
//    
//    else
//        
//    {
//        categoryType = [categoryType substringToIndex:[categoryType length] - 1];
//        
//        Productname.text = [NSString stringWithFormat:@"Your %@ing gear is booked",categoryType] ;
//    }
    
    
    
    UILabel *StartDate=(UILabel *)[cell.contentView viewWithTag:10001000101];
    StartDate.text=[NSString stringWithFormat:@"For %@ Days",   [[DashBoardArray valueForKey:@"booking_dates_count"]objectAtIndex:indexPath.row]];
    
    UILabel *endDate=(UILabel *)[cell.contentView viewWithTag:10001000104];
    endDate.text= [NSString stringWithFormat:@"To %@",   [[DashBoardArray valueForKey:@"end_date"]objectAtIndex:indexPath.row]];
    
    UILabel *name=(UILabel *)[cell.contentView viewWithTag:10001000102];
    name.text= [NSString stringWithFormat:@"%@",[[DashBoardArray valueForKey:@"first_name"]objectAtIndex:indexPath.row]];
    
    UIImageView *ImageMy = (UIImageView *)[cell.contentView viewWithTag:10001000103];
    ImageMy.layer.cornerRadius = ImageMy.frame.size.width/2;
    ImageMy.clipsToBounds= YES;
    [ImageMy sd_setImageWithURL:[NSURL URLWithString: [[DashBoardArray valueForKey:@"product_image"] objectAtIndex:indexPath.row] ]placeholderImage:[UIImage imageNamed:@"1"] options:SDWebImageRefreshCached];
    
    UIButton *MessageBtn =(UIButton *)[cell.contentView viewWithTag:10001000109];
    [MessageBtn addTarget:self
                   action:@selector(dashBoarsmessageBtnPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
 
    

    return  cell;
}





-(void)dashBoarsmessageBtnPressed:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:dashBoardTableVIew];
    NSIndexPath *indexPath = [dashBoardTableVIew indexPathForRowAtPoint:buttonPosition];
    McomLOG(@"like-indexPath--%ld",(long)indexPath.row);
    NSString *reciverString = [NSString stringWithFormat:@"%@",[[DashBoardArray valueForKey:@"id"]objectAtIndex:indexPath.row]];
    
    GetUserId = [NSString stringWithFormat:@"%@",[[DashBoardArray valueForKey:@"user_id"]objectAtIndex:indexPath.row]];
    ownerUserName = [NSString stringWithFormat:@"%@",[[DashBoardArray valueForKey:@"first_name"]objectAtIndex:indexPath.row]];
    
    NSLog(@" reciverString = %@",reciverString);
    
    [self callGetConversationIDAPI];
    
    
    
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




//-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 45;
//}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return [array objectAtIndex:section];
//}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,0,300,44)];
   
    
    tempView.backgroundColor = [UIColor clearColor];
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(45,10,300,44)];
    tempLabel.backgroundColor=[UIColor clearColor];
//    tempLabel.shadowColor = [UIColor blackColor];
//    tempLabel.shadowOffset = CGSizeMake(0,2);
     //here you can change the text color of header.
    tempLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    tempLabel.font = [UIFont boldSystemFontOfSize:12];
    tempLabel.text=[array objectAtIndex:section];
    
    [tempView addSubview:tempLabel];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[imagesArray objectAtIndex:section]]];
    imageView.frame = CGRectMake(20,23,18,18);
    
     [tempView addSubview:imageView];
    if (section ==0) {
        
        tempLabel.textColor = [UIColor redColor];
    }
    else
    {
        tempLabel.textColor = [UIColor lightGrayColor];
    }
    
    return tempView;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    PaymentDetailViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"PaymentDetailViewController"];
    homeObj.Status = [[DashBoardArray valueForKey:@"status"]objectAtIndex:indexPath.row];
    homeObj.TotalAmountString = [[DashBoardArray valueForKey:@"total_amount"]objectAtIndex:indexPath.row];
    homeObj.AmountPaidString = [[DashBoardArray valueForKey:@"amount"]objectAtIndex:indexPath.row];
    homeObj.AdminChargesString = [[DashBoardArray valueForKey:@"admin_charges"]objectAtIndex:indexPath.row];
    homeObj.PaypalIdString = [[DashBoardArray valueForKey:@"paypal_id"]objectAtIndex:indexPath.row];
    
    homeObj.startDateStrig = [[DashBoardArray valueForKey:@"booking_dates_count"]objectAtIndex:indexPath.row];
    
    homeObj.EndDateStrings = [[DashBoardArray valueForKey:@"end_date"]objectAtIndex:indexPath.row];
    
    homeObj.ProductNAmeString = [[DashBoardArray valueForKey:@"product_name"]objectAtIndex:indexPath.row];
    homeObj.Status = [[DashBoardArray valueForKey:@"status"]objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:homeObj animated:YES];
}


-(void)callDashBoardAPI
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
         
         if ([responseDict[@"result"]boolValue]==0)
         {

             if ([[responseDict valueForKey:@"message"]isEqualToString:@"Access token incorrect."])
             {
                 [Utility showAlertWithTitleText:@"Sorry This user is already logged in from other device!" messageText:nil delegate:nil];
                 UIViewController *popUpController = ViewControllerIdentifier(@"LoginScreennavigateID");
                 [self.view.window setRootViewController:popUpController];
                 
             }
             else
             {
                noDashBoardLabel.hidden = NO;
             }
             
         }
         else if ([responseDict[@"result"]boolValue]==1)
         {
             NSLog(@"sign_up%@", responseDict);
             DashBoardArray =[[NSMutableArray alloc]initWithArray:responseDict[@"data"]];
             [dashBoardTableVIew reloadData];
             
             NSLog(@"Dashboard list Data%@",DashBoardArray);
         }
     }];
}





-(void)MycallDashBoardAPI
{
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"],
                                   };
    
   
    [API paymentListingWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
     {
         [Appdelegate stopLoader:nil];
       //  NSDictionary *dict_response = [[NSDictionary alloc]initWithDictionary:responseDict];
         
         if ([responseDict[@"result"]boolValue]==0)
         {
             
             if ([[responseDict valueForKey:@"message"]isEqualToString:@"Access token incorrect."])
             {
                 [Utility showAlertWithTitleText:@"Sorry This user is already logged in from other device!" messageText:nil delegate:nil];
                 UIViewController *popUpController = ViewControllerIdentifier(@"LoginScreennavigateID");
                 [self.view.window setRootViewController:popUpController];
                 
             }
             else
             {
                 noDashBoardLabel.hidden = NO;
             }
             
         }
         else if ([responseDict[@"result"]boolValue]==1)
         {
             NSLog(@"sign_up%@", responseDict);
             DashBoardArray =[[NSMutableArray alloc]initWithArray:responseDict[@"data"]];
             [dashBoardTableVIew reloadData];
             
             NSLog(@"Dashboard list Data%@",DashBoardArray);
         }
     }];
}


@end
