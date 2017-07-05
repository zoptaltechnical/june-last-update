//
//  SaveCreditCardViewController.h
//  Steezz
//
//  Created by Apple on 03/07/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaveCreditCardViewController : UIViewController


{
    IBOutlet UITextField *firstName;
    
    IBOutlet UIButton *saveBtnAction;
    IBOutlet UITextField *expryYrTxtFld;
    IBOutlet UITextField *expiryMnth;
    IBOutlet UIButton *cardTypeBtn;
    IBOutlet UITextField *accountNmberTxtFld;
    IBOutlet UITextField *lastNAme;
    
    IBOutlet UITextField *CvvNmberTxtFld;
   
    IBOutlet UIButton *saveCreditCardBackBtn;
}

@end
