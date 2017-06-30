//
//  LenderReportDetailViewController.m
//  Steezz
//
//  Created by Apple on 09/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "LenderReportDetailViewController.h"

@interface LenderReportDetailViewController ()
{
    NSMutableArray *reportListArray;
    NSDictionary *dict;
    
    NSString *reportID;
    NSString *host_email;
    
}

@end

@implementation LenderReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dict=  [[NSUserDefaults standardUserDefaults]objectForKey:@"loginData"];
    NSLog(@"%@ login data = ",dict);
    
    
    
    
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    [self callAllReportsAPI];
    
    
}


-(void)callAllReportsAPI
{
        [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"]
                                   };
    
    McomLOG(@"%@",registerInfo);
    [API ReportListtingWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
     {
         
         [Appdelegate stopLoader:nil];
         NSDictionary *dict_response = [[NSDictionary alloc]initWithDictionary:responseDict];
         NSLog(@"%@",dict_response);
         
         if ([responseDict[@"result"]boolValue]==0)
         {
             noReportLabel.hidden = NO;
             reportListArray = [[NSMutableArray alloc]init];
             [reportListTableView reloadData];
         }
         
         else if ([responseDict[@"result"]boolValue]==1)
         {
             NSLog(@"report List  = %@",responseDict);
             
             if ([responseDict[@"data"] count]>0)
             {
                 reportListArray =[[NSMutableArray alloc]initWithArray:[responseDict valueForKey:@"data"]];
                 NSLog(@"report List = %@", reportListArray);
                 [reportListTableView reloadData];
                
             }
         }
     }];

    
}

- (IBAction)backBtnPressed:(id)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return reportListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ReportDetailCell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReportDetailCell"];
    }

    
    UILabel *Productname=(UILabel *)[cell.contentView viewWithTag:12000];
    Productname.text= [NSString stringWithFormat:@"%@",   [[reportListArray valueForKey:@"cat_name"]objectAtIndex:indexPath.row]];
    
    UIImageView *ImageMy = (UIImageView *)[cell.contentView viewWithTag:12001];
    
    ImageMy.layer.cornerRadius = 5;
    ImageMy.layer.masksToBounds = YES;
    [ImageMy sd_setImageWithURL:[NSURL URLWithString: [[reportListArray valueForKey:@"product_image"] objectAtIndex:indexPath.row] ]placeholderImage:[UIImage imageNamed:@"1"] options:SDWebImageRefreshCached];
    
    UILabel *description=(UILabel *)[cell.contentView viewWithTag:12002];
    description.text= [NSString stringWithFormat:@"%@",[[reportListArray valueForKey:@"description"]objectAtIndex:indexPath.row]];
    
    
    UIButton *EditBtn =(UIButton *)[cell.contentView viewWithTag:12003];
    [EditBtn addTarget:self
                         action:@selector(EditBtnPressed:)
               forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *DeletBtn =(UIButton *)[cell.contentView viewWithTag:12004];
    [DeletBtn addTarget:self
                action:@selector(DeletBtnPressed:)
      forControlEvents:UIControlEventTouchUpInside];

       return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}




-(void)EditBtnPressed:(id)sender
{
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:reportListTableView];
    NSIndexPath *indexPath = [reportListTableView indexPathForRowAtPoint:buttonPosition];
    McomLOG(@"like-indexPath--%ld",(long)indexPath.row);
   // ProductId = [NSString stringWithFormat:@"%@",[[bookingListArray valueForKey:@"id"]objectAtIndex:indexPath.row]];
    
    
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        EditReportViewController *homeObj = [storyboard instantiateViewControllerWithIdentifier:@"EditReportViewController"];
        homeObj.Reportid = [NSString stringWithFormat:@"%@",[[reportListArray valueForKey:@"id"]objectAtIndex:indexPath.row]];
    
       homeObj.HostEmail_Id = [NSString stringWithFormat:@"%@",[[reportListArray valueForKey:@"host_email"]objectAtIndex:indexPath.row]];
     homeObj.ReportImage =[NSString stringWithFormat:@"%@",[[reportListArray valueForKey:@"product_image"]objectAtIndex:indexPath.row]];
    
     homeObj.Report_Discription = [NSString stringWithFormat:@"%@",[[reportListArray valueForKey:@"description"]objectAtIndex:indexPath.row]];
    
      homeObj.Report_Category_Name = [NSString stringWithFormat:@"%@",[[reportListArray valueForKey:@"cat_name"]objectAtIndex:indexPath.row]];
      homeObj.report_cat_ID = [NSString stringWithFormat:@"%@",[[reportListArray valueForKey:@"cat_id"]objectAtIndex:indexPath.row]];
    
       // homeObj.availabelDate = dateString;
        [self.navigationController pushViewController:homeObj animated:YES];
    
   
    
    
}

-(void)DeletBtnPressed:(id)sender
{
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:reportListTableView];
    NSIndexPath *indexPath = [reportListTableView indexPathForRowAtPoint:buttonPosition];
    McomLOG(@"like-indexPath--%ld",(long)indexPath.row);
    
    reportID = [NSString stringWithFormat:@"%@",[[reportListArray valueForKey:@"id"]objectAtIndex:indexPath.row]];

     [self callDeletReportAPI];

}


-(void)callDeletReportAPI
{

    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[dict valueForKey:@"access_token"],
                                   @"report_id":reportID
                                   };
    
    McomLOG(@"%@",registerInfo);
    [API DeleteReportWithInfo:[registerInfo mutableCopy] completionHandler:^(NSDictionary *responseDict,NSError *error)
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
             NSLog(@"report List  = %@",responseDict);
             
             [Utility showAlertWithTitleText:[responseDict valueForKey:@"message"] messageText:nil delegate:nil];
             
             [self callAllReportsAPI];
             
         }
     }];

    
}

@end
