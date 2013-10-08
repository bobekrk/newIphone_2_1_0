     //
//  FSSettingViewController.m
//  PeopleNewsReaderPhone
//
//  Created by people.com.cn on 12-8-13.
//  Copyright 2012 people.com.cn. All rights reserved.
//
#import "PeopleNewsReaderPhoneAppDelegate.h"
#import "FSSettingViewController.h"
#import "FSMyFavoritesViewController.h"
#import "FSUINavigationController.h"
#import "FSSlideViewController.h"
#import "FSLocalWeatherViewController.h"
#import "FSCheckAppStoreVersionObject.h"

#import "FS_GZF_AppUpdateDAO.h"


#import "FSChannelSettingForOneDayViewController.h"
#import "FSALLSettingViewController.h"

#import "FSCommonFunction.h"
#import "GlobalConfig.h"

#define FSSETTING_VIEW_NAVBAR_HEIGHT 44.0f

@implementation FSSettingViewController

- (id)init {
	self = [super init];
	if (self) {
		
	}
	return self;
}

- (void)dealloc {
	[_navTopBar release];
	[_settingView release];
    [_fs_GZF_GetNewsDataForOFFlineDAO release];
    _myMessageDao.parentDelegate = nil;
    [_myMessageDao release];
    [super dealloc];
}
-(void)addNavView
{
    _navTopBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, FSSETTING_VIEW_NAVBAR_HEIGHT)];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
        [_navTopBar setBackgroundImage:[UIImage imageNamed: @"navigatorBar.png"] forBarMetrics:UIBarMetricsDefault];
    }
	UINavigationItem *topItem = [[UINavigationItem alloc] init];
	NSArray *items = [[NSArray alloc] initWithObjects:topItem, nil];
	_navTopBar.items = items;
	_navTopBar.topItem.title = NSLocalizedString(@"工具栏", nil);
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18], UITextAttributeFont,[UIColor blackColor],UITextAttributeTextColor,nil];
    _navTopBar.titleTextAttributes = dict;
	[topItem release];
	[items release];
	[self.view addSubview:_navTopBar];
}

- (void)loadChildView {
		

    [self addNavView];
    //the setting view
    _settingView = [[FSNewSettingView alloc]initWithFrame:CGRectMake(0.0f, FSSETTING_VIEW_NAVBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - FSSETTING_VIEW_NAVBAR_HEIGHT)];
    _settingView.delegate = self;
    [self.view addSubview:_settingView];
    
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightAction:)];
    swipeRight.delegate = self;
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [_settingView addGestureRecognizer:swipeRight];
    [swipeRight release];
    
    _fs_GZF_GetNewsDataForOFFlineDAO = [[FS_GZF_GetNewsDataForOFFlineDAO alloc] init];//离线下载
    _fs_GZF_GetNewsDataForOFFlineDAO.parentDelegate = self;
    _fs_GZF_GetNewsDataForOFFlineDAO.parentView = self.view;
    
    
    
//    _myMessageDao = [[FS_GZF_GetWeatherMessageDAO alloc] init];
//    _myMessageDao.group =   getCityName();
//    _myMessageDao.parentDelegate = self;
//    _myMessageDao.isGettingList = NO;
//    [_myMessageDao HTTPGetDataWithKind:GET_DataKind_ForceRefresh];
}
- (void)weatherNewsViewButtonClick
{
    FSLocalWeatherViewController *weatherCtrl = [[FSLocalWeatherViewController alloc] init];
    //weatherCtrl.fs_GZF_localGetWeatherMessageDAO = _myMessageDao;
    weatherCtrl.canBeHaveNaviBar = YES;
    UINavigationController * navi = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    [navi pushViewController:weatherCtrl animated:YES];
    [weatherCtrl release];
}
#pragma mark - FSNewSettingViewDelegate
//***************************************
//by QIN,Zhuoran
//implement the FSNewSettingView delegate

//离线下载----字体设置
- (void)tappedInSettingView:(UIView *)settingView downloadButton:(UIButton *)button
{
    NSLog(@"download");
    
    FSChannelSettingForOneDayViewController *fsChannelSettingForOneDayViewController = [[FSChannelSettingForOneDayViewController alloc] init];
    fsChannelSettingForOneDayViewController.isReSetting = YES;

    [self.fsSlideViewController presentModalViewController:fsChannelSettingForOneDayViewController animated:YES];
    //[self.navigationController pushViewController:fsChannelSettingForOneDayViewController animated:YES];
    [fsChannelSettingForOneDayViewController release];
    


}

-(void)doSomethingWithDAO:(FSBaseDAO *)sender withStatus:(FSBaseDAOCallBackStatus)status
{
    if ([sender isEqual:_myMessageDao]) {
        if (status == FSBaseDAOCallBack_SuccessfulStatus ||
            status == FSBaseDAOCallBack_BufferSuccessfulStatus) {
            //NSLog(@"_fs_GZF_GetWeatherMessageDAO");
            if ([_myMessageDao.objectList count]>0) {
                if (status == FSBaseDAOCallBack_SuccessfulStatus) {
                    [_myMessageDao operateOldBufferData];
                }
                
                @synchronized(self)
                {
                    [_settingView updataWeatherStatus];
                }
                
            }
            
        }
    }
}


//设置
- (void)tappedInSettingView:(UIView *)settingView nightModeButton:(UIButton *)button
{
    NSLog(@"nigth mode");
    
    //设置
    
    
    FSALLSettingViewController *fsSettingViewController = [[FSALLSettingViewController alloc] init];
    fsSettingViewController.isnavTopBar = YES;
    [self.fsSlideViewController presentModalViewController:fsSettingViewController animated:YES];
    [fsSettingViewController release];
    
}

//我的收藏
- (void)tappedInSettingView:(UIView *)settingView myCollectionButton:(UIButton *)button
{
    NSLog(@"MY CLOLLECTION");
    NSArray * xxx  = [[FSBaseDB sharedFSBaseDB] getAllObjectsSortByKey:@"FSMyFaverateObject" key:@"UPDATE_DATE" ascending:NO];
    if (!xxx||xxx.count == 0) {
        UIAlertView * oooo = [[UIAlertView alloc]initWithTitle:@"没有找到收藏记录" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [oooo show];
        return;
    }
    FSMyFavoritesViewController *myFavoritesCtrl = [[FSMyFavoritesViewController alloc] init];
    myFavoritesCtrl.isnavTopBar                  = YES;
    myFavoritesCtrl.title                        = @"我的收藏";
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18], UITextAttributeFont,[UIColor blackColor],UITextAttributeTextColor,nil];
    myFavoritesCtrl.navigationController.navigationBar.titleTextAttributes = dict;
    FSUINavigationController *navMyFavoritesCtrl = [[FSUINavigationController alloc] initWithRootViewController:myFavoritesCtrl];
    [self.fsSlideViewController  presentModalViewController:navMyFavoritesCtrl animated:YES];
    [navMyFavoritesCtrl release];
    [myFavoritesCtrl release];
}




//清理缓存
- (void)tappedInSettingView:(UIView *)settingView clearMemoryButton:(UIButton *)button{
    NSLog(@"CLEAR MEMORY");
    //[self clearAllBufferWithPath];
    [self performSelectorInBackground:@selector(clearAllBufferWithPath) withObject:nil];
}

//检查更新
- (void)tappedInSettingView:(UIView *)settingView updateButton:(UIButton *)button
{
    FSCheckAppStoreVersionObject *checkAppStoreVersionObject = [[FSCheckAppStoreVersionObject alloc] init];
    checkAppStoreVersionObject.isManual = YES;
	[checkAppStoreVersionObject checkAppVersion:MYAPPLICATIONID_IN_APPSTORE];
	[checkAppStoreVersionObject release];

}
-(void)xxxxxxx:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"通知"
                                                   message:message
                                                  delegate:self
                                         cancelButtonTitle:@"返回" otherButtonTitles: nil];
    [alert show];
    [alert release];
}

-(void)clearAllBufferWithPath{
    
    [[FSBaseDB sharedFSBaseDB] clearCache];
    
    GlobalConfig *config = [GlobalConfig shareConfig];
    BOOL mark = NO;
        
    NSString *cachePath = getCachesPath();
    if (![config clearBufferWithPath:cachePath]) {
        mark = YES;
    }
   
    NSString *message;
    if (mark == YES) {
        message = @"不能完全清除缓存文件";
    }else{
       message = @"缓存文件已经成功清除！";
    }
    [self performSelectorOnMainThread:@selector(xxxxxxx:) withObject:message waitUntilDone:nil];
}


//***************************************
-(void)swipeRightAction:(id)sender{
    [self.fsSlideViewController resetViewControllerWithAnimated:NO];
}


- (void)layoutControllerViewWithRect:(CGRect)rect {
	_navTopBar.frame = CGRectMake(0.0f, 0.0f, rect.size.width, FSSETTING_VIEW_NAVBAR_HEIGHT);
	_settingView.frame = CGRectMake(0.0f, FSSETTING_VIEW_NAVBAR_HEIGHT, rect.size.width, rect.size.height - FSSETTING_VIEW_NAVBAR_HEIGHT);
}


-(void)doSomethingForViewFirstTimeShow{
        [_myMessageDao HTTPGetDataWithKind:GET_DataKind_ForceRefresh];
}

@end
