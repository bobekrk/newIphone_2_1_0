    //
//  FSBasePeopleViewController.m
//  PeopleNewsReaderPhone
//
//  Created by people.com.cn on 12-8-13.
//  Copyright 2012 people.com.cn. All rights reserved.
//

#import "FSBasePeopleViewController.h"
#import "FSSlideViewController.h"
#import "FSLoadingImageView.h"
//#import "FSWeatherViewController.h"
#import "FSLocalWeatherViewController.h"
#import "FSSettingViewController.h"

#import "FSBaseDB.h"
#import "FSWeatherObject.h"
#import "PeopleNewsReaderPhoneAppDelegate.h"

@implementation FSBasePeopleViewController

- (id)init {
	self = [super init];
	if (self) {
        self.wantsFullScreenLayout = YES;
		_left_lock = NO;
        _right_lock = NO;
	}
	return self;
}

- (void)dealloc {
    [_fsWeatherView release];
    [super dealloc];
}
-(void)xxxxxxxxxxx
{
    [PeopleNewsStati insertNewEventLabel:LOADING andAction:TABBARCLICK];
}
-(void)showLoadingView{
    float xxx = ISIPHONE5?568:480;
    [self performSelectorInBackground:@selector(xxxxxxxxxxx) withObject:nil];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    //FSLoadingImageView *loadingView = [[FSLoadingImageView alloc] initWithFrame:CGRectMake(-320, 0, 320, xxx)];
    
    FSLoadingImageView *loadingView = [[FSLoadingImageView alloc] initWithFrame:CGRectMake(-320, 0, 320, xxx) andISNeedAutoClose:NO];
    loadingView.parentDelegate = self;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [window addSubview:loadingView];
    loadingView.frame = CGRectMake(0, 0, 320, xxx);
    [UIView commitAnimations];
    
    [loadingView release];
}

-(void)addLeftButtonItem
{

    UIButton *btnNaviOption = [[UIButton alloc] initWithFrame:CGRectZero];
	UIImage *imageBG = [UIImage imageNamed:@"返回1.png"];
	[btnNaviOption setBackgroundImage:imageBG forState:UIControlStateNormal];
	[btnNaviOption setBackgroundImage:imageBG forState:UIControlStateHighlighted];
    btnNaviOption.highlighted = YES;
    
	[btnNaviOption addTarget:self action:@selector(showLoadingView) forControlEvents:UIControlEventTouchUpInside];
    //[btnNaviOption addTarget:self action:@selector(settingActionLock:) forControlEvents:UIControlEventTouchDown];
    
    
    UIBarButtonItem *settingBarItem = [[UIBarButtonItem alloc] initWithCustomView:btnNaviOption];
	btnNaviOption.frame = CGRectMake(0.0f, 0.0f, imageBG.size.width, imageBG.size.height);
	self.myNaviBar.topItem.leftBarButtonItem = settingBarItem;
	[settingBarItem release];
	[btnNaviOption release];
    
    
    
    
//    UIButton *btnNaviOption = [[UIButton alloc] initWithFrame:CGRectZero];
//	UIImage *imageBG = [UIImage imageNamed:@"返回1.png"];
//	[btnNaviOption setBackgroundImage:imageBG forState:UIControlStateNormal];
//	[btnNaviOption setBackgroundImage:imageBG forState:UIControlStateHighlighted];
//    btnNaviOption.highlighted = YES;
//    
//	[btnNaviOption addTarget:self action:@selector(showLoadingView) forControlEvents:UIControlEventTouchUpInside];
    //[btnNaviOption addTarget:self action:@selector(settingActionLock:) forControlEvents:UIControlEventTouchDown];
    
    
    
//    UIBarButtonItem *settingBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回1.png"] style:UIBarButtonItemStyleDone target:self action:@selector(showLoadingView)];
//    NSLog(@"%f",settingBarItem.imageInsets.left);
//    settingBarItem.tintColor = [UIColor whiteColor];
//	[settingBarItem release];
//	//[btnNaviOption release];

}
-(void)addRightButtonItem
{
    UIButton *btnNaviOption = [[UIButton alloc] initWithFrame:CGRectZero];
	UIImage *imageBG = [UIImage imageNamed:@"右抽屉.png"];
	[btnNaviOption setBackgroundImage:imageBG forState:UIControlStateNormal];
	[btnNaviOption setBackgroundImage:imageBG forState:UIControlStateHighlighted];
    btnNaviOption.highlighted = YES;
    
	[btnNaviOption addTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnNaviOption addTarget:self action:@selector(settingActionLock:) forControlEvents:UIControlEventTouchDown];
    
    
    UIBarButtonItem *settingBarItem = [[UIBarButtonItem alloc] initWithCustomView:btnNaviOption];
	btnNaviOption.frame = CGRectMake(0.0f, 0.0f, imageBG.size.width, imageBG.size.height);
	self.myNaviBar.topItem.rightBarButtonItem = settingBarItem;
    
	[settingBarItem release];
	[btnNaviOption release];
    //[right release];
}
- (void)loadChildView {
	//self.title = NSLocalizedString(@"人民新闻", nil);
    [super loadChildView];
	UIImageView *ivLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"peopleLogo.png"]];
	self.myNaviBar.topItem.titleView = ivLogo;
	[ivLogo release];
    NSLog(@"%@",self.myNaviBar);
    if (_canBeHaveNaviBar) {
        [self addLeftButtonItem];
        [self addRightButtonItem];
    }
	   
	
	
    [self updataWeatherMessage];
}

- (void)layoutControllerViewWithRect:(CGRect)rect {
}

#pragma mark -
#pragma mark PrivateMethod


- (void)settingAction:(id)sender {
    NSLog(@"settingAction");
    if (_right_lock) {
        _left_lock = NO;
        return;
    }
	//[self.fsSlideViewController pushViewControllerWithKind:PushViewControllerKind_Right withAnimated:YES];
    
    if ([self.fsSlideViewController.rightViewController isKindOfClass:[FSSettingViewController class]]) {
        [self.fsSlideViewController slideViewController:self.fsSlideViewController.rightViewController withKind:PushViewControllerKind_Right withAnimation:YES];
    }
    else{
        FSSettingViewController *settingCtrl = [[FSSettingViewController alloc] init];
        [self.fsSlideViewController slideViewController:settingCtrl withKind:PushViewControllerKind_Right withAnimation:YES];
        [settingCtrl release];
    }
    
    _left_lock = NO;
}

-(void)settingActionLock:(id)sender{
    NSLog(@"settingActionLock");
    _left_lock = YES;
}

- (UIImage *)tabBarItemNormalImage {
	return nil;
}

- (NSString *)tabBarItemText {
	return nil;
}

- (UIImage *)tabBarItemSelectedImage {
	return nil;
}

-(void)updataWeatherMessage{
    if (!_fsWeatherView) {
        return;
    }
   NSArray *array = [[FSBaseDB sharedFSBaseDB] getObjectsByKeyWithName:@"FSWeatherObject" key:@"group" value:getCityName()];
    
    for (FSWeatherObject *obj in array) {
        if ([obj.day isEqualToString:@"0"]) {
            _fsWeatherView.data = obj;
            [_fsWeatherView doSomethingAtLayoutSubviews];
        }
    }
    
}

@end
