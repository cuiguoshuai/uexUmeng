//
//  EUExUmeng.m
//  EUExUmeng
//
//  Created by 黄锦 on 15/10/29.
//  Copyright © 2015年 AppCan. All rights reserved.
//

#import "EUExUmeng.h"
#import <UMMobClick/MobClick.h>
<<<<<<< HEAD
#import "JSON/JSON.h"
=======
>>>>>>> origin/dev-4.0


@implementation EUExUmeng
//      测试Key
//      NSString* startWithAppkey=@"562df76b67e58e0592003544";
//      NSString* channelId=@"web";
+ (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    NSString *startWithAppkey=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"uexUmeng_APPKey"];
    NSString *channelId=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"uexUmeng_channel"];
    UMConfigInstance.appKey = startWithAppkey;
    UMConfigInstance.channelId = channelId;
    [MobClick startWithConfigure:UMConfigInstance];
    return YES;
}

-(void)onEvent:(NSMutableArray*)inArguments{
    if(inArguments.count < 1){
        return;
    }
    ACArgsUnpack(NSString* eventId,NSDictionary*attributes) = inArguments;
    if(eventId){
        if(attributes ){
            [MobClick event:eventId attributes:attributes];
        }
        else{
            [MobClick event:eventId];
        }
    }
}

-(NSDictionary*)getDeviceInfo:(NSMutableArray*)inArguments{
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
    
    if (deviceID) {
        [self.webViewEngine callbackWithFunctionKeyPath:@"uexUmeng.cbGetDeviceInfo" arguments:ACArgsPack([@{@"oid":deviceID} ac_JSONFragment])];
        return @{@"device_id":deviceID};
        
    }else{
        [self.webViewEngine callbackWithFunctionKeyPath:@"uexUmeng.cbGetDeviceInfo" arguments:ACArgsPack([@{@"oid":@""} ac_JSONFragment])];
        return nil;
    }
    
}
@end
