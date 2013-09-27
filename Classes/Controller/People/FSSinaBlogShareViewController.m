//
//  FSSinaBlogShareViewController.m
//  PeopleNewsReaderPhone
//
//  Created by ganzf on 12-11-7.
//
//

#import "FSSinaBlogShareViewController.h"




#define kWBSDKDemoAppKey @"1368810072"
#define kWBSDKDemoAppSecret @"5dd07c1fd64d4e3ba3bef34ec59edfa1"

#define kWBAlertViewLogOutTag 100
#define FSSETTING_VIEW_NAVBAR_HEIGHT 44.0f


@interface FSSinaBlogShareViewController ()

@end

@implementation FSSinaBlogShareViewController

@synthesize sinaWBEngine = _sinaWBEngine;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//        self.title = @"新浪微博分享";
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [super dealloc];
}


-(void)doSomethingForViewFirstTimeShow{

    if (_sinaWBEngine == nil) {
        WBEngine *wbengine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
        [wbengine setRootViewController:self];
        [wbengine setDelegate:self];
        [wbengine setRedirectURI:@"http://wap.people.com.cn"];
        [wbengine setIsUserExclusive:NO];
        self.sinaWBEngine = wbengine;
        [wbengine release];
    }
    
    if ([_sinaWBEngine isLoggedIn] && ![_sinaWBEngine isAuthorizeExpired]) {
		//显示发送微博的主体
		;
	} else {

	}
}


-(void)postShareMessage{
    
    if ([_sinaWBEngine isLoggedIn] && ![_sinaWBEngine isAuthorizeExpired]) {
		//显示发送微博的主体
		NSString *sharedMsg = [NSString stringWithFormat:@"%@",[_fsBlogShareContentView getShareContent]];
        [_sinaWBEngine setDelegate:self];
        [_sinaWBEngine sendWeiBoWithText:sharedMsg image:nil];
	} else {
        
        FSSinaBlogLoginViewController *fsSinaBlogLoginViewController = [[FSSinaBlogLoginViewController alloc] init];
        fsSinaBlogLoginViewController.title                          = @"新浪微博授权";
        fsSinaBlogLoginViewController.sinaWBEngine                   = _sinaWBEngine;
        fsSinaBlogLoginViewController.parentDelegate                 = self;
        if (self.withnavTopBar) {
            fsSinaBlogLoginViewController.isnavTopBar                = YES;
            [self presentModalViewController:fsSinaBlogLoginViewController animated:YES];
        }
        else{
            [self.navigationController pushViewController:fsSinaBlogLoginViewController animated:YES];
        }
        [fsSinaBlogLoginViewController release];
	}
    
}


//*******************************
-(void)loginSuccesss:(BOOL)isSuccess{
    NSLog(@"loginSuccesssloginSuccesss ");
    [self postShareMessage];
}
//*******************************

#pragma mark - WBEngineDelegate Methods

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
/*
    FSInformationMessageView *informationMessageView = [[FSInformationMessageView alloc] initWithFrame:CGRectMake(70, 70, 70, 70)];
    informationMessageView.parentDelegate = self;
    [informationMessageView showInformationMessageViewInView:self.view
                                                 withMessage:@"分享成功"
                                            withDelaySeconds:1.2
                                            withPositionKind:PositionKind_Horizontal_Center
                                                  withOffset:40.0f];
    [informationMessageView release];
 */
    NSLog(@"requestDidSucceedWithResultrequestDidSucceedWithResult");
   [[NSNotificationCenter defaultCenter] postNotificationName:SHARE_SUCCESSFUL_NOTICE object:self userInfo:nil];
    
    [self performSelector:@selector(returnToParentView) withObject:nil afterDelay:0.0];
    //[self.navigationController popViewControllerAnimated:YES];
    
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    
    _fsShareNoticView.data = @"分享内容重复";
    _fsShareNoticView.backgroundColor = COLOR_CLEAR;
    _fsShareNoticView.alpha = 1.0f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2.0];
    _fsShareNoticView.alpha = 0.0f;
    [UIView commitAnimations];
    return;
    
    FSInformationMessageView *informationMessageView = [[FSInformationMessageView alloc] initWithFrame:CGRectMake(70, 70, 70, 70)];
    informationMessageView.parentDelegate = self;
    [informationMessageView showInformationMessageViewInView:self.view
                                                 withMessage:@"分享失败"
                                            withDelaySeconds:1.2
                                            withPositionKind:PositionKind_Horizontal_Center
                                                  withOffset:40.0f];
    [informationMessageView release];
}



//******************************************************************


@end
