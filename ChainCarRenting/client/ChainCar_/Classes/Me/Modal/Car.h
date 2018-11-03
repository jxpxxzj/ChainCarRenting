//
//  Car.h
//  ChainCar
//
//  Created by mai on 2018/5/12.
//  Copyright © 2018年 Mai. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Car : NSObject

@property(nonatomic, strong)NSNumber *cid;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *band;
@property(nonatomic, strong)NSNumber *moneyCost;
@property(nonatomic, strong)NSNumber *moneyLeft;
@property(nonatomic, strong)NSNumber *moneyPre;
@property(nonatomic, strong)NSNumber *moneyTotal;
@property(nonatomic, strong)NSString *state;
@property(nonatomic, strong)NSString *beginTime;
@property(nonatomic, strong)NSString *imageName;


- (void)setUpCarId:(NSNumber*)cid name:(NSString *)name band:(NSString *)band moneyCost:(NSNumber *)moneyCost moneyLeft:(NSNumber *)moneyLeft moneyPre:(NSNumber *)moneyPre moneyTotal:(NSNumber *)moneyTotal state:(NSString *)state beginTime:(NSString *)beginTime imageName:(NSString*)imageName;





@end
