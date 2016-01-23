//
//  EwonViewController.m
//  EWon
//
//  Created by Seby Feier on 22/11/15.
//  Copyright © 2015 Seby Feier. All rights reserved.
//

#import "EwonViewController.h"
#import "WebServiceManager.h"
#import "MBProgressHUD.h"
#import "EwonTableViewCell.h"
#import "WebViewViewController.h"
@interface EwonViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@end

@implementation EwonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(logoutButtonTapped:)];
//    self.navigationItem.rightBarButtonItem = logoutButton;
    
    UIButton *logoutButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 71, 25) ];
    [logoutButton setImage:[UIImage imageNamed:@"log_out"] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logoutButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem1 = [[UIBarButtonItem alloc]
                                            initWithCustomView:logoutButton];
    [rightBarButtonItem1 setTintColor:[UIColor blackColor]];
    
    //set the action for button
    
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem1;
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 61, 25) ];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem1 = [[UIBarButtonItem alloc]
                                           initWithCustomView:backButton];
    [leftBarButtonItem1 setTintColor:[UIColor blackColor]];
    
    //set the action for button
    
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem1;

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 100, 44)];
    nameLabel.text = @"Instalación:";
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(100 + 15, 0, CGRectGetWidth(self.view.frame)-100, 44)];
    name.text = self.ewonInfo[@"ewon"][@"name"];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, 100, 44)];
    descriptionLabel.text = @"Description:";
    UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(100 + 15, 50, CGRectGetWidth(self.view.frame)-100, 44)];
    description.text = self.ewonInfo[@"ewon"][@"description"];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 100, 100, 44)];
    statusLabel.text = @"Status:";
    UILabel *status = [[UILabel alloc] initWithFrame:CGRectMake(100 + 15, 100, CGRectGetWidth(self.view.frame)-100, 44)];
    status.text = self.ewonInfo[@"ewon"][@"status"];
    
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [actionButton setFrame:CGRectMake(15, 150, 100, 44)];
    [actionButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    if ([self.ewonInfo[@"ewon"][@"status"] isEqualToString:@"online"]) {
        [actionButton addTarget:self action:@selector(sendOffline:) forControlEvents:UIControlEventTouchUpInside];
        [actionButton setTitle:@"Send Offline" forState:UIControlStateNormal];
    } else if ([self.ewonInfo[@"ewon"][@"status"] isEqualToString:@"offline"]) {
        [actionButton addTarget:self action:@selector(wakeUp:) forControlEvents:UIControlEventTouchUpInside];
        [actionButton setTitle:@"Wake Up" forState:UIControlStateNormal];
    }
    
    [headerView addSubview:nameLabel];
    [headerView addSubview:name];
//    [headerView addSubview:descriptionLabel];
//    [headerView addSubview:description];
//    [headerView addSubview:statusLabel];
//    [headerView addSubview:status];
//    [headerView addSubview:actionButton];
    
    self.tableView.tableHeaderView = headerView;
//    self.nameLabel.text = self.ewonInfo[@"ewon"][@"name"];
//    self.descriptionLabel.text = self.ewonInfo[@"ewon"][@"description"];
//    self.statusLabel.text = self.ewonInfo[@"ewon"][@"status"];
//    // Do any additional setup after loading the view.
//    if ([self.ewonInfo[@"ewon"][@"status"] isEqualToString:@"online"]) {
//        [self.actionButton addTarget:self action:@selector(sendOffline:) forControlEvents:UIControlEventTouchUpInside];
//        [self.actionButton setTitle:@"Send Offline" forState:UIControlStateNormal];
//    } else if ([self.ewonInfo[@"ewon"][@"status"] isEqualToString:@"offline"]) {
//        [self.actionButton addTarget:self action:@selector(wakeUp:) forControlEvents:UIControlEventTouchUpInside];
//        [self.actionButton setTitle:@"Wake Up" forState:UIControlStateNormal];
    //    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.logoImage setImage:[UIImage imageNamed:@"logo_2"]];
        self.widthConstraint.constant = 750;
    } else {
        [self.logoImage setImage:[UIImage imageNamed:@"taib-logo"]];
        self.widthConstraint.constant = 320;
    }
    [self.view layoutIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
- (void)wakeUp:(UIButton *)button {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WebServiceManager sharedInstance] wakeUpEwonWithName:self.ewonInfo[@"ewon"][@"name"] pool:nil withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
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
                //            EwonViewController *ewonViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EwonViewControllerIdentifier"];
                //            ewonViewController.ewonInfo = dictionary;
                //            [self.navigationController pushViewController:ewonViewController animated:YES];
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

- (void)sendOffline:(UIButton *)button {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WebServiceManager sharedInstance] sendOfflineEwonWithName:self.ewonInfo[@"ewon"][@"name"] pool:nil withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
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
                //            EwonViewController *ewonViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EwonViewControllerIdentifier"];
                //            ewonViewController.ewonInfo = dictionary;
                //            [self.navigationController pushViewController:ewonViewController animated:YES];
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
    return [self.ewonInfo[@"ewon"][@"lanDevices"] count] + 1;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return @"Equipos en red";
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, tableView.frame.size.width, 18)];
//    [label setFont:[UIFont boldSystemFontOfSize:12]];
    NSString *string = @"Equipos en red";
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor lightGrayColor]];
     return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EwonTableViewCell *ewonTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"EwonTableViewCellIdentifier"];
    if (!ewonTableViewCell) {
        ewonTableViewCell = [[EwonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EwonTableViewCellIdentifier"];
    }
    ewonTableViewCell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == 0) {
        ewonTableViewCell.ewonNameLabel.text = @"Equipo";
        ewonTableViewCell.ewonStatusLabel.text = @"Descripción";
        ewonTableViewCell.ewonNameLabel.font = [UIFont boldSystemFontOfSize:17];
        ewonTableViewCell.ewonStatusLabel.font = [UIFont boldSystemFontOfSize:17];
    } else {
        NSDictionary *lanDevice = [[[self.ewonInfo objectForKey:@"ewon"] objectForKey:@"lanDevices"] objectAtIndex:indexPath.row - 1];
        ewonTableViewCell.ewonNameLabel.text = lanDevice[@"name"];
        ewonTableViewCell.ewonStatusLabel.text = lanDevice[@"description"];
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
        NSDictionary *lanDevice = [[[self.ewonInfo objectForKey:@"ewon"] objectForKey:@"lanDevices"] objectAtIndex:indexPath.row - 1];
        
        NSURL *url = [[WebServiceManager sharedInstance] reachEwonWithIp:lanDevice[@"ip"] port:lanDevice[@"port"] name:[[self.ewonInfo objectForKey:@"ewon"] objectForKey:@"name"]];
        //    [[WebServiceManager sharedInstance] reachEwonWithIp:lanDevice[@"ip"] port:lanDevice[@"port"] name:[[self.ewonInfo objectForKey:@"ewon"] objectForKey:@"name"] withCompletionBlock:^(NSDictionary *dictionary, NSError *error) {
        //        if (dictionary) {
        //
        //        }
        //    }];
        WebViewViewController *webViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewViewControllerIdentifier"];
        webViewController.url = url;
        [self.navigationController pushViewController:webViewController animated:YES];
    }
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
