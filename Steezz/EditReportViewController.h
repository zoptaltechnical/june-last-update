//
//  EditReportViewController.h
//  Steezz
//
//  Created by Apple on 09/06/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditReportViewController : UIViewController

{
    
    IBOutlet UIButton *emailBtn;
    IBOutlet UIButton *editReportBackBtn;
    
    
    IBOutlet UIImageView *reportImageView;
    
    IBOutlet UIButton *editReportCamerBtn;
    
   
    
    
    IBOutlet UIButton *selectCategory;
    
    
    IBOutlet UIButton *SubmittBtn;
    
    IBOutlet LPlaceholderTextView *discriptionTxtView;
    
    
    
    
}


@property(nonatomic,strong) NSString * Reportid;

@property(nonatomic,strong) NSString * HostEmail_Id;

@property(nonatomic,strong) NSString * ReportImage;

@property(nonatomic,strong) NSString * Report_Discription;

@property(nonatomic,strong) NSString * Report_Category_Name;

@property(nonatomic,strong) NSString *report_cat_ID;

@end
