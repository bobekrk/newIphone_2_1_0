    //
//  FSNewsViewController.m
//  PeopleNewsReaderPhone
//
//  Created by people.com.cn on 12-8-13.
//  Copyright 2012 people.com.cn. All rights reserved.
//

#import "FSNewsViewController.h"
#import "FSChannelListForNewsController.h"
#import "FSUINavigationController.h"

#import "FSSlideViewController.h"
#import "FSLocalWeatherViewController.h"
#import "FSSettingViewController.h"

#import "FS_GZF_ForOnedayNewsFocusTopDAO.h"
#import "FS_GZF_ChannelListDAO.h"
#import "FS_GZF_ForNewsListDAO.h"
#import "FSFocusTopObject.h"
#import "FSOneDayNewsObject.h"
#import "FSUserSelectObject.h"
#import "FSChannelObject.h"
#import "FSTabBarViewCotnroller.h"
#import "FSBaseDAO.h"

#import "FSNewsContainerViewController.h"
#import "FSWebViewForOpenURLViewController.h"
#import "MyNewsLIstView.h"
#import "LygDequeueScroView.h"
#import "PeopleNewsReaderPhoneAppDelegate.h"
#define KIND_USERCHANNEL_SELECTED  @"YAOWENCHANNEL"
#define WIDTHOFNAME 53
@implementation FSNewsViewController

- (id)init {
	self = [super init];
	if (self) {
		_isfirstShow = YES;
	}
	return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    if (self.fpChangeTitleColor) {
        [self performSelector:@selector(xxxxxx) withObject:self afterDelay:0.3];
        
    }
    if (_fs_GZF_ChannelListDAO.objectList.count > 0) {
        [self addKindsScrollView];
    }

}
-(void)myDidReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self unLoadDataModel];
    [_myScroview removeObserver:self forKeyPath:@"contentoffset"];
    self.view   = nil;
    _myScroview = nil;
    _topRedImageView = nil;
}
-(void)unLoadDataModel
{
//    self.fs_GZF_GetWeatherMessageDAO     = nil;
//    self.fsForOneDayNewsListFocusTopData = nil;
//    self.newsListData                    = nil;
//    self.lygAdsDao                       = nil;
//    self.view                            = nil;
//    self.isFirstTimeShow                 = NO;
    self.fpChangeTitleColor = nil;
    _currentIndex           = 0;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.myNaviBar removeFromSuperview];
}
-(void)xxxxxx
{
    self.fpChangeTitleColor();
}

- (void)dealloc {

    [_fs_GZF_ChannelListDAO release];
    [_reFreshDate release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSNOTIF_NEWSCHANNEL_SELECTED object:nil];
    [super dealloc];
}
-(void)addKindsScrollView
{
    if (_myScroview) {
        return;
    }
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 15, 8, 13)];
    imageView.image         = [UIImage imageWithNameString:@"箭头左"];
    imageView.alpha         = 0.0;
    [self.view  addSubview:imageView];
    [imageView release];
    imageView.tag           = 20000;
    
    
    UIImageView * imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(307, 15, 8, 13)];
    imageView2.image         = [UIImage imageWithNameString:@"箭头右"];
    [self.view  addSubview:imageView2];
    imageView2.tag           = 30000;
    [imageView2 release];
    
    
    
    _myScroview = [[UIScrollView alloc]initWithFrame:CGRectMake(15, 0, 290, 44)];
    _myScroview.showsHorizontalScrollIndicator  = NO;
    _myScroview.tag            = 1000;
    [_myScroview addObserver:self forKeyPath:@"contentoffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    //_myScroview.delegate       = self;
    _myScroview.contentSize    = CGSizeMake(WIDTHOFNAME*[_fs_GZF_ChannelListDAO.objectList count], 44);
    _myScroview.delegate       = self;
    
    
    for (int i = 0; i<[_fs_GZF_ChannelListDAO.objectList count]; i++) {
        FSChannelObject *CObject = [_fs_GZF_ChannelListDAO.objectList objectAtIndex:i];
        UIButton * button        = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag               = i;
        button.frame             =  CGRectMake(i*WIDTHOFNAME, 0, WIDTHOFNAME, 44);

        UILabel * label          = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTHOFNAME, 44)];
        label.tag                = 100;
        label.textAlignment      = UITextAlignmentCenter;
        label.text               = CObject.channelname;
        [button addSubview:label];
        [label release];
        [button addTarget:self action:@selector(buttonCliCked:) forControlEvents:UIControlEventTouchUpInside];
        [_myScroview addSubview:button];
        if (i == 0) {
            label.textColor      = [UIColor redColor];
        }else
        {
            label.textColor      = [UIColor lightGrayColor];
        }
    }
    
    [self.view addSubview:_myScroview];
    [_myScroview release];
    _topRedImageView            = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, WIDTHOFNAME, 4)];
    _topRedImageView.image      = [UIImage imageNamed:@"topSelected.png"];
    [_myScroview addSubview:_topRedImageView];
    [_topRedImageView release];
    
    
    
    [self addNewsScrollView];
    UIView * lineView           = [[UIView alloc]initWithFrame:CGRectMake(0, 42, 320, 2)];
    lineView.backgroundColor    = [UIColor redColor];
    [self.view addSubview:lineView];
    [lineView release];
    
    [self userGuideView];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
}
-(void)userGuideView
{
    NSString * isHaveGuided = [[NSUserDefaults standardUserDefaults]objectForKey:@"userGuideView"];
    if (isHaveGuided) {
        return;
    }
    
    UIButton * button      = [[UIButton alloc]initWithFrame:[UIScreen mainScreen].bounds];
    button.tag             = 10000;
    button.backgroundColor = [UIColor blackColor];
    button.alpha           = 0.5;
    [[UIApplication sharedApplication].keyWindow addSubview:button];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((320-192)/2, 30, 192, 140)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"左右滑动切换主题" ofType:@"png"];
    imageView.image         = [UIImage imageWithContentsOfFile:path];
    [button addSubview:imageView];
    [button release];
    [imageView release];
    [button addTarget:self action:@selector(removeGuide) forControlEvents:UIControlEventTouchUpInside];
    [[NSUserDefaults standardUserDefaults]setValue:@"userGuideView" forKey:@"userGuideView"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self performSelector:@selector(removeGuide) withObject:nil afterDelay:5];
}
-(void)removeGuide
{

        UIButton * button = (UIButton*)[[UIApplication sharedApplication].keyWindow viewWithTag:10000];
        [button removeFromSuperview];
}
-(void)addNewsScrollView2
{
    float xx = (ISIPHONE5?576:480)-44-49-20;
    float offset = (_canBeHaveNaviBar?44:0);
    //UIScrollView * scroview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, offset, 320, xx)];
    LygDequeueScroView * view = [[LygDequeueScroView alloc]initWithFrame:CGRectMake(0, offset, 320, xx) adMyDelegate:self];
    view.delegate             = view;
    [self.view addSubview:view];
}
- (NSInteger)myTableView:(LygDequeueScroView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableView.contentSize = CGSizeMake(320*_fs_GZF_ChannelListDAO.objectList.count, tableView.frame.size.height);
    return _fs_GZF_ChannelListDAO.objectList.count;
}
- (UIView *)myTableView:(LygDequeueScroView *)tableView cellForRowAtIndexPath:(int)index
{
    MyNewsLIstView * view = nil;
    view = (MyNewsLIstView *)[tableView dequeueResuableCellWithIdentifier:@"xxxxxx"];
    if (!view) {
        view = [[MyNewsLIstView alloc]initWithChanel:_fs_GZF_ChannelListDAO currentIndex:index parentViewController:self];
        view.parentDelegate = view;
    }else
    {
        //view.currentIndex   = index;
    }
    return view;
}


-(void)addNewsScrollView
{
    
    float xx = (ISIPHONE5?576:480)-44-49-20;
    float offset = (_canBeHaveNaviBar?44:0);
    UIScrollView * scroview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, offset, 320, xx)];
    scroview.contentSize    = CGSizeMake(320*_fs_GZF_ChannelListDAO.objectList.count, xx);
    scroview.delegate       = self;
    scroview.tag            = 2000;
    [self.view addSubview:scroview];
    [scroview release];
    scroview.pagingEnabled  = YES;
    
    
    
    for (int i = 0; i< _fs_GZF_ChannelListDAO.objectList.count; i++) {
        MyNewsLIstView * view1 = [[MyNewsLIstView alloc]initWithChanel:_fs_GZF_ChannelListDAO currentIndex:i parentViewController:self];
        view1.parentNavigationController = self.parentNavigationController;
        view1.frame            = CGRectMake(i*320, 0, 320, xx);
        view1.tag              = 100 + i;
        view1.parentDelegate   = view1;
        [scroview addSubview:view1];
        if (i < 1) {
            [view1 refreshDataSource];
        }else
        {
            [view1 loaddingComplete];
        }
        [view1 release];
    }
}

-(void)buttonCliCked:(UIButton*)sender
{
    //[self manuseletctbutton:sender.tag];
    [self changeButtonColor:sender.tag];
    _currentIndex = sender.tag;
    UIScrollView * view = (UIScrollView *)[self.view viewWithTag:2000];
    view.contentOffset  = CGPointMake(sender.tag*320, 0);

}
-(void)manuseletctbutton:(int)x
{
    [self changeButtonColor:x];
    _currentIndex = x;
}
-(void)addStatic:(NSString*)channelName
{
    NSLog(@"%@",channelName);
    [PeopleNewsStati insertNewEventLabel:channelName andAction:CHANNELSELECT];
}
-(void)changeButtonColor:(int)index
{
    FSChannelObject *aObject = [_fs_GZF_ChannelListDAO.objectList objectAtIndex:index];
    [self performSelectorInBackground:@selector(addStatic:) withObject:aObject.channelname];
    [UIView beginAnimations:@"sdfsadfsafsa" context:nil];
    [UIView setAnimationDuration:0.1];
     [UIView commitAnimations];
    if (index == _currentIndex) {
        return;
    }
    UILabel * Label             = (UILabel*)[[[self.view viewWithTag:1000] viewWithTag:_currentIndex] viewWithTag:100];
    Label.textColor             = [UIColor lightGrayColor];
    
    Label                       = (UILabel*)[[[self.view viewWithTag:1000] viewWithTag:index] viewWithTag:100];
    Label.textColor             = [UIColor redColor];


    _topRedImageView.frame      = CGRectMake(WIDTHOFNAME*index, 40, WIDTHOFNAME, 4);
    _currentIndex               = index;
//    UIView * view               = [self.view viewWithTag:20000];
//    UIView * view3               = [self.view viewWithTag:30000];
//    _currentIndex == 0?(view.alpha = 0.0):(view.alpha = 1);
//    _currentIndex == _fs_GZF_ChannelListDAO.objectList.count -1?(view3.alpha = 0.1):(view3.alpha = 1);
    
    UIView * view               = [self.view viewWithTag:20000];
    UIView * view3               = [self.view viewWithTag:30000];
    printf("%f %f %f\n",_myScroview.contentOffset.x,_myScroview.contentSize.width,_myScroview.frame.size.width);
    _myScroview.contentOffset.x      < 10?(view.alpha = 0.0):(view.alpha = 1);
    _myScroview.contentOffset.x + 10 > (_myScroview.contentSize.width - _myScroview.frame.size.width)?(view3.alpha = 0.1):(view3.alpha = 1);
    
    MyNewsLIstView * view2 =  (MyNewsLIstView*)[[self.view viewWithTag:2000] viewWithTag:(100+index)];
    [view2 isNeedRefresh]?[view2 refreshDataSource]:1;
}


- (void)loadChildView {
    [super loadChildView];
    _reFreshDate = nil;
    
    
	//标签栏设置
	//[self.fsTabBarItem setTabBarItemWithNormalImage:[UIImage imageNamed:@"allNews.png"] withSelectedImage:[UIImage imageNamed:@"allNews.png"] withText:NSLocalizedString(@"新闻", nil)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsChannelSelected:) name:NSNOTIF_NEWSCHANNEL_SELECTED object:nil];
}

-(void)initDataModel{
    NSLog(@"initDataModelinitDataModel");

    
    
    _fs_GZF_ChannelListDAO = [[FS_GZF_ChannelListDAO alloc] init];
    _fs_GZF_ChannelListDAO.parentDelegate = self;
    _fs_GZF_ChannelListDAO.type = @"news";
    _fs_GZF_ChannelListDAO.isGettingList = YES;
    

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    if (_fs_GZF_ChannelListDAO.objectList.count < 11) {
        [_fs_GZF_ChannelListDAO HTTPGetDataWithKind:GET_DataKind_Refresh];
    }

}


-(void)doSomethingForViewFirstTimeShow{
    NSLog(@"doSomethingForViewFirstTimeShowdoSomethingForViewFirstTimeShow");
    
    _reFreshDate = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
  
    //[_fs_GZF_ChannelListDAO HTTPGetDataWithKind:GET_DataKind_Refresh];
    //[self addKindsScrollView];
}

#pragma mark -
#pragma TabBardelegate
- (UIImage *)tabBarItemNormalImage {
	return [UIImage imageNamed:@"news.png"];
}

- (NSString *)tabBarItemText {
	return NSLocalizedString(@"新闻", nil);
}

- (UIImage *)tabBarItemSelectedImage {
	return [UIImage imageNamed:@"news_sel.png"];
}

#pragma mark -----左右滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _myScroview) {
        
    }else{
        int x = scrollView.contentOffset.x/320;
        [self manuseletctbutton:x];
        UIView * view = [_myScroview viewWithTag:x];
        int index = view.frame.origin.x;
        int yyy   = _myScroview.contentOffset.x;
        if (index - yyy > 290 - WIDTHOFNAME) {
            _myScroview.contentOffset = CGPointMake(index - 290+ WIDTHOFNAME, 0);
        }else if(yyy > index)
        {
            _myScroview.contentOffset = CGPointMake(index, 0);
        }
        if (index == _currentIndex) {
            return;
        }
        MyNewsLIstView * view2 =  (MyNewsLIstView*)[scrollView viewWithTag:(100+x)];
        [view2 isNeedRefresh]?[view2 refreshDataSource]:1;
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _myScroview) {
        UIView * view               = [self.view viewWithTag:20000];
        UIView * view3               = [self.view viewWithTag:30000];
        _myScroview.contentOffset.x      < 10?(view.alpha = 0.05):(view.alpha = 1);
        _myScroview.contentOffset.x + 10 > (_myScroview.contentSize.width - _myScroview.frame.size.width)?(view3.alpha = 0.05):(view3.alpha = 1);
    }
}

#pragma mark - 
#pragma FSTableContainerViewDelegate mark

-(void)doSomethingWithDAO:(FSBaseDAO *)sender withStatus:(FSBaseDAOCallBackStatus)status{
    
    NSLog(@"doSomethingWithDAO：%@ :%d",sender,status);

    if ([sender isEqual:_fs_GZF_ChannelListDAO]) {
        NSLog(@"%d",[_fs_GZF_ChannelListDAO.objectList count]);
        if (status == FSBaseDAOCallBack_SuccessfulStatus || status == FSBaseDAOCallBack_BufferSuccessfulStatus) {
            if (status == FSBaseDAOCallBack_SuccessfulStatus) {
                //FSLog(@"_fs_GZF_ForNewsListDAO Refresh");
                //[self getUserChannelSelectedObject];
                if ([_fs_GZF_ChannelListDAO.objectList count]>0) {
                    FSChannelObject *CObject = [_fs_GZF_ChannelListDAO.objectList objectAtIndex:0];
                    NSArray * arry = [[FSBaseDB sharedFSBaseDB]getObjectsByKeyWithName:@"FSUserSelectObject" key:nil value:nil];
                    [[FSBaseDB sharedFSBaseDB] deleteObjectByObjectS:arry];
                    FSUserSelectObject *sobj = (FSUserSelectObject *)[[FSBaseDB sharedFSBaseDB] insertObject:@"FSUserSelectObject"];
                    
                    sobj.kind = @"YAOWENCHANNEL";
                    sobj.keyValue1 = CObject.channelname;
                    sobj.keyValue2 = CObject.channelid;
                    [FSBaseDB saveDB];
                }
                FSChannelObject *CObject = [_fs_GZF_ChannelListDAO.objectList objectAtIndex:0];
                
                FSUserSelectObject *sobj = (FSUserSelectObject *)[[FSBaseDB sharedFSBaseDB] insertObject:@"FSUserSelectObject"];
                
                sobj.kind = KIND_USERCHANNEL_SELECTED;
                sobj.keyValue1 = CObject.channelname;
                sobj.keyValue2 = CObject.channelid;
                sobj.keyValue3 = nil;
                [[FSBaseDB sharedFSBaseDB].managedObjectContext save:nil];
                [self addKindsScrollView];
                if (status == FSBaseDAOCallBack_SuccessfulStatus) {
                    
                    [_fs_GZF_ChannelListDAO operateOldBufferData];
                }
            }
        }else if(status ==FSBaseDAOCallBack_NetworkErrorStatus){
            //[self getUserChannelSelectedObject];
            
            //[_fs_GZF_ForOnedayNewsFocusTopDAO HTTPGetDataWithKind:GET_DataKind_Refresh];
        }
        return;
    }
    
//    if ([sender isEqual:_fs_GZF_GetWeatherMessageDAO]) {
//        if (status == FSBaseDAOCallBack_SuccessfulStatus || status == FSBaseDAOCallBack_BufferSuccessfulStatus) {
//            if (status == FSBaseDAOCallBack_SuccessfulStatus) {
//                //FSLog(@"_fs_GZF_ForNewsListDAO Refresh");
//                //[self getUserChannelSelectedObject];
//                if ([_fs_GZF_GetWeatherMessageDAO.objectList count]>0) {
////                    FSChannelObject *CObject = [_fs_GZF_ChannelListDAO.objectList objectAtIndex:0];
////                    NSArray * arry = [[FSBaseDB sharedFSBaseDB]getObjectsByKeyWithName:@"FSUserSelectObject" key:nil value:nil];
////                    [[FSBaseDB sharedFSBaseDB] deleteObjectByObjectS:arry];
////                    FSUserSelectObject *sobj = (FSUserSelectObject *)[[FSBaseDB sharedFSBaseDB] insertObject:@"FSUserSelectObject"];
////                    
////                    sobj.kind = @"YAOWENCHANNEL";
////                    sobj.keyValue1 = CObject.channelname;
////                    sobj.keyValue2 = CObject.channelid;
////                    [FSBaseDB saveDB];
//                }
////                FSChannelObject *CObject = [_fs_GZF_ChannelListDAO.objectList objectAtIndex:0];
////                
////                FSUserSelectObject *sobj = (FSUserSelectObject *)[[FSBaseDB sharedFSBaseDB] insertObject:@"FSUserSelectObject"];
////                
////                sobj.kind = KIND_USERCHANNEL_SELECTED;
////                sobj.keyValue1 = CObject.channelname;
////                sobj.keyValue2 = CObject.channelid;
////                sobj.keyValue3 = nil;
////                [[FSBaseDB sharedFSBaseDB].managedObjectContext save:nil];
////                [self addKindsScrollView];
////                if (status == FSBaseDAOCallBack_SuccessfulStatus) {
////                    
////                    [_fs_GZF_ChannelListDAO operateOldBufferData];
////                }
//            }
//        }else if(status ==FSBaseDAOCallBack_NetworkErrorStatus){
//            //[self getUserChannelSelectedObject];
//            
//            //[_fs_GZF_ForOnedayNewsFocusTopDAO HTTPGetDataWithKind:GET_DataKind_Refresh];
//        }
//
//    }
    

}
-(void)didReceiveMemoryWarning
{
    NSLog(@"received memory warninng");
}

@end
