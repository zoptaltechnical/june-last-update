//
//  CreditCardListingViewController.h
//  Steezz
//
//  Created by Apple on 07/06/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditCardListingViewController : UIViewController
{
    IBOutlet UIButton *addCardBtn;
    
    IBOutlet UIButton *savedCardBackBtn;
    
    IBOutlet UITableView *cardListingTableView;
    
}


@property(nonatomic,strong) NSString * startDateString;

@property(nonatomic,strong) NSString * endDateString;
@property(nonatomic,strong) NSString * ProductIdStringString;
@end
