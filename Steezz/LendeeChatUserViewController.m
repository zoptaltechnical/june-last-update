//
//  LendeeChatUserViewController.m
//  Steezz
//
//  Created by Apple on 06/06/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "LendeeChatUserViewController.h"

@interface LendeeChatUserViewController ()
{
     NSMutableArray *lendeeChatUserListArray;
    NSDictionary *dict;
}

@end

@implementation LendeeChatUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dict=  [[NSUserDefaults standardUserDefaults]objectForKey:@"loginData"];
    NSLog(@"%@ login data = ",dict);
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    noUserLabel.hidden = YES;
    [self callLendeerChatUserListing];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return lendeeChatUserListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"LendeeChettingUserCell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LendeeChettingUserCell"];
    }
    
    
    
    UIImageView *UserImage = (UIImageView *)[cell.contentView viewWithTag:5700743000];
    
    UserImage.layer.cornerRadius=UserImage.frame.size.width/2;
    UserImage.clipsToBounds= YES;
    
    [UserImage sd_setImageWithURL:[NSURL URLWithString: [[lendeeChatUserListArray valueForKey:@"profile_pic"] objectAtIndex:indexPath.row] ]placeholderImage:[UIImage imageNamed:@"2"] options:SDWebImageRefreshCached];
    
    
    UILabel *UserName=(UILabel *)[cell.contentView viewWithTag:5700743001];
    UserName.text= [NSString stringWithFormat:@"%@",[[lendeeChatUserListArray valueForKey:@"receiver_name"]objectAtIndex:indexPath.row]];
    
    UITextView *LastMessage=(UITextView *)[cell.contentView viewWithTag:5700743002];
    LastMessage.text= [NSString stringWithFormat:@"%@",[[lendeeChatUserListArray valueForKey:@"message"]objectAtIndex:indexPath.row]];
    
    
    
    UILabel *numberOfMesseges=(UILabel *)[cell.contentView viewWithTag:5700743003];
    
    NSString *Message = [NSString stringWithFormat:@"%@",[[lendeeChatUserListArray valueForKey:@"unread_msgs"]objectAtIndex:indexPath.row] ];
    
    if ([Message isEqualToString:@"0"]) {
        numberOfMesseges.hidden = YES;
        
        
    }
    
    else
    {
        numberOfMesseges.text= [NSString stringWithFormat:@"%@",[[lendeeChatUserListArray valueForKey:@"unread_msgs"]objectAtIndex:indexPath.row]];
        
        
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
    homeObj.reciverID_string =[NSString stringWithFormat:@"%@",[[lendeeChatUserListArray valueForKey:@"receiver_id"]objectAtIndex:indexPath.row]] ;
    
    homeObj.ConversationID_string =[NSString stringWithFormat:@"%@",[[lendeeChatUserListArray valueForKey:@"conversation_id"]objectAtIndex:indexPath.row]] ;
    
    homeObj.ReciverName_string =[NSString stringWithFormat:@"%@",[[lendeeChatUserListArray valueForKey:@"receiver_name"]objectAtIndex:indexPath.row]] ;
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
             noUserLabel.hidden = NO;
         }
         
         else if ([responseDict[@"result"]boolValue]==1)
         {
             
             lendeeChatUserListArray =[[NSMutableArray alloc]initWithArray:responseDict[@"data"]];
             NSLog(@"tabel list Data%@", lendeeChatUserListArray);
             
             if (lendeeChatUserListArray.count ==0)
             {
//                 UIAlertView*  myAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No Chat User are Available"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                 
//                 [myAlertView show];
                 
             }
             
             [lendeeChatUserTableView reloadData];
             
         }
     }];
}


@end
