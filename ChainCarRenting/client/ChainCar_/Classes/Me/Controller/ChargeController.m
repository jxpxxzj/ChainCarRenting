//
//  ChargeController.m
//  ChainCar
//
//  Created by mai on 2018/5/12.
//  Copyright © 2018年 Mai. All rights reserved.
//

#import "ChargeController.h"
#import <AFNetworking/AFNetworking.h>
#import "Manager.h"

@interface ChargeController ()
@property (weak, nonatomic) IBOutlet UITextField *moneyTextFeild;

@end

@implementation ChargeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)chargePress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSInteger money = self.moneyTextFeild.text.intValue;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"address"] = @"icbda6cc538e90190230df486c948b84c4c66f7fd";
    dic[@"amount"] = [NSNumber numberWithInteger:money];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"http://%@/api/addMoney",[Manager defaultManager].ip] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    } failure:nil];
    [Manager defaultManager].totalMoney += money;
    
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
