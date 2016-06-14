//
//  CollectionViewCell.h
//  photosFramework
//
//  Created by HuminiOS on 15/11/11.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "JMUIPhotoSelectViewController.h"
#import "JMUIPhotoModel.h"
@interface JMUIThumbImageCollectionViewCell : UICollectionViewCell

- (void)setDataWithModel:(JMUIPhotoModel *)model withDelegate:(id)delegate;
@end
