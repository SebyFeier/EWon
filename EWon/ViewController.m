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
#import <MessageUI/MessageUI.h>

@interface ViewController ()<UITextFieldDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountLabel;
@property (weak, nonatomic) IBOutlet UITextField *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.accountLabel.text = @"";
    self.usernameLabel.text = @"";
    self.passwordLabel.text = @"";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //        [self.logoImage setImage:[UIImage imageNamed:@"logo_2"]];
        //        self.widthConstraint.constant = 750;
        
        [self.logoImage setImage:[UIImage imageNamed:@"logo2"]];
        self.widthConstraint.constant = 210;
    } else {
        [self.logoImage setImage:[UIImage imageNamed:@"logo2"]];
        self.widthConstraint.constant = 210;
    }
    [self.view layoutIfNeeded];
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
                                                                 andPassword:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]
                                                         withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
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
                                                                                                                                         //
                                                                                                                                         [[[UIAlertView alloc] initWithTitle:@"Error" message:dictionary[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                                                                                                         
                                                                                                                                     } else {
                                                                                                                                         [WebServiceManager sharedInstance].sessionId = dictionary[@"t2msession"];
                                                                                                                                         //            [WebServiceManager sharedInstance].sessionId = @"123abc456";
                                                                                                                                         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                                                                                                         [[WebServiceManager sharedInstance] getAccountInfoWithCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                                                                                                                                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                                                                             if (dictionary) {
                                                                                                                                                 if (![[dictionary objectForKey:@"success"] boolValue]) {
                                                                                                                                                     [[[UIAlertView alloc] initWithTitle:@"Error" message:dictionary[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                                                                                                                     
                                                                                                                                                     
                                                                                                                                                     NSDictionary *pool = [dictionary[@"pools"] firstObject];
                                                                                                                                                     [[WebServiceManager sharedInstance] getEwonsWithPool:pool[@"id"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                                                                                                                                                         NSLog(@"%@",dictionary);
                                                                                                                                                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                                                                                         if (dictionary) {
                                                                                                                                                             if (![[dictionary objectForKey:@"success"] boolValue]) {
                                                                                                                                                                 [[[UIAlertView alloc] initWithTitle:@"Error" message:dictionary[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                                                                                                                                 
                                                                                                                                                                 EwonListViewController *ewonListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EwonListViewControllerIdentifier"];
                                                                                                                                                                 ewonListViewController.ewonsList = dictionary;
                                                                                                                                                                 [self.navigationController pushViewController:ewonListViewController animated:YES];
                                                                                                                                                             }
                                                                                                                                                         } else {
                                                                                                                                                             [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                                                                                                                             
                                                                                                                                                         }
                                                                                                                                                     }];
                                                                                                                                                 }
                                                                                                                                             } else {
                                                                                                                                                 //
                                                                                                                                                 [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                                                                                                                 
                                                                                                                                             }
                                                                                                                                             
                                                                                                                                         }];
                                                                                                                                     }
                                                                                                                                 }
                                                                                                                             } else {
                                                                                                                                 //
                                                                                                                                 [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                                                                                                 
                                                                                                                             }
                                                                                                                         }];
                                                                             
                                                                             
                                                                         } else {
                                                                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                             [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                                             
                                                                         }
                                                                     }];
                                                                 } else {
                                                                     if (dictionary) {
                                                                         if (![[dictionary objectForKey:@"success"] boolValue]) {
                                                                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                             //
                                                                             [[[UIAlertView alloc] initWithTitle:@"Error" message:dictionary[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                                             
                                                                         } else {
                                                                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                             [WebServiceManager sharedInstance].sessionId = dictionary[@"t2msession"];
                                                                             //            [WebServiceManager sharedInstance].sessionId = @"123abc456";
                                                                             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                                             [[WebServiceManager sharedInstance] getAccountInfoWithCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                                                                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                 if (![[dictionary objectForKey:@"success"] boolValue]) {
                                                                                     [[[UIAlertView alloc] initWithTitle:@"Error" message:dictionary[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                                                     
                                                                                 } else {
                                                                                     NSDictionary *pool = [dictionary[@"pools"] firstObject];
                                                                                     [[WebServiceManager sharedInstance] getEwonsWithPool:pool[@"id"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                                                                                         NSLog(@"%@",dictionary);
                                                                                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                         if (dictionary) {
                                                                                             if (![[dictionary objectForKey:@"success"] boolValue]) {
                                                                                                 [[[UIAlertView alloc] initWithTitle:@"Error" message:dictionary[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                                                                 
                                                                                             } else {
                                                                                                 EwonListViewController *ewonListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EwonListViewControllerIdentifier"];
                                                                                                 ewonListViewController.ewonsList = dictionary;
                                                                                                 [self.navigationController pushViewController:ewonListViewController animated:YES];
                                                                                             }
                                                                                         } else {
                                                                                             [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                                                             
                                                                                         }
                                                                                     }];
                                                                                 }
                                                                                 
                                                                             }];
                                                                         }
                                                                     } else {
                                                                         [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                                         
                                                                     }
                                                                 }
                                                             } else {
                                                                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                                 [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                                 
                                                             }
                                                         }];
                        
                    } else {                        [[[UIAlertView alloc] initWithTitle:@"Error" message:dictionary[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                        
                    }
                } else {
                    NSDictionary *pool = [dictionary[@"pools"] firstObject];
                    [[WebServiceManager sharedInstance] getEwonsWithPool:pool[@"id"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                        NSLog(@"%@",dictionary);
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        if (dictionary) {
                            if (![[dictionary objectForKey:@"success"] boolValue]) {
                                [[[UIAlertView alloc] initWithTitle:@"Error" message:dictionary[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                
                            } else {
                                EwonListViewController *ewonListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EwonListViewControllerIdentifier"];
                                ewonListViewController.ewonsList = dictionary;
                                [self.navigationController pushViewController:ewonListViewController animated:YES];
                            }
                        } else {
                            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                            
                        }
                    }];
                }
            }
        }];
        
    }}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.accountLabel.text = @"TAIB automation";
    //    self.usernameLabel.text = @"AlexP";
    //    self.passwordLabel.text = @"Ap123456";
    // Do any additional setup after loading the view, typically from a nib.
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
                                                                                                                             //
                                                                                                                             [[[UIAlertView alloc] initWithTitle:@"Error" message:dictionary[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                                                                                             
                                                                                                                         } else {
                                                                                                                             [WebServiceManager sharedInstance].sessionId = dictionary[@"t2msession"];
                                                                                                                             //            [WebServiceManager sharedInstance].sessionId = @"123abc456";
                                                                                                                             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                                                                                             [[WebServiceManager sharedInstance] getAccountInfoWithCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                                                                                                                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                                                                 if (dictionary) {
                                                                                                                                     if (![[dictionary objectForKey:@"success"] boolValue]) {
                                                                                                                                         [[[UIAlertView alloc] initWithTitle:@"Error" message:dictionary[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                                                                                                         
                                                                                                                                     } else {
                                                                                                                                         NSDictionary *pool = [dictionary[@"pools"] firstObject];
                                                                                                                                         [[WebServiceManager sharedInstance] getEwonsWithPool:pool[@"id"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                                                                                                                                             NSLog(@"%@",dictionary);
                                                                                                                                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                                                                             if (dictionary) {
                                                                                                                                                 if (![[dictionary objectForKey:@"success"] boolValue]) {
                                                                                                                                                     [[[UIAlertView alloc] initWithTitle:@"Error" message:dictionary[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                                                                                                                     
                                                                                                                                                 } else {
                                                                                                                                                     EwonListViewController *ewonListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EwonListViewControllerIdentifier"];
                                                                                                                                                     ewonListViewController.ewonsList = dictionary;
                                                                                                                                                     [self.navigationController pushViewController:ewonListViewController animated:YES];
                                                                                                                                                 }
                                                                                                                                             } else {
                                                                                                                                                 [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                                                                                                                 
                                                                                                                                             }
                                                                                                                                         }];
                                                                                                                                     }
                                                                                                                                 } else {
                                                                                                                                     [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                                                                                                     
                                                                                                                                 }
                                                                                                                                 
                                                                                                                             }];
                                                                                                                         }
                                                                                                                     }
                                                                                                                 } else {
                                                                                                                     [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                                                                                     
                                                                                                                 }
                                                                                                             }];
                                                                 
                                                                 
                                                             } else {
                                                                 [MBProgressHUD hideHUDForView:self.view animated:YES];                                                                 [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                                 
                                                             }
                                                         }];
                                                     } else {
                                                         if (dictionary) {
                                                             if (![[dictionary objectForKey:@"success"] boolValue]) {
                                                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                 if (dictionary[@"message"]) {
                                                                     [[[UIAlertView alloc] initWithTitle:@"Error" message:dictionary[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                                     
                                                                 } else {
                                                                     [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Login Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                                     
                                                                 }
                                                             } else {
                                                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                 [WebServiceManager sharedInstance].sessionId = dictionary[@"t2msession"];
                                                                 //            [WebServiceManager sharedInstance].sessionId = @"123abc456";
                                                                 [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                                 [[WebServiceManager sharedInstance] getAccountInfoWithCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                                                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                     if (![[dictionary objectForKey:@"success"] boolValue]) {                                                                         [[[UIAlertView alloc] initWithTitle:@"Error" message:dictionary[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                                         
                                                                         //                                                                     });
                                                                     } else {
                                                                         NSDictionary *pool = [dictionary[@"pools"] firstObject];
                                                                         [[WebServiceManager sharedInstance] getEwonsWithPool:pool[@"id"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                                                                             NSLog(@"%@",dictionary);
                                                                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                             if (dictionary) {
                                                                                 if (![[dictionary objectForKey:@"success"] boolValue]) {
                                                                                     [[[UIAlertView alloc] initWithTitle:@"Error" message:dictionary[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                                                     
                                                                                 } else {
                                                                                     EwonListViewController *ewonListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EwonListViewControllerIdentifier"];
                                                                                     ewonListViewController.ewonsList = dictionary;
                                                                                     [self.navigationController pushViewController:ewonListViewController animated:YES];
                                                                                 }
                                                                             } else {
                                                                                 [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                                             }
                                                                         }];
                                                                         
                                                                     }
                                                                     
                                                                 }];
                                                             }
//                                                             [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                             
                                                         }
                                                     }
                                                 }
                                             }];
    
}
- (IBAction)contactButtonTapped:(id)sender {
    NSString * subject = @"";
    //email body
    NSString * body = @"";
    //recipient(s)
    NSArray * recipients = [NSArray arrayWithObjects:@"info@taibautomation.com", nil];
    
    //create the MFMailComposeViewController
    MFMailComposeViewController * composer = [[MFMailComposeViewController alloc] init];
    composer.mailComposeDelegate = self;
    [composer setSubject:subject];
    [composer setMessageBody:body isHTML:YES];
    //[composer setMessageBody:body isHTML:YES]; //if you want to send an HTML message
    [composer setToRecipients:recipients];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    [self presentViewController:composer animated:YES completion:^{
        [hud hide:YES];
    }];
}

#pragma mark MFMailComposeViewControllerDelegate methods

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled"); break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved"); break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent"); break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]); break;
        default:
            break;
    }
    
    // close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
