//
//  ContactViewController.m
//  TAIB Remote
//
//  Created by Seby Feier on 08/02/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "ContactViewController.h"
#import "WebServiceManager.h"

@interface ContactViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //        [self.logoImage setImage:[UIImage imageNamed:@"logo_2"]];
        //        self.widthConstraint.constant = 750;
        
        [self.logoImage setImage:[UIImage imageNamed:@"logo2"]];
        self.widthConstraint.constant = 210;
    } else {
        [self.logoImage setImage:[UIImage imageNamed:@"logo2"]];
        self.widthConstraint.constant = 210;
    }
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 61, 25) ];
    [backButton setImage:[UIImage imageNamed:@"back-slim"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem1 = [[UIBarButtonItem alloc]
                                           initWithCustomView:backButton];
    [leftBarButtonItem1 setTintColor:[UIColor blackColor]];
    
    //set the action for button
    
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem1;

    // Do any additional setup after loading the view.
}

- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)contactButtonTapped:(id)sender {
    [self.view endEditing:YES];
    if ([self validateEmail:self.emailTextField.text]) {
        if (self.phoneTextField.text.length >= 10) {
            NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            [[WebServiceManager sharedInstance] contactOwnerWithUsername:self.emailTextField.text andPhoneNumber:self.phoneTextField.text andUuid:uniqueIdentifier withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
                NSLog(@"%@", dictionary);
                if ([dictionary[@"error"] boolValue]) {
//                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
//                                                                                   message:@"There was a problem sending your contact information"
//                                                                            preferredStyle:UIAlertControllerStyleAlert];
//                    
//                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                                          handler:^(UIAlertAction * action) {}];
//                    
//                    [alert addAction:defaultAction];
//                    [self presentViewController:alert animated:YES completion:nil];
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem sending your contact information" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

                } else {
//                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Success"
//                                                                                   message:@"You will be contacted by the owner soon"
//                                                                            preferredStyle:UIAlertControllerStyleAlert];
//                    
//                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                                          handler:^(UIAlertAction * action) {}];
//                    
//                    [alert addAction:defaultAction];
//                    [self presentViewController:alert animated:YES completion:nil];
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"You will be contacted by the owner soon" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

                }
            }];
            
        } else {
//            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
//                                                                           message:@"Invalid phone number"
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                                  handler:^(UIAlertAction * action) {}];
//            
//            [alert addAction:defaultAction];
//            [self presentViewController:alert animated:YES completion:nil];
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid phone number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

        }
    } else {
//        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
//                                                                       message:@"Invalid email"
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                              handler:^(UIAlertAction * action) {}];
//        
//        [alert addAction:defaultAction];
//        [self presentViewController:alert animated:YES completion:nil];
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

    }
}

-(BOOL) validateEmail: (NSString *) email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:email];
    return isValid;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailTextField) {
        [self.phoneTextField becomeFirstResponder];
    } else {
        [self contactButtonTapped:nil];
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
