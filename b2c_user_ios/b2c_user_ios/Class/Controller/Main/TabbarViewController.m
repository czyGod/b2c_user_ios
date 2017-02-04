//
//  TabbarViewController.m
//  BS
//
//  Created by 崔露凯 on 16/3/31.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "TabbarViewController.h"

#import "NavigationController.h"
//#import "HomeViewController.h"
//#import "ServiceViewController.h"
//#import "RecommendViewController.h"
//#import "PersonViewController.h"

#import <SDWebImageDownloader.h>
#import <SDWebImageManager.h>

//#import "CustomTabar.h"
//#import "UnreadMessageNumApi.h"

@interface TabbarViewController () <UITabBarControllerDelegate>


@property (nonatomic, strong) UILabel *msgLabel;


@end

@implementation TabbarViewController

- (NavigationController*)createNavWithTitle:(NSString*)title imgNormal:(NSString*)imgNormal imgSelected:(NSString*)imgSelected vcName:(NSString*)vcName {
    
    UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:vc];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:nil
                                                             image:[UIImage imageNamed:imgNormal]
                                                     selectedImage:[UIImage imageNamed:imgSelected]];
    
     tabBarItem.selectedImage = [tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem.image= [tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    tabBarItem.imageInsets = UIEdgeInsetsMake(7, 7, 7, 7);
    
    
    vc.tabBarItem = tabBarItem;
    
    return nav;
}


- (void)createSubControllers {
    
    // 首页
    NavigationController *homeNav = [self createNavWithTitle:@"" imgNormal:@"home_un_selected" imgSelected:@"home_selected" vcName:@"HomeViewController"];
    
    // 服务
    NavigationController *searchNav = [self createNavWithTitle:@"" imgNormal:@"service_un_selected" imgSelected:@"service_selected" vcName:@"ServiceViewController"];
    
    // 通知
    NavigationController *shoppingCartNav = [self createNavWithTitle:@"" imgNormal:@"notice_un_selected" imgSelected:@"notice_selected" vcName:@"RecommendViewController"];
    
    // 我的
    NavigationController *personNav = [self createNavWithTitle:@"" imgNormal:@"person_un_selected" imgSelected:@"person_selected" vcName:@"PersonViewController"];
    
    self.viewControllers = @[homeNav, searchNav, shoppingCartNav, personNav];

}


// 消息提示红点
- (UILabel *)msgLabel {
    if (_msgLabel == nil) {
        
        CGFloat widthButton = kScreenWidth/self.viewControllers.count;
        
        CGFloat msgX = widthButton*2.5 + 6;
        
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(msgX, 10, 6, 6)];
        _msgLabel.layer.cornerRadius = 3;
        _msgLabel.layer.masksToBounds = YES;
        _msgLabel.backgroundColor = [UIColor redColor];
        _msgLabel.hidden = YES;
        
        [self.tabBar addSubview:_msgLabel];
    }
   
    return _msgLabel;
}

// 创建按钮
- (void)createTabbarButton {

//    CustomTabar *customTabar = [CustomTabar shareTabbar];
//    customTabar.images = @[@"home", @"service", @"notice", @"person"];
//    [self.tabBar addSubview:customTabar];
//    
//    customTabar.eventBlock = ^(NSInteger index) {
//        
//        self.selectedIndex = index;
//        
//        [self removeOriginTabbarButton];
//        
//        // 刷新未读消息数
//        [self requestUnreadMessageNumApi];
//    };
}


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [UITabBar appearance].tintColor = kAppCustomMainColor;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor] , NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
  

    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
    
    
    // 创建子控制器
    [self createSubControllers];
    
    [self removeOriginTabbarButton];
    
    [self createTabbarButton];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    [self removeOriginTabbarButton];
    
    [self requestUnreadMessageNumApi];
}


- (void)requestUnreadMessageNumApi {
//    UnreadMessageNumApi * unreadMessageNumApi = [[UnreadMessageNumApi alloc]init];
//    [unreadMessageNumApi getUnreadMessageNumCallback:^(id resultData, NSInteger code) {
//        if (code == 0) {
//            
//            self.msgLabel.hidden = ([resultData integerValue] == 0?YES:NO);
//        }
//    }];
}

#pragma mark - Private
- (void)removeOriginTabbarButton {

    // 移除原来的按钮
    for (UIView *view in self.tabBar.subviews) {
        
        Class c = NSClassFromString(@"UITabBarButton");
        if ([view isKindOfClass:c]) {
            [view removeFromSuperview];
        
        }
    }
}

#pragma mark - Setter
- (void)setIsHaveMsg:(BOOL)isHaveMsg {

    _msgLabel.hidden = !isHaveMsg;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {

    _currentIndex = currentIndex;

    self.selectedIndex = _currentIndex;
    
   // [CustomTabar shareTabbar].index = currentIndex;
}



@end
