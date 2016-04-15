//
// Created by Javen on 15/5/11.
// Copyright (c) 2015 HXHG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>

@interface JMUIStringUtils : NSObject

+ (NSString*)errorAlert:(NSError *)error;

+ (NSString *)dictionary2String:(NSDictionary *)dictionary;

+ (NSString *)getFriendlyDateString:(NSTimeInterval)timeInterval;

+ (NSString *)getFriendlyDateString:(NSTimeInterval)timeInterval
                    forConversation:(BOOL)isShort;

+ (BOOL)isValidatIP:(NSString *)ipAddress;

+ (NSString *)conversationIdWithConversation:(JMSGConversation *)conversation;

+ (CGSize)stringSizeWithWidthString:(NSString *)string withWidthLimit:(CGFloat)width withFont:(UIFont *)font;
@end

