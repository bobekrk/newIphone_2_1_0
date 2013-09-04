//
//  PeopleNewsStati.m
//  PeopleNewsReaderPhone
//
//  Created by lygn128 on 13-9-4.
//
//

#import "PeopleNewsStati.h"
#import "ASIHTTPRequest.h"
#define URLPrefix @"http://mobile.app.people.com.cn:81/total/total.php?act=event_button&rt=xml&event_name=%@&appkey=rmw_t0vzf1&token=%@&count=%d&type=get"

#include <sys/socket.h> // Per msqr

#include <sys/sysctl.h>

#include <net/if.h>

#include <net/if_dl.h>
NSString * getLocalMacAddress()

{
    
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
    
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    free(buf);
    
    return [outstring uppercaseString];
    
}
@implementation PeopleNewsStati
+(PeopleNewsStati*)sharedStati
{
    static PeopleNewsStati * myStatic = nil;
    if (myStatic == nil) {
        myStatic = [[PeopleNewsStati alloc]init];
    }
    return myStatic;
}
-(id)init
{
    if (self = [super init]) {
        _resultOfStatic = [[NSMutableDictionary alloc]init];
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
+(BOOL)insertNewEventLabel:(NSString *)aString
{
    PeopleNewsStati * xxxxx = [PeopleNewsStati sharedStati];
    NSNumber * num = [xxxxx.resultOfStatic  objectForKey:aString];
    int  x = -1;
    if (num == nil) {
        x = 1;
    }else
    {
        x = [num intValue] + 1;
    }
    if (x > 100) {
     //   ASIHTTPRequest * request = [ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:URLPrefix,]]
    }else
    {
       //  [xxxxx.resultOfStatic setObject:[NSNumber numberWithInt:x] forKey:aString];
    }
    

}
@end
