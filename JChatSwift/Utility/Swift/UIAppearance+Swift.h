//
//  UIAppearance+Swift.h
//  JChatSwift
//
//  Created by oshumini on 2016/12/28.
//  Copyright © 2016年 HXHG. All rights reserved.
//



// UIAppearance+Swift.h
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIView (UIViewAppearance_Swift)
// appearanceWhenContainedIn: is not available in Swift. This fixes that.
+ (instancetype)my_appearanceWhenContainedIn:(Class<UIAppearanceContainer>)containerClass;
@end
NS_ASSUME_NONNULL_END
