//
//  disclaimerViewController.m
//  Steezz
//
//  Created by Apple on 24/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "disclaimerViewController.h"

@interface disclaimerViewController ()<UIWebViewDelegate>

@end

@implementation disclaimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    disWebView.delegate = self;
    
    NSURL *url = [NSURL URLWithString:@"http://workmeappit.com/steezz/disclaimer"];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [disWebView loadRequest:requestObj];
    // Do any additional setup after loading the view.
}

- (IBAction)disBackBtnAction:(id)sender {
    
       [self.navigationController popViewControllerAnimated:YES];
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [Appdelegate startLoader:nil withTitle:@"Loading..."];
    
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [Appdelegate stopLoader:nil];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"webview error:%@",[error localizedDescription]);
}

@end
