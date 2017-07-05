//
//  ApiMaster.h
//  
//
//  Created by Prince Mehra on 11/3/17.
//  Copyright (c) 2017 Prince Mehra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utility.h"
#import "Constants.h"

typedef void (^APICompletionHandler)(NSDictionary* responseDict,NSError *error);

@interface ApiMaster : NSObject


+(ApiMaster*)singleton;


-(void)FaceBookSignInWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)signUpUserWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)signInUserWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)ForgotPasswrodWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)myProfileWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)UpdateProfileWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)LenderHomeFeedWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)getCategoriesList:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)AddProductWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)LogoutWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)HomePageWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)ProductDetailWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)SaveProductWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)LenderSavedProductWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)LenderSearchProductWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)SwitchToLenderWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)LenderSupportWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)LenderFeedbackWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)BookProductWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)BookingListWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)LendeeProductListingWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)LendeeDeleteProductWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)EditProductWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)paypalPaymentSucessWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)StartReportWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)ReportListtingWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)DeleteReportWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)LenderEmailsWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)BookingHistoryWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)LenderChatUserListingInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)MessageWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)LoadAllMessagesWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)GetConversationIDWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)CreditCardPaymnetWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)SavedCreditCardWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)EditReportWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)DashboardtWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)NotificationWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)changePasswordWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)MyOrderWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;

-(void)NewCardSavingWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;










@end
