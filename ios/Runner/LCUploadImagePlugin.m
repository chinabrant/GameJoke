//
//  LCUploadImagePlugin.m
//  Runner
//
//  Created by brant on 07/05/2018.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import "LCUploadImagePlugin.h"
#import <UIKit/UIKit.h>
#import <AVOSCloud.h>

@interface LCUploadImagePlugin ()

@property (nonatomic, copy) FlutterResult result;
@property (nonatomic, copy) NSString *imagePath;

@end

@implementation LCUploadImagePlugin

+ (LCUploadImagePlugin *)shareInstance {
    static LCUploadImagePlugin *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LCUploadImagePlugin alloc] init];
    });
    
    return instance;
}

- (void)uploadImagePath:(NSString *)path {
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        if (image) {
            __block AVFile *file = [AVFile fileWithData:UIImagePNGRepresentation(image)];
            NSMutableDictionary *meta = [file.metaData mutableCopy];
            [meta addEntriesFromDictionary:@{ @"width": @(image.size.width), @"height": @(image.size.height) }];
            
            [file setMetaData:[meta copy]];

            __weak typeof(self) weakSelf = self;
            [file uploadWithCompletionHandler:^(BOOL succeeded, NSError * _Nullable error) {
                __strong typeof(self) strongSelf = weakSelf;
                
                strongSelf.result(file.objectId);
                
            }];
            
        } else {
            NSLog(@"图片读取不到");
        }
    }
    else {
    
        NSLog(@"图片不存在");
        _result(FlutterMethodNotImplemented);
        _result = nil;
    }
}

+ (void)registerChannel:(AppDelegate *)delegate {
    FlutterViewController* controller = (FlutterViewController*)delegate.window.rootViewController;
    
    FlutterMethodChannel* uploadChannel = [FlutterMethodChannel
                                            methodChannelWithName:@"joke.brant.com/upload"
                                            binaryMessenger:controller];
    
    [uploadChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        [[LCUploadImagePlugin shareInstance] handleMethodCall:call result:result];
    }];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if (_result) {
        _result([FlutterError errorWithCode:@"multiple_request"
                                    message:@"Cancelled by a second request"
                                    details:nil]);
        _result = nil;
    }
    
    if ([@"uploadImage" isEqualToString:call.method]) {
        
        NSLog(@"请求参数：%@", call.arguments);
        self.result = result;
        _imagePath = call.arguments;
        
        [self uploadImagePath:_imagePath];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
