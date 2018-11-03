//
//  DetailInfoController.h
//  ChainCar
//
//  Created by mai on 2018/5/12.
//  Copyright © 2018年 Mai. All rights reserved.
//

#import <UIKit/UIKit.h>
//@interface Car : NSObject

//@property(nonatomic, strong)NSNumber *cid;
//@property(nonatomic, strong)NSString *name;
//@property(nonatomic, strong)NSString *band;
//@property(nonatomic, strong)NSNumber *moneyCost;
//@property(nonatomic, strong)NSNumber *moneyLeft;
//@property(nonatomic, strong)NSNumber *moneyPre;
//@property(nonatomic, strong)NSNumber *moneyTotal;
//@property(nonatomic, strong)NSString *state;
//@property(nonatomic, strong)NSString *beginTime;

@interface DetailInfoController : UIViewController


@property(nonatomic, assign)NSInteger index;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;



@property (weak, nonatomic) IBOutlet UILabel *idLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bandLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyCostLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyPreLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;






- (void)freshDataWithNum:(NSInteger)index;

@end
