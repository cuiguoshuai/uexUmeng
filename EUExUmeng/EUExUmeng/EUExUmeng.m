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
    NSString *startWithAppkey=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"uexUmengAppKey"];
    NSString *channelId=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"uexUmengChannelId"];
    [MobClick startWithAppkey:startWithAppkey reportPolicy:BATCH   channelId:channelId];
    return YES;
}

-(void)onEvent:(NSMutableArray*)inArguments{
    if(inArguments.count < 2){
        return;
    }
    NSString* eventId=inArguments[0];
    NSDictionary* attributes= [inArguments[1] JSONValue];
    if(![eventId isKindOfClass:[NSString class]]||![attributes isKindOfClass:[NSDictionary class]]){
        return;
    }
    [MobClick event:eventId attributes:attributes];
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
