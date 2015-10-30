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
        NSString *startWithAppkey=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"uexUmengAppkey"];
        NSString *channelId=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"uexUmengChannelId"];
        
        //测试Key
//        NSString* startWithAppkey=@"562df76b67e58e0592003544";
//        NSString* channelId=@"web";
        [MobClick startWithAppkey:startWithAppkey reportPolicy:BATCH   channelId:channelId];
    }
    return self;
}

-(void)onEvent:(NSMutableArray*)inArguments{
    if(inArguments.count < 2){
        return;
    }
    NSString* evevtId=inArguments[0];
    NSDictionary* attributes= [inArguments[1] JSONValue];
    [MobClick event:evevtId attributes:attributes];
}

-(void)getDeviceInfo:(NSMutableArray*)inArguments{
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
//    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:nil];
//    
//    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    [self cbDeviceInfo:[@{@"oid":deviceID} JSONFragment]];
}

//callback
-(void)cbDeviceInfo:(NSString*)param{
    NSString *cbStr=[NSString stringWithFormat:@"if(uexUmeng.cbGetDeviceInfo != null){uexUmeng.cbGetDeviceInfo('%@');}",param];
    [EUtility brwView:meBrwView evaluateScript:cbStr];
}
@end
