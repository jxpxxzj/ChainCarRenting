//
//  MeInfoController.m
//  ChainCar
//
//  Created by mai on 2018/5/12.
//  Copyright © 2018年 Mai. All rights reserved.
//

#import "MeInfoController.h"
#import "MeMainCell.h"
#import "MeCarCell.h"
#import "Manager.h"
#import "ChargeController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "SimpleCar.h"


@interface MeInfoController ()

@property(nonatomic, strong)ChargeController* chargeController;
@property(nonatomic, strong)NSNumber *totalmoney;
@property(nonatomic, strong)NSMutableArray *simpleCarArr;
@property(nonatomic, assign)NSInteger count;

@end


@implementation MeInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"MeMainCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MeMainCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MeCarCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MeCarCell"];
    self.simpleCarArr = [[NSMutableArray alloc] init];
    [self freshMoney];
    [self freshData];
    self.count = 0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (true) {
            sleep(2);
            [self freshData];
        }
        
    });
    
}
- (void)freshMoney{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    Manager *peopleManager = [Manager defaultManager];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    dic[@"address"] = @"icbda6cc538e90190230df486c948b84c4c66f7fd";
//
//    [manager POST:[NSString stringWithFormat:@"http://%@/api/getMoney",peopleManager.ip] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        self.totalmoney = responseObject[@"money"];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // UI更新代码
//            [self.tableView reloadData];
//        });
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error:%@",error);
//    }];
    [self.tableView reloadData];
    
}
- (void)freshData{
    [self.simpleCarArr removeAllObjects];
    Manager *peopleManager = [Manager defaultManager];

    AFHTTPSessionManager *manager2 = [AFHTTPSessionManager manager];
    [manager2 GET:[NSString stringWithFormat:@"http://%@/api/allRent",peopleManager.ip] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *arr = responseObject;
        NSLog(@"%@",responseObject);
        for (int i = 0; i < arr.count; ++i) {
            SimpleCar *simpleCar = [SimpleCar mj_objectWithKeyValues:arr[i]];
            if(i == 1 && [simpleCar.state isEqualToString:@"renting"]&&self.count == 0){
                [Manager defaultManager].totalMoney -= 1200;
                self.count++;
            }
            [peopleManager resetState:simpleCar.state withId:simpleCar.cid];
            [self.simpleCarArr addObject:simpleCar];
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                [self.tableView reloadData];
            });
        }
    } failure:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.simpleCarArr.count == 0)
        return 3;
    
    return self.simpleCarArr.count+2;
}
//@property (weak, nonatomic) IBOutlet UIImageView *carImage;
//@property (weak, nonatomic) IBOutlet UILabel *carName;
//@property (weak, nonatomic) IBOutlet UILabel *carBand;
//@property (weak, nonatomic) IBOutlet UILabel *carCost;
//@property (weak, nonatomic) IBOutlet UILabel *carPre;


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        return cell;
    }else if(indexPath.row == 1){
        MeMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeMainCell" forIndexPath:indexPath];
        [cell.chargeButton addTarget:self action:@selector(chargeButtonPress) forControlEvents:UIControlEventTouchUpInside];
        cell.userMoneyLabel.text = [NSString stringWithFormat:@"用户余额:%ld",[Manager defaultManager].totalMoney];
        
        return cell;
        
    }else{
        MeCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeCarCell" forIndexPath:indexPath];
        Manager *manager = [Manager defaultManager];
        Car *car = manager.carArray[indexPath.row-2];
        cell.carName.text = car.name;
        cell.carBand.text = car.band;
        cell.carCost.text = [NSString stringWithFormat:@"租金:%@/日", car.moneyCost ];
        cell.carPre.text = [NSString stringWithFormat:@"余额:%@元,预计使用%ld日", car.moneyLeft, car.moneyLeft.integerValue/car.moneyCost.integerValue];
        if([car.state isEqualToString:@"renting"]){
            cell.stateLabel.textColor = [UIColor greenColor];
        }else{
            cell.stateLabel.textColor = [UIColor redColor];
        }
        cell.stateLabel.text = car.state;
        UIImage *image = [UIImage imageNamed:car.imageName];
        cell.imageView.image = image;
        return cell;
    }

}

- (void)chargeButtonPress{
    self.chargeController = [[ChargeController alloc] initWithNibName:@"ChargeController" bundle:nil];
//    
//    [self.chargeController.chargeConfirmButton addTarget:self action:@selector(chargeConfirmPress) forControlEvents:UIControlEventTouchUpInside];
    self.chargeController.modalPresentationStyle=UIModalPresentationFormSheet;
    [self presentViewController:self.chargeController animated:YES completion:nil];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 50;
    }else if(indexPath.row == 1){
        return 65.5;
    }else{
        return 69.5;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row <= 1) {
        return;
    }
    [self.detailInfoController freshDataWithNum:indexPath.row-2];
}
//定金+租金*天数

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self freshData];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
