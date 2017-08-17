//
//  AboutUsViewController.m
//  Steezz
//
//  Created by Apple on 24/05/17.
//  Copyright © 2017 Prince. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()<UIWebViewDelegate>

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    aboutUsWebView.delegate = self;
    
    NSURL *url = [NSURL URLWithString:@"https://zoptal.com/demo/steezz/about_us"];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [aboutUsWebView loadRequest:requestObj];
    
    // Do any additional setup after loading the view.
}
- (IBAction)backBtnAction:(id)sender {
    
    
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
