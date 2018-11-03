//
//  MeMainCell.h
//  ChainCar
//
//  Created by mai on 2018/5/12.
//  Copyright © 2018年 Mai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeMainCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *chargeButton;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userMoneyLabel;

@end
