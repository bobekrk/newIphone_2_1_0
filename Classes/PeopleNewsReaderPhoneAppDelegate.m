//
//  PeopleNewsReaderPhoneAppDelegate.m
//  PeopleNewsReaderPhone
//
//  Created by people.com.cn on 12-7-30.
//  Copyright 2012 people.com.cn. All rights reserved.
//

#import "PeopleNewsReaderPhoneAppDelegate.h"
#import "FSNewsContainerViewController.h"

#import "FSTabBarViewCotnroller.h"
#import "FSSlideViewController.h"

//#import "FSWeatherViewController.h"
#import "FSLocalWeatherViewController.h"
#import "FSSettingViewController.h"
#import "FSChannelSettingForOneDayViewController.h"

#import "FSOneDayNewsViewController.h"
#import "FSNewsViewController.h"
#import "FSTopicViewController.h"
#import "FSMoreViewController.h"

#import "FSCommonFunction.h"
#import "FSNetworkData.h"
#import "FSConst.h"
#import "FSCheckAppStoreVersionObject.h"
#import "FSHTTPWebExData.h"

#import "FSUserSelectObject.h"

//友盟追踪
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

//激活统计
#import "FS_GZF_StatisticePOSTXMLDAO.h"
//推送
#import "FS_GZF_PushTokenPOSTXMLDAO.h"


@interface PeopleNewsReaderPhoneAppDelegate(PrivateMethod)
- (void)showLoadingView;
- (void)showMainUserInterface;
- (void)showChannelSettingForOneDay;
@end


@implementation PeopleNewsReaderPhoneAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle
/*typedef NS_ENUM(NSInteger, UIStatusBarStyle) {
    UIStatusBarStyleDefault,
    UIStatusBarStyleBlackTranslucent,
    UIStatusBarStyleBlackOpaque
};

typedef NS_ENUM(NSInteger, UIStatusBarAnimation) {
    UIStatusBarAnimationNone,
#if __IPHONE_3_2 <= __IPHONE_OS_VERSION_MAX_ALLOWED
    UIStatusBarAnimationFade,
    UIStatusBarAnimationSlide,
#endif
};*/
extern NSString * CTSettingCopyMyPhoneNumber();
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
    _fsNewsContainerViewController_forPush = nil;
    //推送
    //如果在设置中开启 才注册推送
    [PeopleNewsStati sharedStati].timeOfAppOpen = time(NULL);
    if (launchOptions == nil) {
        [self performSelectorInBackground:@selector(xxxxx) withObject:nil];
    }
    
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = YES; // 是否允许截获并发送崩溃信息，请设置YES或者NO
    statTracker.channelId = @"AppStore";//设置您的app的发布渠道
    statTracker.logStrategy = BaiduMobStatLogStrategyCustom;//根据开发者设定的时间间隔接口发送 也可以使用启动时发送策略
    statTracker.logSendInterval = 1;  //为1时表示发送日志的时间间隔为1小时
    statTracker.logSendWifiOnly = YES; //是否仅在WIfi情况下发送日志数据
    statTracker.sessionResumeInterval = 60;//设置应用进入后台再回到前台为同一次session的间隔时间[0~600s],超过600s则设为600s，默认为30s
    //statTracker.shortAppVersion  =]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [statTracker startWithAppId:BAIDUAPPKEY];//设置您在mtj网站上添加的app的appkey

    if([[GlobalConfig shareConfig] readImportantNewsPush] == YES){
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }else{
        //注销推送 防止在更多里关闭时没正常注销
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
	
    [MobClick setDelegate:self reportPolicy:REALTIME];//友盟
    
    [self ShareWeiXinSetting];//微信
    
    
    //友盟追踪 begin
    NSString * appKey = @"361bcf569ed3991df0a74850a1f84d6f";
    
    NSString * deviceName = [[[UIDevice currentDevice] name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
   NSString * mac = [self macString];
    
    NSString * urlString = [NSString stringWithFormat:@"http://log.umtrack.com/ping/%@/?devicename=%@&udid=%@", appKey,deviceName,mac];
    
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:urlString]] delegate:nil];
    
    //友盟追踪 end
    
//    [self showLoadingView];
    
//    GlobalConfig *config = [GlobalConfig shareConfig];
//	BOOL isShowChannel = [config isPostChannel];
//	
//	if (!isShowChannel) {
//		[self showChannelSettingForOneDay];
//	} else {
//		[self showMainUserInterface];
//	}
    
    //激活统计
    [self postStatistice];
    
    //[self  fsLoaddingImageViewWillDisappear:nil];
    [self showFirstLoad];
    [self.window makeKeyAndVisible];
#ifdef MYDEBUG
 	NSLog(@"%@", NSLocalizedString(@"DemoTitle", nil)); 
#endif
    
//    [FSHTTPWebExData HTTPGetDataWithURLString:@"http://mobile.app.people.com.cn:81/paper/rmrb.php?action=iphone"
//                              blockCompletion:^(NSData *data, BOOL success) {
//                                  NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                  FSLog(@"test.str:%@", str);
//                                  [str release];
//    }];
	
    
    NSDictionary *value = (NSDictionary *)[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    //NSLog(@"didFinishLaunchingWithOptions");
    pushInof = [value retain];
    
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    _TimeForeground = [date timeIntervalSince1970];
    [date release];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //NSLog(@"%@",CTSettingCopyMyPhoneNumber());
        return YES;
}
-(void)xxxxx
{
    [PeopleNewsStati appOpenStatic];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)pToken {
    
    //NSLog(@"regisger success:%@", pToken);
    
    
    NSString *strToken = [NSString stringWithFormat:@"%@",pToken];
    
    strToken = [strToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    strToken = [strToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    strToken = [strToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"PushToken:%@",strToken);
    
    //注册成功，将deviceToken保存到应用服务器数据库中
    FS_GZF_PushTokenPOSTXMLDAO *fs_GZF_PushTokenPOSTXMLDAO = [[FS_GZF_PushTokenPOSTXMLDAO alloc] init];
    fs_GZF_PushTokenPOSTXMLDAO.token = strToken;
    [fs_GZF_PushTokenPOSTXMLDAO HTTPPostDataWithKind:HTTPPOSTDataKind_Normal];
    [fs_GZF_PushTokenPOSTXMLDAO release];
    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    // 处理推送消息
    pushInof = [userInfo retain];
    //NSLog(@"didReceiveRemoteNotification:");
    
    [self DidRecivePushMessage:userInfo];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    //NSLog(@"Regist fail%@",error);
    
}


-(void)DidRecivePushMessage:(NSDictionary *)Inof{
    
    if (Inof==nil) {
        return;
    }
    
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    NSTimeInterval timeNow = [date timeIntervalSince1970];
    [date release];
    
    if (timeNow - _TimeForeground<10) {
        [self ShowPushMessage:pushInof];
    }
    else{
        NSDictionary *valuedic = (NSDictionary *)[Inof objectForKey:@"aps"];
        NSString *value = (NSString *)[valuedic objectForKey:@"alert"];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"人民新闻" message:value delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消", @"打开",nil];
        [alert show];
        [alert release];
    }
    //return;
    
   
    
}


-(void)ShowPushMessage:(NSDictionary *)Inof{
   
    //NSLog(@"Inof:%@",Inof);
    
    NSString *nid = (NSString *)[Inof objectForKey:@"nid"];
    //NSLog(@"nid:%@",nid);
    
    if (_fsNewsContainerViewController_forPush!=nil) {
        [_fsNewsContainerViewController_forPush dismissModalViewControllerAnimated:NO];
        [_fsNewsContainerViewController_forPush release];
        _fsNewsContainerViewController_forPush = nil;
    }
    
    _fsNewsContainerViewController_forPush = [[FSNewsContainerViewController alloc] init];
    _fsNewsContainerViewController_forPush.obj = nil;
    _fsNewsContainerViewController_forPush.FCObj = nil;
    _fsNewsContainerViewController_forPush.newsSourceKind = NewsSourceKind_PushNews;
    _fsNewsContainerViewController_forPush.newsID = nid;
    _fsNewsContainerViewController_forPush.isNewNavigation = YES;
    
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if (version>=6.0) {
        [_slideViewController.rootViewController presentViewController:_fsNewsContainerViewController_forPush animated:YES completion:^{}];
    }
    else{
        [_slideViewController.rootViewController presentModalViewController:_fsNewsContainerViewController_forPush animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (buttonIndex == 1) {
        [self ShowPushMessage:pushInof];
    }
    
    [pushInof release];
    pushInof = nil;
}




- (void)applicationWillResignActive:(UIApplication *)application {
    
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [PeopleNewsStati saveDataOfStatic];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [PeopleNewsStati  appExitStatic];
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    //[self saveContext];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [PeopleNewsStati sharedStati].timeOfAppOpen = time(NULL);
    [self performSelectorInBackground:@selector(xxxxx) withObject:nil];
    /*
     Called as part of the transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    //NSLog(@"applicationWillEnterForeground");
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    _TimeForeground = [date timeIntervalSince1970];
    [date release];
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	FSCheckAppStoreVersionObject *checkAppStoreVersionObject = [[FSCheckAppStoreVersionObject alloc] init];
	[checkAppStoreVersionObject checkAppVersion:MYAPPLICATIONID_IN_APPSTORE];
	[checkAppStoreVersionObject release];
    
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    //[self saveContext];
    //[PeopleNewsStati  saveDataOfStatic];
    [PeopleNewsStati  appExitStatic];
}


- (void)saveContext {
    
//    NSError *error = nil;
//	NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
//    if (managedObjectContext != nil) {
//        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
//
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        } 
//    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PeopleNewsReaderPhone" withExtension:@"momd"];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel_;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PeopleNewsReaderPhone.sqlite"];
    //NSLog(@"stroeURL:%@", [storeURL absoluteURL]);
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	//local store
	//简单迁移
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
							 NSMigratePersistentStoresAutomaticallyOption,
							 [NSNumber numberWithBool:YES],
							 NSInferMappingModelAutomaticallyOption, nil];
	
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {

        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        NSFileManager *fm = [NSFileManager defaultManager];
        
        NSString *fullFileName = [getCachesPath() stringByAppendingPathComponent:[storeURL lastPathComponent]];
        
		if (![fm removeItemAtPath:fullFileName error:&error]) {
			//NSLog(@"removeItemAtPath:%@:%@",fullFileName,error);
		}
		if ([persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]){
            //NSLog(@"addPersistentStoreWithType");
			return persistentStoreCoordinator_;
		}else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"人民新闻" message:@"初始化配置文件失败，请删除旧版本后重新下载安装！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
			
		}
        
    }    
    
    return persistentStoreCoordinator_;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
//	NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
//	NSLog(@"urls:%@", urls);
	
	NSURL *url = [[[NSURL alloc] initFileURLWithPath:getCachesPath()] autorelease];
#ifdef MYDEBUG
	NSLog(@"url:%@", url);
#endif
    return url;
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    
    [managedObjectContext_ release];
    [managedObjectModel_ release];
    [persistentStoreCoordinator_ release];
    
	[_slideViewController release];
	[_rootViewController release];
	[_navChannelSettingController release];
    [window release];
    if (_fsNewsContainerViewController_forPush!=nil) {
        [_fsNewsContainerViewController_forPush release];
    }
    [super dealloc];
}

#pragma mark -
#pragma mark FSLoadingViewDelegate

-(void)endShowImage:(FSLoadingImageView *)loadingImageView{
	//loadingImageView.alpha = 0.0f;
	//[loadingImageView removeFromSuperview];
	//[loadingImageView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];	
}


#pragma mark -
#pragma mark PrivateMethod
-(void)loading
{
    [PeopleNewsStati insertNewEventLabel:LOADING andAction:TABBARCLICK];
}
-(void)showLoadingView{
    float xxx = ISIPHONE5?548:460;
    [self performSelectorInBackground:@selector(loading) withObject:nil];
    FSLoadingImageView *loadingView = [[FSLoadingImageView alloc] initWithFrame:CGRectMake(0, 0, 320, xxx)];
    loadingView.userInteractionEnabled = YES;
    //loadingView.parentDelegate = self;
    [self.window addSubview:loadingView];
    [loadingView release];
}



- (void)showMainUserInterface {

	FSUINavigationController * navi = nil;
	if (_slideViewController == nil) {
		_slideViewController = [[FSSlideViewController alloc] init];
        navi = [[FSUINavigationController alloc]initWithRootViewController:_slideViewController];
        navi.navigationBarHidden      = YES;
    }
	
	if (_rootViewController == nil) {
		NSMutableArray *fsViewCtrls = [[NSMutableArray alloc] init];
		_rootViewController = [[FSTabBarViewCotnroller alloc] init];
        
		//1.
		FSOneDayNewsViewController *oneDayNewsCtrl = [[FSOneDayNewsViewController alloc] init];
        oneDayNewsCtrl.canBeHaveNaviBar            = YES;
		FSUINavigationController *navOneDayNewsCtrl = [[FSUINavigationController alloc] initWithRootViewController:oneDayNewsCtrl];
        navOneDayNewsCtrl.navigationBarHidden      = YES;
        //[navOneDayNewsCtrl setViewControllers:[NSArray arrayWithObject:oneDayNewsCtrl]];
		[fsViewCtrls addObject:navOneDayNewsCtrl];
		[navOneDayNewsCtrl release];
		[oneDayNewsCtrl release];
		
		//2.
		FSNewsViewController *newsCtrl = [[FSNewsViewController alloc] init];
        newsCtrl.canBeHaveNaviBar      = YES;
		FSUINavigationController *navNewsCtrl = [[FSUINavigationController alloc] initWithRootViewController:newsCtrl];
        navNewsCtrl.navigationBarHidden = YES;
		[fsViewCtrls addObject:navNewsCtrl];
		[navNewsCtrl release];
		[newsCtrl release];
		
		//3.
		FSTopicViewController *topicCtrl = [[FSTopicViewController alloc] init];
        topicCtrl.canBeHaveNaviBar       = YES;
		FSUINavigationController *navTopicCtrl = [[FSUINavigationController alloc] initWithRootViewController:topicCtrl];
        navTopicCtrl.navigationBarHidden = YES;
		[fsViewCtrls addObject:navTopicCtrl];
		[navTopicCtrl release];
		[topicCtrl release];
		
		//4.
		FSMoreViewController *moreCtrl = [[FSMoreViewController alloc] init];
        moreCtrl.canBeHaveNaviBar      = YES;
		FSUINavigationController *navMoreCtrl = [[FSUINavigationController alloc] initWithRootViewController:moreCtrl];
        navMoreCtrl.navigationBarHidden = YES;
		[fsViewCtrls addObject:navMoreCtrl];
		[navMoreCtrl release];
		[moreCtrl release];
//
        _rootViewController.fsViewControllers = fsViewCtrls;
		[fsViewCtrls release];
        
	}
	

	
	_slideViewController.rootViewController = _rootViewController;
    self.window.rootViewController = navi;
    [navi release];
    [self DidRecivePushMessage:pushInof];
    
}

- (void)showChannelSettingForOneDay {
	FSChannelSettingForOneDayViewController *channelSettingCtrl = [[FSChannelSettingForOneDayViewController alloc] init];
    channelSettingCtrl.isReSetting                              = YES;
	channelSettingCtrl.parentDelegate                           = self;
    self.window.rootViewController                              = channelSettingCtrl;
    [channelSettingCtrl release];
}

- (void)fsChannelSettingForOneDayViewControllerWillDisapear:(FSChannelSettingForOneDayViewController *)sender {
	[self showMainUserInterface];
}

- (void)fsChannelSettingForOneDayViewControllerDidDisapper:(FSChannelSettingForOneDayViewController *)sender {
    [self showMainUserInterface];
}
-(void)showFirstLoad
{
    GlobalConfig *config = [GlobalConfig shareConfig];
	BOOL isShowChannel = [config isPostChannel];
	
	if (!isShowChannel) {
		[self showChannelSettingForOneDay];
	} else {
		[self showMainUserInterface];
	}
    [self showLoadingView];
}

- (void)fsLoaddingImageViewWillDisappear:(FSLoadingImageView *)sender {
	
}

- (void)fsLoaddingImageViewDidDisappear:(FSLoadingImageView *)sender {
}


//****************************************
//微信分享设置

-(void)ShareWeiXinSetting{
    [WXApi registerApp:@"wx4490d5048d2feccc"];//微信wx4490d5048d2feccc
}

/////////////////////////////////////////////
//	微信需要
/////////////////////////////////////////////
- (BOOL)sendWXTextMessage:(NSString *)content {
	
	SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = YES;
    req.text = content;
    BOOL rst = [WXApi sendReq:req];
	[req release];
	
	return rst;
}

//普通分享
- (BOOL)sendWXMidiaMessage:(NSString *)title content:(NSString *)content thumbImage:(UIImage *)thumbImage webURL:(NSString *)webURL {
    
	BOOL rst = NO;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = content;
    [message setThumbImage:thumbImage];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = webURL;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;//普通分享
    //req.scene = WXSceneTimeline;//朋友圈分享
    
    rst = [WXApi sendReq:req];
	return rst;
}

//朋友圈分享

- (BOOL)sendWXMidiaMessagePYQ:(NSString *)title content:(NSString *)content thumbImage:(UIImage *)thumbImage webURL:(NSString *)webURL {
    
	BOOL rst = NO;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = content;
    [message setThumbImage:thumbImage];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = webURL;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    //req.scene = WXSceneSession;//普通分享
    req.scene = WXSceneTimeline;//朋友圈分享
    
    rst = [WXApi sendReq:req];
	return rst;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
#ifdef MYDEBUG
	NSLog(@"handleOpenURL.url:%@", [url absoluteString]);
#endif
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
#ifdef MYDEBUG
	NSLog(@"openURL.url:%@", [url absoluteString]);
#endif
    return  [WXApi handleOpenURL:url delegate:self];
}

-(void) onReq:(BaseReq*)req {
	
}

-(void) onResp:(BaseResp*)resp {
    
    
    
	if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
		if (resp.errCode == WXSuccess) {
			//[CommonFuncs showMessage:@"人民新闻" ContentMessage:@"分享到微信成功"];
		} else {
			//[CommonFuncs showMessage:@"人民新闻" ContentMessage:@"分享到微信失败"];
		}
        
        //        NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
        //        NSString *strMsg = [NSString stringWithFormat:@"发送媒体消息结果:%d", resp.errCode];
        //
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alert show];
        //        [alert release];
    }
}
/////////////////////////////////////////////
//	微信需要
/////////////////////////////////////////////

//友盟
-(NSString *)appKey{
	return @"4ed5f5da527015150700001b";
}



//友盟追踪

-(NSString *)macString{
    int                 mib[6];
    
    size_t              len;
    
    char                *buf;
    
    unsigned char       *ptr;
    
    struct if_msghdr    *ifm;
    
    struct sockaddr_dl  *sdl;
    
    
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return macString;
}

//激活统计

-(void)postStatistice{
    FS_GZF_StatisticePOSTXMLDAO *fs_GZF_StatisticePOSTXMLDAO = [[FS_GZF_StatisticePOSTXMLDAO alloc] init];
    [fs_GZF_StatisticePOSTXMLDAO HTTPPostDataWithKind:HTTPPOSTDataKind_Normal];
    [fs_GZF_StatisticePOSTXMLDAO release];
}
//更新更多界面 用户更改设置后执行
-(void)updateMoreControllerView{
    if([_rootViewController.fsViewControllers count] > 0){
        for (int i = 0; i<[_rootViewController.fsViewControllers count]; i++) {
            UINavigationController* c = [_rootViewController.fsViewControllers objectAtIndex:i];
            if ([c isKindOfClass:[UINavigationController class]]) {
                for (int j=0; j<[c.viewControllers count]; j++) {
                    UIViewController* nc = [c.viewControllers objectAtIndex:j];
                    NSLog(@"NC:%@",nc);
                    if([nc isKindOfClass:[FSMoreViewController class]]){
                        FSMoreViewController *mc = (FSMoreViewController*)nc;
                        [mc updateTableView];
                        
                    }
                }

            }

        }
    }
}

@end

