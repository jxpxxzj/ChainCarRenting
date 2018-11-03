//
//  CarViewController.h
//  ChainCar
//
//  Created by mai on 2018/5/12.
//  Copyright © 2018年 Mai. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CarViewController : UIViewController

@property(nonatomic, assign)NSInteger position;

- (void)loadCarInfo;

@end
