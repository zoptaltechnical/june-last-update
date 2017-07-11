//
//  chatViewController.m
//  Steezz
//
//  Created by Apple on 01/06/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "chatViewController.h"
#import "SPHTextBubbleCell.h"
#import "SPHMediaBubbleCell.h"
#import "Constantvalues.h"
#import "SPH_PARAM_List.h"


@interface chatViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TextCellDelegate,MediaCellDelegate>

{
    NSDictionary*dict1;
    NSDictionary *dict;
    NSMutableArray *sphBubbledata,*MessageData;
    BOOL isfromMe;
    NSData *data;
    NSString *base64EncodedP;
    BOOL isFromImagePicker;
    NSInteger selectedPhotoTag;
    UIImage *image;
    NSDateFormatter *dateFormatter;
    
    NSString *currentTime;
    
    
}


@end

@implementation chatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    dict=  [[NSUserDefaults standardUserDefaults]objectForKey:@"loginData"];
    NSLog(@"%@ login data = ",dict);
    
    messageTxtFld.delegate = self;
    reciverUserName.text = [NSString stringWithFormat:@"%@",_ReciverName_string];
    
    isfromMe=YES;
    [self currentTime];
    sphBubbledata =[[NSMutableArray alloc]init];
    
   
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [Chattable addGestureRecognizer:tap];
     Chattable.backgroundColor =[UIColor clearColor];
    
    
    
    
    [self loadAllMessages:_ConversationID_string];

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self currentTime];
}

- (IBAction)chatCameraBtnAction:(id)sender {
    
    selectedPhotoTag=[sender tag];
    
    [self ActionSheetImage];
  
}



-(void) ActionSheetImage
{
    UIActionSheet *popup;
  
        popup = [[UIActionSheet alloc] initWithTitle:@"Choose Photo:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Camera",
                 @"Photos Album",
                 nil];
    
    
    [popup showInView:self.view];
}


#pragma mark - UIImagePickerController Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.navigationBar.barStyle = UIBarStyleBlack; // Or whatever style.
    picker.navigationBar.tintColor = [UIColor whiteColor];
    picker.delegate  = self;
    picker.allowsEditing = YES;
    switch (buttonIndex) {
        case 0:
            
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                               message:@"Device has no camera"
                                       leftActionTitle:@"OK"
                                      rightActionTitle:@""
                                        animationStyle:AlertViewAnimationTopToCenterSpring
                                          selectAction:^(AlertViewActionType actionType) {
                                              NSLog(@"%zd", actionType);
                                          }];
                
                
            }
            else
            {
                
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                [self presentViewController:picker animated:YES completion:Nil];
            }
            
            break;
        case 1:
            
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:NULL];
        default:
            break;
    }
}

#pragma mark IMAGE PICKER DELEGATES
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    isFromImagePicker=YES;
    image = [info objectForKey:UIImagePickerControllerEditedImage];
    data = UIImageJPEGRepresentation(image, 0.99);
    base64EncodedP = [[NSString alloc] initWithString:[Base64 encode:data]];
    CGRect rect = CGRectMake(0,0,100,80);
    UIGraphicsBeginImageContext( rect.size );
    [image drawInRect:rect];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImagePNGRepresentation(picture1);
    image=[UIImage imageWithData:imageData];
    
    [self sendImage:image];
    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)sendImage:(UIImage*)image1
{
  
//    if ([_Value isEqualToString:@"1"])
//    {
//        NSLog(@"id== %@",_ID);
    
        [self sendMessageAPI:_reciverID_string];
    
    
        //[self SetupDummyMessages:_ConversationidString];
  //  }
//    else  if ([_Value isEqualToString:@"2"])
//    {
//        NSLog(@"_friend_idString== %@",_friend_idString);
//        [self sendmessageapi:_friend_idString];
//        //  [self SetupDummyMessages:_ConversationidString];
//    }
    [Utility setValue:@"1" forKey:@"reloadChattabelView"];
    [Chattable reloadData];
    [self scrollTableview];
    [self performSelector:@selector(loadAllMessages:) withObject:_ConversationID_string afterDelay:1];
}



- (IBAction)chatBackBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)chatSendBtnAction:(id)sender {
    
    
    
    NSDate *date = [NSDate date];
    NSLog(@"%@",date);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    
    [self sendMessageAPI:_reciverID_string];

    [Chattable reloadData];
    //  [self scrollTableview];

    
    messageTxtFld.text=@"";
    [Chattable reloadData];
}






#pragma mark tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return sphBubbledata.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPH_PARAM_List *feed_data=[[SPH_PARAM_List alloc]init];
    feed_data=[sphBubbledata objectAtIndex:indexPath.row];
    
    if ([feed_data.chat_media_type isEqualToString:kImagebyme]||[feed_data.chat_media_type isEqualToString:kImagebyOther])  return 180;
    
    CGSize labelSize =[feed_data.chat_message boundingRectWithSize:CGSizeMake(226.0f, MAXFLOAT)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14.0f] }
                                                           context:nil].size;
    return labelSize.height + 30 + TOP_MARGIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *L_CellIdentifier = @"SPHTextBubbleCell";
    static NSString *R_CellIdentifier = @"SPHMediaBubbleCell";
    
    SPH_PARAM_List *feed_data=[[SPH_PARAM_List alloc]init];
    feed_data=[sphBubbledata objectAtIndex:indexPath.row];
    if ([feed_data.chat_media_type isEqualToString:kTextByme]||[feed_data.chat_media_type isEqualToString:kTextByOther])
    {
        SPHTextBubbleCell *cell = (SPHTextBubbleCell *) [tableView dequeueReusableCellWithIdentifier:L_CellIdentifier];
        if (cell == nil)
        {
            cell = [[SPHTextBubbleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:L_CellIdentifier];
        }
        cell.bubbletype=([feed_data.chat_media_type isEqualToString:kTextByme])?@"RIGHT":@"LEFT";
        cell.textLabel.text = feed_data.chat_message;
        
        NSLog(@"chat message =  %@",feed_data.chat_message);
        
        cell.textLabel.tag=indexPath.row;
        cell.timestampLabel.text =feed_data.chat_time;
        cell.CustomDelegate=self;
        //cell.AvatarImageView.image=([feed_data.chat_media_type isEqualToString:kTextByme])?[UIImage imageNamed:@"ProfilePic"]:[UIImage imageNamed:@"person"];
        
        [cell.AvatarImageView sd_setImageWithURL:[NSURL URLWithString:feed_data.chat_downloadStatus]placeholderImage:[UIImage imageNamed:@"user"] options:SDWebImageRefreshCached];
        
        
        return cell;
        
    }
    
    SPHMediaBubbleCell *cell = (SPHMediaBubbleCell *) [tableView dequeueReusableCellWithIdentifier:R_CellIdentifier];
    if (cell == nil)
    {
        cell = [[SPHMediaBubbleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:R_CellIdentifier];
    }
    cell.bubbletype=([feed_data.chat_media_type isEqualToString:kImagebyme])?@"RIGHT":@"LEFT";
    cell.textLabel.text = feed_data.chat_message;
    cell.messageImageView.tag=indexPath.row;
    cell.CustomDelegate=self;
    cell.timestampLabel.text = feed_data.chat_time;
    [cell.messageImageView sd_setImageWithURL:[NSURL URLWithString:feed_data.chat_Thumburl]placeholderImage:[UIImage imageNamed:@"user"] options:SDWebImageRefreshCached];
    
    
    
    
    
    return cell;
}




//=========***************************************************=============
#pragma mark - CELL CLICKED  PROCEDURE
//=========***************************************************=============


-(void)textCellDidTapped:(SPHTextBubbleCell *)tesxtCell AndGesture:(UIGestureRecognizer*)tapGR;
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tesxtCell.textLabel.tag inSection:0];
    NSLog(@"Forward Pressed =%@ and IndexPath=%@",tesxtCell.textLabel.text,indexPath);
    [tesxtCell showMenu];
}
// 7684097905

-(void)cellCopyPressed:(SPHTextBubbleCell *)tesxtCell
{
    NSLog(@"copy Pressed =%@",tesxtCell.textLabel.text);
    
}

-(void)cellForwardPressed:(SPHTextBubbleCell *)tesxtCell
{
    NSLog(@"Forward Pressed =%@",tesxtCell.textLabel.text);
    
}
-(void)cellDeletePressed:(SPHTextBubbleCell *)tesxtCell
{
    NSLog(@"Delete Pressed =%@",tesxtCell.textLabel.text);
    
}

//=========*******************  BELOW FUNCTIONS FOR IMAGE  **************************=============

-(void)mediaCellDidTapped:(SPHMediaBubbleCell *)mediaCell AndGesture:(UIGestureRecognizer*)tapGR;
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:mediaCell.messageImageView.tag inSection:0];
    NSLog(@"Media cell Pressed  and IndexPath=%@",indexPath);
    
    [mediaCell showMenu];
}

-(void)mediaCellCopyPressed:(SPHMediaBubbleCell *)mediaCell
{
    NSLog(@"copy Pressed =%@",mediaCell.messageImageView.image);
    
}

-(void)mediaCellForwardPressed:(SPHMediaBubbleCell *)mediaCell
{
    NSLog(@"Forward Pressed =%@",mediaCell.messageImageView.image);
    
}
-(void)mediaCellDeletePressed:(SPHMediaBubbleCell *)mediaCell
{
    NSLog(@"Delete Pressed =%@",mediaCell.messageImageView.image);
    
}


/////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark               KEYBOARD UPDOWN EVENT
/////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (sphBubbledata.count>2) {
        [self performSelector:@selector(scrollTableview) withObject:nil afterDelay:0.0];
    }
    CGRect tableviewframe=Chattable.frame;
    tableviewframe.size.height-=270;
    [UIView animateWithDuration:0.25 animations:^{
        Chattable.frame=tableviewframe;
    }];
   
    
    if (ScreenHeight<= 568)
    {
        msgInPutView.frame=CGRectMake(0,self.view.frame.size.height-320, self.view.frame.size.width, 50);
    }
    else if (ScreenHeight<= 667)
    {
        
        msgInPutView.frame=CGRectMake(0,self.view.frame.size.height-300, self.view.frame.size.width, 50);
        
    }
    
    else if(ScreenHeight <= 736)
    {
        msgInPutView.frame=CGRectMake(0,self.view.frame.size.height-325, self.view.frame.size.width, 50);
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    
    if (sphBubbledata.count>2) {
        [self performSelector:@selector(scrollTableview) withObject:nil afterDelay:0.0];
    }
    CGRect tableviewframe=Chattable.frame;
    tableviewframe.size.height-=270;
    [UIView animateWithDuration:0.25 animations:^{
        Chattable.frame=tableviewframe;
    }];
    
    
    if (ScreenHeight<= 568)
    {
        msgInPutView.frame=CGRectMake(0,self.view.frame.size.height-302, self.view.frame.size.width, 50);
    }
    else if (ScreenHeight<= 667)
    {
        
        msgInPutView.frame=CGRectMake(0,self.view.frame.size.height-300, self.view.frame.size.width, 50);
        
    }
    
    else if(ScreenHeight <= 736)
    {
        msgInPutView.frame=CGRectMake(0,self.view.frame.size.height-325, self.view.frame.size.width, 50);
    }

    
   
    
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    CGRect tableviewframe=Chattable.frame;
    tableviewframe.size.height+=260;
    [UIView animateWithDuration:0.25 animations:^{
        msgInPutView.frame=CGRectMake(0,self.view.frame.size.height-50,  self.view.frame.size.width, 50);
        Chattable.frame=tableviewframe;  }];
    if (sphBubbledata.count>2) {
        [self performSelector:@selector(scrollTableview) withObject:nil afterDelay:0.25];
    }

    
    return  YES;
}




-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect tableviewframe=Chattable.frame;
    tableviewframe.size.height+=260;
    [UIView animateWithDuration:0.25 animations:^{
        msgInPutView.frame=CGRectMake(0,self.view.frame.size.height-50,  self.view.frame.size.width, 50);
        Chattable.frame=tableviewframe;  }];
    if (sphBubbledata.count>2) {
        [self performSelector:@selector(scrollTableview) withObject:nil afterDelay:0.25];
    }
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

-(void)scrollTableview
{
    NSInteger item = [Chattable numberOfRowsInSection:0] - 1;
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
    [Chattable scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}




#pragma mark  GENERATE RANDOM ID to SAVE IN LOCAL
/////////////////////////////////////////////////////////////////////////////////////////////////////


-(NSString *) genRandStringLength: (int) len {
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}



-(void)adddMediaBubbledata:(NSString*)mediaType  mediaPath:(NSString*)mediaPath mtime:(NSString*)messageTime thumb:(NSString*)thumbUrl  downloadstatus:(NSString*)downloadstatus sendingStatus:(NSString*)sendingStatus msg_ID:(NSString*)msgID
{
    
    SPH_PARAM_List *feed_data=[[SPH_PARAM_List alloc]init];
    feed_data.chat_message=mediaPath;
    feed_data.chat_date_time=messageTime;
    feed_data.chat_media_type=mediaType;
    feed_data.chat_send_status=sendingStatus;
    feed_data.chat_Thumburl=thumbUrl;
    feed_data.chat_downloadStatus=downloadstatus;
    feed_data.chat_messageID=msgID;
    [sphBubbledata addObject:feed_data];
}



-(void)currentTime
{
    dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd hh:mm a"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
}




-(void)loadAllMessages:(NSString *)String
{
    
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSLog(@"%@",dict1);
    
    NSDictionary* registerInfo;
    
    NSLog(@"string  = =   %@",String);
    
    registerInfo= @{
                    @"access_token":[dict valueForKey:@"access_token"],
                    @"conversation_id":String,
                    };
    
    McomLOG(@"%@",registerInfo);
    [API LoadAllMessagesWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
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
             NSLog(@"responce =  %@",responseDict);
             
             MessageData = [responseDict valueForKey:@"data"];
             [sphBubbledata removeAllObjects];
             
             if (MessageData.count ==0)
             {
                 
             }
             
             else
             {
                 
                 for (int i=0; i<[[responseDict valueForKey:@"data"] count]; i++)
                 {
                     NSDate *date = [NSDate date];
                     NSLog(@"%@",date);
                     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                     [formatter setDateFormat:@"hh:mm a"];
                     dict1=[[responseDict valueForKey:@"data"] objectAtIndex:i];
                     
                     if ([[dict1 valueForKey:@"type"] isEqualToString:@"self"])
                     {
                         if ([[dict1 valueForKey:@"image"]length]>0)
                         {
                             [self adddMediaBubbledata:kImagebyme mediaPath:[dict1 valueForKey:@"image"] mtime:[formatter stringFromDate:[dict1 valueForKey:@"date"]] thumb:[dict1 valueForKey:@"image"] downloadstatus:[dict1 valueForKey:@"profile_pic"] sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
                         }
                         else
                         {
                             [self adddMediaBubbledata:kTextByme mediaPath:[dict1 valueForKey:@"message"] mtime:[formatter stringFromDate:[dict1 valueForKey:@"date"]] thumb:[dict1 valueForKey:@"image"] downloadstatus:[dict1 valueForKey:@"profile_pic"] sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
                         }
                         
                         NSMutableDictionary* mutableDict = [dict1 mutableCopy];
                         [mutableDict removeObjectForKey:@"data"];
                         
                     }
                     
                     else  if ([[dict1 valueForKey:@"type"]isEqualToString:@"other"])
                         
                     {
                         if ([[dict1 valueForKey:@"image"]length]>0)
                         {
                             [self adddMediaBubbledata:kImagebyOther mediaPath:[dict1 valueForKey:@"image"] mtime:[formatter stringFromDate:[dict1 valueForKey:@"date"]] thumb:[dict1 valueForKey:@"image"] downloadstatus:[dict1 valueForKey:@"profile_pic"] sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
                         }
                         else
                         {
                             [self adddMediaBubbledata:kTextByOther mediaPath:[dict1 valueForKey:@"message"] mtime:[formatter stringFromDate:[dict1 valueForKey:@"date"]] thumb:[dict1 valueForKey:@"image"] downloadstatus:[dict1 valueForKey:@"profile_pic"] sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
                         }
                         
                         NSMutableDictionary* mutableDict = [dict1 mutableCopy];
                         [mutableDict removeObjectForKey:@"data"];
                     }
                     
                     [Chattable reloadData];
                     [self scrollTableview];
                     [self performSelector:@selector(messageSent:) withObject:@"0" afterDelay:1];
                 }
             }
         }
     }];
}

-(void)messageSent:(NSString*)rownum
{
    int rowID=[rownum intValue];
    
    SPH_PARAM_List *feed_data=[[SPH_PARAM_List alloc]init];
    feed_data=[sphBubbledata objectAtIndex:rowID];
    [sphBubbledata  removeObjectAtIndex:rowID];
    feed_data.chat_send_status=kSent;
    [sphBubbledata insertObject:feed_data atIndex:rowID];
    
    // [self.chattable reloadData];
    
    NSArray *indexPaths = [NSArray arrayWithObjects:
                           [NSIndexPath indexPathForRow:rowID inSection:0],
                           // Add some more index paths if you want here
                           nil];
    BOOL animationsEnabled = [UIView areAnimationsEnabled];
    [UIView setAnimationsEnabled:NO];
    [Chattable reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [UIView setAnimationsEnabled:animationsEnabled];
}



-(void)sendMessageAPI :(NSString *)OtherUserId
{
    
    NSLog(@"other user id =%@ ",OtherUserId);
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
     NSDictionary* registerInfo;
    
    if ([base64EncodedP  isEqual: @""])
    {
        if ([messageTxtFld.text length]==0)
        {
             [Appdelegate stopLoader:nil];
             return;
        }
        else
        {
            base64EncodedP=@"";
            registerInfo= @{
                            @"access_token":[dict valueForKey:@"access_token"],
                            @"receiver_id":OtherUserId,
                            @"message":messageTxtFld.text,
                            @"image":base64EncodedP,
                            @"date_time":[dateFormatter stringFromDate:[NSDate date]],
                            };
            McomLOG(@"%@",registerInfo);
        }
    }
    
//    else if ([base64EncodedP  isEqual: @""]|| [messageTxtFld.text length]==0)
//    {
//        [Appdelegate stopLoader:nil];
//        return;
//    }
    
   else if (([messageTxtFld.text length]>0))
   {
       base64EncodedP = @"";
       
       registerInfo= @{
                       @"access_token":[dict valueForKey:@"access_token"],
                       @"receiver_id":OtherUserId,
                       @"message":messageTxtFld.text,
                       @"image":base64EncodedP,
                       @"date_time":[dateFormatter stringFromDate:[NSDate date]],
                       };
       McomLOG(@"%@",registerInfo);
   }
   else if (([base64EncodedP length]>0))
   {
       messageTxtFld.text = @"";
       
       registerInfo= @{
                       @"access_token":[dict valueForKey:@"access_token"],
                       @"receiver_id":OtherUserId,
                       @"message":messageTxtFld.text,
                       @"image":base64EncodedP,
                       @"date_time":[dateFormatter stringFromDate:[NSDate date]],
                       };
       
       McomLOG(@"%@",registerInfo);
   }
   else
    {
        NSLog(@"you cant send this message");
    }

    [API MessageWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
     {
         [Appdelegate stopLoader:nil];
         NSDictionary *dict_response = [[NSDictionary alloc]initWithDictionary:responseDict];
         
         if ([responseDict[@"response"]boolValue]==0)
         {
             NSString * errormessage = [NSString stringWithFormat:@"%@",[dict_response valueForKey:@"message"]];
             
             [Utility showAlertWithTitleText:errormessage messageText:nil delegate:nil];
         }
         else if ([responseDict[@"response"]boolValue]==1)
         {
             [self loadAllMessages:_ConversationID_string];
             if ([messageTxtFld.text length]>0)
             {
                // [self scrollTableview];
                // [self performSelector:@selector(messageSent:) withObject:@"0" afterDelay:1];
             }
             else if ([base64EncodedP length]>0)
             {
                 base64EncodedP=nil;
                 //[self scrollTableview];
                // [self performSelector:@selector(messageSent:) withObject:@"0" afterDelay:1];
             }
             [messageTxtFld resignFirstResponder];
             [self.view endEditing:YES];
         }
     }];
}
@end
