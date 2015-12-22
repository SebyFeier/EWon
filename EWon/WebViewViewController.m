//
//  WebViewViewController.m
//  EWon
//
//  Created by Seby Feier on 02/12/15.
//  Copyright © 2015 Seby Feier. All rights reserved.
//

#import "WebViewViewController.h"
#import "WebServiceManager.h"
#import "MBProgressHUD.h"

@interface WebViewViewController ()<UIWebViewDelegate> {
    NSInteger repeat;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    self.webView.scalesPageToFit = YES;
    repeat = 0;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
    [self performSelector:@selector(logout) withObject:nil afterDelay:1];
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('cancel').click();"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('userIdentity').getElementsByTagName('a')[0].click();"];

}

- (void)logout {
    [MBProgressHUD hideHUDForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (repeat == 0) {
        NSString *username = [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('username').value = '%@'", [[WebServiceManager sharedInstance] username]]];
        
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('password').value = '%@'", [[WebServiceManager sharedInstance] password]]];
        if ([username length]) {
            [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('regular').style.display = 'none';"];
            [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('connect').click();"];
        }
        repeat++;
    } else {
        [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('regular').style.display = 'inline';"];
    }
}



//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    return YES;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
