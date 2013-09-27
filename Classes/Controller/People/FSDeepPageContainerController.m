//
//  FSDeepPageContainerController.m
//  PeopleNewsReaderPhone
//
//  Created by people.com.cn on 12-11-1.
//
//

#import "FSDeepPageContainerController.h"

#import "FS_GZF_DeepPageListDAO.h"
#import "FSDeepPageObject.h"

#import "FSDeepLeadViewController.h"
#import "FSDeepPictureVeiwController.h"
#import "FSDeepTextViewController.h"
#import "FSDeepOuterLinkViewController.h"
#import "FSDeepInvestigateViewController.h"
#import "FSDeepEndViewController.h"
#import "FSDeepCommentViewController.h"
#import "FSDeepPriorViewController.h"
#import "FSSinaBlogShareViewController.h"
#import "FSNetEaseBlogShareViewController.h"
#import "FSPeopleBlogShareViewController.h"
#import "NTESNBSMSManager.h"
#import "LygTencentShareViewController.h"
#import "PeopleNewsReaderPhoneAppDelegate.h"
/*
 flag:1（导语页面）深度id
 flag:2（图片页面）图片id
 flag:3（文本页面）正文id
 flag:4（外链页面）外链id
 flag:5（调查页面）调查id
 flag:6（结束语页面）深度id
 flag:7（评论页面）深度id
 flag:8（往期页面）深度id
 */
#define FSDEEP_PAGE_LEAD 1
#define FSDEEP_PAGE_PICTURE 2
#define FSDEEP_PAGE_TEXT 3
#define FSDEEP_PAGE_OUTER 4
#define FSDEEP_PAGE_INVESTIGATE 5
#define FSDEEP_PAGE_END 6
#define FSDEEP_PAGE_COMMENT 7
#define FSDEEP_PAGE_PRIOR 8


@interface FSDeepPageContainerController ()

@end

@implementation FSDeepPageContainerController
@synthesize deepid = _deepid;
@synthesize Deep_title = _Deep_title;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    NSInteger k = [self retainCount];
//    for (NSInteger i=0; i<k-1; i++) {
//        [self release];
//    }
        
    
    NSLog(@"%@.viewDidDisappear:%d",self,[self retainCount]);
}
-(void)loadChildView
{
    [super loadChildView];
    _fsShareIconContainView = [[FSShareIconContainView alloc] initWithFrame:CGRectZero];
    _fsShareIconContainView.parentDelegate = self;
    [self.view addSubview:_fsShareIconContainView];
    [_fsShareIconContainView release];
}

- (void)dealloc {
    [_deepid release];
    _fs_GZF_DeepPageListDAO.parentDelegate = NULL;
    [_fs_GZF_DeepPageListDAO release];
    [super dealloc];
}

- (void)initDataModel {
    _fs_GZF_DeepPageListDAO = [[FS_GZF_DeepPageListDAO alloc] init];
    _fs_GZF_DeepPageListDAO.parentDelegate = self;
}

- (void)doSomethingForViewFirstTimeShow {
    _fs_GZF_DeepPageListDAO.deepid = self.deepid;
    [_fs_GZF_DeepPageListDAO HTTPGetDataWithKind:GET_DataKind_Refresh];
}

- (void)doSomethingWithDAO:(FSBaseDAO *)sender withStatus:(FSBaseDAOCallBackStatus)status {
    if (status == FSBaseDAOCallBack_WorkingStatus) {
        FSIndicatorMessageView *indicatorMessageView = [[FSIndicatorMessageView alloc] initWithFrame:self.view.frame andBool:YES];
        [indicatorMessageView showIndicatorMessageViewInView:_svContainer withMessage:[self indicatorMessageTextWithDAO:sender withStatus:status]];
        [indicatorMessageView release];
    }
    if ([sender isEqual:_fs_GZF_DeepPageListDAO]) {
        
        if (status == FSBaseDAOCallBack_BufferSuccessfulStatus || status == FSBaseDAOCallBack_SuccessfulStatus) {
            NSLog(@"_fs_GZF_DeepPageListDAO:%d",[_fs_GZF_DeepPageListDAO.objectList count]);
            
            if (status == FSBaseDAOCallBack_SuccessfulStatus) {
                [_fs_GZF_DeepPageListDAO operateOldBufferData];
                [self setPageControllerCount:[_fs_GZF_DeepPageListDAO.objectList count]];
            }
        }
//        if (status == FSBaseDAOCallBack_WorkingStatus) {
//            FSIndicatorMessageView *indicatorMessageView = [[FSIndicatorMessageView alloc] initWithFrame:CGRectZero andBool:YES];
//			[indicatorMessageView showIndicatorMessageViewInView:self.view withMessage:[self indicatorMessageTextWithDAO:sender withStatus:status]];
//			[indicatorMessageView release];
//        }
    }
}

- (Class)pageControllerClassWithPageNum:(NSInteger)pageNum {
    //NSIndexPath *indexPath = [self indexPathWithPageNum:pageNum];
    //FSDeepPageObject *pageObj = [_deepPageListData.fetchedResultsController objectAtIndexPath:indexPath];
    FSDeepPageObject *pageObj = [_fs_GZF_DeepPageListDAO.objectList objectAtIndex:pageNum];
    if (pageObj) {
        Class controllerClass = nil;
        NSInteger flag = [pageObj.flag intValue];
        
        switch (flag) {
            case FSDEEP_PAGE_LEAD:
                controllerClass = [FSDeepLeadViewController class];
                break;
            case FSDEEP_PAGE_PICTURE:
                controllerClass = [FSDeepPictureVeiwController class];
                break;
            case FSDEEP_PAGE_TEXT:
                controllerClass = [FSDeepTextViewController class];
                break;
            case FSDEEP_PAGE_OUTER:
                controllerClass = [FSDeepOuterLinkViewController class];
                break;
            case FSDEEP_PAGE_INVESTIGATE:
                controllerClass = [FSDeepInvestigateViewController class];
                break;
            case FSDEEP_PAGE_END:
                controllerClass = [FSDeepEndViewController class];
                break;
            case FSDEEP_PAGE_COMMENT:
                controllerClass = [FSDeepCommentViewController class];
                break;
            case FSDEEP_PAGE_PRIOR:
                controllerClass = [FSDeepPriorViewController class];
                break;
            default:
                break;
        }
        return controllerClass;

    }
    return nil;
}

- (void)initializePageController:(UIViewController *)viewController withPageNum:(NSInteger)pageNum {
    NSIndexPath  *indexPath = [self indexPathWithPageNum:pageNum];
    if (indexPath) {
        //FSDeepPageObject *pageObj = [_deepPageListData.fetchedResultsController objectAtIndexPath:indexPath];
        FSDeepPageObject *pageObj = [_fs_GZF_DeepPageListDAO.objectList objectAtIndex:pageNum];
        NSInteger flag = [pageObj.flag intValue];
        FSLog(@"deepPage.flag:%d[%@]", flag, pageObj.pageid);
        switch (flag) {
            case FSDEEP_PAGE_LEAD:
                //controllerClass = [FSDeepLeadViewController class];
                if ([viewController isKindOfClass:[FSDeepLeadViewController class]]) {
                    FSDeepLeadViewController *deepLeadCtrl = (FSDeepLeadViewController *)viewController;
                    deepLeadCtrl.bottomControlHeight = [self pageControlHeight];
                    deepLeadCtrl.deepid = pageObj.pageid;
                }
                break;
            case FSDEEP_PAGE_PICTURE:
                //controllerClass = [FSDeepPictureVeiwController class];
                if ([viewController isKindOfClass:[FSDeepPictureVeiwController class]]) {
                    FSDeepPictureVeiwController *deepPictureCtrl = (FSDeepPictureVeiwController *)viewController;
                    deepPictureCtrl.bottomControlHeight = [self pageControlHeight];
                    deepPictureCtrl.pictureid = pageObj.pageid;
                }
                break;
            case FSDEEP_PAGE_TEXT:
                if ([viewController isKindOfClass:[FSDeepTextViewController class]]) {
                    FSDeepTextViewController *deepTextCtrl = (FSDeepTextViewController *)viewController;
                    deepTextCtrl.contentid = pageObj.pageid;
                    deepTextCtrl.Deep_title = self.Deep_title;
                }
                //controllerClass = [FSDeepTextViewController class];
                break;
            case FSDEEP_PAGE_OUTER:
                //controllerClass = [FSDeepOuterLinkViewController class];
                if ([viewController isKindOfClass:[FSDeepOuterLinkViewController class]]) {
                    FSDeepOuterLinkViewController *outerLinkCtrl = (FSDeepOuterLinkViewController *)viewController;
                    outerLinkCtrl.outerid = pageObj.pageid;
                }
                break;
            case FSDEEP_PAGE_INVESTIGATE:
                //controllerClass = [FSDeepInvestigateViewController class];
                break;
            case FSDEEP_PAGE_END:
                //controllerClass = [FSDeepEndViewController class];
                if ([viewController isKindOfClass:[FSDeepEndViewController class]]) {
                    FSDeepEndViewController *deepEndCtrl = (FSDeepEndViewController *)viewController;
                    deepEndCtrl.deepid = pageObj.pageid;
                }
                break;
            case FSDEEP_PAGE_COMMENT:
                //controllerClass = [FSDeepCommentViewController class];
                break;
            case FSDEEP_PAGE_PRIOR:
                //controllerClass = [FSDeepPriorViewController class];
                if ([viewController isKindOfClass:[FSDeepPriorViewController class]]) {
                    FSDeepPriorViewController *deepPriorCtrl = (FSDeepPriorViewController *)viewController;
                    deepPriorCtrl.deepid = pageObj.pageid;
                }
                break;
            default:
                break;
        }
    }
}
-(void)fsBaseContainerViewTouchEvent:(FSBaseContainerView *)sender{
    if ([sender isEqual:_fsShareIconContainView]) {
        switch (_fsShareIconContainView.shareSelectEvent) {
            case ShareSelectEvent_return:
                break;
            case ShareSelectEvent_sina:
                NSLog(@"分享到新浪微博");
            {
                FSSinaBlogShareViewController *fsSinaBlogShareViewController = [[FSSinaBlogShareViewController alloc] init];
                
                fsSinaBlogShareViewController.withnavTopBar                  = YES;
                fsSinaBlogShareViewController.title                          = @"新浪微博分享";
                fsSinaBlogShareViewController.shareContent = [self shareContent];
                [self presentViewController:fsSinaBlogShareViewController animated:YES completion:nil];
                [fsSinaBlogShareViewController release];
            }
                
                break;
            case ShareSelectEvent_netease:
                NSLog(@"分享到网易微博");
                FSNetEaseBlogShareViewController *fsNetEaseBlogShareViewController = [[FSNetEaseBlogShareViewController alloc] init];
                fsNetEaseBlogShareViewController.withnavTopBar                     = YES;
                fsNetEaseBlogShareViewController.shareContent                      = [self shareContent];
                [self presentViewController:fsNetEaseBlogShareViewController animated:YES completion:nil];
                [fsNetEaseBlogShareViewController release];
                //}
                
                break;
            case ShareSelectEvent_weixin:
                [self sendShareWeiXin:0];
                break;
            case ShareSelectEvent_friend:
            {
                [self sendShareWeiXin:1];
            }
                
                break;
            case ShareSelectEvent_peopleBlog:
                NSLog(@"分享到人民微博");
                FSPeopleBlogShareViewController *fsPeopleBlogShareViewController = [[FSPeopleBlogShareViewController alloc] init];
                fsPeopleBlogShareViewController.withnavTopBar                    = YES;
                fsPeopleBlogShareViewController.shareContent = [self shareContent];
                //[self.navigationController pushViewController:fsPeopleBlogShareViewController animated:YES];
                [self presentViewController:fsPeopleBlogShareViewController animated:YES completion:nil];
                //[self.fsSlideViewController pres:fsNewsContainerViewController animated:YES];
                [fsPeopleBlogShareViewController release];
                //}
                
                break;
            case ShareSelectEvent_mail:
                NSLog(@"邮件分享");
                if ([MFMailComposeViewController canSendMail]) {
                    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
                    picker.mailComposeDelegate = self;
                    //[picker setSubject:[self shareContent]];

                    NSArray *toRecipients = [NSArray arrayWithObject:@"[email][/email]"];
                    [picker setToRecipients:toRecipients];
                    NSString *emailBody = [self shareContent];
                    [picker setMessageBody:emailBody isHTML:NO];
                    [self presentModalViewController:picker animated:YES];
                    [picker release];
                }
                else{
                    FSInformationMessageView *informationMessageView = [[FSInformationMessageView alloc] initWithFrame:CGRectZero];
                    informationMessageView.parentDelegate = self;
                    [informationMessageView showInformationMessageViewInView:self.view
                                                                 withMessage:@"请先设置您的邮箱再分享，谢谢！"
                                                            withDelaySeconds:2.0f
                                                            withPositionKind:PositionKind_Vertical_Horizontal_Center
                                                                  withOffset:0.0f];

                    [self performSelector:@selector(shearWithMail) withObject:nil afterDelay:1.5];
                }
                
                break;
            case ShareSelectEvent_message:
                NSLog(@"短信分享");
                [NTESNBSMSManager sharedSMSManager].smsBody = [self shareContent];
                [NTESNBSMSManager sharedSMSManager].pushNavigation = self.navigationController;
                [[NTESNBSMSManager sharedSMSManager] pushSMSComposer];
                break;
            case ShareSelectEvent_tencent:
            {
                LygTencentShareViewController *fsSinaBlogShareViewController = [[LygTencentShareViewController alloc] init];
                fsSinaBlogShareViewController.withnavTopBar                  = YES;
                fsSinaBlogShareViewController.title                          = @"腾讯微博分享";
                fsSinaBlogShareViewController.shareContent                   = [self shareContent];
                [self presentViewController:fsSinaBlogShareViewController animated:YES completion:nil];
                [fsSinaBlogShareViewController release];
            }
                break;
            default:
                break;
        }
        NSLog(@"。。。。。。。。。");
        //_fsNewsContainerView.userInteractionEnabled = YES;
        _fsShareIconContainView.isShow = NO;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.6];
        _fsShareIconContainView.frame = CGRectMake(0, self.view.frame.size.height+44, self.view.frame.size.width, [_fsShareIconContainView getHeight]);
        [UIView commitAnimations];
        
    }
}
-(void)sendShareWeiXin:(int)isSendToFriend{
    if (1) {
        NSString *newsContent = @"";
        PeopleNewsReaderPhoneAppDelegate*appDelegate = (PeopleNewsReaderPhoneAppDelegate *)[UIApplication sharedApplication].delegate;
        [self retain];
        UIImage *image = [UIImage imageNamed:@"icon@2x.png"];
        if (isSendToFriend == 0) {
            if (![appDelegate sendWXMidiaMessage:[self shareContent] content:newsContent thumbImage:image webURL:@"https://itunes.apple.com/cn/app/id424180337"]) {
                //[CommonFuncs showMessage:@"人民新闻" ContentMessage:@"不能分享到微信，请确认安装了最新版本的微信客户端"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"人民新闻" message:@"不能分享到微信，请确认安装了最新版本的微信客户端" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
            else{
                NSLog(@"sendShareWeiXin fail");
            }
        }else
        {
            if (![appDelegate sendWXMidiaMessagePYQ:[self shareContent] content:[self shareContent] thumbImage:image webURL:@"https://itunes.apple.com/cn/app/id424180337"]) {
                //[CommonFuncs showMessage:@"人民新闻" ContentMessage:@"不能分享到微信，请确认安装了最新版本的微信客户端"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"人民新闻" message:@"不能分享到微信，请确认安装了最新版本的微信客户端" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
            else{
                NSLog(@"sendShareWeiXin fail");
            }
            
        }
        
        
	} else {
        //[CommonFuncs showMessage:@"人民新闻" ContentMessage:@"正文内容不存在"];
	}
    
}


-(NSString *)shareContent{
    NSArray * arry = [_Deep_title componentsSeparatedByString:@"】"];
    NSString * string;
    if (arry.count == 2) {
        string = [arry objectAtIndex:1];
    }else
    {
        string = _Deep_title;
    }
    return [NSString stringWithFormat:@"【%@】%@->下载人民新闻：http://3g.qglt.com/n/client",string,_newsAbstract];
}
-(void)share{
    _fsShareIconContainView.frame  = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, [_fsShareIconContainView getHeight]);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.6];
    _fsShareIconContainView.frame  = CGRectMake(0, self.view.frame.size.height-[_fsShareIconContainView getHeight], self.view.frame.size.width, [_fsShareIconContainView getHeight]);
    _fsShareIconContainView.isShow = YES;
    [UIView commitAnimations];
}

-(void)onButtonClick:(int)index
{
    if (index == 100) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (index == 200)
    {
        [self share];
    }
    
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    NSLog(@"result:%d",result);
    
    
    if (result == MFMailComposeResultCancelled) {
        FSInformationMessageView *informationMessageView = [[FSInformationMessageView alloc] initWithFrame:CGRectZero];
        informationMessageView.parentDelegate = self;
        [informationMessageView showInformationMessageViewInView:self.view
                                                     withMessage:@"取消分享"
                                                withDelaySeconds:2.0f
                                                withPositionKind:PositionKind_Vertical_Horizontal_Center
                                                      withOffset:0.0f];
        [informationMessageView release];
    }else if(result == MFMailComposeResultFailed){
        FSInformationMessageView *informationMessageView = [[FSInformationMessageView alloc] initWithFrame:CGRectZero];
        informationMessageView.parentDelegate = self;
        [informationMessageView showInformationMessageViewInView:self.view
                                                     withMessage:@"分享邮件发送失败！"
                                                withDelaySeconds:2.0f
                                                withPositionKind:PositionKind_Vertical_Horizontal_Center
                                                      withOffset:0.0f];
    }else if(result == MFMailComposeResultSaved){
        FSInformationMessageView *informationMessageView = [[FSInformationMessageView alloc] initWithFrame:CGRectZero];
        informationMessageView.parentDelegate = self;
        [informationMessageView showInformationMessageViewInView:self.view
                                                     withMessage:@"分享邮件已保存到草稿箱！"
                                                withDelaySeconds:2.0f
                                                withPositionKind:PositionKind_Vertical_Horizontal_Center
                                                      withOffset:0.0f];
    }
    else if(result == MFMailComposeResultSent){
        FSInformationMessageView *informationMessageView = [[FSInformationMessageView alloc] initWithFrame:CGRectZero];
        informationMessageView.parentDelegate = self;
        [informationMessageView showInformationMessageViewInView:self.view
                                                     withMessage:@"分享邮件已发送！"
                                                withDelaySeconds:2.0f
                                                withPositionKind:PositionKind_Vertical_Horizontal_Center
                                                      withOffset:0.0f];
    }
    
    
    if (self.navigationController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else if(self.presentingViewController)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



@end
