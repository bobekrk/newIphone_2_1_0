//
//  PeopleNewsStati.m
//  PeopleNewsReaderPhone
//
//  Created by lygn128 on 13-9-4.
//
//

#import "PeopleNewsStati.h"
#import "ASIHTTPRequest.h"


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
        NSString * string = [NSString stringWithFormat:URLPrefix,actionName,aString,getLocalMacAddress(),x];
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
+(BOOL)headPicEvent:(NSString *)aid nameOfEVent:(NSString*)channelName andTitle:(NSString *)aTitle
{
        NSString * string = [NSString stringWithFormat:HEADERURLPREFIX,channelName,getLocalMacAddress(),aid,aTitle];
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
+(BOOL)newsEvent:(NSString *)aid nameOfEVent:(NSString*)channelName andTitle:(NSString *)aTitle
{
    NSString * string = [NSString stringWithFormat:NEWSPREFIX,channelName,getLocalMacAddress(),aid,aTitle];
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
+(BOOL)appRecommendEvent:(NSString *)appID  andAppName:(NSString *)appName
{
    NSString * string = [NSString stringWithFormat:APPRECOPURLPREFI,getLocalMacAddress(),appID,appName];
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
+(void)saveDataOfStatic
{
    NSMutableDictionary * dict  = [PeopleNewsStati sharedStati].resultOfStatic;
    [[NSUserDefaults standardUserDefaults]setObject:dict forKey:@"static.data"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
@end
NSString * getLocalMacAddress()
{
    static NSString  * outstring = nil;
    if ([outstring length] > 0) {
        return [outstring uppercaseString];
    }
    
    int                    mib[6];
    
    size_t                len;
    
    char                *buf;
    
    unsigned char        *ptr;
    
    struct if_msghdr    *ifm;
    
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    
    mib[1] = AF_ROUTE;
    
    mib[2] = 0;
    
    mib[3] = AF_LINK;
    
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        
        //printf("Error: if_nametoindex error/n");
        
        return NULL;
        
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        
        //printf("Error: sysctl, take 1/n");
        
        return NULL;
        
    }
    
    if ((buf = malloc(len)) == NULL) {
        
        //printf("Could not allocate memory. error!/n");
        
        return NULL;
        
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        
        //printf("Error: sysctl, take 2");
        
        return NULL;
        
    }
    
    ifm = (struct if_msghdr *)buf;
    
    sdl = (struct sockaddr_dl *)(ifm + 1);
    
    ptr = (unsigned char *)LLADDR(sdl);
    
    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    [outstring retain];
    free(buf);
    
    return [outstring uppercaseString];
    
}

