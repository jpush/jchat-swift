//
//  HMThumbImageModel.h
//  photosFramework
//
//  Created by HuminiOS on 15/11/11.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface JMUIPhotoModel : NSObject
@property(assign, nonatomic)NSInteger index;
@property(assign, nonatomic)BOOL isSelected;
@property(assign, nonatomic)BOOL isOriginPhoto;

@property(strong, nonatomic)PHCachingImageManager *cachingManager;//rename
@property(strong, nonatomic)PHAsset *photoAsset;
//iOS 7
@property(strong, nonatomic)ALAsset *asset;
@property(strong, nonatomic)NSURL *imgURL;

@property(strong, nonatomic)UIImage *largeImage;//最后要发送的大图， 如果isOriginPhoto 为Yes 的话 则返回原图
@property(assign, nonatomic)CGSize largeImageSize;//
- (void)setDataWithPhotoAsset:(PHAsset *)asset imageManager:(PHCachingImageManager *)imageManager;//rename
- (UIImage *)getLargeImageWithImageManager:(PHCachingImageManager *)imageManager;

- (void)setDatawithAsset:(ALAsset *)asset;
@end
