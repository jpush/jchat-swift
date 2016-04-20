//
//  HMAlbumModel.h
//  JChat
//
//  Created by oshumini on 15/12/1.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface JMUIAlbumModel : NSObject
@property(strong, nonatomic)UIImage *albumImage;
@property(strong, nonatomic)NSString *albumTittle;
@property(assign, nonatomic)NSInteger albumCount;
//ios 8 photoAlbum
@property(strong, nonatomic)PHCollection *albumCollection;
@property(strong, nonatomic)PHFetchResult *albumFetchResult;
//ios 8 以前
@property (strong, nonatomic) ALAssetsGroup *assetsGroup;

- (void)setDataWithAssets:(ALAssetsGroup *)assetsGroup;

- (void)setDataWithAlbumCollection:(PHCollection *)albumCollection;
- (void)setDataWithAlbumResult:(PHFetchResult *)albumFetchResult;
@end
