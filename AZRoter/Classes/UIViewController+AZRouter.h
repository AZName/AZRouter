//
//  UIViewController+AZRouter.h
//  router
//
//  Created by 徐振 on 2020/4/1.
//  Copyright © 2020 徐振. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (AZRouter)

@property (nonatomic, copy)NSDictionary *parames;

@property (nonatomic, copy)NSString *originUrl;

@end

NS_ASSUME_NONNULL_END
