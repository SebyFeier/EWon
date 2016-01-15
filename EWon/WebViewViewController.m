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

@interface WebViewViewController ()<UIWebViewDelegate, UITextFieldDelegate> {
    NSInteger repeat;
    BOOL isPasswordEnabled;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;

@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    self.webView.scalesPageToFit = YES;
    self.navigationItem.hidesBackButton = YES;
//    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(logoutButtonTapped:)];
//    self.navigationItem.rightBarButtonItem = logoutButton;
    self.webView.hidden = YES;
    self.passwordTextField.hidden = NO;
    self.connectButton.hidden = NO;
    self.passwordTextField.delegate = self;
    self.passwordTextField.secureTextEntry = YES;
    repeat = 0;
    isPasswordEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)connectButtonTapped:(id)sender {
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('vncpasswordeWon bise clima40615').value = '%@'", @"clima01"]];
    isPasswordEnabled = YES;
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('connect').click();"];
    [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
}

//- (void)logoutButtonTapped:(id)sender {
//    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(logoutButtonTapped:)];
//    self.navigationItem.rightBarButtonItem = logoutButton;
//    NSString *username = [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('vncpasswordeWon bise clima40615').value = '%@'", @"clima01"]];
//    [self performSelector:@selector(tap) withObject:nil afterDelay:2];
//
//}

//- (void)tap {
//    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('connect').click();"];
//    self.webView.hidden = NO;
//}

- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
    [self performSelector:@selector(logout) withObject:nil afterDelay:1];
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('cancel').click();"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('userIdentity').getElementsByTagName('a')[0].click();"];
    //vncpasswordeWon bise clima40615
    //connect

}

- (void)logout {
    [MBProgressHUD hideHUDForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *webViewText = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerText;"];
    if (isPasswordEnabled) {
        [self.passwordTextField resignFirstResponder];
        self.webView.hidden = NO;
        self.passwordTextField.hidden = YES;
        self.connectButton.hidden = YES;
        self.navigationController.navigationBarHidden = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } else {
        self.webView.hidden = YES;
        self.passwordTextField.hidden = NO;
        self.connectButton.hidden = NO;
    }
    if ([webViewText rangeOfString:@"Login"].location != NSNotFound) {
        if (repeat == 0) {
            NSString *username = [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('username').value = '%@'", [[WebServiceManager sharedInstance] username]]];
            
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('password').value = '%@'", [[WebServiceManager sharedInstance] password]]];
            if ([username length]) {
                [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('regular').style.display = 'none';"];
                [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('connect').click();"];
            }
            repeat++;
        } else {
            if ([webViewText rangeOfString:@"Sorry"].location != NSNotFound) {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, too many concurrent connections for this account" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            } else {
                self.webView.hidden = YES;
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if ([webViewText rangeOfString:@"Enter VNC password"].location != NSNotFound) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('regular').style.display = 'inline';"];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } else if ([webViewText rangeOfString:@"Welcome"].location != NSNotFound) {
//        self.webView.hidden = YES;
        [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('userIdentity').getElementsByTagName('a')[0].click();"];
//        [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('container').style.display = 'none';"];

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
