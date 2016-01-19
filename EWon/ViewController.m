//
//  ViewController.m
//  EWon
//
//  Created by Seby Feier on 21/11/15.
//  Copyright © 2015 Seby Feier. All rights reserved.
//

#import "ViewController.h"
#import "WebServiceManager.h"
#import "AccountInfoViewController.h"
#import "MBProgressHUD.h"
#import "EwonListViewController.h"

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountLabel;
@property (weak, nonatomic) IBOutlet UITextField *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.accountLabel.text = @"";
    self.usernameLabel.text = @"";
    self.passwordLabel.text = @"";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.logoImage setImage:[UIImage imageNamed:@"logo_2"]];
    } else {
        [self.logoImage setImage:[UIImage imageNamed:@"taib-logo"]];
    }
        self.accountLabel.text = @"TAIB automation";
        self.usernameLabel.text = @"AlexP";
        self.passwordLabel.text = @"Ap123456";
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.accountLabel.text = @"TAIB automation";
    //    self.usernameLabel.text = @"AlexP";
    //    self.passwordLabel.text = @"Ap123456";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"account"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"username"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"password"]) {
        [[WebServiceManager sharedInstance] setAccount:[[NSUserDefaults standardUserDefaults] objectForKey:@"account"]];
        [[WebServiceManager sharedInstance] setUsername:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
        [[WebServiceManager sharedInstance] setPassword:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]];
        [[WebServiceManager sharedInstance] setSessionId:[[NSUserDefaults standardUserDefaults] objectForKey:@"sessionId"]];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[WebServiceManager sharedInstance] getAccountInfoWithCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (dictionary) {
                if (![[dictionary objectForKey:@"success"] boolValue]) {
                    if ([dictionary[@"code"] integerValue] == 403) {
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        [[WebServiceManager sharedInstance] loginWithAccount:[[NSUserDefaults standardUserDefaults] objectForKey:@"account"]
                                                                    username:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]
                                                                 andPassword:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                                                                     NSLog(@"%@",dictionary);
                                                                     if (dictionary) {
                                                                         if ([[dictionary objectForKey:@"code"] integerValue] == 429) {
                                                                             [[WebServiceManager sharedInstance] logoutWithCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                                                                                 if ([dictionary[@"success"] boolValue]) {
                                                                                     [[WebServiceManager sharedInstance] loginWithAccount:[[NSUserDefaults standardUserDefaults] objectForKey:@"account"]
                                                                                                                                 username:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]                                                                                              andPassword:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                                                                                                                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                                                                     NSLog(@"%@",dictionary);
                                                                                                                                     if (dictionary) {
                                                                                                                                         if ([[dictionary objectForKey:@"code"] integerValue] == 429) {
                                                                                                                                             
                                                                                                                                         } else {
                                                                                                                                             if (![[dictionary objectForKey:@"success"] boolValue]) {
                                                                                                                                                 UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                                                                                                message:dictionary[@"message"]
                                                                                                                                                                                                         preferredStyle:UIAlertControllerStyleAlert];
                                                                                                                                                 
                                                                                                                                                 UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                                                                                                                       handler:^(UIAlertAction * action) {}];
                                                                                                                                                 
                                                                                                                                                 [alert addAction:defaultAction];
                                                                                                                                                 [self presentViewController:alert animated:YES completion:nil];
                                                                                                                                             } else {
                                                                                                                                                 [WebServiceManager sharedInstance].sessionId = dictionary[@"t2msession"];
                                                                                                                                                 //            [WebServiceManager sharedInstance].sessionId = @"123abc456";
                                                                                                                                                 [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                                                                                                                 [[WebServiceManager sharedInstance] getAccountInfoWithCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                                                                                                                                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                                                                                     if (dictionary) {
                                                                                                                                                         if (![[dictionary objectForKey:@"success"] boolValue]) {
                                                                                                                                                             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                                                                                                            message:dictionary[@"message"]
                                                                                                                                                                                                                     preferredStyle:UIAlertControllerStyleAlert];
                                                                                                                                                             
                                                                                                                                                             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                                                                                                                                   handler:^(UIAlertAction * action) {}];
                                                                                                                                                             
                                                                                                                                                             [alert addAction:defaultAction];
                                                                                                                                                             [self presentViewController:alert animated:YES completion:nil];
                                                                                                                                                         } else {
                                                                                                                                                             //                                                                                                                                                             AccountInfoViewController *accountInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountInfoViewControllerIdentifier"];
                                                                                                                                                             //                                                                                                                                                             accountInfoViewController.accountInfo = dictionary;
                                                                                                                                                             //                                                                                                                                                             [self.navigationController pushViewController:accountInfoViewController animated:YES];
                                                                                                                                                             
                                                                                                                                                             NSDictionary *pool = [dictionary[@"pools"] firstObject];
                                                                                                                                                             [[WebServiceManager sharedInstance] getEwonsWithPool:pool[@"id"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                                                                                                                                                                 NSLog(@"%@",dictionary);
                                                                                                                                                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                                                                                                 if (dictionary) {
                                                                                                                                                                     if (![[dictionary objectForKey:@"success"] boolValue]) {
                                                                                                                                                                         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                                                                                                                        message:dictionary[@"message"]
                                                                                                                                                                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                                                                                                                                                                         
                                                                                                                                                                         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                                                                                                                                               handler:^(UIAlertAction * action) {}];
                                                                                                                                                                         
                                                                                                                                                                         [alert addAction:defaultAction];
                                                                                                                                                                         [self presentViewController:alert animated:YES completion:nil];
                                                                                                                                                                     } else {
                                                                                                                                                                         EwonListViewController *ewonListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EwonListViewControllerIdentifier"];
                                                                                                                                                                         ewonListViewController.ewonsList = dictionary;
                                                                                                                                                                         [self.navigationController pushViewController:ewonListViewController animated:YES];
                                                                                                                                                                     }
                                                                                                                                                                 } else {
                                                                                                                                                                     UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                                                                                                                    message:[error localizedDescription]
                                                                                                                                                                                                                             preferredStyle:UIAlertControllerStyleAlert];
                                                                                                                                                                     
                                                                                                                                                                     UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                                                                                                                                           handler:^(UIAlertAction * action) {}];
                                                                                                                                                                     
                                                                                                                                                                     [alert addAction:defaultAction];
                                                                                                                                                                     [self presentViewController:alert animated:YES completion:nil];
                                                                                                                                                                 }
                                                                                                                                                             }];
                                                                                                                                                         }
                                                                                                                                                     } else {
                                                                                                                                                         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                                                                                                        message:[error localizedDescription]
                                                                                                                                                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                                                                                                                                                         
                                                                                                                                                         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                                                                                                                               handler:^(UIAlertAction * action) {}];
                                                                                                                                                         
                                                                                                                                                         [alert addAction:defaultAction];
                                                                                                                                                         [self presentViewController:alert animated:YES completion:nil];
                                                                                                                                                     }
                                                                                                                                                     
                                                                                                                                                 }];
                                                                                                                                             }
                                                                                                                                         }
                                                                                                                                     } else {
                                                                                                                                         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                                                                                        message:[error localizedDescription]
                                                                                                                                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                                                                                                                                         
                                                                                                                                         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                                                                                                               handler:^(UIAlertAction * action) {}];
                                                                                                                                         
                                                                                                                                         [alert addAction:defaultAction];
                                                                                                                                         [self presentViewController:alert animated:YES completion:nil];
                                                                                                                                     }
                                                                                                                                 }];
                                                                                     
                                                                                     
                                                                                 } else {
                                                                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                     
                                                                                     UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                                    message:[error localizedDescription]
                                                                                                                                             preferredStyle:UIAlertControllerStyleAlert];
                                                                                     
                                                                                     UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                                                           handler:^(UIAlertAction * action) {}];
                                                                                     
                                                                                     [alert addAction:defaultAction];
                                                                                     [self presentViewController:alert animated:YES completion:nil];
                                                                                 }
                                                                             }];
                                                                         } else {
                                                                             if (dictionary) {
                                                                                 if (![[dictionary objectForKey:@"success"] boolValue]) {
                                                                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                     UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                                    message:dictionary[@"message"]
                                                                                                                                             preferredStyle:UIAlertControllerStyleAlert];
                                                                                     
                                                                                     UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                                                           handler:^(UIAlertAction * action) {}];
                                                                                     
                                                                                     [alert addAction:defaultAction];
                                                                                     [self presentViewController:alert animated:YES completion:nil];
                                                                                 } else {
                                                                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                     [WebServiceManager sharedInstance].sessionId = dictionary[@"t2msession"];
                                                                                     //            [WebServiceManager sharedInstance].sessionId = @"123abc456";
                                                                                     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                                                     [[WebServiceManager sharedInstance] getAccountInfoWithCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                                                                                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                         if (![[dictionary objectForKey:@"success"] boolValue]) {
                                                                                             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                                            message:dictionary[@"message"]
                                                                                                                                                     preferredStyle:UIAlertControllerStyleAlert];
                                                                                             
                                                                                             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                                                                   handler:^(UIAlertAction * action) {}];
                                                                                             
                                                                                             [alert addAction:defaultAction];
                                                                                             [self presentViewController:alert animated:YES completion:nil];
                                                                                         } else {
                                                                                             //                                                                                             AccountInfoViewController *accountInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountInfoViewControllerIdentifier"];
                                                                                             //                                                                                             accountInfoViewController.accountInfo = dictionary;
                                                                                             //                                                                                             [self.navigationController pushViewController:accountInfoViewController animated:YES];
                                                                                             
                                                                                             NSDictionary *pool = [dictionary[@"pools"] firstObject];
                                                                                             [[WebServiceManager sharedInstance] getEwonsWithPool:pool[@"id"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                                                                                                 NSLog(@"%@",dictionary);
                                                                                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                                 if (dictionary) {
                                                                                                     if (![[dictionary objectForKey:@"success"] boolValue]) {
                                                                                                         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                                                        message:dictionary[@"message"]
                                                                                                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                                                                                                         
                                                                                                         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                                                                               handler:^(UIAlertAction * action) {}];
                                                                                                         
                                                                                                         [alert addAction:defaultAction];
                                                                                                         [self presentViewController:alert animated:YES completion:nil];
                                                                                                     } else {
                                                                                                         EwonListViewController *ewonListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EwonListViewControllerIdentifier"];
                                                                                                         ewonListViewController.ewonsList = dictionary;
                                                                                                         [self.navigationController pushViewController:ewonListViewController animated:YES];
                                                                                                     }
                                                                                                 } else {
                                                                                                     UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                                                    message:[error localizedDescription]
                                                                                                                                                             preferredStyle:UIAlertControllerStyleAlert];
                                                                                                     
                                                                                                     UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                                                                           handler:^(UIAlertAction * action) {}];
                                                                                                     
                                                                                                     [alert addAction:defaultAction];
                                                                                                     [self presentViewController:alert animated:YES completion:nil];
                                                                                                 }
                                                                                             }];
                                                                                         }
                                                                                         
                                                                                     }];
                                                                                 }
                                                                             } else {
                                                                                 UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                                message:[error localizedDescription]
                                                                                                                                         preferredStyle:UIAlertControllerStyleAlert];
                                                                                 
                                                                                 UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                                                       handler:^(UIAlertAction * action) {}];
                                                                                 
                                                                                 [alert addAction:defaultAction];
                                                                                 [self presentViewController:alert animated:YES completion:nil];
                                                                             }
                                                                         }
                                                                     } else {
                                                                         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                                         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                        message:[error localizedDescription]
                                                                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                                                                         
                                                                         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                                               handler:^(UIAlertAction * action) {}];
                                                                         
                                                                         [alert addAction:defaultAction];
                                                                         [self presentViewController:alert animated:YES completion:nil];
                                                                     }
                                                                 }];
                        
                    } else {
                        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                       message:dictionary[@"message"]
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction * action) {}];
                        
                        [alert addAction:defaultAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                } else {
                    //                    AccountInfoViewController *accountInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountInfoViewControllerIdentifier"];
                    //                    accountInfoViewController.accountInfo = dictionary;
                    //                    [self.navigationController pushViewController:accountInfoViewController animated:YES];
                    
                    NSDictionary *pool = [dictionary[@"pools"] firstObject];
                    [[WebServiceManager sharedInstance] getEwonsWithPool:pool[@"id"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                        NSLog(@"%@",dictionary);
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        if (dictionary) {
                            if (![[dictionary objectForKey:@"success"] boolValue]) {
                                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                               message:dictionary[@"message"]
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                                
                                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                      handler:^(UIAlertAction * action) {}];
                                
                                [alert addAction:defaultAction];
                                [self presentViewController:alert animated:YES completion:nil];
                            } else {
                                EwonListViewController *ewonListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EwonListViewControllerIdentifier"];
                                ewonListViewController.ewonsList = dictionary;
                                [self.navigationController pushViewController:ewonListViewController animated:YES];
                            }
                        } else {
                            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                           message:[error localizedDescription]
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                            
                            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                  handler:^(UIAlertAction * action) {}];
                            
                            [alert addAction:defaultAction];
                            [self presentViewController:alert animated:YES completion:nil];
                        }
                    }];
                }
            }
        }];
        
    }    // Do any additional setup after loading the view, typically from a nib.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.accountLabel) {
        [self.usernameLabel becomeFirstResponder];
    } else if (textField == self.usernameLabel) {
        [self.passwordLabel becomeFirstResponder];
    } else if (textField == self.passwordLabel) {
        [textField resignFirstResponder];
        [self loginButtonTapped:nil];
    }
    return YES;
}

- (IBAction)loginButtonTapped:(id)sender {
    [self.view endEditing:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WebServiceManager sharedInstance] loginWithAccount:self.accountLabel.text
                                                username:self.usernameLabel.text
                                             andPassword:self.passwordLabel.text withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                                                 NSLog(@"%@",dictionary);
                                                 if (dictionary) {
                                                     if ([[dictionary objectForKey:@"code"] integerValue] == 429) {
                                                         [[WebServiceManager sharedInstance] logoutWithCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                                                             if ([dictionary[@"success"] boolValue]) {
                                                                 [[WebServiceManager sharedInstance] loginWithAccount:self.accountLabel.text
                                                                                                             username:self.usernameLabel.text                                                                                              andPassword:self.passwordLabel.text withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                                                                                                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                                                 NSLog(@"%@",dictionary);
                                                                                                                 if (dictionary) {
                                                                                                                     if ([[dictionary objectForKey:@"code"] integerValue] == 429) {
                                                                                                                         
                                                                                                                     } else {
                                                                                                                         if (![[dictionary objectForKey:@"success"] boolValue]) {
                                                                                                                             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                                                                            message:dictionary[@"message"]
                                                                                                                                                                                     preferredStyle:UIAlertControllerStyleAlert];
                                                                                                                             
                                                                                                                             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                                                                                                   handler:^(UIAlertAction * action) {}];
                                                                                                                             
                                                                                                                             [alert addAction:defaultAction];
                                                                                                                             [self presentViewController:alert animated:YES completion:nil];
                                                                                                                         } else {
                                                                                                                             [WebServiceManager sharedInstance].sessionId = dictionary[@"t2msession"];
                                                                                                                             //            [WebServiceManager sharedInstance].sessionId = @"123abc456";
                                                                                                                             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                                                                                             [[WebServiceManager sharedInstance] getAccountInfoWithCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                                                                                                                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                                                                 if (dictionary) {
                                                                                                                                     if (![[dictionary objectForKey:@"success"] boolValue]) {
                                                                                                                                         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                                                                                        message:dictionary[@"message"]
                                                                                                                                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                                                                                                                                         
                                                                                                                                         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                                                                                                               handler:^(UIAlertAction * action) {}];
                                                                                                                                         
                                                                                                                                         [alert addAction:defaultAction];
                                                                                                                                         [self presentViewController:alert animated:YES completion:nil];
                                                                                                                                     } else {
                                                                                                                                         //                                                                                                                                         AccountInfoViewController *accountInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountInfoViewControllerIdentifier"];
                                                                                                                                         //                                                                                                                                         accountInfoViewController.accountInfo = dictionary;
                                                                                                                                         //                                                                                                                                         [self.navigationController pushViewController:accountInfoViewController animated:YES];
                                                                                                                                         
                                                                                                                                         NSDictionary *pool = [dictionary[@"pools"] firstObject];
                                                                                                                                         [[WebServiceManager sharedInstance] getEwonsWithPool:pool[@"id"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                                                                                                                                             NSLog(@"%@",dictionary);
                                                                                                                                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                                                                             if (dictionary) {
                                                                                                                                                 if (![[dictionary objectForKey:@"success"] boolValue]) {
                                                                                                                                                     UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                                                                                                    message:dictionary[@"message"]
                                                                                                                                                                                                             preferredStyle:UIAlertControllerStyleAlert];
                                                                                                                                                     
                                                                                                                                                     UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                                                                                                                           handler:^(UIAlertAction * action) {}];
                                                                                                                                                     
                                                                                                                                                     [alert addAction:defaultAction];
                                                                                                                                                     [self presentViewController:alert animated:YES completion:nil];
                                                                                                                                                 } else {
                                                                                                                                                     EwonListViewController *ewonListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EwonListViewControllerIdentifier"];
                                                                                                                                                     ewonListViewController.ewonsList = dictionary;
                                                                                                                                                     [self.navigationController pushViewController:ewonListViewController animated:YES];
                                                                                                                                                 }
                                                                                                                                             } else {
                                                                                                                                                 UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                                                                                                message:[error localizedDescription]
                                                                                                                                                                                                         preferredStyle:UIAlertControllerStyleAlert];
                                                                                                                                                 
                                                                                                                                                 UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                                                                                                                       handler:^(UIAlertAction * action) {}];
                                                                                                                                                 
                                                                                                                                                 [alert addAction:defaultAction];
                                                                                                                                                 [self presentViewController:alert animated:YES completion:nil];
                                                                                                                                             }
                                                                                                                                         }];
                                                                                                                                     }
                                                                                                                                 } else {
                                                                                                                                     UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                                                                                    message:[error localizedDescription]
                                                                                                                                                                                             preferredStyle:UIAlertControllerStyleAlert];
                                                                                                                                     
                                                                                                                                     UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                                                                                                           handler:^(UIAlertAction * action) {}];
                                                                                                                                     
                                                                                                                                     [alert addAction:defaultAction];
                                                                                                                                     [self presentViewController:alert animated:YES completion:nil];
                                                                                                                                 }
                                                                                                                                 
                                                                                                                             }];
                                                                                                                         }
                                                                                                                     }
                                                                                                                 } else {
                                                                                                                     UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                                                                    message:[error localizedDescription]
                                                                                                                                                                             preferredStyle:UIAlertControllerStyleAlert];
                                                                                                                     
                                                                                                                     UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                                                                                           handler:^(UIAlertAction * action) {}];
                                                                                                                     
                                                                                                                     [alert addAction:defaultAction];
                                                                                                                     [self presentViewController:alert animated:YES completion:nil];
                                                                                                                 }
                                                                                                             }];
                                                                 
                                                                 
                                                             } else {
                                                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                 
                                                                 UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                message:[error localizedDescription]
                                                                                                                         preferredStyle:UIAlertControllerStyleAlert];
                                                                 
                                                                 UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                                       handler:^(UIAlertAction * action) {}];
                                                                 
                                                                 [alert addAction:defaultAction];
                                                                 [self presentViewController:alert animated:YES completion:nil];
                                                             }
                                                         }];
                                                     } else {
                                                         if (dictionary) {
                                                             if (![[dictionary objectForKey:@"success"] boolValue]) {
                                                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                 UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                message:dictionary[@"message"]
                                                                                                                         preferredStyle:UIAlertControllerStyleAlert];
                                                                 
                                                                 UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                                       handler:^(UIAlertAction * action) {}];
                                                                 
                                                                 [alert addAction:defaultAction];
                                                                 [self presentViewController:alert animated:YES completion:nil];
                                                             } else {
                                                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                 [WebServiceManager sharedInstance].sessionId = dictionary[@"t2msession"];
                                                                 //            [WebServiceManager sharedInstance].sessionId = @"123abc456";
                                                                 [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                                 [[WebServiceManager sharedInstance] getAccountInfoWithCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                                                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                     if (![[dictionary objectForKey:@"success"] boolValue]) {
                                                                         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                        message:dictionary[@"message"]
                                                                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                                                                         
                                                                         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                                               handler:^(UIAlertAction * action) {}];
                                                                         
                                                                         [alert addAction:defaultAction];
                                                                         [self presentViewController:alert animated:YES completion:nil];
                                                                     } else {
                                                                         //                                                                         AccountInfoViewController *accountInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountInfoViewControllerIdentifier"];
                                                                         //                                                                         accountInfoViewController.accountInfo = dictionary;
                                                                         //                                                                         [self.navigationController pushViewController:accountInfoViewController animated:YES];
                                                                         NSDictionary *pool = [dictionary[@"pools"] firstObject];
                                                                         [[WebServiceManager sharedInstance] getEwonsWithPool:pool[@"id"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                                                                             NSLog(@"%@",dictionary);
                                                                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                             if (dictionary) {
                                                                                 if (![[dictionary objectForKey:@"success"] boolValue]) {
                                                                                     UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                                    message:dictionary[@"message"]
                                                                                                                                             preferredStyle:UIAlertControllerStyleAlert];
                                                                                     
                                                                                     UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                                                           handler:^(UIAlertAction * action) {}];
                                                                                     
                                                                                     [alert addAction:defaultAction];
                                                                                     [self presentViewController:alert animated:YES completion:nil];
                                                                                 } else {
                                                                                     EwonListViewController *ewonListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EwonListViewControllerIdentifier"];
                                                                                     ewonListViewController.ewonsList = dictionary;
                                                                                     [self.navigationController pushViewController:ewonListViewController animated:YES];
                                                                                 }
                                                                             } else {
                                                                                 UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                                message:[error localizedDescription]
                                                                                                                                         preferredStyle:UIAlertControllerStyleAlert];
                                                                                 
                                                                                 UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                                                       handler:^(UIAlertAction * action) {}];
                                                                                 
                                                                                 [alert addAction:defaultAction];
                                                                                 [self presentViewController:alert animated:YES completion:nil];
                                                                             }
                                                                         }];
                                                                         
                                                                     }
                                                                     
                                                                 }];
                                                             }
                                                         } else {
                                                             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                            message:[error localizedDescription]
                                                                                                                     preferredStyle:UIAlertControllerStyleAlert];
                                                             
                                                             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                                   handler:^(UIAlertAction * action) {}];
                                                             
                                                             [alert addAction:defaultAction];
                                                             [self presentViewController:alert animated:YES completion:nil];
                                                         }
                                                     }
                                                 }
                                             }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
