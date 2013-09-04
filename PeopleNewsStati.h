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
#define WODETOUTIAO   @"我的头条"
#define NEWS          @"新闻"
#define SHENDU        @"深度"
#define GENGDUO       @"更多"
#define LOADING       @"loading"
#define  URLPrefix  @"http://mobile.app.people.com.cn:81/total/total.php?act=event_button&rt=xml&event_name=%@&appkey=rmw_t0vzf1&token=%@&count=%d&type=get"


//一）按钮类型统计
//按钮类型的分为：我的头条，新闻，深度，更多,loading点击,5种,分别对应参数event_name
//地址：
//http://mobile.app.people.com.cn:81/total/total.php?act=event_button&rt=xml&event_name=我的头条&appkey=rmw_t0vzf1&token=tttt&count=10&type=get
//参数说明
//act:跳转url对应PHP地址，不可修改
//rt:返回文件格式,xml，不可修改
//event_name:按钮事件名称
//appkey:应用的密钥10位，由后台分配(人民新闻ios版:rmw_t0vzf1,人民新闻安卓版:rmw_10fxri)
//token:(可以是IMEI或mac地址,手机唯一标识)这个需要保证唯一
//type:传值方式(post或get默认post)，可不传此参数
//count:累计次数，用户前端优化，可以累计到一定点击数量后提交,不传此参数默认为1次
//如果用post方式，需要向http://mobile.app.people.com.cn:81/total/total.php?act=event_button&rt=xml post event_name、appkey、token、count四个参数
NSString * getLocalMacAddress();
@interface PeopleNewsStati : NSObject
{
    
}
@property(nonatomic,retain)NSMutableDictionary * resultOfStatic;
+(BOOL)insertNewEventLabel:(NSString *)aString;
+(void)saveDataOfStatic;
@end
