//
//  Manager.h
//  ChainCar
//
//  Created by mai on 2018/5/12.
//  Copyright © 2018年 Mai. All rights reserved.
//
//172.20.10.3:3000


#import <Foundation/Foundation.h>
#import "Car.h"

@interface Manager : NSObject
@property(nonatomic, strong)NSArray *carArray;
@property(nonatomic, strong)NSString *ip;
@property(nonatomic, strong)NSMutableArray<NSNumber*> *notUsedCarNumArr;

@property(nonatomic, assign)NSInteger totalMoney;

+ (instancetype)defaultManager;
- (void)addCar:(Car*)car;

- (void)resetState:(NSString *)state withId:(NSNumber* )cid;



@end
