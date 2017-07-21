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
    
   
    
    // Do any additional setup after loading the view.
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
    Productname.text= [NSString stringWithFormat:@"Your  %@ is booked",   [[DashBoardArray valueForKey:@"product_name"]objectAtIndex:indexPath.row]];
    
    UILabel *StartDate=(UILabel *)[cell.contentView viewWithTag:10001000101];
    StartDate.text= @"for 5 days";//[NSString stringWithFormat:@"From %@",   [[DashBoardArray valueForKey:@"start_date"]objectAtIndex:indexPath.row]];
    
    UILabel *endDate=(UILabel *)[cell.contentView viewWithTag:10001000104];
    endDate.text= [NSString stringWithFormat:@"To %@",   [[DashBoardArray valueForKey:@"end_date"]objectAtIndex:indexPath.row]];
    
    UILabel *name=(UILabel *)[cell.contentView viewWithTag:10001000102];
    name.text= [NSString stringWithFormat:@"%@",[[DashBoardArray valueForKey:@"first_name"]objectAtIndex:indexPath.row]];
    
    UIImageView *ImageMy = (UIImageView *)[cell.contentView viewWithTag:10001000103];
    ImageMy.layer.cornerRadius = ImageMy.frame.size.width/2;
    ImageMy.clipsToBounds= YES;
    [ImageMy sd_setImageWithURL:[NSURL URLWithString: [[DashBoardArray valueForKey:@"product_image"] objectAtIndex:indexPath.row] ]placeholderImage:[UIImage imageNamed:@"1"] options:SDWebImageRefreshCached];
    

    return  cell;
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
    
    homeObj.startDateStrig = [[DashBoardArray valueForKey:@"start_date"]objectAtIndex:indexPath.row];
    
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
             
               noDashBoardLabel.hidden = NO;
             
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
             DashBoardArray =[[NSMutableArray alloc]initWithArray:responseDict[@"data"]];
             
             
             [dashBoardTableVIew reloadData];
             
             NSLog(@"Dashboard list Data%@",DashBoardArray);
         }
     }];
}




@end
