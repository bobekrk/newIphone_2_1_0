    //
//  FSMoreViewController.m
//  PeopleNewsReaderPhone
//
//  Created by people.com.cn on 12-8-13.
//  Copyright 2012 people.com.cn. All rights reserved.
//

#import "FSMoreViewController.h"
#import "FSMoreTableListTopCell.h"
#import "FSMoreTablePeopleAPPCell.h"
//#import "FSRecommendListCell.h"
#import "FSSettingViewController.h"

#import "FSSlideViewController.h"
//#import "FSWeatherViewController.h"
#import "FSLocalWeatherViewController.h"

#import "FSNewsTextFontSettingController.h"
//#import "FSLanguageSettingViewController.h"
#import "FSChannelSettingForOneDayViewController.h"
#import "FSAuthorizationViewController.h"

#import "FSALLSettingViewController.h"
#import "FSAboutViewController.h"
#import "FSCommonFunction.h"
#import "FSFeedbackViewController.h"

#import "FS_GZF_AppRecommendDAO.h"
#import "FSRecommentAPPObject.h"
#import "FSTabBarViewCotnroller.h"
#import "FSAppStoreViewController.h"

#import "FSMoreAPPRecommendViewController.h"


@implementation FSMoreViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (id)init {
	self = [super init];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:@"refreshSetting" object:nil];
	if (self) {
		NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
        _TimeInterval = [date timeIntervalSince1970];
		[date release];
	}
	return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObject:self];
    [_fs_GZF_AppRecommendDAO release];
    [_peopleAPPS removeAllObjects];
    [_peopleAPPS release];
    [_RecommentAPPS removeAllObjects];
    [_RecommentAPPS release];
    
    [super dealloc];
}

- (void)loadChildView {
	[super loadChildView];
    _fsMoreContainerView = [[FSMoreContainerView alloc] init];
    _fsMoreContainerView.parentDelegate = self;
    _fsMoreContainerView.flag = 0;
    [self.view addSubview:_fsMoreContainerView];
    [_fsMoreContainerView release];
	//self.view.backgroundColor = [UIColor blueColor];
	
	//标签栏设置
	//[self.fsTabBarItem setTabBarItemWithNormalImage:[UIImage imageNamed:@"more.png"] withSelectedImage:[UIImage imageNamed:@"more.png"] withText:NSLocalizedString(@"更多", nil)];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftAction:)];
    swipeLeft.delegate = self;
    swipeLeft.direction = UISwipeGestureRecognizerDirectionRight;
    [_fsMoreContainerView addGestureRecognizer:swipeLeft];
    [swipeLeft release];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightAction:)];
    swipeRight.delegate = self;
    swipeRight.direction = UISwipeGestureRecognizerDirectionLeft;
    [_fsMoreContainerView addGestureRecognizer:swipeRight];
    [swipeRight release];
    
    
}

- (UIImage *)tabBarItemNormalImage {
	return [UIImage imageNamed:@"moresubj.png"];
}

- (NSString *)tabBarItemText {
	return NSLocalizedString(@"更多", nil);
}

- (UIImage *)tabBarItemSelectedImage {
	return [UIImage imageNamed:@"moresubj_sel.png"];
}

- (void)layoutControllerViewWithRect:(CGRect)rect {
    rect.origin.y = self.canBeHaveNaviBar?44:0;
    rect.size.height -= (self.canBeHaveNaviBar?44:0);
    _fsMoreContainerView.frame = rect;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _peopleAPPS = [[NSMutableArray alloc] init];
    _RecommentAPPS = [[NSMutableArray alloc] init];
    
    //[_fsMoreContainerView loadData];
}

-(void)doSomethingForViewFirstTimeShow{
    
}

-(void)swipeLeftAction:(id)sender{
    return;
    [self  showLoadingView];
}

-(void)swipeRightAction:(id)sender{
    return;
    if ([self.fsSlideViewController.rightViewController isKindOfClass:[FSSettingViewController class]]) {
        [self.fsSlideViewController slideViewController:self.fsSlideViewController.rightViewController withKind:PushViewControllerKind_Right withAnimation:YES];
    }
    else{
        FSSettingViewController *settingCtrl = [[FSSettingViewController alloc] init];
        [self.fsSlideViewController slideViewController:settingCtrl withKind:PushViewControllerKind_Right withAnimation:YES];
        [settingCtrl release];
    }
}


//************************************************************
-(void)initDataModel{
    _fs_GZF_AppRecommendDAO = [[FS_GZF_AppRecommendDAO alloc]init];
    _fs_GZF_AppRecommendDAO.parentDelegate = self;
    
}


- (void)layoutControllerViewWithInterfaceOrientation:(UIInterfaceOrientation)willToOrientation {
	[super layoutControllerViewWithInterfaceOrientation:willToOrientation];
	//NSLog(@"layoutControllerViewWithInterfaceOrientation 111");
    
    
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    NSTimeInterval currentTimeInterval = [date timeIntervalSince1970];
    [date release];
    
    if ([_fs_GZF_AppRecommendDAO.objectList count] == 0 || currentTimeInterval - _TimeInterval>60*2) {
        NSLog(@"刷新1111");
        _TimeInterval = currentTimeInterval;
        [_fs_GZF_AppRecommendDAO HTTPGetDataWithKind:GET_DataKind_Unlimited];
    }
    else{
        NSLog(@"时间过短");
        //[_scrollPageView loadPageData];
    }
    
}



-(void)doSomethingWithDAO:(FSBaseDAO *)sender withStatus:(FSBaseDAOCallBackStatus)status{
    NSLog(@"doSomethingWithDAO");
    if ([sender isEqual:_fs_GZF_AppRecommendDAO]) {
        if (status == FSBaseDAOCallBack_SuccessfulStatus || status == FSBaseDAOCallBack_BufferSuccessfulStatus) {
            if ([_fs_GZF_AppRecommendDAO.objectList count]>0) {
                [_peopleAPPS removeAllObjects];
                [_RecommentAPPS removeAllObjects];
                NSLog(@"doSomethingWithDAO:%d",[_fs_GZF_AppRecommendDAO.objectList count]);
                for (FSRecommentAPPObject *o in _fs_GZF_AppRecommendDAO.objectList) {
                    if ([o.appType isEqualToString:@"1"]) {
                       // NSLog(@"11111111");
                        [_peopleAPPS addObject:o];
                    }
                    if ([o.appType isEqualToString:@"2"]) {
                       // NSLog(@"222222");
                        [_RecommentAPPS addObject:o];
                    }
                }
                _fsMoreContainerView.data = _fs_GZF_AppRecommendDAO.objectList;
                [_fsMoreContainerView loadData];
                if (status == FSBaseDAOCallBack_SuccessfulStatus) {
                    [_fs_GZF_AppRecommendDAO operateOldBufferData];
                }
            }
        }
        if (status == FSBaseDAOCallBack_WorkingStatus) {
//            FSIndicatorMessageView *indicatorMessageView = [[FSIndicatorMessageView alloc] initWithFrame:self.view.frame andBool:NO];
//            [indicatorMessageView showIndicatorMessageViewInView:_fsMoreContainerView withMessage:[self indicatorMessageTextWithDAO:sender withStatus:status]];
//            [indicatorMessageView release];
        }
    }
}

 
#pragma mark -
#pragma FSTableContainerViewDelegate mark

- (UITableViewCellSelectionStyle) tableViewCellSelectionStyl:(FSTableContainerView *)sender withIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellSelectionStyleNone;
}


-(NSInteger)tableViewSectionNumber:(FSTableContainerView *)sender{
    return 3;
}

-(NSInteger)tableViewNumberInSection:(FSTableContainerView *)sender section:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    return 3;
}

-(NSString *)tableViewSectionTitle:(FSTableContainerView *)sender section:(NSInteger)section{
    return @"";
}

-(NSObject *)tableViewCellData:(FSTableContainerView *)sender withIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    
    if (section==1) {
        switch (row) {
            case 0:
                return @"新闻推送";
                break;
            case 1:
                return @"正文全屏功能";
                break;
            case 2:
                return @"只WiFi网络加载图片";
                break;
            case 3:
                return @"账号管理";
            default:
                break;
        }
    }
    return @"more";
}


-(void)tableViewDataSourceDidSelected:(FSTableContainerView *)sender withIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    if (section == 0) {
        NSLog(@"FSNewsTextFontSettingControllerFSNewsTextFontSettingController:%d",row);
        if (row == 0) {
            //字体设置
            FSNewsTextFontSettingController *fsSettingViewController = [[FSNewsTextFontSettingController alloc] init];
            fsSettingViewController.isnavTopBar                      = YES;
            //[self.navigationController presentModalViewController:fsSettingViewController animated:YES];
            [self.parentNavigationController pushViewController:fsSettingViewController animated:YES];
           // [self.navigationController pushViewController:fsSettingViewController animated:YES];
            fsSettingViewController.navigationController.navigationBarHidden = YES;
            [fsSettingViewController release];
            
        }
        if (row == 1){
            //账号绑定
            FSAuthorizationViewController *fsAuthorizationViewController = [[FSAuthorizationViewController alloc] init];
            fsAuthorizationViewController.isnavTopBar                    = YES;
            //[self.navigationController presentModalViewController:fsAuthorizationViewController animated:YES];
            //[self.parentNavigationController presentModalViewController:fsAuthorizationViewController animated:YES];
            [self.parentNavigationController pushViewController:fsAuthorizationViewController animated:YES];
            [fsAuthorizationViewController release];
        }
    }
    
    
    if (section == 2) {
        if (row == 0) {
            FSFeedbackViewController *fsFeedbackViewController = [[FSFeedbackViewController alloc] init];
            fsFeedbackViewController.isnavTopBar               = YES;
            fsFeedbackViewController.title                     = NSLocalizedString(@"意见反馈", nil);
            //[self.navigationController presentModalViewController:fsFeedbackViewController animated:YES];
            [self.parentNavigationController pushViewController:fsFeedbackViewController animated:YES];
            [fsFeedbackViewController release];
            
        }
        
        if (row == 1) {
            NSLog(@"TouchButton_Score");
            openAppStoreComment(MYAPPLICATIONID_IN_APPSTORE);
            //[self yingyongpingfen];
        }
        
        if (row == 2) {
            FSAboutViewController *fsAboutViewController = [[FSAboutViewController alloc] init];
            fsAboutViewController.isnavTopBar            = YES;
            fsAboutViewController.title                  = NSLocalizedString(@"关于我们", nil);
            //[self.navigationController pushViewController:fsAboutViewController animated:YES];
            [self.parentNavigationController pushViewController:fsAboutViewController animated:YES];
            [fsAboutViewController release];
        }
    }


}


-(void)tableViewTouchPicture:(FSTableContainerView *)sender withImageURLString:(NSString *)imageURLString withImageLocalPath:(NSString *)imageLocalPath imageID:(NSString *)imageID{
    NSLog(@"channel did selected!!");
}


-(void)tableViewTouchEvent:(FSTableContainerView *)sender cell:(FSTableViewCell *)cellSender{
    
    
    FSMoreContainerView *obj = (FSMoreContainerView *)sender;
    
    NSLog(@"tableViewTouchEvent:%d",obj.currentIndex);
    
    if (obj.currentIndex == -1) {
        NSLog(@"更多应用推荐！！");
        FSMoreAPPRecommendViewController *fsMoreAPPRecommendViewController = [[FSMoreAPPRecommendViewController alloc]init];
        [self presentModalViewController:fsMoreAPPRecommendViewController animated:YES];
        [fsMoreAPPRecommendViewController release];
    }
    
    if (obj.currentIndex>=0 && obj.currentIndex < [_fs_GZF_AppRecommendDAO.objectList count]) {
        NSLog(@"1111");
        FSRecommentAPPObject *objc = [_fs_GZF_AppRecommendDAO.objectList objectAtIndex:obj.currentIndex];
        [PeopleNewsStati appRecommendEvent:objc.appid andAppName:objc.appName];
        [self addMyWebView:objc];
    }
    
        
}


- (void) addMyWebView:(FSRecommentAPPObject *)obj{
    
    NSLog(@"%@ %@ %@",obj.appid,obj.appLink,obj.applinkid);
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    
    if (version >= 6.0 && [obj.applinkid length]>1) {
        
        
        FSAppStoreViewController *fsAppStoreViewController = [[FSAppStoreViewController alloc]init];
        fsAppStoreViewController.isnavTopBar               = YES;
        fsAppStoreViewController.url = obj.applinkid;
        
        
        NSLog(@"fsAppStoreViewController.url  :%@",fsAppStoreViewController.url);
        //[self.navigationController pushViewController:fsAppStoreViewController animated:YES];
        [self.parentNavigationController pushViewController:fsAppStoreViewController animated:YES];
        //[self presentModalViewController:fsAppStoreViewController animated:YES];
        fsAppStoreViewController.view.backgroundColor      = [UIColor whiteColor];
        [fsAppStoreViewController release];
        
        
        
    }else{
        
        NSURL *appUrl = [NSURL URLWithString:obj.appLink];
        
        [[UIApplication sharedApplication] openURL:appUrl];
        
        NSLog(@"appUrl is %@",obj.appLink);
    }
    
}


#pragma mark -
#pragma mark SKStoreProductViewControllerDelegate
-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)updateTableView{
    [_fsMoreContainerView loadData];
}

-(void)yingyongpingfen{
//    NSString *url = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8",MYAPPLICATIONID_IN_APPSTORE];
//    NSLog(@"comment url is %@",url);
}




/*
#pragma mark -FSRecommendListCellDelegate 
//create by Qin,Zhuoran
- (void)TappedInAppRemmendListCell:(FSRecommendListCell *)cell downloadButton:(UIButton *)button{
   
    NSLog(@"TappedInAppRemmendListCell:");
    
 
}

 */


@end
