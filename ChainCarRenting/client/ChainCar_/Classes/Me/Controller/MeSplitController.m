//
//  MeSplitController.m
//  ChainCar
//
//  Created by mai on 2018/5/12.
//  Copyright © 2018年 Mai. All rights reserved.
//

#import "MeSplitController.h"
#import "MeInfoController.h"
#import "DetailInfoController.h"

@interface MeSplitController ()

@end

@implementation MeSplitController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MeInfoController" bundle:[NSBundle mainBundle]];
//    MeInfoController *meinfoController = [storyboard instantiateInitialViewController];
    MeInfoController *infoControllelr = [[MeInfoController alloc] init];
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:infoControllelr];
    DetailInfoController *detailInfoController = [[DetailInfoController alloc] init];
    infoControllelr.detailInfoController = detailInfoController;
    self.viewControllers = @[infoControllelr, detailInfoController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
