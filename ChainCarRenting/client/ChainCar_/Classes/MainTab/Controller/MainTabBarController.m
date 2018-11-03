//
//  MainTabBarController.m
//  ChainCar
//
//  Created by mai on 2018/5/12.
//  Copyright © 2018年 Mai. All rights reserved.
//

#import "MainTabBarController.h"
#import "CarViewController.h"
#import "MeSplitController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTwoChildViewController];
//    self.selectedIndex = 1;
}

- (void)addTwoChildViewController{
    MeSplitController *meSplitController = [[MeSplitController alloc] init];
    CarViewController *carViewController = [[CarViewController alloc] init];
    
    meSplitController.title = @"我的租车";
    carViewController.title = @"我要租车";
    
    self.viewControllers = @[meSplitController, carViewController];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
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
