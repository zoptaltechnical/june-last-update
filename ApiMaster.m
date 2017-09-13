//
//  ApiMaster.m
//
//  Created by Prince Mehra on 11/3/17.
//  Copyright (c) 2017 Prince Mehra. All rights reserved.
//

#import "ApiMaster.h"
#import "UIAlertView+Blocks.h"

typedef void (^APICompletionHandler)(NSDictionary* responseDict,NSError *error);


@implementation ApiMaster


static ApiMaster* singleton = nil;

+(ApiMaster*)singleton
{
    if(singleton == nil)
        singleton = [[self alloc] init];
    return singleton;
}
-(id)init
{
    if(self = [super init])
    {
    }
    return self;
}


-(void)FaceBookSignInWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
    
    //   facebook_id, first_name, last_name, email, profile_pic, device_token, device_type
    
    NSString* infoStr = [NSString stringWithFormat:@"first_name=%@&email=%@&last_name=%@&profile_pic=%@&device_token=%@&device_type=%@&facebook_id=%@",userInfo [@"first_name"],userInfo[@"email"],userInfo[@"last_name"],userInfo [@"profile_pic"],userInfo[@"device_token"],userInfo[@"device_type"],userInfo[@"facebook_id"]];
    
    
    McomLOG(@"infostr :%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@fblogin",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"that is the url -->%@",url);
    
    
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] ];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:540];
    
    NSLog(@" request at sign up%@",request);
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
    
    
}


-(void)GooglePlusSignInWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
    
    
    NSString* infoStr = [NSString stringWithFormat:@"name=%@&email=%@&address=%@&latitude=%@&longitude=%@&device_token=%@&device_type=%@&g_id=%@",userInfo [@"name"],userInfo[@"email"],userInfo[@"address"],userInfo [@"longitude"],userInfo[@"latitude"],userInfo[@"device_token"],userInfo[@"device_type"],userInfo[@"g_id"]];
    
    
    McomLOG(@"infostr :%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@google_register",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"that is the url -->%@",url);
    
    
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] ];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:540];
    
    NSLog(@" request at sign up%@",request);
    [self forwardRequest1:request showActivity:YES completionHandler:handler];

    
    
    
    
}



# pragma mark - Register user API
-(void)getCategoriesList:(NSMutableDictionary*)userInfo
        completionHandler:(APICompletionHandler)handler
{

    NSString* infoStr = [NSString stringWithFormat:@"access_token=%@",userInfo[@"access_token"]];
    NSLog(@"infoStr AT LOGIN %@",infoStr);
    
    NSString *url=[[NSString stringWithFormat:@"%@get_categories",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"that is URL -->%@",url);
    
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Category Request URL %@",request);
    
    
    [request setTimeoutInterval:540];
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
}




# pragma mark - Register user API
-(void)signUpUserWithInfo:(NSMutableDictionary*)userInfo
          completionHandler:(APICompletionHandler)handler
{
    
     NSString* infoStr = [NSString stringWithFormat:@"first_name=%@&last_name=%@&email=%@&phone=%@&address=%@&password=%@&device_token=%@&device_type=%@&cpassword=%@&city=%@&state=%@&zip_code=%@&date_of_birth=%@",userInfo [@"first_name"],userInfo[@"last_name"],userInfo [@"email"],userInfo[@"phone"],userInfo [@"address"],userInfo[@"password"],userInfo[@"device_token"],userInfo[@"device_type"],userInfo[@"cpassword"],userInfo[@"city"],userInfo[@"state"],userInfo[@"zip_code"],userInfo[@"date_of_birth"]];
    
    McomLOG(@"infostr :%@",infoStr);
    
    NSString *url=[[NSString stringWithFormat:@"%@register",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"that is the url -->%@",url);
    
    
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] ];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:540];
    
    NSLog(@" request at sign up%@",request);
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
}


# pragma mark - Login user API
-(void)signInUserWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{

    NSString* infoStr = [NSString stringWithFormat:@"username=%@&password=%@&device_token=%@&device_type=%@",userInfo[@"username"], userInfo[@"password"],userInfo[@"device_token"] ,userInfo [@"device_type"]];
    NSLog(@"infoStr AT LOGIN %@",infoStr);
    
        NSString *url=[[NSString stringWithFormat:@"%@login",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"that is URL -->%@",url);
    
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"REQUEST AT LOGIN %@",request);
    
    
    [request setTimeoutInterval:540];
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
}

# pragma mark - Forgot Password API

-(void)ForgotPasswrodWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler

{
    //   http://workmeappit.com/test/home/forgot_password
    
    NSString* infoStr = [NSString stringWithFormat:@"email=%@",userInfo[@"email"]];
        NSLog(@"%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@forgot_password",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Request At Frogot %@",request);
    [request setTimeoutInterval:540];
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
}







-(void)HomePageWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler

{
  
    NSString* infoStr = [NSString stringWithFormat:@"category=%@&search=%@&page_no=%@&no_of_post=%@",userInfo[@"category"], userInfo[@"search"],userInfo[@"page_no"] ,userInfo [@"no_of_post"]];
    NSLog(@"infoStr AT LOGIN %@",infoStr);
    
    NSString *url=[[NSString stringWithFormat:@"%@menu_data",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"that is URL -->%@",url);
    
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"REQUEST AT LOGIN %@",request);
    
    
    [request setTimeoutInterval:540];
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
    
}

-(void)myProfileWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler

{
     NSString* infoStr = [NSString stringWithFormat:@"access_token=%@",userInfo[@"access_token"]];
        NSLog(@"%@",infoStr);
     NSString *url=[[NSString stringWithFormat:@"%@profile_data",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
     NSLog(@"Request At profile %@",request);
    [request setTimeoutInterval:540];
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
    
}


-(void)UpdateProfileWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
    
    
    NSString* infoStr = [NSString stringWithFormat:@"access_token=%@&device_token=%@&device_type=%@&first_name=%@&last_name=%@&email=%@&phone=%@&city=%@&address=%@&about_user=%@&profile_pic=%@&paypal_id=%@&zip_code=%@&state=%@",userInfo[@"access_token"],userInfo[@"device_token"],userInfo[@"device_type"],userInfo[@"first_name"],userInfo[@"last_name"],userInfo[@"email"],userInfo[@"phone"],userInfo[@"city"],userInfo[@"address"],userInfo[@"about_user"],userInfo[@"profile_pic"],userInfo[@"paypal_id"],userInfo[@"zip_code"],userInfo[@"state"]];
    NSLog(@"%@",infoStr);
    
    
    NSLog(@"infoStr  =  %@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@update_profile",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Request At profile %@",request);
    [request setTimeoutInterval:540];
    [self forwardRequest1:request showActivity:YES completionHandler:handler];

    
}


-(void)AddProductWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
    
    NSString* infoStr = [NSString stringWithFormat:@"cat_id=%@&product_name=%@&product_desc=%@&location=%@&unavailable_dates=%@&is_available=%@&access_token=%@&product_image=%@&price=%@",userInfo[@"cat_id"],userInfo[@"product_name"],userInfo[@"product_desc"],userInfo[@"location"],userInfo[@"unavailable_dates"],userInfo[@"is_available"],userInfo[@"access_token"],userInfo[@"product_image"],userInfo[@"price"]];
    NSLog(@"%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@add_product",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Request At profile %@",request);
    [request setTimeoutInterval:540];
    [self forwardRequest1:request showActivity:YES completionHandler:handler];

    
    
    
    
}



-(void)LenderHomeFeedWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
    
    NSString* infoStr = [NSString stringWithFormat:@"access_token=%@" ,userInfo [@"access_token"]];
    
    NSLog(@"%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@listing_feeds",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Request At Lender Home Feed %@",request);
    [request setTimeoutInterval:540];
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
    
    
}






-(void)LogoutWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler

{
    NSString* infoStr = [NSString stringWithFormat:@"access_token=%@",userInfo[@"access_token"]];
    NSLog(@"%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@logout",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Request At Logout %@",request);
    [request setTimeoutInterval:540];
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
    
}





-(void)changePasswordWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
    NSString* infoStr = [NSString stringWithFormat:@"old_password=%@&password=%@&cpassword=%@&access_token=%@",userInfo[@"old_password"],userInfo[@"password"],userInfo[@"cpassword"] ,userInfo[@"access_token"]];
    NSLog(@"%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@change_password",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Request At Change Password %@",request);
    [request setTimeoutInterval:540];
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
    
}

-(void)ProductDetailWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
    
    
    NSString* infoStr = [NSString stringWithFormat:@"product_id=%@&access_token=%@",userInfo[@"product_id"],userInfo[@"access_token"]];
    NSLog(@"%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@product_details",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Request At Product Detail %@",request);
    [request setTimeoutInterval:540];
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
    
    
}



-(void)SaveProductWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
    
    
    NSString* infoStr = [NSString stringWithFormat:@"product_id=%@&access_token=%@",userInfo[@"product_id"],userInfo[@"access_token"]];
    NSLog(@"%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@save_product",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Request At save product %@",request);
    [request setTimeoutInterval:540];
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
    

    
}


-(void)LenderSavedProductWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
    NSString* infoStr = [NSString stringWithFormat:@"access_token=%@",userInfo[@"access_token"]];
    NSLog(@"%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@saved_products",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Request At saved Product %@",request);
    [request setTimeoutInterval:540];
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
    
}


-(void)SwitchToLenderWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
    
    NSString* infoStr = [NSString stringWithFormat:@"user_type=%@&access_token=%@",userInfo[@"user_type"],userInfo[@"access_token"]];
    NSLog(@"%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@switch_to",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Request At switch to lender %@",request);
    [request setTimeoutInterval:540];
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
    

    
    
}

-(void)LenderSupportWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
    
    
    NSString* infoStr = [NSString stringWithFormat:@"name=%@&email=%@&message=%@&access_token=%@",userInfo[@"name"],userInfo[@"email"],userInfo[@"message"] ,userInfo[@"access_token"]];
    NSLog(@"%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@support",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Request At support lender %@",request);
    [request setTimeoutInterval:540];
    [self forwardRequest1:request showActivity:YES completionHandler:handler];

    
    
}


-(void)LenderFeedbackWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
    
    NSString* infoStr = [NSString stringWithFormat:@"rate=%@&message=%@&access_token=%@",userInfo[@"rate"],userInfo[@"message"] ,userInfo[@"access_token"]];
    NSLog(@"%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@send_feedback",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Request At support lender %@",request);
    [request setTimeoutInterval:540];
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
    
    
}

-(void)BookProductWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
    
    NSString* infoStr = [NSString stringWithFormat:@"product_id=%@&booking_dates=%@&access_token=%@",userInfo[@"product_id"],userInfo[@"booking_dates"] ,userInfo[@"access_token"]];
    NSLog(@"%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@is_booking_available",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Request At support lender %@",request);
    [request setTimeoutInterval:540];
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
 
}


-(void)BookingListWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
 
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%@&access_token=%@",userInfo[@"user_id"],userInfo[@"access_token"]];
    NSLog(@"%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@get_host_details",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Request At support lender %@",request);
    [request setTimeoutInterval:540];
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
    
}


-(void)LendeeProductListingWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
    
    NSString* infoStr = [NSString stringWithFormat:@"access_token=%@",userInfo[@"access_token"]];
    NSLog(@"%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@get_host_products",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Request At support lender %@",request);
    [request setTimeoutInterval:540];
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
 
}


-(void)LendeeDeleteProductWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
    
    NSString* infoStr = [NSString stringWithFormat:@"product_id=%@&access_token=%@",userInfo[@"product_id"],userInfo[@"access_token"]];
    NSLog(@"%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@delete_product",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Request At support lender %@",request);
    [request setTimeoutInterval:540];
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
    
}



-(void)DeleteCardWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
   
    NSString* infoStr = [NSString stringWithFormat:@"card_id=%@&access_token=%@",userInfo[@"card_id"],userInfo[@"access_token"]];
    NSLog(@"%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@remove_credit_card",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Request At support lender %@",request);
    [request setTimeoutInterval:540];
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
    
    
}


-(void)LenderSearchProductWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
   
    NSString* infoStr = [NSString stringWithFormat:@"access_token=%@&cat_id=%@&available_date=%@&location=%@&price=%@",userInfo[@"access_token"],userInfo[@"cat_id"] ,userInfo[@"available_date"],userInfo[@"location"],userInfo[@"price"]];
    NSLog(@"%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@search_products",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Request At support lender %@",request);
    [request setTimeoutInterval:540];
    [self forwardRequest1:request showActivity:YES completionHandler:handler];

    
}

-(void)EditProductWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler{
    
    
    NSString* infoStr = [NSString stringWithFormat:@"access_token=%@&product_id=%@&cat_id=%@&product_name=%@&product_desc=%@&location=%@&unavailable_dates=%@&is_available=%@&price=%@&product_image=%@" ,userInfo [@"access_token"],userInfo [@"product_id"],userInfo[@"cat_id"],userInfo [@"product_name"],userInfo[@"product_desc"],userInfo [@"location"],userInfo[@"unavailable_dates"],userInfo [@"is_available"],userInfo [@"price"],userInfo[@"product_image"]];
    
    NSLog(@"%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@edit_product",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Request At Frogot %@",request);
    [request setTimeoutInterval:540];
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
}

-(void)paypalPaymentSucessWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
    
    NSString* infoStr = [NSString stringWithFormat:@"access_token=%@&product_id=%@&txd_id=%@&booking_dates=%@&amount=%@&create_time=%@&trans_fees=%@&total_amount=%@" ,userInfo [@"access_token"],userInfo[@"product_id"],userInfo [@"txd_id"],userInfo[@"booking_dates"],userInfo [@"amount"],userInfo[@"create_time"],userInfo[@"trans_fees"],userInfo[@"total_amount"]];
    
    McomLOG(@"infostr :%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@paypal_payment",creditCardURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"that is the url -->%@",url);
    
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] ];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:540];
    
    NSLog(@" request at sign up%@",request);
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
    
}

-(void)FreeBookingWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
    
    NSString* infoStr = [NSString stringWithFormat:@"access_token=%@&product_id=%@&booking_dates=%@&amount=%@" ,userInfo [@"access_token"],userInfo[@"product_id"],userInfo[@"booking_dates"],userInfo [@"amount"]];
    
    McomLOG(@"infostr :%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@free_booking",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"that is the url -->%@",url);
    
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] ];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:540];
    
    NSLog(@" request at sign up%@",request);
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
    
}






-(void)StartReportWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
    
    NSString* infoStr = [NSString stringWithFormat:@"access_token=%@&cat_id=%@&description=%@&report_type=%@&product_image=%@&host_email=%@" ,userInfo [@"access_token"],userInfo[@"cat_id"],userInfo [@"description"],userInfo[@"report_type"],userInfo [@"product_image"],userInfo[@"host_email"]];
    
    McomLOG(@"infostr :%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@add_report",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"that is the url -->%@",url);
    
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] ];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:540];
    
    NSLog(@" request at sign up%@",request);
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
    
}


-(void)ReportListtingWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
    
    NSString* infoStr = [NSString stringWithFormat:@"access_token=%@" ,userInfo [@"access_token"]];
    McomLOG(@"infostr :%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@get_reports",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"that is the url -->%@",url);
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] ];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:540];
    
    NSLog(@" request at sign up%@",request);
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
  
}


-(void)DeleteReportWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
    
    NSString* infoStr = [NSString stringWithFormat:@"report_id=%@&access_token=%@",userInfo[@"report_id"],userInfo[@"access_token"]];
    NSLog(@"%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@delete_report",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Request At support lender %@",request);
    [request setTimeoutInterval:540];
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
    
}

-(void)LenderEmailsWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
    NSString* infoStr = [NSString stringWithFormat:@"access_token=%@",userInfo[@"access_token"]];
    NSLog(@"%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@booking_products_host_emails",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Request At support lender %@",request);
    [request setTimeoutInterval:540];
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
}



-(void)BookingHistoryWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
    
    NSString* infoStr = [NSString stringWithFormat:@"access_token=%@",userInfo[@"access_token"]];
    NSLog(@"%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@booking_history",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Request At support lender %@",request);
    [request setTimeoutInterval:540];
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
  
}

-(void)MessageWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{

    NSString* infoStr = [NSString stringWithFormat:@"access_token=%@&receiver_id=%@&message=%@&image=%@&date_time=%@" ,userInfo [@"access_token"],userInfo[@"receiver_id"],userInfo [@"message"],userInfo[@"image"],userInfo [@"date_time"]];
    
    McomLOG(@"infostr :%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@send_message",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"that is the url -->%@",url);
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] ];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:540];
    NSLog(@" request at sign up%@",request);
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
   
}

-(void)LenderChatUserListingInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{

    NSString* infoStr = [NSString stringWithFormat:@"access_token=%@" ,userInfo [@"access_token"]];
    
    McomLOG(@"infostr :%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@inbox",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"that is the url -->%@",url);
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] ];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:540];
    NSLog(@" request at sign up%@",request);
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
  
}


-(void)LoadAllMessagesWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
    
    NSString* infoStr = [NSString stringWithFormat:@"access_token=%@&conversation_id=%@",userInfo [@"access_token"],userInfo[@"conversation_id"]];
    
    McomLOG(@"infostr :%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@conversation",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"that is the url -->%@",url);
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] ];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:540];
    NSLog(@" request at sign up%@",request);
    [self forwardRequest1:request showActivity:YES completionHandler:handler];

}


-(void)GetConversationIDWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{

    NSString* infoStr = [NSString stringWithFormat:@"access_token=%@&receiver_id=%@" ,userInfo [@"access_token"],userInfo[@"receiver_id"]];
    McomLOG(@"infostr :%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@get_conversation_id",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"that is the url -->%@",url);
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] ];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:540];
    NSLog(@" request at sign up%@",request);
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
   
}

-(void)CreditCardPaymnetWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
   // access_token, product_id, start_date, end_date, payment_by = new_card, save_cc_id, cc_fname, cc_lname, cc_number, card_type, exp_month, exp_year, cvv, save_credit_card
    
    
    NSString* infoStr = [NSString stringWithFormat:@"access_token=%@&product_id=%@&booking_dates=%@&payment_by=%@&save_cc_id=%@&cc_fname=%@&cc_lname=%@&cc_number=%@&card_type=%@&exp_month=%@&exp_year=%@&cvv=%@&save_credit_card=%@  " ,userInfo [@"access_token"],userInfo[@"product_id"],userInfo [@"booking_dates"],userInfo [@"payment_by"],userInfo[@"save_cc_id"] ,       userInfo [@"cc_fname"],userInfo[@"cc_lname"],userInfo [@"cc_number"],userInfo[@"card_type"],userInfo [@"exp_month"],userInfo[@"exp_year"] ,userInfo[@"cvv"],userInfo[@"save_credit_card"]];
    
    McomLOG(@"infostr :%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@make_payment",webURLCardSaving] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"that is the url -->%@",url);
    
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] ];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:540];
    
    NSLog(@" request at sign up%@",request);
    [self forwardRequest1:request showActivity:YES completionHandler:handler];

    
    
    
}

-(void)SavedCreditCardWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
    
    
    NSString* infoStr = [NSString stringWithFormat:@"access_token=%@" ,userInfo [@"access_token"]];
    McomLOG(@"infostr :%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@saved_credit_cards",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"that is the url -->%@",url);
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] ];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:540];
    NSLog(@" request at sign up%@",request);
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
}

-(void)EditReportWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
    
    NSString* infoStr = [NSString stringWithFormat:@"access_token=%@&report_id=%@&cat_id=%@&description=%@&report_type=%@&host_email=%@&product_image=%@" ,userInfo [@"access_token"],userInfo[@"report_id"],userInfo [@"cat_id"],userInfo[@"description"],userInfo [@"report_type"],userInfo[@"host_email"],userInfo[@"product_image"]];
    
    McomLOG(@"infostr :%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@edit_report",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"that is the url -->%@",url);
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] ];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:540];
    NSLog(@" request at sign up%@",request);
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
}

-(void)DashboardtWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{

    NSString* infoStr = [NSString stringWithFormat:@"access_token=%@" ,userInfo [@"access_token"]];
    McomLOG(@"infostr :%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@get_host_dashboard",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"that is the url -->%@",url);
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] ];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:540];
    NSLog(@" request at sign up%@",request);
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
}


-(void)NotificationWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
    NSString* infoStr = [NSString stringWithFormat:@"access_token=%@" ,userInfo [@"access_token"]];
    McomLOG(@"infostr :%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@notifications",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"that is the url -->%@",url);
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] ];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:540];
    NSLog(@" request at sign up%@",request);
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
 
}





-(void)MyOrderWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler

{
    NSString* infoStr = [NSString stringWithFormat:@"access_token=%@",userInfo[@"access_token"]];
    McomLOG(@"infostr :%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@renter_current_bookings",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"that is the url -->%@",url);
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] ];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:540];
    NSLog(@" request at sign up%@",request);
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
    
}



-(void)NewCardSavingWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
 
    NSString* infoStr = [NSString stringWithFormat:@"access_token=%@&cc_fname=%@&cc_lname=%@&cc_number=%@&card_type=%@&exp_month=%@&exp_year=%@&cvv=%@",userInfo [@"access_token"],userInfo [@"cc_fname"],userInfo[@"cc_lname"],userInfo [@"cc_number"],userInfo[@"card_type"],userInfo [@"exp_month"],userInfo[@"exp_year"] ,userInfo[@"cvv"]];
    
    McomLOG(@"infostr :%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@save_credit_card",webURLCardSaving] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"that is the url -->%@",url);
    
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] ];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:540];
    
    NSLog(@" request at sign up%@",request);
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
   
}

-(void)paymentListingWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
    
    
    
    NSString* infoStr = [NSString stringWithFormat:@"access_token=%@",userInfo [@"access_token"]];
    
    McomLOG(@"infostr :%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@payment_history",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"that is the url -->%@",url);
    
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] ];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:540];
    
    NSLog(@" request at sign up%@",request);
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
    
    
    
}



-(void)PayPalDescriptionWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler
{
    
    NSString* infoStr = [NSString stringWithFormat:@"access_token=%@",userInfo[@"access_token"]];
    NSLog(@"%@",infoStr);
    NSString *url=[[NSString stringWithFormat:@"%@admin_paypal_credentials",WebURl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Request At support lender %@",request);
    [request setTimeoutInterval:540];
    [self forwardRequest1:request showActivity:YES completionHandler:handler];
    
}






















#pragma mark request to Server
-(void)forwardRequest:(NSMutableURLRequest*)request showActivity:(BOOL)showActivity

    completionHandler:(APICompletionHandler)handler
{
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
  
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         if(connectionError != nil)
         {
             
             [[[UIAlertView alloc] initWithTitle:@"Connection Error !" message:@"No Internet Connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
             return;
         }
         McomLOG(@"Response String %@", NSStringFromNSData(data));
         if(handler != nil)
             handler(JSONObjectFromData(data),connectionError);
     }];
}
#pragma mark request1 to Server
-(void)forwardRequest1:(NSMutableURLRequest*)request showActivity:(BOOL)showActivity
    completionHandler:(APICompletionHandler)handler
{
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
   
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         if(connectionError != nil)
         {
             
            [[[UIAlertView alloc] initWithTitle:@"Connection Error !" message:@"No Internet Connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
             
            [Appdelegate stopLoader:nil];
             
              return;
         }
         McomLOG(@"Response String %@", NSStringFromNSData(data));
         if(handler != nil)
             handler(JSONObjectFromData(data),connectionError);
     }];
}


#pragma mark request1 to Server
-(void)forwardRequest2:(NSMutableURLRequest*)request showActivity:(BOOL)showActivity
     completionHandler:(APICompletionHandler)handler
{
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         if(connectionError != nil)
         {
             
             [[[UIAlertView alloc] initWithTitle:@"Connection Error !" message:@"No Internet Connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
             
             [Appdelegate stopLoader:nil];
             
             return;
         }
         McomLOG(@"Response String %@", NSStringFromNSData(data));
         if(handler != nil)
             handler(JSONObjectFromData(data),connectionError);
     }];
}

#pragma mark request1 to Server
-(void)forwardGetServive:(NSMutableURLRequest*)request showActivity:(BOOL)showActivity
     completionHandler:(APICompletionHandler)handler
{
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         if(connectionError != nil)
         {
          
             
             [[[UIAlertView alloc] initWithTitle:@"Connection Error !" message:@"No Internet Connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
             return;
         }
         McomLOG(@"Response String %@", NSStringFromNSData(data));
         if(handler != nil)
             handler(JSONObjectFromData(data),connectionError);
     }];
}

@end
