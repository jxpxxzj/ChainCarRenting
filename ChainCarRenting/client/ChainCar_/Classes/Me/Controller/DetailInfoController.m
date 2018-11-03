//
//  DetailInfoController.m
//  ChainCar
//
//  Created by mai on 2018/5/12.
//  Copyright © 2018年 Mai. All rights reserved.
//

#import "DetailInfoController.h"
#import "Manager.h"
#import "Car.h"
#import <AFNetworking/AFNetworking.h>

@interface DetailInfoController ()


@end

@implementation DetailInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self freshDataWithNum:0];
    // Do any additional setup after loading the view from its nib.
}
//@property(nonatomic, strong)NSNumber *cid;
//@property(nonatomic, strong)NSString *name;
//@property(nonatomic, strong)NSString *band;
//@property(nonatomic, strong)NSNumber *moneyCost;
//@property(nonatomic, strong)NSNumber *moneyLeft;
//@property(nonatomic, strong)NSNumber *moneyPre;
//@property(nonatomic, strong)NSNumber *moneyTotal;
//@property(nonatomic, strong)NSString *state;
//@property(nonatomic, strong)NSString *beginTime;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)freshDataWithNum:(NSInteger)index{
    Manager *manager = [Manager defaultManager];
    Car *car = manager.carArray[index];
    UIImage *image = [UIImage imageNamed:car.imageName];
    self.imageView.image = image;
    self.nameLabel.text = car.name;
    self.idLabel.text = [NSString stringWithFormat:@"车辆id:%@", car.cid];
    self.bandLabel.text = car.band;
    self.moneyCostLabel.text = [NSString stringWithFormat:@"租金:%@/日", car.moneyCost];
    self.moneyPreLabel.text = [NSString stringWithFormat:@"押金:%@/日", car.moneyPre];
    self.moneyLeftLabel.text = [NSString stringWithFormat:@"余额:%@", car.moneyLeft];
    self.moneyTotalLabel.text = [NSString stringWithFormat:@"总金额:%@",car.moneyTotal];
    self.stateLabel.text = [NSString stringWithFormat:@"车辆状态:%@",car.state];
    self.beginTimeLabel.text = [NSString stringWithFormat:@"开始租借时间:%@", car.beginTime];
    
}
- (IBAction)stopRentPress:(id)sender {
    self.stateLabel.text = [NSString stringWithFormat:@"车辆状态:%@",@"waiting"];
    Manager *manager = [Manager defaultManager];
    Car *car = manager.carArray[self.index];
    car.state = @"waiting";
    AFHTTPSessionManager *afmanager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"cid"] = @2;
    
    [afmanager POST:[NSString stringWithFormat:@"http://%@/api/endRent",manager.ip] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:nil];
}
- (IBAction)openDoorPress:(id)sender {
    AFHTTPSessionManager *afmanager = [AFHTTPSessionManager manager];
    [afmanager GET:[NSString stringWithFormat:@"http://%@/api/openDoor",[Manager defaultManager].ip] parameters:nil progress:nil success:nil failure:nil];
}
- (IBAction)closeDoor:(id)sender {
    AFHTTPSessionManager *afmanager = [AFHTTPSessionManager manager];
    [afmanager GET:[NSString stringWithFormat:@"http://%@/api/closeDoor",[Manager defaultManager].ip] parameters:nil progress:nil success:nil failure:nil];
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
