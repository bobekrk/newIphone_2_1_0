//
//  FSLocalWeatherViewController.m
//  PeopleNewsReaderPhone
//
//  Created by ganzf on 13-3-18.
//
//

#import "FSLocalWeatherViewController.h"
#import "FSSlideViewController.h"
#import "FSLocalNewsCityListController.h"


#import "FS_GZF_CityListDAO.h"
#import "FS_GZF_GetWeatherMessageDAO.h"

#import "FSCityObject.h"
#import "FSUserSelectObject.h"
#import "FSWeatherObject.h"
#import "FSBaseDB.h"
#import "PeopleNewsReaderPhoneAppDelegate.h"
#define KIND_CITY_SELECTED @"KIND_CITY_SELECTED"

#define FSSETTING_VIEW_NAVBAR_HEIGHT 44.0f

@interface FSLocalWeatherViewController ()

@end

@implementation FSLocalWeatherViewController

- (id)init {
	self = [super init];
	if (self) {
		_isFirstShow = YES;
        _localCity = @"";
	}
	return self;
}

- (void)dealloc {
    [_fs_GZF_CityListDAO release];
    _fs_GZF_CityListDAO = nil;
    _fs_GZF_localGetWeatherMessageDAO.parentDelegate = nil;
    [_fs_GZF_localGetWeatherMessageDAO release];
    _fs_GZF_localGetWeatherMessageDAO = nil;
    [_reFreshDate release];
    _reFreshDate = nil;
    [_titleView removeFromSuperview];
    _titleView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSNOTIF_POPOCITYLISTCONTROLLER object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSNOTIF_LOCALNEWSLISTREFRESH object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSNOTIF_LOCALNEWSLIST_CITYSELECTED object:nil];
    [super dealloc];
}
-(void)viewDidDisappear:(BOOL)animated
{
    //self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    //self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillAppear:(BOOL)animated
{

}
-(void)backButtonClicked
{
    //self.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setNaviBar
{
    _titleView = [[FSTitleView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width, 44)];
    _titleView.hidRefreshBt = YES;
    _titleView.toBottom = NO;
    _titleView.parentDelegate = self;
    [self.myNaviBar addSubview:_titleView];
    //self.myNaviBar.topItem.titleView = _titleView;
    [_titleView release];
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked)];
    self.myNaviBar.topItem.leftBarButtonItem = backButton;
    backButton.tintColor = [UIColor whiteColor];
    [backButton release];
}
-(void)setWeatherView
{
    _fsLocalWeatherMessageView = [[FSLocalWeatherMessageView alloc] initWithFrame:CGRectMake(0.0, self.canBeHaveNaviBar?44:0, self.view.frame.size.width, self.view.frame.size.height)];
    _fsLocalWeatherMessageView.group = getCityName();
    _fsLocalWeatherMessageView.parentDelegate = self;
    [self.view addSubview:_fsLocalWeatherMessageView];
    [_fsLocalWeatherMessageView release];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftAction:)];
    swipeRight.delegate = self;
    swipeRight.direction = UISwipeGestureRecognizerDirectionLeft;
    [swipeRight release];

}

-(void)viewDidLoad
{
    [self setWeatherView];
    [self setNaviBar];
}

- (void)loadChildView {
    [super loadChildView];
    _reFreshDate = nil;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popoCityListController) name:NSNOTIF_POPOCITYLISTCONTROLLER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localNewsListRefresh) name:NSNOTIF_LOCALNEWSLISTREFRESH object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localNewsListCitySelected:) name:NSNOTIF_LOCALNEWSLIST_CITYSELECTED object:nil];
}



-(void)initDataModel{
    self.cityName = getCityName();
    _fs_GZF_CityListDAO = [[FS_GZF_CityListDAO alloc] init];
    
    _fs_GZF_localGetWeatherMessageDAO = [[FS_GZF_GetWeatherMessageDAO alloc] init];
    _fs_GZF_localGetWeatherMessageDAO.parentDelegate = self;
    _fs_GZF_localGetWeatherMessageDAO.isGettingList = NO;
    _fs_GZF_localGetWeatherMessageDAO.group = getCityName();
}


-(void)doSomethingForViewFirstTimeShow{
    
    _reFreshDate = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    [_fs_GZF_localGetWeatherMessageDAO HTTPGetDataWithKind:GET_DataKind_ForceRefresh];

}


- (void)layoutControllerViewWithRect:(CGRect)rect {
    _fsLocalWeatherMessageView.frame = CGRectMake(0, self.canBeHaveNaviBar?44:0, rect.size.width, rect.size.height);
}


-(void)swipeLeftAction:(id)sender{
    [self.fsSlideViewController resetViewControllerWithAnimated:NO];
}



#pragma mark -
#pragma nsnotify mark

-(void)FSTitleViewTouchEvent:(FSTitleView *)titleView{
    FSLocalNewsCityListController *localCityListController = [[FSLocalNewsCityListController alloc] init];
    localCityListController.canBeHaveNaviBar = YES;
    localCityListController.cityName = _cityName;
    localCityListController.localCity = _localCity;
    [self presentModalViewController:localCityListController animated:YES];
    
    [localCityListController release];
}

-(void)popoCityListController{
    FSLocalNewsCityListController *localCityListController = [[FSLocalNewsCityListController alloc] init];
    localCityListController.canBeHaveNaviBar     = YES;
    localCityListController.view.backgroundColor = [UIColor blueColor];
    [self.fsSlideViewController presentModalViewController:localCityListController animated:YES];
    
    [localCityListController release];
    return;
}

-(void)localNewsListRefresh{
#ifdef MYDEBUG
    NSLog(@"localNewsListRefresh11");
#endif
    
    //[_fs_GZF_CityListDAO HTTPGetDataWithKind:GET_DataKind_Refresh];
    
}

-(void)localNewsListCitySelected:(NSNotification *)aNotification{
    
    NSDictionary *info = [aNotification userInfo];
	_cityName = [info objectForKey:NSNOTIF_LOCALNEWSLIST_CITYSELECTED_KEY];
    //NSLog(@"localNewsListCitySelected 111111");
    _fs_GZF_localGetWeatherMessageDAO.group = _cityName;
    [_fs_GZF_localGetWeatherMessageDAO HTTPGetDataWithKind:GET_DataKind_ForceRefresh];
}

#pragma mark -
-(void)doSomethingWithDAO:(FSBaseDAO *)sender withStatus:(FSBaseDAOCallBackStatus)status{
    NSLog(@"doSomethingWithDAO:%d",status);
    if ([sender isEqual:_fs_GZF_CityListDAO]) {
        if (status == FSBaseDAOCallBack_SuccessfulStatus || status == FSBaseDAOCallBack_BufferSuccessfulStatus) {
            if ([_fs_GZF_CityListDAO.objectList count]>0) {
                NSLog(@"获取城市列表成功！！！");

                if (status == FSBaseDAOCallBack_SuccessfulStatus) {
                    [_fs_GZF_CityListDAO operateOldBufferData];
                }
            }
        }else if(status ==FSBaseDAOCallBack_NetworkErrorStatus){
            ;
        }
        return;
    }
    
    
    if ([sender isEqual:_fs_GZF_localGetWeatherMessageDAO]) {
        @synchronized(self)
        {
            if (status == FSBaseDAOCallBack_SuccessfulStatus || status == FSBaseDAOCallBack_BufferSuccessfulStatus) {
                NSLog(@"获取天气成功！！！:%d",[_fs_GZF_localGetWeatherMessageDAO.objectList count]);
                
                if ([_fs_GZF_localGetWeatherMessageDAO.objectList count]>0) {
                    NSLog(@"%@",_fs_GZF_localGetWeatherMessageDAO.group);
                    _fsLocalWeatherMessageView.group = _fs_GZF_localGetWeatherMessageDAO.group;
                    _fsLocalWeatherMessageView.data = _fs_GZF_localGetWeatherMessageDAO.objectList;
                    //[_fsLocalWeatherMessageView doSomethingAtLayoutSubviews];
                    FSWeatherObject *obj =  [_fs_GZF_localGetWeatherMessageDAO.objectList objectAtIndex:0];
                    
                    _titleView.data = obj.cityname;
                    self.cityName = obj.cityname;
                    
                    if ([_localCity length]==0) {
                        self.localCity = _cityName;
                    }
                    
                    if (status == FSBaseDAOCallBack_SuccessfulStatus ) {//if(_fsUserSelectObject.keyValue3!=nil)
                        
                        if (![_fs_GZF_localGetWeatherMessageDAO.group isEqualToString:_cityName] && [_fs_GZF_localGetWeatherMessageDAO.group length]>0) {
                            //NSLog(@"%@ 暂无数据！",_fs_GZF_localGetWeatherMessageDAO.group);
                            FSInformationMessageView *informationMessageView = [[FSInformationMessageView alloc] initWithFrame:CGRectZero];
                            informationMessageView.parentDelegate = self;
                            [informationMessageView showInformationMessageViewInView:self.view
                                                                         withMessage:[NSString stringWithFormat:@"%@ 暂无数据！",_fs_GZF_localGetWeatherMessageDAO.group]
                                                                    withDelaySeconds:2.0f
                                                                    withPositionKind:PositionKind_Vertical_Horizontal_Center
                                                                          withOffset:0.0f];
                            [informationMessageView release];
                        }
                        
                        [_fs_GZF_localGetWeatherMessageDAO operateOldBufferData];
                        //[_fs_GZF_CityListDAO HTTPGetDataWithKind:GET_DataKind_Unlimited];
                        if (_isFirstShow) {
                            _isFirstShow = NO;
                           // [self getlocationManager];
                            
                        }
                    }
                }else
                {
                    NSArray *array = [[FSBaseDB sharedFSBaseDB] getObjectsByKeyWithName:@"FSWeatherObject" key:@"group" value:getCityName()];
                   // FSWeatherObject * obj = (FSWeatherObject*)[array objectAtIndex:0];
                    if (array.count > 0 ) {
                        _fsLocalWeatherMessageView.data = array;
                        _titleView.data                 = getCityName();
                        _cityName                       = getCityName();
                        [_fsLocalWeatherMessageView doSomethingAtLayoutSubviews];
                    }
//                    for (FSWeatherObject *obj in array) {
//                        if ([obj.day isEqualToString:@"0"]) {
//                            _fsLocalWeatherMessageView.data = obj;
//                            [_fsLocalWeatherMessageView doSomethingAtLayoutSubviews];
//                        }
//                    }

                }
            }
            else if (status == FSBaseDAOCallBack_WorkingStatus)
            {
                FSIndicatorMessageView* INDICTORE  = [[FSIndicatorMessageView alloc] init];
                [INDICTORE showIndicatorMessageViewInView:self.view withMessage:@"正在更新天气信息"];
            }
            else if(status ==FSBaseDAOCallBack_NetworkErrorStatus){
                ;
            }
            return;
        }

    }
}


-(FSUserSelectObject *)insertCityselectedObject:(FSCityObject *)obj{
    NSArray *array = [[FSBaseDB sharedFSBaseDB] getObjectsByKeyWithName:@"FSUserSelectObject" key:@"kind" value:KIND_CITY_SELECTED];
    
    if ([array count]>0) {
        FSUserSelectObject *sobj = [array objectAtIndex:0];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
        NSString *nsstringdate = dateToString_YMD(date);
        if ([sobj.keyValue4 isEqualToString:nsstringdate]) {
            return sobj;
        }
        else{
            //[self getlocationManager];
        }
        return sobj;
    }
    else{
        if (obj==nil) {
            return nil;
        }
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
        NSString *nsstringdate = dateToString_YMD(date);
        FSUserSelectObject *sobj = (FSUserSelectObject *)[[FSBaseDB sharedFSBaseDB] insertObject:@"FSUserSelectObject"];
        sobj.kind = KIND_CITY_SELECTED;
        sobj.keyValue1 = obj.cityName;
        sobj.keyValue2 = obj.cityId;
        sobj.keyValue3 = obj.provinceId;
        sobj.keyValue4 = nsstringdate;
        [[FSBaseDB sharedFSBaseDB].managedObjectContext save:nil];
        return sobj;
    }
    
}
@end
