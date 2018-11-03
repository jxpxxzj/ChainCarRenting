//
//  MoneyController.m
//  ChainCar
//
//  Created by mai on 2018/5/13.
//  Copyright © 2018年 Mai. All rights reserved.
//

#import "MoneyController.h"
#import "MoneyConfirmController.h"
@interface MoneyController ()

@end

@implementation MoneyController
- (IBAction)rentConfirmPress:(id)sender {
    MoneyConfirmController *confirmController = [[MoneyConfirmController alloc] init];
    confirmController.carViewController = self.carViewController;
    [self.navigationController pushViewController:confirmController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
