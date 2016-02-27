//
//  HMPhotoBrowserCollectionViewCell.h
//  photosFramework
//
//  Created by HuminiOS on 15/11/12.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "JMUIPhotoModel.h"
@interface JMUIPhotoBrowserCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIScrollView *imageContent;

- (void)setDataWithModel:(JMUIPhotoModel *)model;
@end
