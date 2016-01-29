//
//  AccountInfoViewController.m
//  EWon
//
//  Created by Seby Feier on 22/11/15.
//  Copyright © 2015 Seby Feier. All rights reserved.
//

#import "AccountInfoViewController.h"
#import "WebServiceManager.h"
#import "EwonListViewController.h"
#import "MBProgressHUD.h"

@interface AccountInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@end

@implementation AccountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(logoutButtonTapped:)];
//    self.navigationItem.rightBarButtonItem = logoutButton;
    UIButton *logoutButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 71, 25) ];
    [logoutButton setImage:[UIImage imageNamed:@"log_out_slim"] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logoutButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem1 = [[UIBarButtonItem alloc]
                                            initWithCustomView:logoutButton];
    [rightBarButtonItem1 setTintColor:[UIColor blackColor]];
    
    //set the action for button
    
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem1;

    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *accountNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(self.view.frame)/2, 44)];
    accountNameLabel.text = @"Account Name:";
    UILabel *accountName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2 + 5, 0, CGRectGetWidth(self.view.frame)/2, 44)];
    accountName.text = self.accountInfo[@"accountName"];
    //    accountName.text = @"Account Name:";
    
    UILabel *companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, CGRectGetWidth(self.view.frame)/2, 44)];
    companyLabel.text = @"Company:";
    UILabel *company = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2 + 5, 50, CGRectGetWidth(self.view.frame)/2, 44)];
    company.text = self.accountInfo[@"company"];
    //    company.text = @"Account Name:";
    
    
    UILabel *accountReferenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 100, CGRectGetWidth(self.view.frame)/2, 44)];
    accountReferenceLabel.text = @"Account Reference:";
    UILabel *accountReference = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2 + 5, 100, CGRectGetWidth(self.view.frame)/2, 44)];
    accountReference.text = self.accountInfo[@"accountReference"];
    //    accountReference.text = @"Account Name:";
    
    
    UILabel *accountTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 150, CGRectGetWidth(self.view.frame)/2, 44)];
    accountTypeLabel.text = @"Account Type:";
    UILabel *accountType = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2 + 5, 150, CGRectGetWidth(self.view.frame)/2, 44)];
    accountType.text = self.accountInfo[@"accountType"];
    //    accountType.text = @"Account Name:";
    
    
    [headerView addSubview:accountNameLabel];
    [headerView addSubview:accountName];
    [headerView addSubview:companyLabel];
    [headerView addSubview:company];
    [headerView addSubview:accountReferenceLabel];
    [headerView addSubview:accountReference];
    [headerView addSubview:accountTypeLabel];
    [headerView addSubview:accountType];
    
    self.tableView.tableHeaderView = headerView;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        [self.logoImage setImage:[UIImage imageNamed:@"logo_2"]];
//        self.widthConstraint.constant = 750;
        
        [self.logoImage setImage:[UIImage imageNamed:@"taib-logo"]];
        self.widthConstraint.constant = 320;
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
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    return [self.accountInfo[@"pools"] count];
    //    return 5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Pools";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountInfoCellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"accountInfoCellIdentifier"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [[self.accountInfo[@"pools"] objectAtIndex:indexPath.row] objectForKey:@"name"];
    //    cell.textLabel.text = @"asf";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *pool = [self.accountInfo[@"pools"] objectAtIndex:indexPath.row];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
