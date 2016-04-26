//
//  EwonListViewController.m
//  EWon
//
//  Created by Seby Feier on 22/11/15.
//  Copyright © 2015 Seby Feier. All rights reserved.
//

#import "EwonListViewController.h"
#import "EwonTableViewCell.h"
#import "EwonViewController.h"
#import "WebServiceManager.h"
#import "MBProgressHUD.h"
#import "ContactViewController.h"

@interface EwonListViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@property (weak, nonatomic) IBOutlet UIView *proView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfDaysLabel;
@property (weak, nonatomic) IBOutlet UIButton *upgradeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proViewHeightConstraint;


@end

@implementation EwonListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Instalaciones";
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *logoutButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 71, 25) ];
    [logoutButton setImage:[UIImage imageNamed:@"log_out_slim"] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logoutButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem1 = [[UIBarButtonItem alloc]
                                            initWithCustomView:logoutButton];
    [rightBarButtonItem1 setTintColor:[UIColor blackColor]];
    
    //set the action for button
    rightBarButtonItem1.action =  @selector(logoutButtonTapped:);
    self.navigationItem.rightBarButtonItem = rightBarButtonItem1;
    self.searchBar.showsCancelButton = YES;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        [self.logoImage setImage:[UIImage imageNamed:@"logo_2"]];
//        self.widthConstraint.constant = 750;
        
        [self.logoImage setImage:[UIImage imageNamed:@"logo2"]];
        self.widthConstraint.constant = 210;
    } else {
        [self.logoImage setImage:[UIImage imageNamed:@"logo2"]];
        self.widthConstraint.constant = 210;
    }
    self.proViewHeightConstraint.constant = 0;
    
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [[WebServiceManager sharedInstance] getNumberOfDaysWithUUid:uniqueIdentifier andUsername:[[[WebServiceManager sharedInstance] username] lowercaseString] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
        NSLog(@"%@",dictionary);
        if ([dictionary[@"has_pro_version"] boolValue]) {
            self.proViewHeightConstraint.constant = 0;
            self.tableView.userInteractionEnabled = YES;
            self.searchBar.userInteractionEnabled = YES;
        } else {
            if ([dictionary[@"days_left"] integerValue] > 0) {
                self.proViewHeightConstraint.constant = 57;
                self.tableView.userInteractionEnabled = YES;
                self.searchBar.userInteractionEnabled = YES;
                if ([dictionary[@"days_left"] integerValue] > 1) {
                    self.numberOfDaysLabel.text = [NSString stringWithFormat:@"You have %@ days remaining for your free trial",dictionary[@"days_left"]];
                } else {
                    self.numberOfDaysLabel.text = [NSString stringWithFormat:@"You have one day remaining for your free trial"];
                }
            } else {
                self.proViewHeightConstraint.constant = 57;
                self.tableView.userInteractionEnabled = NO;
                self.searchBar.userInteractionEnabled = NO;
                self.numberOfDaysLabel.text = @"Please upgrade to pro version";
            }
        }
    }];
    
    
    [self.view layoutIfNeeded];
    
    // Do any additional setup after loading the view.
}
- (void)logoutButtonTapped:(UIButton *)button {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WebServiceManager sharedInstance] logoutWithCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (dictionary) {
            if (![[dictionary objectForKey:@"success"] boolValue]) {
//                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
//                                                                               message:dictionary[@"message"]
//                                                                        preferredStyle:UIAlertControllerStyleAlert];
//                
//                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                                      handler:^(UIAlertAction * action) {}];
//                
//                [alert addAction:defaultAction];
//                [self presentViewController:alert animated:YES completion:nil];
                [[[UIAlertView alloc] initWithTitle:@"Error" message:dictionary[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

            } else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        } else {
//            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
//                                                                           message:[error localizedDescription]
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                                  handler:^(UIAlertAction * action) {}];
//            
//            [alert addAction:defaultAction];
//            [self presentViewController:alert animated:YES completion:nil];
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.ewonsList[@"ewons"] count] + 1;
    //    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EwonTableViewCell *ewonTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"EwonTableViewCellIdentifier"];
    if (!ewonTableViewCell) {
        ewonTableViewCell = [[EwonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EwonTableViewCellIdentifier"];
    }
    ewonTableViewCell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == 0) {
        ewonTableViewCell.ewonNameLabel.text = @"Instalación";
        ewonTableViewCell.ewonStatusLabel.text = @"Estado";
        ewonTableViewCell.ewonNameLabel.font = [UIFont boldSystemFontOfSize:17];
        ewonTableViewCell.ewonStatusLabel.font = [UIFont boldSystemFontOfSize:17];
    } else {
        NSDictionary *ewonInfo = [[self.ewonsList objectForKey:@"ewons"] objectAtIndex:indexPath.row - 1];
        ewonTableViewCell.ewonNameLabel.text = ewonInfo[@"name"];
        ewonTableViewCell.ewonStatusLabel.text = ewonInfo[@"status"];
        ewonTableViewCell.ewonNameLabel.font = [UIFont systemFontOfSize:17];
        ewonTableViewCell.ewonStatusLabel.font = [UIFont systemFontOfSize:17];
    }
    //    ewonTableViewCell.ewonNameLabel.text = @"name";
    //    ewonTableViewCell.ewonStatusLabel.text = @"status";
    return ewonTableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row > 0) {
        NSDictionary *ewonInfo = [[self.ewonsList objectForKey:@"ewons"] objectAtIndex:indexPath.row - 1];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[WebServiceManager sharedInstance] getEwonWithName:nil pool:ewonInfo[@"id"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (dictionary) {
                if ([[dictionary objectForKey:@"code"] integerValue] == 403) {
//                    [[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@. Please log in again",dictionary[@"message"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    if (![[dictionary objectForKey:@"success"] boolValue]) {
//                        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
//                                                                                       message:dictionary[@"message"]
//                                                                                preferredStyle:UIAlertControllerStyleAlert];
//                        
//                        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                                              handler:^(UIAlertAction * action) {}];
//                        
//                        [alert addAction:defaultAction];
//                        [self presentViewController:alert animated:YES completion:nil];
                        [[[UIAlertView alloc] initWithTitle:@"Error" message:dictionary[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

                    } else {
                        EwonViewController *ewonViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EwonViewControllerIdentifier"];
                        ewonViewController.ewonInfo = dictionary;
                        [self.navigationController pushViewController:ewonViewController animated:YES];
                    }
                }
            } else {
//                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
//                                                                               message:[error localizedDescription]
//                                                                        preferredStyle:UIAlertControllerStyleAlert];
//                
//                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                                      handler:^(UIAlertAction * action) {}];
//                
//                [alert addAction:defaultAction];
//                [self presentViewController:alert animated:YES completion:nil];
                [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

            }
        }];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WebServiceManager sharedInstance] getEwonWithName:searchBar.text pool:nil withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (dictionary) {
            if (![[dictionary objectForKey:@"success"] boolValue]) {
//                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
//                                                                               message:dictionary[@"message"]
//                                                                        preferredStyle:UIAlertControllerStyleAlert];
//                
//                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                                      handler:^(UIAlertAction * action) {}];
//                
//                [alert addAction:defaultAction];
//                [self presentViewController:alert animated:YES completion:nil];
                [[[UIAlertView alloc] initWithTitle:@"Error" message:dictionary[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

            } else {
                EwonViewController *ewonViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EwonViewControllerIdentifier"];
                ewonViewController.ewonInfo = dictionary;
                [self.navigationController pushViewController:ewonViewController animated:YES];
            }
        } else {
//            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
//                                                                           message:[error localizedDescription]
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                                  handler:^(UIAlertAction * action) {}];
//            
//            [alert addAction:defaultAction];
//            [self presentViewController:alert animated:YES completion:nil];
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

        }
    }];
}
- (IBAction)upgradeButtonTapped:(id)sender {
    ContactViewController *contactViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactViewControllerIdentifier"];
    [self.navigationController pushViewController:contactViewController animated:YES];
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
