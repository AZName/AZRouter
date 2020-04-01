//
//  UIApplication+AZRouter.h
//  router
//
//  Created by 徐振 on 2020/3/31.
//  Copyright © 2020 徐振. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "UIViewController+AZRouter.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (AZRouter)

/// 获取当前显示的控制器
+ (UIViewController *)currentViewController;

/// 向路由表中注册路由
/// @param URL 地址
/// @param className 控制器的类名
+ (void)registerRouterWithURL:(NSString *)URL className:(Class)className;

/// 平滑的跳转到相应的页面
/// @param URLString 跳转的地址
/// @param animated 是否启用动画
+ (void)pushURLString:(NSString *)URLString animated:(BOOL)animated;

/// 平滑的跳转到相应的页面
/// @param URLString 跳转的地址 zjd://user/userdelta?userid=23&name=xuzhen
/// @param params 多余的参数
/// @param animated 是否启用动画
+ (void)pushURLString:(NSString *)URLString params:(NSDictionary *)params animated:(BOOL)animated;

/// 模态推入控制器
/// @param URLString 跳转的地址 zjd://user/userdelta?userid=23&name=xuzhen
/// @param params 多余的参数
/// @param animated 是否启用动画
+ (void)presnetURLString:(NSString *)URLString params:(NSDictionary *)params animated:(BOOL)animated;

/// 推出到某个控制器
/// @param URLString 推出的地址 zjd://user/userdelta?userid=23&name=xuzhen
/// @param animated 是否启用动画
+ (void)popURLString:(NSString *)URLString animated:(BOOL)animated;

/// 推出到某个控制器
/// @param URLString 推出的地址 zjd://user/userdelta?userid=23&name=xuzhen
/// @param animated 是否启用动画
+ (void)dismissURLString:(NSString *)URLString animated:(BOOL)animated;


@end

NS_ASSUME_NONNULL_END
