//
//  UIViewController+AZRouter.m
//  router
//
//  Created by 徐振 on 2020/4/1.
//  Copyright © 2020 徐振. All rights reserved.
//

static const int  paramesKeys;
static const int  originUrlKyes;

#import "UIViewController+AZRouter.h"
#import <objc/runtime.h>
@implementation UIViewController (AZRouter)

- (void)setParames:(NSDictionary *)parames{
    objc_setAssociatedObject(self, &paramesKeys, parames, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSDictionary *)parames{
    return objc_getAssociatedObject(self, &paramesKeys);
}

- (void)setOriginUrl:(NSString *)originUrl{
    objc_setAssociatedObject(self, &originUrlKyes, originUrl, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)originUrl{
    return objc_getAssociatedObject(self, &originUrlKyes);
}


@end
