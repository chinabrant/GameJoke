//
//  LCUploadImagePlugin.h
//  Runner
//
//  Created by brant on 07/05/2018.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "AppDelegate.h"

/**
 * 上传图片到LeanCloud
 */
@interface LCUploadImagePlugin : NSObject

+ (void)registerChannel:(AppDelegate *)delegate;

@end
