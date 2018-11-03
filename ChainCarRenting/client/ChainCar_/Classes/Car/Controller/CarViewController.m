//
//  CarViewController.m
//  ChainCar
//
//  Created by mai on 2018/5/12.
//  Copyright © 2018年 Mai. All rights reserved.
//

#import "CarViewController.h"
#import <ARKit/ARKit.h>
#import "Manager.h"
#import "Car.h"
#import "MoneyController.h"
#import "MoneyConfirmController.h"

@interface CarViewController ()<ARSCNViewDelegate>
//@property(nonatomic,strong)ARSCNView *arSCNView;
@property (weak, nonatomic) IBOutlet ARSCNView *arscnView;
@property (weak, nonatomic) IBOutlet UIImageView *rentCarImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rentMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *rentPreLabel;




//AR会话，负责管理相机追踪配置及3D相机坐标
@property(nonatomic,strong)ARSession *arSession;

//会话追踪配置：负责追踪相机的运动
@property(nonatomic,strong)ARWorldTrackingConfiguration *arSessionConfiguration;
@property(nonatomic, assign)NSInteger count;
@property(nonatomic, strong)NSMutableArray *nodeArray;

@property (nonatomic, strong) ARPlaneAnchor *planeAnchor;

@end

@implementation CarViewController
- (IBAction)leftButtonPress:(id)sender {
    if([Manager defaultManager].carArray.count == 1)
        return;
    if(self.position == 0)
        return;
    self.position--;
    [self reloadARview];
    [self loadCarInfo];
}
- (IBAction)rightButtonpress:(id)sender {
    if([Manager defaultManager].carArray.count == 1)
        return;
    if(self.position == 1)
        return;
    self.position++;
    [self reloadARview];
    [self loadCarInfo];
    
}

- (IBAction)confirmRentPress:(id)sender {
    MoneyController *moneyController = [[MoneyController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:moneyController];
//    MoneyConfirmController *confirmController = [[MoneyConfirmController alloc] init];
    moneyController.position = self.position;
    moneyController.carViewController = self;
//    [navController addChildViewController:confirmController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController animated:YES completion:nil];

    
    
}



//懒加载会话追踪配置
- (ARWorldTrackingConfiguration *)arSessionConfiguration
{
    if (_arSessionConfiguration != nil) {
        return _arSessionConfiguration;
    }
    
    //1.创建世界追踪会话配置（使用ARWorldTrackingSessionConfiguration效果更加好），需要A9芯片支持
    ARWorldTrackingConfiguration *configuration = [[ARWorldTrackingConfiguration alloc] init];
    //2.设置追踪方向（追踪平面，后面会用到）
    configuration.planeDetection = ARPlaneDetectionHorizontal;
    _arSessionConfiguration = configuration;
    //3.自适应灯光（相机从暗到强光快速过渡效果会平缓一些）
    _arSessionConfiguration.lightEstimationEnabled = YES;
    
    return _arSessionConfiguration;
    
}

//懒加载拍摄会话
- (ARSession *)arSession
{
    if(_arSession != nil)
    {
        return _arSession;
    }
    //1.创建会话
    _arSession = [[ARSession alloc] init];
    //2返回会话
    return _arSession;
}

////创建AR视图
//- (ARSCNView *)arSCNView
//{
//    if (_arSCNView != nil) {
//        return _arSCNView;
//    }
//    //1.创建AR视图
//    _arSCNView = [[ARSCNView alloc] initWithFrame:self.view.bounds];
//    //2.设置视图会话
//    _arSCNView.session = self.arSession;
//    //3.自动刷新灯光（3D游戏用到，此处可忽略）
//    _arSCNView.automaticallyUpdatesLighting = YES;
//
//    return _arSCNView;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arscnView.session = self.arSession;
    self.arscnView.automaticallyUpdatesLighting = YES;
    self.arscnView.showsStatistics = true;
    self.arscnView.delegate = self;
    self.position = 0;
    self.count = 0;
    self.nodeArray = [[NSMutableArray alloc] init];
    [self loadCarInfo];
    
    
    
    
    
    
    
    
    
//    SCNScene *scene = [SCNScene sceneNamed:@"Modals.scnassets/BRZ4.scn"];
//    for(SCNNode *node in scene.rootNode.childNodes){
//
//        node.position = SCNVector3Make(0, 0, -5);
//        node.rotation = SCNVector4Make(1, 0, 0, M_PI/2*3);
//        [self.arscnView.scene.rootNode addChildNode:node];
//    }
    
    
    
}

- (void)loadCarInfo{
    Manager *manager = [Manager defaultManager];
    NSInteger index = [manager.notUsedCarNumArr[self.position] integerValue];
    Car *car = manager.carArray[index-1];
    self.nameLabel.text = car.name;
    self.rentMoneyLabel.text = [NSString stringWithFormat:@"租金:%@/日",car.moneyCost];
    self.rentPreLabel.text = [NSString stringWithFormat:@"定金:%@",car.moneyPre];
    UIImage *image = [UIImage imageNamed:car.imageName];
    self.rentCarImage.image = image;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.arSession runWithConfiguration:self.arSessionConfiguration];
}

- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{
    if ([anchor isMemberOfClass:[ARPlaneAnchor class]]) {
        if(self.count != 0){
            return;
        }
        self.count++;
//        NSLog(@"捕捉到平地");
        //添加一个3D平面模型，ARKit只有捕捉能力，锚点只是一个空间位置，要想更加清楚看到这个空间，我们需要给空间添加一个平地的3D模型来渲染他
        //1.获取捕捉到的平地锚点
        ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;
        self.planeAnchor = planeAnchor;
        //2.创建一个3D物体模型    （系统捕捉到的平地是一个不规则大小的长方形，这里笔者将其变成一个长方形，并且是否对平地做了一个缩放效果）
        //参数分别是长宽高和圆角
        SCNBox *plane = [SCNBox boxWithWidth:planeAnchor.extent.x*0.3 height:0 length:planeAnchor.extent.x*0.3 chamferRadius:0];
        //3.使用Material渲染3D模型（默认模型是白色的，这里笔者改成红色）
        plane.firstMaterial.diffuse.contents = [UIColor redColor];
        //4.创建一个基于3D物体模型的节点
        SCNNode *planeNode = [SCNNode nodeWithGeometry:plane];
        //5.设置节点的位置为捕捉到的平地的锚点的中心位置  SceneKit框架中节点的位置position是一个基于3D坐标系的矢量坐标SCNVector3Make
        planeNode.position =SCNVector3Make(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z);
        //self.planeNode = planeNode;
        [node addChildNode:planeNode];
        //2.当捕捉到平地时，2s之后开始在平地上添加一个3D模型
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            SCNScene *scene = [SCNScene sceneNamed:@"Models.scnassets/vase/vase.scn"];
        //2.获取花瓶节点（一个场景会有多个节点，此处我们只写，花瓶节点则默认是场景子节点的第一个）
        //所有的场景有且只有一个根节点，其他所有节点都是根节点的子节点           SCNNode *vaseNode = scene.rootNode.childNodes[0];
        //4.设置花瓶节点的位置为捕捉到的平地的位置，如果不设置，则默认为原点位置，也就是相机位置
//        vaseNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
        //5.将花瓶节点添加到当前屏幕中
        //!!!此处一定要注意：花瓶节点是添加到代理捕捉到的节点中，而不是AR试图的根节点。因为捕捉到的平地锚点是一个本地坐标系，而不是世界坐标系
//            [node addChildNode:vaseNode];
            NSString *string;
            if(self.position == 0){
                string = @"Modals.scnassets/BRZ4.scn";
                SCNScene *scene = [SCNScene sceneNamed:string];
                for(SCNNode *node in scene.rootNode.childNodes){
                    [self.nodeArray addObject:node];
                    if([node.name isEqualToString:@"leftback"]){
                        node.position = SCNVector3Make(self.planeAnchor.center.x+0.623, self.planeAnchor.center.y-0.291-1, self.planeAnchor.center.z+0.534);
                    }else if([node.name isEqualToString:@"rightback"]){
                        node.position = SCNVector3Make(self.planeAnchor.center.x+0.623, self.planeAnchor.center.y-0.272-1, self.planeAnchor.center.z-0.584);
                    }else if([node.name isEqualToString:@"center"]){
                        node.position = SCNVector3Make(self.planeAnchor.center.x, self.planeAnchor.center.y-1, self.planeAnchor.center.z);
                    }else if([node.name isEqualToString:@"leftfore"]){
                        node.position = SCNVector3Make(self.planeAnchor.center.x-0.982, self.planeAnchor.center.y-0.298-1, self.planeAnchor.center.z+0.538);
                    }else if([node.name isEqualToString:@"rightfore"]){
                        node.position = SCNVector3Make(self.planeAnchor.center.x-0.981, self.planeAnchor.center.y-0.288-1, self.planeAnchor.center.z-0.579);
                    }
                    [self.arscnView.scene.rootNode addChildNode:node];
                }
            }else{
                string = @"Modals.scnassets/free_car_1.scn";
                SCNScene *scene = [SCNScene sceneNamed:string];
                for(SCNNode *node in scene.rootNode.childNodes){
                    
                    [self.nodeArray addObject:node];
                    node.rotation = SCNVector4Make(1, 0, 0, M_PI/2*3);
                    node.position = SCNVector3Make(self.planeAnchor.center.x, self.planeAnchor.center.y-1, self.planeAnchor.center.z);
                    [self.arscnView.scene.rootNode addChildNode:node];
                }
            }

    });
}
}
- (void)reloadARview{
    for(SCNNode *node in self.nodeArray){
        [node removeFromParentNode];
    }
    [self.nodeArray removeAllObjects];
    NSString *string;
    if(self.position == 0){
        string = @"Modals.scnassets/BRZ4.scn";
        SCNScene *scene = [SCNScene sceneNamed:string];
        for(SCNNode *node in scene.rootNode.childNodes){
            [self.nodeArray addObject:node];
            if([node.name isEqualToString:@"leftback"]){
                node.position = SCNVector3Make(self.planeAnchor.center.x+0.623, self.planeAnchor.center.y-0.291-1, self.planeAnchor.center.z+0.534);
            }else if([node.name isEqualToString:@"rightback"]){
                node.position = SCNVector3Make(self.planeAnchor.center.x+0.623, self.planeAnchor.center.y-0.272-1, self.planeAnchor.center.z-0.584);
            }else if([node.name isEqualToString:@"center"]){
                node.position = SCNVector3Make(self.planeAnchor.center.x, self.planeAnchor.center.y-1, self.planeAnchor.center.z);
            }else if([node.name isEqualToString:@"leftfore"]){
                node.position = SCNVector3Make(self.planeAnchor.center.x-0.982, self.planeAnchor.center.y-0.298-1, self.planeAnchor.center.z+0.538);
            }else if([node.name isEqualToString:@"rightfore"]){
                node.position = SCNVector3Make(self.planeAnchor.center.x-0.981, self.planeAnchor.center.y-0.288-1, self.planeAnchor.center.z-0.579);
            }
            [self.arscnView.scene.rootNode addChildNode:node];
        }
    }else{
        string = @"Modals.scnassets/free_car_1.scn";
        SCNScene *scene = [SCNScene sceneNamed:string];
        for(SCNNode *node in scene.rootNode.childNodes){
            
            [self.nodeArray addObject:node];
            node.rotation = SCNVector4Make(1, 0, 0, M_PI/2*3);
            node.position = SCNVector3Make(self.planeAnchor.center.x, self.planeAnchor.center.y-1, self.planeAnchor.center.z);
            [self.arscnView.scene.rootNode addChildNode:node];
        }
    }

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
