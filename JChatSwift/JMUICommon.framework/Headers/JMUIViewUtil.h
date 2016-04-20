//
//  ViewUtil.h
//  JMUIKit
//
//  Created by oshumini on 15/12/24.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define NIB(x)  (x *)[JMUIViewUtil nib:#x]
#define NIB_OWN(x, y)  (x *)[JMUIViewUtil nib:#x owner:y]
#define REG_NIB(x, y)  [JMUIViewUtil table:x registerNib:#y]
#define CELL(x, y) (y *)[JMUIViewUtil table:x nib:#y]


@interface JMUIViewUtil : NSObject

+ (UIImage *)colorImage:(UIColor *)c frame:(CGRect)frame;

+ (UIView *)nib:(char *)nib;
+ (UIView *)nib:(char *)nib owner:(id)owner;

+ (UITableViewCell *)table:(UITableView *)table nib:(char *)nib;
+ (void)table:(UITableView *)table registerNib:(char *)nib;

@end
