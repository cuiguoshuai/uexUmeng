//
//  EUExUmeng.m
//  EUExUmeng
//
//  Created by 黄锦 on 15/10/29.
//  Copyright © 2015年 AppCan. All rights reserved.
//

#import "EUExUmeng.h"
#import "MobClick.h"


@implementation EUExUmeng

//-(id)initWithBrwView:(EBrowserView *) eInBrwView {
//    if (self = [super initWithBrwView:eInBrwView]) {
//
//    }
//    return self;
//}
//      测试Key
//      NSString* startWithAppkey=@"562df76b67e58e0592003544";
//      NSString* channelId=@"web";
+ (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    NSString *startWithAppkey=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"uexUmeng_APPKey"];
    NSString *channelId=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"uexUmeng_channel"];
    [MobClick startWithAppkey:startWithAppkey reportPolicy:BATCH   channelId:channelId];
    return YES;
}

-(void)onEvent:(NSMutableArray*)inArguments{
    if(inArguments.count < 1){
        return;
    }
    NSString* eventId=inArguments[0];
    id attributes;
    if(inArguments.count>1){
        attributes= [inArguments[1] ac_JSONValue];
    }
    if([eventId isKindOfClass:[NSString class]]){
        if([attributes isKindOfClass:[NSDictionary class]]){
            [MobClick event:eventId attributes:attributes];
        }
        else{
            [MobClick event:eventId];
        }
    }
}

-(NSDictionary*)getDeviceInfo:(NSMutableArray*)inArguments{
   //ACJSFunctionRef *func = JSFunctionArg(inArguments.lastObject);
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }

    //[self cbDeviceInfo:[@{@"oid":deviceID} ac_JSONFragment]];
    //[func executeWithArguments:ACArgsPack(@{@"oid":deviceID})];
    if (deviceID) {
        [self.webViewEngine callbackWithFunctionKeyPath:@"uexUmeng.cbGetDeviceInfo" arguments:ACArgsPack([@{@"oid":deviceID} ac_JSONFragment])];
        return @{@"device_id":deviceID};
        
    }else{
        [self.webViewEngine callbackWithFunctionKeyPath:@"uexUmeng.cbGetDeviceInfo" arguments:ACArgsPack([@{@"oid":@""} ac_JSONFragment])];
        return nil;
    }
    
}

//callback
//-(void)cbDeviceInfo:(NSString*)param{
//    NSString *cbStr=[NSString stringWithFormat:@"if(uexUmeng.cbGetDeviceInfo != null){uexUmeng.cbGetDeviceInfo('%@');}",param];
//    [EUtility brwView:meBrwView evaluateScript:cbStr];
//}
@end
