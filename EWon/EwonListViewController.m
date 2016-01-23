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

@interface EwonListViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@end

@implementation EwonListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Instalaciones";
    [self.navigationItem setHidesBackButton:YES];
//    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(logoutButtonTapped:)];
//    self.navigationItem.rightBarButtonItem = logoutButton;
    
    UIButton *logoutButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 71, 25) ];
    [logoutButton setImage:[UIImage imageNamed:@"log_out"] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logoutButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem1 = [[UIBarButtonItem alloc]
                                            initWithCustomView:logoutButton];
    [rightBarButtonItem1 setTintColor:[UIColor blackColor]];
    
    //set the action for button
    rightBarButtonItem1.action =  @selector(logoutButtonTapped:);
    self.navigationItem.rightBarButtonItem = rightBarButtonItem1;
    self.searchBar.showsCancelButton = YES;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.logoImage setImage:[UIImage imageNamed:@"logo_2"]];
        self.widthConstraint.constant = 750;
    } else {
        [self.logoImage setImage:[UIImage imageNamed:@"taib-logo"]];
        self.widthConstraint.constant = 320;
    }
    [self.view layoutIfNeeded];
    // Do any additional setup after loading the view.
}
- (void)logoutButtonTapped:(UIButton *)button {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WebServiceManager sharedInstance] logoutWithCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
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
                [self.navigationController popToRootViewControllerAnimated:YES];
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
                        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                       message:dictionary[@"message"]
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction * action) {}];
                        
                        [alert addAction:defaultAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    } else {
                        EwonViewController *ewonViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EwonViewControllerIdentifier"];
                        ewonViewController.ewonInfo = dictionary;
                        [self.navigationController pushViewController:ewonViewController animated:YES];
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
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                               message:dictionary[@"message"]
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            } else {
                EwonViewController *ewonViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EwonViewControllerIdentifier"];
                ewonViewController.ewonInfo = dictionary;
                [self.navigationController pushViewController:ewonViewController animated:YES];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
