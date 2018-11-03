//
//  MeCarCell.h
//  ChainCar
//
//  Created by mai on 2018/5/12.
//  Copyright © 2018年 Mai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeCarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *carImage;
@property (weak, nonatomic) IBOutlet UILabel *carName;
@property (weak, nonatomic) IBOutlet UILabel *carBand;
@property (weak, nonatomic) IBOutlet UILabel *carCost;
@property (weak, nonatomic) IBOutlet UILabel *carPre;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end
