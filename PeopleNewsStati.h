//
//  PeopleNewsStati.h
//  PeopleNewsReaderPhone
//
//  Created by lygn128 on 13-9-4.
//
//

#import <Foundation/Foundation.h>
#import <sys/ioctl.h>
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import  <time.h>
#define WODETOUTIAO   @"我的头条"
#define NEWS          @"新闻"
#define SHENDU        @"深度"
#define GENGDUO       @"更多"
#define LOADING       @"loading"
#define TABBARCLICK   @"event_button"
#define CHANNELSELECT @"event_channel"
#define URLPrefix  @"http://mobile.app.people.com.cn:81/total/total.php?act=%@&rt=xml&event_name=%@&appkey=rmw_t0vzf1&token=%@&count=%d&type=get"

NSString * getCellularProviderName();
@interface PeopleNewsStati : NSObject
{
}
@property(nonatomic,retain)NSMutableDictionary * resultOfStatic;
@property(nonatomic,assign)time_t                timeOfAppOpen;
+(BOOL)insertNewEventLabel:(NSString *)aString andAction:(NSString*)channelName;
+(void)saveDataOfStatic;
+(BOOL)headPicEvent:(NSString *)aid nameOfEVent:(NSString*)channelName andTitle:(NSString *)aTitle;
+(BOOL)newsEvent:(NSString *)aid nameOfEVent:(NSString*)channelName andTitle:(NSString *)aTitle;
+(BOOL)appRecommendEvent:(NSString *)appID  andAppName:(NSString *)appName;
+(PeopleNewsStati*)sharedStati;
+(void)appOpenStatic;
+(void)appExitStatic;
+(void)deepStatideepID:(NSString*)aID deepTitle:(NSString*)aTitle;
@end

