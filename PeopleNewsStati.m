//
//  PeopleNewsStati.m
//  PeopleNewsReaderPhone
//
//  Created by lygn128 on 13-9-4.
//
//

#import "PeopleNewsStati.h"
#import "ASIHTTPRequest.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "Reachability.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "OpenUDID.h"

@implementation PeopleNewsStati
+(PeopleNewsStati*)sharedStati
{
    static PeopleNewsStati * myStatic = nil;
    if (myStatic == nil) {
        if (myStatic == nil) {
            myStatic = [[PeopleNewsStati alloc]init];
        }
    }
    return myStatic;
}
-(id)init
{
    if(self = [super init]) {
        _resultOfStatic = [[NSUserDefaults standardUserDefaults]objectForKey:@"static.data"];
        NSLog(@"%@",_resultOfStatic.class);
        if (_resultOfStatic == nil) {
            _resultOfStatic = [[NSMutableDictionary alloc]init];
        }
    }
    return self;
}
+(id)alloc
{
    @synchronized(self)
    {
        static  PeopleNewsStati * myStatic = nil;
        if (myStatic == nil) {
            myStatic = [super alloc];
        }
        return myStatic;
    }
}
//tabbar点击
+(BOOL)insertNewEventLabel:(NSString *)aString andAction:(NSString *)actionName
{
    PeopleNewsStati * xxxxx = [PeopleNewsStati sharedStati];
    NSLog(@"%@",xxxxx.resultOfStatic);
    NSNumber * num = [xxxxx.resultOfStatic  objectForKey:aString];
    int  x = -1;
    if (num == nil) {
        x = 1;
    }else
    {
        x = [num intValue] + 1;
    }
    if (x > 5) {
        NSString * string = [NSString stringWithFormat:URLPrefix,actionName,aString,[OpenUDID value],x];
        NSLog(@"%@",string);
        ASIHTTPRequest * request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        NSLog(@"%@",request.url.absoluteString);
        [request setCompletionBlock:^{
            NSLog(@"%@",request.responseString);
            NSRange range = [request.responseString rangeOfString:@"<errorCode>0</errorCode>"];
            if (range.length > 0) {
                [xxxxx.resultOfStatic removeObjectForKey:aString];
            }else
            {
                [xxxxx.resultOfStatic setObject:[NSNumber numberWithInt:x] forKey:aString];
            }
            [request release];
        }];
        [request setFailedBlock:^{
            
            [request release];
        }];
        [request startAsynchronous];
    }else
    {
        [xxxxx.resultOfStatic setObject:[NSNumber numberWithInt:x] forKey:aString];
    }
    return YES;
}
#define HEADERURLPREFIX  @"http://mobile.app.people.com.cn:81/total/total.php?act=event_headpic&rt=xml&event_name=%@头图&appkey=rmw_t0vzf1&token=%@&id=%@&title=%@&count=1&type=get"

#define NEWSPREFIX  @"http://mobile.app.people.com.cn:81/total/total.php?act=event_news&rt=xml&event_name=%@&appkey=rmw_t0vzf1&token=%@&id=%@&title=%@&count=1&type=get"
//头条图片点击
+(BOOL)headPicEvent:(NSString *)aid nameOfEVent:(NSString*)channelName andTitle:(NSString *)aTitle
{
        NSString * string = [NSString stringWithFormat:HEADERURLPREFIX,channelName,[OpenUDID value],aid,aTitle];
        ASIHTTPRequest * request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        NSLog(@"%@",request.url.absoluteString);
        [request setCompletionBlock:^{
            NSLog(@"%@",request.responseString);
            NSRange range = [request.responseString rangeOfString:@"<errorCode>0</errorCode>"];
            if (range.length > 0) {
                
            }else
            {
                
            }
            [request release];
        }];
        [request setFailedBlock:^{
            
            [request release];
        }];
        [request startAsynchronous];
       return YES;
}
//每条新闻的点击
+(BOOL)newsEvent:(NSString *)aid nameOfEVent:(NSString*)channelName andTitle:(NSString *)aTitle
{
    NSString * string = [NSString stringWithFormat:NEWSPREFIX,channelName,[OpenUDID value],aid,aTitle];
    ASIHTTPRequest * request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSLog(@"%@",request.url.absoluteString);
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSRange range = [request.responseString rangeOfString:@"<errorCode>0</errorCode>"];
        if (range.length > 0) {
            NSLog(@"xxxxxx");
        }else
        {
            
        }
        [request release];
    }];
    [request setFailedBlock:^{
        
        [request release];
    }];
    [request startAsynchronous];
    return YES;
}
#define APPRECOPURLPREFI @"http://mobile.app.people.com.cn:81/total/total.php?act=event_app&rt=xml&appkey=rmw_t0vzf1&token=%@&id=%@&title=%@&count=1&type=get"
//应用推荐点击
+(BOOL)appRecommendEvent:(NSString *)appID  andAppName:(NSString *)appName
{
    NSString * string = [NSString stringWithFormat:APPRECOPURLPREFI,[OpenUDID value],appID,appName];
    ASIHTTPRequest * request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSLog(@"%@",request.url.absoluteString);
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSRange range = [request.responseString rangeOfString:@"<errorCode>0</errorCode>"];
        if (range.length > 0) {
            NSLog(@"xxxxxx");
        }else
        {
            
        }
        [request release];
    }];
    [request setFailedBlock:^{
        
        [request release];
    }];
    [request startAsynchronous];
    return YES;
}
#define APPOPENURLPREFIX  @"http://mobile.app.people.com.cn:81/total/total.php?act=event_start&rt=xml&appkey=rmw_t0vzf1&token=%@&channelid=0&client_ver=v%@&device_os=ios&device_model=%@&operator=%@&network_state=%@&device_size=800x480&visitid=%&ip=%@&type=get"
NSString * getNetworkState()
{
    NSString * state = nil;
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            state = @"";
            break;
        case ReachableViaWWAN:
            state = @"WWAN";
            break;
        case ReachableViaWiFi:
            state = @"WiFi";
            break;
    }
    return state;
}
NSString * getIPAddress()
 {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}
//启动统计
+(void)appOpenStatic
{
    NSString * appVersion   = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    NSString * device_model = [UIDevice currentDevice].model;
    NSString * operator     = getCellularProviderName();
    NSString * netWorkStae  = getNetworkState();
    NSString * deVice_szie  = (ISIPHONE5?@"1156x640":@"960x640");
    long        visiid      = [self sharedStati].timeOfAppOpen;
    NSString * ipAddress    = getIPAddress();
    NSString * urlString    = [NSString stringWithFormat:@"http://mobile.app.people.com.cn:81/total/total.php?act=event_start&rt=xml&appkey=rmw_t0vzf1&token=%@&channelid=0&client_ver=v%@&device_os=ios&device_model=%@&operator=%@&network_state=%@&device_size=%@&visitid=%lu&ip=%@&type=get",[OpenUDID value],appVersion,device_model,operator,netWorkStae,deVice_szie,visiid,ipAddress];
    ASIHTTPRequest * httrequest = [ASIHTTPRequest requestWithURL:[[NSURL alloc ]initWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [httrequest setCompletionBlock:^{
        NSLog(@"%@",httrequest.responseString);
        [httrequest release];
    }];
    [httrequest setFailedBlock:^{
        [httrequest release];
    }];
    [httrequest startAsynchronous];
}
//退出程序的统计
+(void)appExitStatic
{

    long        visiid      = [self sharedStati].timeOfAppOpen;
    //NSString * ipAddress    = getIPAddress();
    NSString * urlString    = [NSString stringWithFormat:@"http://mobile.app.people.com.cn:81/total/total.php?act=event_end&rt=xml&appkey=rmw_t0vzf1&token=%@&visitid=%lu&type=get",[OpenUDID value],visiid];
    ASIHTTPRequest * httrequest = [ASIHTTPRequest requestWithURL:[[NSURL alloc ]initWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [httrequest setCompletionBlock:^{
        NSLog(@"%@",httrequest.responseString);
        [httrequest release];
    }];
    [httrequest setFailedBlock:^{
        [httrequest release];
    }];
    [httrequest startAsynchronous];
}
//深度点击
+(void)deepStatideepID:(NSString*)aID deepTitle:(NSString*)aTitle
{
    NSString * string = [NSString stringWithFormat:@"http://mobile.app.people.com.cn:81/total/total.php?act=event_deep&rt=xml&appkey=rmw_t0vzf1&token=%@&id=%@&title=%@&count=1&type=get",[OpenUDID value],aID,aTitle];
    ASIHTTPRequest * request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSLog(@"%@",request.url.absoluteString);
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSRange range = [request.responseString rangeOfString:@"<errorCode>0</errorCode>"];
        if (range.length > 0) {
            NSLog(@"xxxxxx");
        }else
        {
            
        }
        [request release];
    }];
    [request setFailedBlock:^{
        
        [request release];
    }];
    [request startAsynchronous];
}
//http://mobile.app.people.com.cn:81/total/total.php?act=event_deep&rt=xml&appkey=rmw_t0vzf1&token=tttt&id=114&title=围观有度转发三思拒绝起哄&count=10&type=get
//参数说明
//act:跳转url对应PHP地址，不可修改
//rt:返回文件格式,xml，不可修改
//appkey:应用的密钥10位，由后台分配(人民新闻ios版:rmw_t0vzf1,人民新闻安卓版:rmw_10fxri)
//token:(可以是IMEI或mac地址,手机唯一标识)这个需要保证唯一
//title:该新闻对应的标题
//id:该新闻对应的id
//type:传值方式(post或get默认post)，可不传此参数
//count:累计次数，用户前端优化，可以累计到一定点击数量后提交,不传此参数默认为1次
//如果用post方式，需要向http://mobile.app.people.com.cn:81/total/total.php?act=event_deep&rt=xml post appkey、token、id、title、count五个参数

+(void)saveDataOfStatic
{
    NSMutableDictionary * dict  = [PeopleNewsStati sharedStati].resultOfStatic;
    [[NSUserDefaults standardUserDefaults]setObject:dict forKey:@"static.data"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
@end

NSString* getCellularProviderName()
{
    CTTelephonyNetworkInfo*netInfo = [[[CTTelephonyNetworkInfo alloc]init] autorelease];
    CTCarrier*carrier = [netInfo subscriberCellularProvider];
    return [carrier carrierName];
}



