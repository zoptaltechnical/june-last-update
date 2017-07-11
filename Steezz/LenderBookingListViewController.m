//
//  LenderBookingListViewController.m
//  Steezz
//
//  Created by Apple on 09/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "LenderBookingListViewController.h"

#import "JTSImageViewController.h"
#import "JTSImageInfo.h"

@interface LenderBookingListViewController ()
{
    NSDictionary *dict;
    NSMutableArray *bookingListArray;
    NSString *ProductId;
    NSString *dateString;
}

@end

@implementation LenderBookingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dict=  [[NSUserDefaults standardUserDefaults]objectForKey:@"loginData"];
    NSLog(@"%@ login data = ",dict);
    
    profilePic.layer.cornerRadius=profilePic.frame.size.width/2;
    profilePic.clipsToBounds= YES;

    [profilePic.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [profilePic.layer setBorderWidth: 4.0];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
    [tapRecognizer addTarget:self action:@selector(bigButtonTapped:)];
    [profilePic addGestureRecognizer:tapRecognizer];
    profilePic.userInteractionEnabled=YES;
    
    [self callBookingListAPI];
    // Do any additional setup after loading the view.
}



- (void)bigButtonTapped:(UITapGestureRecognizer*)sender
{
    UIImageView*seletedImage;
    if (sender.view==profilePic)
    {
        seletedImage=profilePic;
        // editProfileButtonNew.hidden=NO;
    }
    
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = seletedImage.image;
    
    imageInfo.referenceRect = seletedImage.frame;
    
    imageInfo.referenceView = seletedImage.superview;
    imageInfo.referenceContentMode = seletedImage.contentMode;
    imageInfo.referenceCornerRadius = seletedImage.layer.cornerRadius;
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc] initWithImageInfo:imageInfo mode:JTSImageViewControllerMode_Image backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
    
}



- (IBAction)bookingSettingBtnPressed:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LenderSettingsViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"LenderSettingsViewController"];
    [self.navigationController pushViewController:homeObj animated:YES];
    
}

- (IBAction)bookingBackBtnPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return bookingListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BookingListCell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BookingListCell"];
    }
 
    UILabel *Productname=(UILabel *)[cell.contentView viewWithTag:4000];
    Productname.text= [NSString stringWithFormat:@"%@",   [[bookingListArray valueForKey:@"product_name"]objectAtIndex:indexPath.row]];
    
    UILabel *price=(UILabel *)[cell.contentView viewWithTag:4001];
    price.text= [NSString stringWithFormat:@"%@",   [[bookingListArray valueForKey:@"product_price"]objectAtIndex:indexPath.row]];
    
    UILabel *description=(UILabel *)[cell.contentView viewWithTag:4002];
    description.text= [NSString stringWithFormat:@"%@",[[bookingListArray valueForKey:@"product_desc"]objectAtIndex:indexPath.row]];
    
    UIImageView *ImageMy = (UIImageView *)[cell.contentView viewWithTag:4003];
    
    [ImageMy sd_setImageWithURL:[NSURL URLWithString: [[bookingListArray valueForKey:@"product_image"] objectAtIndex:indexPath.row] ]placeholderImage:[UIImage imageNamed:@"1"] options:SDWebImageRefreshCached];
    
    
    UIButton *FavouriteSaveBtn =(UIButton *)[cell.contentView viewWithTag:4004];
    [FavouriteSaveBtn addTarget:self
                      action:@selector(FavouriteSaveBtnPressed:)
                      forControlEvents:UIControlEventTouchUpInside];
        
    UIButton *BookBtn =(UIButton *)[cell.contentView viewWithTag:4005];
    [BookBtn addTarget:self
             action:@selector(BookBtnPressed:)
             forControlEvents:UIControlEventTouchUpInside];
   
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LenderProductDetailViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"LenderProductDetailViewController"];
    homeObj.ProductDetail = [[bookingListArray valueForKey:@"id"]objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:homeObj animated:YES];

}



-(void)FavouriteSaveBtnPressed:(id)sender
{
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:bookingListTableView];
    NSIndexPath *indexPath = [bookingListTableView indexPathForRowAtPoint:buttonPosition];
    McomLOG(@"like-indexPath--%ld",(long)indexPath.row);
    ProductId = [NSString stringWithFormat:@"%@",[[bookingListArray valueForKey:@"id"]objectAtIndex:indexPath.row]];
    [self callSaveProductAPI];
    
    
}

-(void)BookBtnPressed:(id)sender
{
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:bookingListTableView];
    NSIndexPath *indexPath = [bookingListTableView indexPathForRowAtPoint:buttonPosition];
    McomLOG(@"like-indexPath--%ld",(long)indexPath.row);
   
    ProductId = [NSString stringWithFormat:@"%@",[[bookingListArray valueForKey:@"id"]objectAtIndex:indexPath.row]];
    dateString = [NSString stringWithFormat:@"%@",[[bookingListArray valueForKey:@"available_date"]objectAtIndex:indexPath.row]];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    BookNowViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"BookNowViewController"];
    homeObj.ProdctID = ProductId;
    homeObj.availabelDate = dateString;
    [self.navigationController pushViewController:homeObj animated:YES];
    
}


-(void)messageBtnPressed:(id)sender
{
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:bookingListTableView];
    NSIndexPath *indexPath = [bookingListTableView indexPathForRowAtPoint:buttonPosition];
    McomLOG(@"like-indexPath--%ld",(long)indexPath.row);
    
    ProductId = [NSString stringWithFormat:@"%@",[[bookingListArray valueForKey:@"id"]objectAtIndex:indexPath.row]];
    dateString = [NSString stringWithFormat:@"%@",[[bookingListArray valueForKey:@"available_date"]objectAtIndex:indexPath.row]];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    chatViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"chatViewController"];
   // homeObj.ProdctID = ProductId;
   // homeObj.availabelDate = dateString;
    [self.navigationController pushViewController:homeObj animated:YES];
    
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

#pragma Bookling List Detail API

-(void)callBookingListAPI
{
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSDictionary* registerInfo = @{
                                   @"user_id":_other_user_ID,
                                   @"access_token":[dict valueForKey:@"access_token"]
                                   };
    
    McomLOG(@"%@",registerInfo);
    [API BookingListWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
     {
         
         [Appdelegate stopLoader:nil];
         
         NSDictionary *dict_response = [[NSDictionary alloc]initWithDictionary:responseDict];
         
         if ([responseDict[@"result"]boolValue]==0)
         {
             NSString * errormessage = [NSString stringWithFormat:@"%@",[dict_response valueForKey:@"message"]];
             
             [SRAlertView sr_showAlertViewWithTitle:@"Alert"
                                            message:errormessage
                                    leftActionTitle:@"OK"
                                   rightActionTitle:@""
                                     animationStyle:AlertViewAnimationRightToCenterSpring
                                       selectAction:^(AlertViewActionType actionType) {
                                           NSLog(@"%zd", actionType);
                                       }];
             
         }
         else if ([responseDict[@"result"]boolValue]==1)
         {
             NSLog(@"sign_up%@", responseDict);
             
             
             
             bookingListArray =[[NSMutableArray alloc]initWithArray:responseDict[@"products"]];
             NSLog(@"tabel list Data%@", bookingListArray);
             [bookingListTableView reloadData];
             
             if (bookingListArray.count ==0)
             {
                 UIAlertView*  myAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No product are Available"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 [myAlertView show];
                 
             }
             
             name.text = [NSString stringWithFormat:@"%@", [[responseDict valueForKey:@"hostData"] valueForKey:@"first_name"]];
             location.text = [NSString stringWithFormat:@"%@", [[responseDict valueForKey:@"hostData"] valueForKey:@"location"]];
             email.text = [NSString stringWithFormat:@"%@", [[responseDict valueForKey:@"hostData"] valueForKey:@"email"]];
             [profilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"hostData"] valueForKey:@"profile_pic"]]] placeholderImage:[UIImage imageNamed:@"1"] options:SDWebImageRefreshCached];
             about.text = [NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"hostData"] valueForKey:@"about_user"]];
          
         }
     }];
}

@end
