//
//  HMPhotoPickerConstants.h
//  photosFramework
//
//  Created by HuminiOS on 15/11/13.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#define FrameworkNibResourcesWithName(resourceName) [NSString stringWithFormat:@"JMUIMultiSelectPhotosKitResource.bundle/%@",resourceName]

#define screenWidth self.view.frame.size.width
#define screenHeight self.view.frame.size.height

#define topBarFrame CGRectMake(0, 0, screenWidth, 64)
#define bottomBarFrame CGRectMake(0, screenHeight - 45 - 64, screenWidth, 45)
#define selectBtnFrame CGRectMake(screenWidth - 35, 30, 25, 25)
#define backBtnFrame CGRectMake(18, 35, 40, 15)
#define BarColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]


static NSString * const kSelectStatusChange = @"SelectPhotoStatusChange";
static NSString * const kFinishToSelectPhoto = @"FinishToSelectPhoto";