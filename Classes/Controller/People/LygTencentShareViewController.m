//
//  LygTencentShareViewController.m
//  PeopleNewsReaderPhone
//
//  Created by lygn128 on 13-8-5.
//
//

#import "LygTencentShareViewController.h"
#import "FSSinaBlogLoginViewController.h"
@interface LygTencentShareViewController ()

@end

@implementation LygTencentShareViewController

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
-(void)initAuth
{
    [_tcWBEngine logInWithDelegate:self
                         onSuccess:@selector(onSuccessLogin)
                         onFailure:@selector(onFailureLogin:)];
}

-(void)doSomethingForViewFirstTimeShow{
    
    if (_tcWBEngine == nil) {
        //TCWBEngine *wbengine = [[TCWBEngine alloc] initWithAppKey:QQAPPKEY appSecret:QQSECRET];
        TCWBEngine * wbengine = [[TCWBEngine alloc]initWithAppKey:QQAPPKEY andSecret:QQSECRET andRedirectUrl:QQREDIRECTURL];
        self.tcWBEngine = wbengine;
        wbengine.rootViewController = self;
        [wbengine release];
    }
    
    if ([_tcWBEngine isLoggedIn] && ![_tcWBEngine isAuthorizeExpired]) {
		//[self postShareMessage];
		;
	} else {


	}
}

-(void)onSuccess
{
    NSLog(@"requestDidSucceedWithResultrequestDidSucceedWithResult");
    [[NSNotificationCenter defaultCenter] postNotificationName:SHARE_SUCCESSFUL_NOTICE object:self userInfo:nil];
    
    [self performSelector:@selector(returnToParentView) withObject:nil afterDelay:0.0];
}
-(void)onFail
{
    _fsShareNoticView.data = @"分享失败！";
    _fsShareNoticView.backgroundColor = COLOR_CLEAR;
    _fsShareNoticView.alpha = 1.0f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2.0];
    _fsShareNoticView.alpha = 0.0f;
    [UIView commitAnimations];
}
-(void)postShareMessage{
    
    if (![_tcWBEngine isAuthorizeExpired]) {
		//显示发送微博的主体
		NSString *sharedMsg  = [NSString stringWithFormat:@"%@",[_fsBlogShareContentView getShareContent]];
        _tcWBEngine.delegate = self;
        //[_tcWBEngine sendWeiBoWithText:sharedMsg image:nil];
        [_tcWBEngine postTextTweetWithFormat:@"json" content:sharedMsg clientIP:nil longitude:nil andLatitude:nil parReserved:nil delegate:self onSuccess:@selector(onSuccess) onFailure:@selector(onFail)];
	} else {
        [self initAuth];
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
    
    _fsShareNoticView.data = @"分享失败！";
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
@end
