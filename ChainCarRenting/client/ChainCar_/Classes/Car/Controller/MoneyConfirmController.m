//
//  MoneyConfirmController.m
//  ChainCar
//
//  Created by mai on 2018/5/13.
//  Copyright © 2018年 Mai. All rights reserved.
//

#import "MoneyConfirmController.h"
#import <AFNetworking/AFNetworking.h>
#import "Manager.h"

@interface MoneyConfirmController ()


@end

@implementation MoneyConfirmController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)moneyConfirmPress:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    self.carViewController.position = 1;
    [self.carViewController loadCarInfo];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //id
    //money
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"cid"] = @2;
    dic[@"moneyTotal"] = @9500;
    [manager POST:[NSString stringWithFormat:@"http://%@/api/makeRent",[Manager defaultManager].ip] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:nil];
    
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
