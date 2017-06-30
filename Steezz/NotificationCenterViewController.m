//
//  NotificationCenterViewController.m
//  Steezz
//
//  Created by Apple on 13/06/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "NotificationCenterViewController.h"

@interface NotificationCenterViewController ()
{
    NSMutableArray *notificationsArray;
    NSDictionary *dict;
}

@end

@implementation NotificationCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dict=  [[NSUserDefaults standardUserDefaults]objectForKey:@"loginData"];
    NSLog(@"%@ login data = ",dict);
    
     [self callNotificationCenterAPI];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    noNotificationLabel.hidden = YES;
}
- (IBAction)notificationBackBtnAction:(id)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
   
    return notificationsArray.count;
  
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"NotificationCell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NotificationCell"];
    }
    
//    UILabel *Productname=(UILabel *)[cell.contentView viewWithTag:20001000100];
//    Productname.text= [NSString stringWithFormat:@"Your  %@ is booked",   [[notificationsArray valueForKey:@"product_name"]objectAtIndex:indexPath.row]];
    
    UILabel *StartDate=(UILabel *)[cell.contentView viewWithTag:20001000101];
    StartDate.text= [NSString stringWithFormat:@"%@",   [[notificationsArray valueForKey:@"description"]objectAtIndex:indexPath.row]];
    
    UILabel *endDate=(UILabel *)[cell.contentView viewWithTag:20001000104];
    endDate.text= [NSString stringWithFormat:@"Created on %@",   [[notificationsArray valueForKey:@"created_on"]objectAtIndex:indexPath.row]];
    
    UILabel *name=(UILabel *)[cell.contentView viewWithTag:20001000102];
    name.text= [NSString stringWithFormat:@"%@",[[notificationsArray valueForKey:@"first_name"]objectAtIndex:indexPath.row]];
    
    
    return  cell;
}




-(void)callNotificationCenterAPI
{
    
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"],
                                   };
    
    McomLOG(@"%@",registerInfo);
    [API NotificationWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
     {
         [Appdelegate stopLoader:nil];
         NSDictionary *dict_response = [[NSDictionary alloc]initWithDictionary:responseDict];
         NSLog(@"%@",dict_response);
         
         if ([responseDict[@"response"]boolValue]==0)
         {
             noNotificationLabel.hidden = NO;
         }
         else if ([responseDict[@"response"]boolValue]==1)
         {
             NSLog(@"NOTIFICATION LISTING = %@", responseDict);
             notificationsArray =[[NSMutableArray alloc]initWithArray:responseDict[@"data"]];
             
             [notificationTableView reloadData];
             
             NSLog(@"Dashboard list Data%@",notificationsArray);
         }
     }];
}



@end
