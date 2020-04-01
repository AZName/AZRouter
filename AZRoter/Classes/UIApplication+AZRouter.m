//
//  UIApplication+AZRouter.m
//  router
//
//  Created by 徐振 on 2020/3/31.
//  Copyright © 2020 徐振. All rights reserved.
//

#import "UIApplication+AZRouter.h"
#import <objc/runtime.h>

static const NSString * router_key = @"router_key";

@interface UIAlertAction(AZRouter)
@property (nonatomic, strong)NSMutableDictionary * routeControllersMap;
@end

@implementation UIApplication (AZRouter)


+ (UIViewController *)currentViewController {
    
    UIViewController *vc = [self sharedApplication].windows.firstObject.rootViewController;
    while (vc) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabbar = (UITabBarController *)vc;
            vc = tabbar.selectedViewController;
            continue;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)vc;
            vc = nav.visibleViewController;
            continue;
        }
        if (vc.presentingViewController) {
            vc = vc.presentingViewController;
            continue;
        }else{
            return vc;
        }
    }
    return vc;
}

+ (void)registerRouterWithURL:(NSString *)URL className:(Class)className {
    if (!className) return;
    
    NSURL *url = [NSURL URLWithString:URL];
    NSString *str = [self parseWithURL:url];
    NSAssert(str, @"URL不合格");
    
    if (![UIApplication sharedApplication].routeControllersMap) {
        [UIApplication sharedApplication].routeControllersMap = [NSMutableDictionary dictionary];
    }
    [[UIApplication sharedApplication].routeControllersMap setValue:NSStringFromClass(className) forKey:str];
    
}

+ (void)pushURLString:(NSString *)URLString animated:(BOOL)animated {
    [[self currentViewController].navigationController pushViewController:[self initWithURLString:URLString query:nil] animated:YES];
}

+ (void)pushURLString:(NSString *)URLString params:(NSDictionary *)params animated:(BOOL)animated {
    [[self currentViewController].navigationController pushViewController:[self initWithURLString:URLString query:params] animated:YES];
}

+ (void)presnetURLString:(NSString *)URLString params:(NSDictionary *)params animated:(BOOL)animated {
    [[self currentViewController] presentViewController:[self initWithURLString:URLString query:params] animated:animated completion:nil];
}

+ (void)popURLString:(NSString *)URLString animated:(BOOL)animated {
    
    UIViewController *visibleViewController = [self currentViewController];
    NSArray *vcs = visibleViewController.navigationController.viewControllers;
    UIViewController *vc = [self initWithURLString:URLString query:nil];
    
    [vcs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[vc class]]) {
            [visibleViewController.navigationController popToViewController:obj animated:animated];
            return;
        }
    }];
}

+ (void)dismissURLString:(NSString *)URLString animated:(BOOL)animated {
    [[self currentViewController] dismissViewControllerAnimated:animated completion:nil];
}


#pragma mark ---------- 私有方法 ----------

+ (UIViewController *)initWithURLString:(NSString *)URLString query:(NSDictionary *)query {
    UIViewController *vc = nil;
    
    NSURL *url =[NSURL URLWithString:URLString];
    NSString *vcKey = [self parseWithURL:url];
    NSString * stringClass = [[UIApplication sharedApplication].routeControllersMap objectForKey:vcKey];
    
    if ([stringClass isKindOfClass:[NSString class]]) {
        vc = [[NSClassFromString(stringClass) alloc]init];
        
        vc.originUrl = URLString;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:query];
        if (url.query) {
            [dic addEntriesFromDictionary:[self parameterParseWithURL:url]];
        }
        vc.parames = [dic copy];
    }
    NSAssert(vc, @"找不这个控制器。请先注册");
    return vc;
}

+ (NSDictionary *)parameterParseWithURL:(NSURL *)URL{
    if (!URL || URL.query) return nil;
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    NSArray *query = [URL.query componentsSeparatedByString:@"&"];
    [query enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *kv  = [obj componentsSeparatedByString:@"="];
        [parameter setValue:kv.firstObject forKey:kv.lastObject];
        NSLog(@"k = %@-------- v = %@",kv.firstObject, kv.lastObject);
    }];
    
    return parameter;
}

//解析URL
+ (NSString *)parseWithURL:(NSURL *)URL {
    if ([URL.scheme containsString:@"file"]) return nil;
    if ([URL.scheme containsString:@"http"]) {
        return nil;
    }
    NSMutableString *routerKey = [[NSMutableString alloc]init];
    if (URL.scheme.length) {
        [routerKey appendFormat:@"%@",URL.scheme];
    }
    if (URL.host.length) {
        [routerKey appendFormat:@"//%@",URL.host];
    }
    if (URL.path.length) {
        [routerKey appendFormat:@"%@",URL.path];
    }
    return [routerKey copy];
}

- (void)setRouteControllersMap:(NSMutableDictionary *)routeControllersMap {
    objc_setAssociatedObject(self, &router_key, routeControllersMap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)routeControllersMap{
    return objc_getAssociatedObject(self, &router_key);
}



@end
