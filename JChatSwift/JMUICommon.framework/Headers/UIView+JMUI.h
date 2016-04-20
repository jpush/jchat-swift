//
//  UIView+JMUI.h
//  JMUIKit
//
//  Created by oshumini on 15/12/24.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JMUI)
@property (nonatomic) CGFloat jmui_left;

/*!
 * Get return view.frame.origin.y
 * Set view.frame.origin.y = top
 */
@property (nonatomic) CGFloat jmui_top;

/*!
 * Get return view.frame.origin.x + uiview.frame.size.width
 * Set view.frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat jmui_right;

/*!
 * Get return uiview.frame.origin.y + uiview.frame.size.height
 * Set frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat jmui_bottom;

/*!
 * Get return view.frame.size.width
 * Set view.frame.size.width = width
 */
@property (nonatomic) CGFloat jmui_width;

/*!
 * Get return view frame.size.height
 * Set view.frame.size.height = height
 */
@property (nonatomic) CGFloat jmui_height;

/*!
 * Get return view.center.x
 * Set center.x = centerX
 */
@property (nonatomic) CGFloat jmui_centerX;

/*!
 * Get return view.center.y
 * Set center.y = CenterY
 */
@property (nonatomic) CGFloat jmui_centerY;

/*!
 * Get return view.frame.origin
 * Set view.frame.origin = Origin
 */
@property (nonatomic) CGPoint jmui_origin;

/*!
 * Get return view.frame.size
 * Set view.frame.size = Size
 */
@property (nonatomic) CGSize jmui_size;

//找到自己的vc
- (UIViewController *)jmui_viewController;

@end
