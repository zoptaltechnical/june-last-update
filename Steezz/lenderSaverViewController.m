//
//  lenderSaverViewController.m
//  Steezz
//
//  Created by Apple on 08/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "lenderSaverViewController.h"

@interface lenderSaverViewController ()
{
    NSString *GetUserId;
    NSString *ownerNameString;

    NSString *ProductId;
    NSString * dateString;
    NSDictionary *dict;
    NSMutableArray *savedProductArray;
    
}

@end

@implementation lenderSaverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    dict=  [[NSUserDefaults standardUserDefaults]objectForKey:@"loginData"];
    NSLog(@"%@ login data = ",dict);
    
    noProductSavedLabel.hidden = YES;
    [self callSavedProductAPI];
    
    
}

- (IBAction)savedSettingBtnPressed:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LenderSettingsViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"LenderSettingsViewController"];
    [self.navigationController pushViewController:homeObj animated:YES];
    
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return savedProductArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"LenderSavedCell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LenderSavedCell"];
    }
    
    
    UILabel *ProductName=(UILabel *)[cell.contentView viewWithTag:2000];
    ProductName.text= [NSString stringWithFormat:@"%@",[[savedProductArray valueForKey:@"product_name"]objectAtIndex:indexPath.row]];

    UILabel *Price=(UILabel *)[cell.contentView viewWithTag:2001];
    Price.text= [NSString stringWithFormat:@"%@",[[savedProductArray valueForKey:@"product_price"]objectAtIndex:indexPath.row]];
    
    UILabel *description=(UILabel *)[cell.contentView viewWithTag:2002];
    description.text= [NSString stringWithFormat:@"%@ %%",[[savedProductArray valueForKey:@"product_desc"]objectAtIndex:indexPath.row]];
    
    UIImageView *ImageMy = (UIImageView *)[cell.contentView viewWithTag:2003];
    
    [ImageMy sd_setImageWithURL:[NSURL URLWithString: [[savedProductArray valueForKey:@"product_image"] objectAtIndex:indexPath.row] ]placeholderImage:[UIImage imageNamed:@"1"] options:SDWebImageRefreshCached];
    
    UIButton *BookNowBtn =(UIButton *)[cell.contentView viewWithTag:2004];
    [BookNowBtn addTarget:self
                action:@selector(BookNowBtnPressed:)
                forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *SaveBtn =(UIButton *)[cell.contentView viewWithTag:2005];
    [SaveBtn addTarget:self
             action:@selector(SavevBtnPressed:)
             forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *MessageBtn =(UIButton *)[cell.contentView viewWithTag:2006];
    [MessageBtn addTarget:self
                action:@selector(MessageBtnPressed:)
      forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return  cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LenderProductDetailViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"LenderProductDetailViewController"];
    homeObj.ProductDetail = [[savedProductArray valueForKey:@"id"]objectAtIndex:indexPath.row];
    
   // homeObj.PricePerDay = [[savedProductArray valueForKey:@"price"]objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:homeObj animated:YES];
    
    
    
}



-(void)BookNowBtnPressed:(id)sender
{
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:savedProductTableView];
    NSIndexPath *indexPath = [savedProductTableView indexPathForRowAtPoint:buttonPosition];
    McomLOG(@"like-indexPath--%ld",(long)indexPath.row);
    
    ProductId = [NSString stringWithFormat:@"%@",[[savedProductArray valueForKey:@"id"]objectAtIndex:indexPath.row]];
    
    dateString = [NSString stringWithFormat:@"%@",[[savedProductArray valueForKey:@"available_date"]objectAtIndex:indexPath.row]];
    
      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    BookNowViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"BookNowViewController"];
    
    homeObj.ProdctID = ProductId;
    homeObj.availabelDate = dateString;
    homeObj.PerDayAmount = [NSString stringWithFormat:@"%@",[[savedProductArray valueForKey:@"price"]objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:homeObj animated:YES];
    

    
    
}



-(void)SavevBtnPressed:(id)sender
{
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:savedProductTableView];
    NSIndexPath *indexPath = [savedProductTableView indexPathForRowAtPoint:buttonPosition];
    McomLOG(@"like-indexPath--%ld",(long)indexPath.row);
    
     ProductId = [NSString stringWithFormat:@"%@",[[savedProductArray valueForKey:@"id"]objectAtIndex:indexPath.row]];
    
    
     [self callSaveProductAPI];
    
    
}



-(void)MessageBtnPressed:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:savedProductTableView];
    NSIndexPath *indexPath = [savedProductTableView indexPathForRowAtPoint:buttonPosition];
    McomLOG(@"like-indexPath--%ld",(long)indexPath.row);
    NSString *reciverString = [NSString stringWithFormat:@"%@",[[savedProductArray valueForKey:@"id"]objectAtIndex:indexPath.row]];
    
    GetUserId = [NSString stringWithFormat:@"%@",[[savedProductArray valueForKey:@"user_id"]objectAtIndex:indexPath.row]];

    ownerNameString = [NSString stringWithFormat:@"%@",[[savedProductArray valueForKey:@"first_name"]objectAtIndex:indexPath.row]];
    NSLog(@" reciverString = %@",reciverString);
    
    [self callGetConversationIDAPI];
    
    
}


#pragma Product call Save Product  API -> which we have to  USe to show saved Product
-(void)callSavedProductAPI
{
    
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"],
                                   };
    
    McomLOG(@"%@",registerInfo);
    [API LenderSavedProductWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
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
             NSLog(@"saved product = %@",responseDict);
 
             savedProductArray =[[NSMutableArray alloc]initWithArray:responseDict[@"data"]];
             NSLog(@"tabel list Data%@", savedProductArray);
             
             if (savedProductArray.count ==0)
             {
                 noProductSavedLabel.hidden = NO;

             }
             
             [savedProductTableView reloadData];

             
         }
     }];
}



#pragma Product call Save Product  API " which we have to save"
-(void)callSaveProductAPI
{
    
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"],
                                   @"product_id":ProductId
                                   };
    
    McomLOG(@"%@",registerInfo);
    [API SaveProductWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
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
             NSLog(@"save product = %@",responseDict);
             
             
             [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                            message:[responseDict valueForKey:@"message"]
                                    leftActionTitle:@"OK"
                                   rightActionTitle:@""
                                     animationStyle:AlertViewAnimationZoom
                                       selectAction:^(AlertViewActionType actionType) {
                                           NSLog(@"%zd", actionType);
                                       }];
             
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
             homeObj.ReciverName_string = [NSString stringWithFormat:@"%@",ownerNameString];
             homeObj.ConversationID_string = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"data"]valueForKey:@"conversation_id"]];
             [self.navigationController pushViewController:homeObj animated:YES];
             
         }
     }];
}



@end
