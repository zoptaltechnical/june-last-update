//
//  LenderBookingListViewController.h
//  Steezz
//
//  Created by Apple on 09/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LenderBookingListViewController : UIViewController

{
    
    IBOutlet UITableView *bookingListTableView;
    IBOutlet UIButton *bookingBackBtn;
    IBOutlet UIButton *bookingSettingBtn;
    IBOutlet UIImageView *profilePic;
    IBOutlet UITextView *about;
    IBOutlet UILabel *location;
    IBOutlet UILabel *email;
    IBOutlet UILabel *name;
    
}

@property(nonatomic,strong) NSString * other_user_ID;


@end
