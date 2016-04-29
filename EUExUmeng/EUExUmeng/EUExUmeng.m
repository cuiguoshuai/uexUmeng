//
//  EUExUmeng.m
//  EUExUmeng
//
//  Created by 黄锦 on 15/10/29.
//  Copyright © 2015年 AppCan. All rights reserved.
//

#import "EUExUmeng.h"
#import "MobClick.h"
#import "JSON/JSON.h"

@implementation EUExUmeng

-(id)initWithBrwView:(EBrowserView *) eInBrwView {
    if (self = [super initWithBrwView:eInBrwView]) {

    }
    return self;
}
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
        attributes= [inArguments[1] JSONValue];
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

-(void)getDeviceInfo:(NSMutableArray*)inArguments{
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = @"";
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }

    [self cbDeviceInfo:[@{@"oid":deviceID} JSONFragment]];
}

//callback
-(void)cbDeviceInfo:(NSString*)param{
    NSString *cbStr=[NSString stringWithFormat:@"if(uexUmeng.cbGetDeviceInfo != null){uexUmeng.cbGetDeviceInfo('%@');}",param];
    [EUtility brwView:meBrwView evaluateScript:cbStr];
}
@end
