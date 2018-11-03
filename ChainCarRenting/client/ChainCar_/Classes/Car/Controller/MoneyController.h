//
//  MoneyController.h
//  ChainCar
//
//  Created by mai on 2018/5/13.
//  Copyright © 2018年 Mai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarViewController.h"

@interface MoneyController : UIViewController

@property(nonatomic, assign)NSInteger position;

@property (nonatomic, weak)CarViewController *carViewController;

@end
