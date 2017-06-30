//
//  lenderStartReportViewController.h
//  Steezz
//
//  Created by Apple on 08/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPlaceholderTextView.h"

@interface lenderStartReportViewController : UIViewController

{
    
    IBOutlet UIButton *selectEmail;
    
    IBOutlet UIButton *submitBtn;
    
    IBOutlet UIButton *ReportDetailBtn;
    
    
    IBOutlet UIButton *camera;
    
    IBOutlet UIImageView *startImage;
    
    IBOutlet UIButton *startReportBackBtn;
    
    IBOutlet UIButton *selectCategoryBtn;
    
    IBOutlet LPlaceholderTextView *startReportTextView;
    
    
    IBOutlet UIButton *startReportSettingBtn;
    
    
}

@end
