//
//  UIAppearance+Swift.m
//  JChatSwift
//
//  Created by oshumini on 2016/12/28.
//  Copyright © 2016年 HXHG. All rights reserved.
//

// UIAppearance+Swift.m
#import "UIAppearance+Swift.h"
@implementation UIView (UIViewAppearance_Swift)
+ (instancetype)my_appearanceWhenContainedIn:(Class<UIAppearanceContainer>)containerClass {
  return [self appearanceWhenContainedIn:containerClass, nil];
}
@end
