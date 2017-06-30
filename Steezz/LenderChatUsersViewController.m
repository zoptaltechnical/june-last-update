//
//  LenderChatUsersViewController.m
//  Steezz
//
//  Created by Apple on 01/06/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "LenderChatUsersViewController.h"

@interface LenderChatUsersViewController ()

{
    NSMutableArray *lenderChatUserListArray;
    NSDictionary *dict;
}

@end

@implementation LenderChatUsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    dict=  [[NSUserDefaults standardUserDefaults]objectForKey:@"loginData"];
    NSLog(@"%@ login data = ",dict);
    
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
     noUserFoundLabel.hidden = YES;
    [self callLendeerChatUserListing];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return lenderChatUserListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ChettingUserCell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChettingUserCell"];
    }
    
 
    
    UIImageView *UserImage = (UIImageView *)[cell.contentView viewWithTag:56743000];
    
    UserImage.layer.cornerRadius=UserImage.frame.size.width/2;
    UserImage.clipsToBounds= YES;
    
    [UserImage sd_setImageWithURL:[NSURL URLWithString: [[lenderChatUserListArray valueForKey:@"profile_pic"] objectAtIndex:indexPath.row] ]placeholderImage:[UIImage imageNamed:@"profile_icon-1"] options:SDWebImageRefreshCached];
    
    
    UILabel *UserName=(UILabel *)[cell.contentView viewWithTag:56743001];
    UserName.text= [NSString stringWithFormat:@"%@",[[lenderChatUserListArray valueForKey:@"receiver_name"]objectAtIndex:indexPath.row]];
    
    UITextView *LastMessage=(UITextView *)[cell.contentView viewWithTag:56743002];
    LastMessage.text= [NSString stringWithFormat:@"%@",[[lenderChatUserListArray valueForKey:@"message"]objectAtIndex:indexPath.row]];
    
    
    UILabel *numberOfMesseges=(UILabel *)[cell.contentView viewWithTag:56743003];
    
    NSString *Message = [NSString stringWithFormat:@"%@",[[lenderChatUserListArray valueForKey:@"unread_msgs"]objectAtIndex:indexPath.row] ];
                         
    if ([Message isEqualToString:@"0"]) {
        numberOfMesseges.hidden = YES;
       
      
    }
    
    else
    {
        numberOfMesseges.text= [NSString stringWithFormat:@"%@",[[lenderChatUserListArray valueForKey:@"unread_msgs"]objectAtIndex:indexPath.row]];
        
        
        numberOfMesseges.layer.cornerRadius = numberOfMesseges.frame.size.width/2;
        numberOfMesseges.clipsToBounds =YES;
        
    }
 

    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return  cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    chatViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"chatViewController"];
    homeObj.reciverID_string =[NSString stringWithFormat:@"%@",[[lenderChatUserListArray valueForKey:@"receiver_id"]objectAtIndex:indexPath.row]] ;
    
    homeObj.ConversationID_string =[NSString stringWithFormat:@"%@",[[lenderChatUserListArray valueForKey:@"conversation_id"]objectAtIndex:indexPath.row]] ;
    
    
    homeObj.ReciverName_string =[NSString stringWithFormat:@"%@",[[lenderChatUserListArray valueForKey:@"receiver_name"]objectAtIndex:indexPath.row]] ;
    [self.navigationController pushViewController:homeObj animated:YES];
    
}

#pragma  Lendeer Home Feed List API
-(void)callLendeerChatUserListing
{
    
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"]
                                   };
    
    McomLOG(@"%@",registerInfo);
    [API LenderChatUserListingInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
     {
         
         [Appdelegate stopLoader:nil];
         NSDictionary *dict_response = [[NSDictionary alloc]initWithDictionary:responseDict];
         NSLog(@"dict_response = %@",dict_response);
         
         if ([responseDict[@"result"]boolValue]==0)
         {
             noUserFoundLabel.hidden = NO;
         }
         
         else if ([responseDict[@"result"]boolValue]==1)
         {
    
             lenderChatUserListArray =[[NSMutableArray alloc]initWithArray:responseDict[@"data"]];
             NSLog(@"tabel list Data%@", lenderChatUserListArray);
             
             if (lenderChatUserListArray.count ==0)
             {
                 UIAlertView*  myAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No product are Available"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 
                 [myAlertView show];
                 
             }
             
             [UserListingTableView reloadData];
             
         }
     }];
}






@end
