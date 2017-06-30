//
//  chatViewController.h
//  Steezz
//
//  Created by Apple on 01/06/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface chatViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>

{
    IBOutlet UILabel *reciverUserName;
    IBOutlet UIView *msgInPutView;
    
    IBOutlet UITableView *Chattable;
    
    IBOutlet UIButton *chatBackBtn;
    
    IBOutlet UIButton *cameraBtn;
    
    IBOutlet UIButton *sendBtn;
    
    IBOutlet UITextView *messageTxtFld;
    
    
   // IBOutlet UITextField *messageTxtFld;
}


@property(nonatomic,strong) NSString * reciverID_string;

@property(nonatomic,strong) NSString * ReciverName_string;

@property(nonatomic,strong) NSString * ConversationID_string;

@end
