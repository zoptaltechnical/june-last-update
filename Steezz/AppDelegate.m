//
//  AppDelegate.m
//  Steezz
//
//  Created by Apple on 05/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//


//    com.zoptal.blitz   identifier for test Flight .

//    com.zoptal.chinaMoon identifire for running app on devices.

#import "AppDelegate.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    
        
     [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction:@"EOiEnYkQfcuHN45knuphrEN-MNJ8KFkb3vXHDqgj5RSkhPcUb8HMGrsCEKIuKMP4gC4B19qso7JyRfg0",PayPalEnvironmentSandbox:@"Ae6QnxsdQgyUZSzuMSA306aEbaAf6RFe4ea934EgWtow7knriA_O3qcLI1exXEUgnng3zFZ4HyLhFkfT"}];
    // Override point for customization after application launch.
    return YES;
}


#pragma mark  Loader 

-(void)startLoader:(UIView*)view withTitle:(NSString*)message
{
    [self.window setUserInteractionEnabled:FALSE];
    [GMDCircleLoader setOnView:self.window withTitle:@"Loading ..." animated:YES];
    
}

- (void)stopLoader:(UIView*)view
{
    [self.window setUserInteractionEnabled:TRUE];
    [GMDCircleLoader hideFromView:self.window animated:YES];
    
}


#pragma mark : Url Scheme method

-(BOOL) application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options
{
    if ([[url absoluteString] rangeOfString:@"fb1701866856509602"].location != NSNotFound)
    {
        //Facebook
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                           annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
        
    return YES;
}

-(BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[url absoluteString] rangeOfString:@"fb1701866856509602"].location != NSNotFound)
    {
        //Facebook
        
        
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
