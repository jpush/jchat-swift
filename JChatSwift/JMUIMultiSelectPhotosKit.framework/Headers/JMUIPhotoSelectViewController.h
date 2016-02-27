//
//  HMPhotoSelectViewController.h
//  HMPhotoPickerDemo
//
//  Created by HuminiOS on 15/11/16.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class JMUIPhotoModel;
@class JMUIPhotoSelectViewController;

@protocol JMUIMultiSelectPhotosDelegate <NSObject>

- (void)JMUIMultiSelectedPhotoArray:(NSArray *)selected_photo_array;

@end

@interface JMUIPhotoSelectViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic)id<JMUIMultiSelectPhotosDelegate> photoDelegate;
@property (strong,nonatomic) PHFetchResult *allFetchResult;
@property (strong, nonatomic)PHCollection *photoCollection;

@property (strong, nonatomic)ALAssetsGroup *assetsGroup;

- (void)didSelectStatusChange:(JMUIPhotoModel *)model;
- (void)finshToSelectPhoto:(JMUIPhotoModel *)model;
@end
