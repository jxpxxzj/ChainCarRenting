//
//  Manager.m
//  ChainCar
//
//  Created by mai on 2018/5/12.
//  Copyright © 2018年 Mai. All rights reserved.
//

#import "Manager.h"
#import "Car.h"
#import <AFNetworking/AFNetworking.h>


@interface Manager()

@property(nonatomic, strong)NSMutableArray<Car*> *carMutableArray;


@end


@implementation Manager


+ (instancetype)defaultManager
{
    static Manager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[Manager alloc] initPrivate];
    });
    return manager;
}

- (instancetype)initPrivate{
    self = [super init];
    if(self){
        self.carMutableArray = [[NSMutableArray alloc] init];
        self.ip = @"172.20.10.3:3000";
        self.totalMoney = 463270;
        self.notUsedCarNumArr = [[NSMutableArray alloc] init];
        [self.notUsedCarNumArr addObject:@2];
        [self.notUsedCarNumArr addObject:@3];
        [self addData];
    }
    return self;
}

- (instancetype)init
{
    NSException *exception = [NSException exceptionWithName:@"单例" reason:@"使用 [Manager defaultManager]" userInfo:nil];
    @throw exception;
}

- (void)addCar:(Car*)car{
    [self.carMutableArray addObject:car];
}

- (NSArray*)carArray{
    return self.carMutableArray;
}

#pragma tempData

- (void)addData{
    Car *car1 = [[Car alloc] init];
    [car1 setUpCarId:@1 name:@"朗逸 黑 DSG30年纪念版" band:@"京C.12345" moneyCost:@100 moneyLeft:@1000 moneyPre:@5000 moneyTotal:@7000 state:@"renting" beginTime:@"2018-5-12" imageName:@"ly"];
    [self addCar:car1];
    
    
    Car *car2 = [[Car alloc] init];
    [car2 setUpCarId:@2 name:@"布加迪 红 Prinetti&Stucchi" band:@"京A.12347" moneyCost:@200 moneyLeft:@1000 moneyPre:@10000 moneyTotal:@7000 state:@"renting" beginTime:@"2018-5-12" imageName:@"bjd"];
    [self addCar:car2];
    
    Car *car3 = [[Car alloc] init];
    [car3 setUpCarId:@3 name:@"奔驰 黑 B200" band:@"京D.12346" moneyCost:@150 moneyLeft:@1000 moneyPre:@8000 moneyTotal:@7000 state:@"renting" beginTime:@"2018-5-12" imageName:@"ben"];
    [self addCar:car3];
    

}
- (void)resetState:(NSString *)state withId:(NSNumber* )cid{
    self.carMutableArray[cid.integerValue-1].state = state;
}

@end
