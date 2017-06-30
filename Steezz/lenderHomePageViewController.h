//
//  lenderHomePageViewController.h
//  Steezz
//
//  Created by Apple on 08/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVPlaceSearchTextField.h"

@interface lenderHomePageViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

{
    
    IBOutlet UILabel *noProductLabel;
    
    IBOutlet UIButton *selectCategoryBtn;
    
    IBOutlet MVPlaceSearchTextField *locationTextField;
    
    IBOutlet UITextField *priceTextFld;
    IBOutlet UITextField *selectDateTxtFld;
    
    IBOutlet UIView *backgroudView;

   
    
    IBOutlet UIView *searchPopUpView;
    
    IBOutlet UIButton *filterBtn;
    
    IBOutlet UIButton *settingBtn;
    
    IBOutlet UIButton *searchNowBtn;
    
    
    IBOutlet UITableView *homeFeedTableView;
    
}

@end
