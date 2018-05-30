#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import <AVOSCloud/AVOSCloud.h>
#import "LCUploadImagePlugin.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [AVOSCloud setApplicationId:@"a4h8AfUwvYJFsiwl0JBv9Fu5" clientKey:@"4ywjc0gCkPxkEQMImhSjKurf"];
    
  [GeneratedPluginRegistrant registerWithRegistry:self];
    
    [LCUploadImagePlugin registerChannel:self];
    
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
