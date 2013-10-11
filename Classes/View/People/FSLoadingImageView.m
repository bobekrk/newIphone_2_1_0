//
//  FSLoadingImageView.m
//  PeopleNewsReaderPhone
//
//  Created by yuan lei on 12-8-4.
//  Copyright (c) 2012年 people. All rights reserved.
//

#import "FSLoadingImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "FSAsyncImageView.h"
#import "LygAdsLoadingImageObject.h"
#import "FSShareIconContainView.h"
#import "FSNewsContainerViewController.h"
#import "FSWebViewForOpenURLViewController.h"
#import "FSSinaBlogShareViewController.h"
#import "FSNetEaseBlogShareViewController.h"
#import "FSPeopleBlogShareViewController.h"
#import "FSSlideViewController.h"
#import "LygTencentShareViewController.h"
#import "NTESNBSMSManager.h"
#import <MessageUI/MessageUI.h>
#import "PeopleNewsReaderPhoneAppDelegate.h"
#import "LygAdsDao.h"
#import "FSLoadingImageObject.h"
#import "FSOneDayNewsObject.h"
#import "FSIndicatorMessageView.h"
//#import "MFMailComposeViewController.h"
#define FSLOADING_IMAGEVIEW_ANIMATION_KEY @"FSLOADING_IMAGEVIEW_ANIMATION_KEY_STRING"

#define FSLOADING_IMAGEVIEW_URL @"http://mobile.app.people.com.cn:81/news2/news.php?act=focuspicture&type=loading&channelid=&count=&rt=xml"
/*
 <item>
 <newsid><![CDATA[0]]></newsid>
 <title><![CDATA[欢迎使用人民新闻客户端]]></title>
 <browserCount><![CDATA[0]]></browserCount>
 <type><![CDATA[loading]]></type>
 <channelid><![CDATA[]]></channelid>
 <timestamp><![CDATA[1362367616]]></timestamp>
 <date><![CDATA[2013-03-04 11:26:56]]></date>
 <picture><![CDATA[http://58.68.130.168/thumbs/640/320/data/newsimages/client/130116/F201301161358313981237275.jpg]]></picture>
 <link><![CDATA[http://wap.people.com.cn/]]></link>
 <flag><![CDATA[0]]></flag>
 </item>
*/


@implementation FSLoadingImageView

@synthesize parentDelegate = _parentDelegate;


- (id)initWithFrame:(CGRect)frame andISNeedAutoClose:(BOOL)isClose
{
    self.isNeedAutoClose = isClose;
    
    return [self initWithFrame:frame];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView * VIEW = [[UIImageView alloc]initWithFrame:self.bounds];
        //VIEW.image         = [UIImage imageWithContentsOfFile:@"Default"];
        if (ISIPHONE5) {
            
            //_adImageView.defaultFileName = @"Default-568h@2x.png";
            //VIEW.image         = [UIImage imageWithNameString:@"Default-568h@2x"];
            VIEW.image         = [[[UIImage alloc]initWithNameString:@"Default-568h@2x"] autorelease];
        }
        else{
            VIEW.image         = [[[UIImage alloc]initWithNameString:@"Default"] autorelease];
            
        }

        [self addSubview:VIEW];
        [VIEW release];
        _adsStatus     = 0;
        _headPicStatus = 0;
        if (self.isNeedAutoClose) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeOutEvent) userInfo:nil repeats:NO];
        }
        //UIImage * tempImage       = [UIImage imageNamed:@"翻页.png"];
        UIImage * tempImage       = [[UIImage alloc]initWithNameString:@"翻页"];
        float     xxx             = 1.4;
        UIButton * button         = [[UIButton alloc]initWithFrame:CGRectMake(250, [UIScreen mainScreen].bounds.size.height/2  - tempImage.size.width/(2*xxx), tempImage.size.width/xxx, tempImage.size.height/xxx)];
        [button setBackgroundImage:tempImage forState:UIControlStateNormal];
        [tempImage release];
        button.tag                = -1;
        button.alpha              = 1;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button release];
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)saveImage:(UILongPressGestureRecognizer*)sender
{

    if (sender.state == UIGestureRecognizerStateBegan) {
        FSAsyncImageView * view = (FSAsyncImageView*)sender.view;
        if (view) {
            if (_timer) {
                [_timer invalidate];
                _timer = nil;
            }
            UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片到相册", nil];
            [sheet showInView:self];
            [sheet release];
        }
    }
}

- (void)               image: (UIImage *) image
    didFinishSavingWithError: (NSError *) error
                 contextInfo: (void *) contextInfo
{
    if (error == nil) {
        FSInformationMessageView * temp = [[FSInformationMessageView alloc]init];
        [temp showInformationMessageViewInView:self withMessage:@"已经保存到手机相册" withDelaySeconds:0.5 withPositionKind:PositionKind_Vertical_Horizontal_Center withOffset:0];
        [temp release];
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"保存失败" message:@"请到设置->隐私->照片 里面把人民新闻对应的开关打开" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) {
        return;
    }
    
//    [self performSelectorInBackground:@selector(savePic) withObject:nil];
    UIImage * image = nil;
    if (_adsStatus == 1) {
        image = _adImageView.imageView.image;
    }else
    {
        image = _adImageView2.imageView.image;
    }
    
    //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    //UIImageWriteToSavedPhotosAlbum(image, self, @selector(savedImage), <#void *contextInfo#>)
//    FSInformationMessageView * temp = [[FSInformationMessageView alloc]init];
//    [temp showInformationMessageViewInView:self withMessage:@"已经保存到手机相册" withDelaySeconds:0.5 withPositionKind:PositionKind_Vertical_Horizontal_Center withOffset:0];
//    [temp release];
}
-(void)handleSingleFingerEvent:(id)sender
{
    int flag                  =  -1;  //[obj.adLinkFlag intValue];
    LygAdsLoadingImageObject * adObject  = nil;
    FSLoadingImageObject * loadingObject = nil;
    NSString             *  url          = nil;
    NSString             * newsid        = nil;
    if (_adsStatus == 1) {
        adObject = [_fs_GZF_ForLoadingImageDAO.objectList objectAtIndex:0];
        flag     = adObject.adLinkFlag.intValue;
        url      = adObject.adLink;
        newsid   = adObject.adLink;
    }else
    {
        loadingObject = [_fs_GZF_ForLoadingImageDAO2.objectList objectAtIndex:0];
        flag          = loadingObject.flag.intValue;
        url           = loadingObject.link;
        newsid        = loadingObject.newsid;
    }
    
    if (flag == 1) {
        FSOneDayNewsObject  * o                                      = [[FSOneDayNewsObject alloc]init];
        o.newsid                                                     = newsid;
        FSNewsContainerViewController *fsNewsContainerViewController = [[FSNewsContainerViewController alloc] init];
        fsNewsContainerViewController.obj                            = o;
        fsNewsContainerViewController.newsSourceKind                 = NewsSourceKind_ShiKeNews;
        UINavigationController * navi                                = (UINavigationController *)([UIApplication sharedApplication].keyWindow.rootViewController);
        [navi pushViewController:fsNewsContainerViewController animated:YES];
        [fsNewsContainerViewController release];
        [o release];
        [[FSBaseDB sharedFSBaseDB] updata_visit_message:o.channelid];
    }
    else if (flag == 3){
        //NSString * string =[NSString stringWithFormat:@"%@",obj.adLink];
        NSURL *url2 = [[NSURL alloc] initWithString:url];
        [[UIApplication sharedApplication] openURL:url2];
        [url2 release];
    }
    else if (flag == 2){//内嵌浏览器
        FSWebViewForOpenURLViewController *fsWebViewForOpenURLViewController = [[FSWebViewForOpenURLViewController alloc] init];
        
        fsWebViewForOpenURLViewController.urlString = [NSString stringWithFormat:@"%@",url];
        fsWebViewForOpenURLViewController.withOutToolbar = NO;
        //[[UIApplication sharedApplication].keyWindow
        // [self.window.rootViewController.navigationController pushViewController:fsWebViewForOpenURLViewController animated:YES];
        
        if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController * navi = (UINavigationController *)([UIApplication sharedApplication].keyWindow.rootViewController);
            [navi pushViewController:fsWebViewForOpenURLViewController animated:YES];
            [fsWebViewForOpenURLViewController release];
        }else
        {
            [[UIApplication sharedApplication].keyWindow.rootViewController presentModalViewController:fsWebViewForOpenURLViewController animated:YES];
            [fsWebViewForOpenURLViewController release];
        }
        //[self.navigationController pushViewController:fsWebViewForOpenURLViewController animated:YES];
        //[self.fsSlideViewController pres:fsNewsContainerViewController animated:YES];
        //[fsWebViewForOpenURLViewController release];
    }
    if (flag != 0) {
        [self timeOutEvent];
    }
}
-(NSString *)shareContent{
    NSMutableString * string = [[NSMutableString alloc]init];
    if (_adsStatus == 1) {
        LygAdsLoadingImageObject * object = [_fs_GZF_ForLoadingImageDAO.objectList objectAtIndex:0];
        [string appendFormat:@"%@%@",object.shareContent,object.shareUrl];
    }else
    {
        FSLoadingImageObject * temp = [_fs_GZF_ForLoadingImageDAO2.objectList objectAtIndex:0];
        [string appendFormat:@"%@%@",temp.shareContent,temp.shareUrl];
    }
    
    return [string autorelease];
}
-(void)fsBaseContainerViewTouchEvent:(FSBaseContainerView *)sender{
    if ([sender isEqual:_fsShareIconContainView]) {
        _fsShareIconContainView.isShow = NO;
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
//                [self presentViewController:fsSinaBlogShareViewController animated:YES completion:nil];
                if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[FSSlideViewController class]]) {
                    FSSlideViewController * slider  = (FSSlideViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
                    [slider.rootViewController presentModalViewController:fsSinaBlogShareViewController animated:YES];
                    
                }else
                {
                    NSLog(@"%@", [UIApplication sharedApplication].keyWindow.rootViewController);
                    //[[UIApplication sharedApplication].keyWindow.rootViewController presentModalViewController:fsPeopleBlogShareViewController animated:YES];
                    UINavigationController * navi = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
                    [navi pushViewController:fsSinaBlogShareViewController animated:YES];
                    
                }
   
                [fsSinaBlogShareViewController release];
                [self removeFromSuperview];
            }
                
                break;
            case ShareSelectEvent_netease:
            {
                NSLog(@"分享到网易微博");
                FSNetEaseBlogShareViewController *fsNetEaseBlogShareViewController = [[FSNetEaseBlogShareViewController alloc] init];
                fsNetEaseBlogShareViewController.withnavTopBar                     = YES;
                fsNetEaseBlogShareViewController.shareContent                      = [self shareContent];
                if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[FSSlideViewController class]]) {
                    FSSlideViewController * slider  = (FSSlideViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
                    [slider.rootViewController presentModalViewController:fsNetEaseBlogShareViewController animated:YES];
                    
                }else
                {
                    NSLog(@"%@", [UIApplication sharedApplication].keyWindow.rootViewController);
                    //[[UIApplication sharedApplication].keyWindow.rootViewController presentModalViewController:fsPeopleBlogShareViewController animated:YES];
                    UINavigationController * navi = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
                    [navi pushViewController:fsNetEaseBlogShareViewController animated:YES];
                    
                }
                
                [fsNetEaseBlogShareViewController release];
                [self removeFromSuperview];

            }
                                //}
                
                break;
            case ShareSelectEvent_weixin:
            {
                [self sendShareWeiXin:0];
                [self removeFromSuperview];
            }
                
                break;
            case ShareSelectEvent_friend:
            {
                [self sendShareWeiXin:1];
                [self removeFromSuperview];
            }
                
                break;
            case ShareSelectEvent_peopleBlog:
            {
                NSLog(@"分享到人民微博");
                FSPeopleBlogShareViewController *fsPeopleBlogShareViewController = [[FSPeopleBlogShareViewController alloc] init];
                fsPeopleBlogShareViewController.withnavTopBar                    = YES;
                fsPeopleBlogShareViewController.shareContent = [self shareContent];
                //[[UIApplication sharedApplication].keyWindow.rootViewController.rootViewController presentModalViewController:fsPeopleBlogShareViewController animated:YES];
                if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[FSSlideViewController class]]) {
                    FSSlideViewController * slider  = (FSSlideViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
                    [slider.rootViewController presentModalViewController:fsPeopleBlogShareViewController animated:YES];
                    
                }else
                {
                    NSLog(@"%@", [UIApplication sharedApplication].keyWindow.rootViewController);
                    //[[UIApplication sharedApplication].keyWindow.rootViewController presentModalViewController:fsPeopleBlogShareViewController animated:YES];
                    UINavigationController * navi = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
                    [navi pushViewController:fsPeopleBlogShareViewController animated:YES];
                    
                }
                [fsPeopleBlogShareViewController release];
                [self removeFromSuperview];
            }
                break;
            case ShareSelectEvent_mail:
            {
                if ([MFMailComposeViewController canSendMail]) {
                    [self retain];
                    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
                    picker.mailComposeDelegate = self;
                    [picker setSubject:[self shareContent]];
                    
                    NSArray *toRecipients = [NSArray arrayWithObject:@"[email][/email]"];
                    [picker setToRecipients:toRecipients];
                    NSString *emailBody = [self shareContent];
                    [picker setMessageBody:emailBody isHTML:NO];
                    UINavigationController * navi                = (UINavigationController*)([UIApplication sharedApplication].keyWindow.rootViewController);
                    [navi.topViewController presentModalViewController:picker animated:YES];
                    [picker release];
                    [self removeFromSuperview];
                }
                else{
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"不能发送" message:@"请设置邮箱" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                }
            }
                
                break;
                
            case ShareSelectEvent_message:
            {
                NSLog(@"短信分享");
                [self retain];
                MFMessageComposeViewController  * controller = [[MFMessageComposeViewController alloc]init];
                controller.delegate                          = self;
                controller.messageComposeDelegate            = self;
                controller.body                              = [self shareContent];
                UINavigationController * navi                = (UINavigationController*)([UIApplication sharedApplication].keyWindow.rootViewController);
                [navi.topViewController presentModalViewController:controller animated:YES];
                [controller release];
                [self removeFromSuperview];
                
                
            }
                
                break;
            case ShareSelectEvent_tencent:
            {
                LygTencentShareViewController *fsSinaBlogShareViewController = [[LygTencentShareViewController alloc] init];
                fsSinaBlogShareViewController.withnavTopBar                  = YES;
                fsSinaBlogShareViewController.title                          = @"腾讯微博分享";
                fsSinaBlogShareViewController.shareContent                   = [self shareContent];
                if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[FSSlideViewController class]]) {
                    FSSlideViewController * slider  = (FSSlideViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
                    [slider.rootViewController presentModalViewController:fsSinaBlogShareViewController animated:YES];
                    
                }else
                {
                    NSLog(@"%@", [UIApplication sharedApplication].keyWindow.rootViewController);
                    //[[UIApplication sharedApplication].keyWindow.rootViewController presentModalViewController:fsPeopleBlogShareViewController animated:YES];
                    UINavigationController * navi = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
                    [navi pushViewController:fsSinaBlogShareViewController animated:YES];
                    
                    
                }
                [fsSinaBlogShareViewController release];
                [self removeFromSuperview];
            }
                break;
            default:
                break;
        }
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.6];
        [_fsShareIconContainView removeFromSuperview];
        //_fsShareIconContainView.frame = CGRectMake(0, self.frame.size.height+44, self.frame.size.width, [_fsShareIconContainView getHeight]);
        //[self timeOutEvent];
        [UIView commitAnimations];
        
    }
}
//微信

-(void)sendShareWeiXin:(int)isSendToFriend{
    if (1) {
        NSString *newsContent;
        

        PeopleNewsReaderPhoneAppDelegate*appDelegate = (PeopleNewsReaderPhoneAppDelegate *)[UIApplication sharedApplication].delegate;
        NSString * xxxx = nil;
        if (_adsStatus == 1) {
            LygAdsLoadingImageObject * object = [_fs_GZF_ForLoadingImageDAO.objectList objectAtIndex:0];
            xxxx                              = object.shareUrl;
        }else
        {
            FSLoadingImageObject * temp = [_fs_GZF_ForLoadingImageDAO2.objectList objectAtIndex:0];
            xxxx                              = temp.shareUrl;
        }

        [self retain];
        UIImage *image = [UIImage imageNamed:@"icon@2x.png"];
        if (isSendToFriend == 0) {
            if (![appDelegate sendWXMidiaMessage:[self shareContent] content:[self shareContent] thumbImage:image webURL:xxxx]) {
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
            if (![appDelegate sendWXMidiaMessagePYQ:[self shareContent] content:[self shareContent] thumbImage:image webURL:xxxx]) {
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
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0)
{
    [self release];
    [controller dismissModalViewControllerAnimated:YES];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissModalViewControllerAnimated:YES];
    [self release];
}
-(void)buttonClick:(UIButton*)sender
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    int flag                  =  -1;  //[obj.adLinkFlag intValue];
    LygAdsLoadingImageObject *obj =  nil;
    if (_fs_GZF_ForLoadingImageDAO.objectList && _fs_GZF_ForLoadingImageDAO.objectList.count > 0) {
        obj = [_fs_GZF_ForLoadingImageDAO.objectList objectAtIndex:0];
        flag                  =  [obj.adLinkFlag intValue];
    }
    
    int x = sender.tag;
    switch (x) {
        case -1:
        {

            [self timeOutEvent];
        }
            break;
        case -2:
        {
            if (_timer) {
                [_timer invalidate];
                _timer = nil;
            }
            _fsShareIconContainView = [[FSShareIconContainView alloc] initWithFrame:CGRectZero];
            _fsShareIconContainView.parentDelegate = self;
            [[UIApplication sharedApplication].keyWindow addSubview:_fsShareIconContainView];
            [_fsShareIconContainView release];
            
            [self bringSubviewToFront:_fsShareIconContainView];
            _fsShareIconContainView.frame  = CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height, 320, 320);
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.6];
            _fsShareIconContainView.frame  = CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height -320, 320, 320);
            _fsShareIconContainView.isShow = YES;
            [UIView commitAnimations];
        }
            break;
        case -3:
        {
            if (flag == 1) {
//                FSNewsContainerViewController *fsNewsContainerViewController = [[FSNewsContainerViewController alloc] init];
//                fsNewsContainerViewController.FCObj = o;
//                fsNewsContainerViewController.newsSourceKind = NewsSourceKind_ShiKeNews;
//                
//                [self.navigationController pushViewController:fsNewsContainerViewController animated:YES];
//                //[self.fsSlideViewController pres:fsNewsContainerViewController animated:YES];
//                
//                [fsNewsContainerViewController release];
//                [[FSBaseDB sharedFSBaseDB] updata_visit_message:o.channelid];
            }
            else if (flag == 3){
                NSString * string =[NSString stringWithFormat:@"%@",obj.adLink];
                NSURL *url = [[NSURL alloc] initWithString:string];
                [[UIApplication sharedApplication] openURL:url];
                [url release];
            }
            else if (flag == 2){//内嵌浏览器
                FSWebViewForOpenURLViewController *fsWebViewForOpenURLViewController = [[FSWebViewForOpenURLViewController alloc] init];
                
                fsWebViewForOpenURLViewController.urlString = [NSString stringWithFormat:@"%@",obj.adLink];
                fsWebViewForOpenURLViewController.withOutToolbar = NO;
                //[[UIApplication sharedApplication].keyWindow
               // [self.window.rootViewController.navigationController pushViewController:fsWebViewForOpenURLViewController animated:YES];
                
                if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UINavigationController class]]) {
                    UINavigationController * navi = (UINavigationController *)([UIApplication sharedApplication].keyWindow.rootViewController);
                    [navi pushViewController:fsWebViewForOpenURLViewController animated:YES];
                    [fsWebViewForOpenURLViewController release];
                }else
                {
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentModalViewController:fsWebViewForOpenURLViewController animated:YES];
                    [fsWebViewForOpenURLViewController release];
                }
                //[self.navigationController pushViewController:fsWebViewForOpenURLViewController animated:YES];
                //[self.fsSlideViewController pres:fsNewsContainerViewController animated:YES];
                //[fsWebViewForOpenURLViewController release];
            }
            [self timeOutEvent];

        }
            break;
            
        default:
            break;
    }
}



-(void)layoutSubviews{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoadingXMLComplete:) name:LOADINGIMAGE_LOADING_XML_COMPELECT object:nil];
    
    _fs_GZF_ForLoadingImageDAO         = [[LygAdsDao alloc] init];
    _fs_GZF_ForLoadingImageDAO.parentDelegate  = self;
    _fs_GZF_ForLoadingImageDAO.placeID = 44;
    [_fs_GZF_ForLoadingImageDAO HTTPGetDataWithKind:GET_DataKind_Refresh];
    
    
    
    
    
    
//    _fsShareIconContainView = [[FSShareIconContainView alloc] initWithFrame:CGRectZero];
//    _fsShareIconContainView.parentDelegate = self;
//    [self addSubview:_fsShareIconContainView];
//    
//    [_fsShareIconContainView release];
    _fs_GZF_ForLoadingImageDAO2 = [[FS_GZF_ForLoadingImageDAO alloc] init];
    _fs_GZF_ForLoadingImageDAO2.isIphone5 = ISIPHONE5;
    [self performSelector:@selector(asyXXX) withObject:nil afterDelay:0.3];
    
}
-(void)asyXXX
{
    [_fs_GZF_ForLoadingImageDAO2 HTTPGetDataWithKind:GET_DataKind_ForceRefresh];
}
- (void)dataAccessObjectSyncEnd:     (FSBaseDAO *)sender
{
    
}



-(void)dealloc{
    printf("deeeeeeeeeee\n");
    //[_fsShareIconContainView removeFromSuperview];
    _fs_GZF_ForLoadingImageDAO.parentDelegate = nil;
    [_fs_GZF_ForLoadingImageDAO release];
    _fs_GZF_ForLoadingImageDAO = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOADINGIMAGE_LOADING_XML_COMPELECT object:nil];
    _fs_GZF_ForLoadingImageDAO2.parentDelegate = nil;
    [_fs_GZF_ForLoadingImageDAO2 release];
    _fs_GZF_ForLoadingImageDAO2 = nil;
    [super dealloc];
}


-(void)LoadingXMLComplete:(NSNotification *)notification{
    //NSLog(@"LoadingXMLComplete111");
    [self imageLoadingComplete];
}

-(void)addButtons
{
    NSLog(@"%d",_fs_GZF_ForLoadingImageDAO.objectList.count);
    //LygAdsLoadingImageObject *obj = [_fs_GZF_ForLoadingImageDAO.objectList objectAtIndex:0];
    
    
    UIButton * buttonxxx = (UIButton*)[self viewWithTag:-1];
    [self bringSubviewToFront:buttonxxx];
    UIButton * titleButton    = [[UIButton alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 65, 260, 80)];
    [titleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [titleButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    titleButton.titleLabel.numberOfLines = 0;
    //titleButton.backgroundColor = [UIColor clearColor];
    titleButton.tag           = -3;
    if (_adsStatus == 1) {
        LygAdsLoadingImageObject *obj = [_fs_GZF_ForLoadingImageDAO.objectList objectAtIndex:0];
         [titleButton setTitle:obj.adTitle forState:UIControlStateNormal];
    }else
    {
        
        FSLoadingImageObject * load   = [_fs_GZF_ForLoadingImageDAO2.objectList objectAtIndex:0];
        [titleButton setTitle:load.title  forState:UIControlStateNormal];

    }
   
    [titleButton addTarget:self action:@selector(handleSingleFingerEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:titleButton];
    [titleButton release];
    
    UIImage * tempImage2 = [[UIImage alloc]initWithNameString:@"跳转"];
    float xxx = 0.65;
    UIButton * button2 = [[UIButton alloc]initWithFrame:CGRectMake(265, [UIScreen mainScreen].bounds.size.height - tempImage2.size.width - 40, tempImage2.size.width/xxx, tempImage2.size.height/xxx)];
    button2.alpha = 1;
    [button2 setBackgroundImage:tempImage2 forState:UIControlStateNormal];
    [tempImage2 release];
    button2.tag = -2;
    [button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button2];
    [button2 release];
}
-(void)imageLoadingComplete{
    if ([_fs_GZF_ForLoadingImageDAO.objectList count]>0) {
        //firstTime = NO;
        if (_adsStatus == 0) {
            _adsStatus = 1;
        }else if (_adsStatus == 1)
        {
            return;
        }
        [_fs_GZF_ForLoadingImageDAO operateOldBufferData];
        LygAdsLoadingImageObject *obj = [_fs_GZF_ForLoadingImageDAO.objectList objectAtIndex:0];
        
        _adImageView = [[FSAsyncImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        //[_adImageView release];
        NSString *localStoreFileName = getFileNameWithURLString(obj.picUrl, getCachesPath());
        _adImageView.alpha = 0.0f;
        
        _adImageView.urlString = obj.picUrl;
        _adImageView.localStoreFileName = localStoreFileName;
        _adImageView.imageCuttingKind = ImageCuttingKind_fixrect;
        _adImageView.borderColor = COLOR_CLEAR;
        
        [self addSubview:_adImageView];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        _adImageView.alpha = 1.0f;
        [UIView commitAnimations];
        
        //_timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerEvent) userInfo:nil repeats:NO];
        
        if ([UIScreen mainScreen].bounds.size.height==568.0f) {
            
            _adImageView.defaultFileName = @"Default-568h@2x.png";
        }
        else{
            _adImageView.defaultFileName = @"Default.png";
        }
        
        [_adImageView updateAsyncImageView];
        [_adImageView release];
        
        
        UILongPressGestureRecognizer * gester = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveImage:)];
        //gester.minimumPressDuration           =  5;
//        UITapGestureRecognizer       * gester2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
//        [_adImageView addGestureRecognizer:gester2];
        [_adImageView addGestureRecognizer:gester];
//        [gester2 requireGestureRecognizerToFail:gester];
        [gester release];
//        [gester2 release];
        //_returnButton.alpha = 1.0f;
        CAGradientLayer * layer        = [[CAGradientLayer alloc]init];
        layer.frame                    = CGRectMake(0, _adImageView.frame.size.height - 100, 320, 100);
        layer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor,(id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8].CGColor,nil];
        [_adImageView.layer addSublayer:layer];
        [layer release];
        [self addButtons];
        return;
    }
    if ([_fs_GZF_ForLoadingImageDAO2.objectList count]>0) {
        //firstTime = NO;
        if (_adsStatus == 1) {
            return;
        }
        if (_headPicStatus == 0) {
            _headPicStatus = 1;
        }else if (_headPicStatus == 1)
        {
            return;
        }
        
        FSLoadingImageObject *obj = [_fs_GZF_ForLoadingImageDAO2.objectList objectAtIndex:0];
        
        _adImageView2 = [[FSAsyncImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        NSString *localStoreFileName = getFileNameWithURLString(obj.picture, getCachesPath());
        _adImageView2.alpha = 0.0f;
        
        _adImageView2.urlString = obj.picture;
        _adImageView2.localStoreFileName = localStoreFileName;
        _adImageView2.imageCuttingKind = ImageCuttingKind_fixrect;
        _adImageView2.borderColor = COLOR_CLEAR;
        
        [self addSubview:_adImageView2];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        _adImageView2.alpha = 1.0f;
        [UIView commitAnimations];
        
        //_timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerEvent) userInfo:nil repeats:NO];
        
        if ([UIScreen mainScreen].bounds.size.height==568.0f) {
            
            _adImageView2.defaultFileName = @"Default-568h@2x.png";
            
            //            UIImageView *image = [[UIImageView alloc] init];
            //            image.image = [UIImage imageNamed:@"loadingbgd.png"];
            //            image.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 180, self.frame.size.width, 180);
            //
            //            [self addSubview:image];
            //            [image release];
        }
        else{
            _adImageView2.defaultFileName = @"Default.png";
        }
        
        [_adImageView2 updateAsyncImageView];
        [_adImageView2 release];
        
        
//        UILongPressGestureRecognizer * gester = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveImage)];
//        [self addGestureRecognizer:gester];
//        [gester release];
        //_returnButton.alpha = 1.0f;
        
        UILongPressGestureRecognizer * gester = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveImage:)];
        //gester.minimumPressDuration           =  5;
//        UITapGestureRecognizer       * gester2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
//        [_adImageView2 addGestureRecognizer:gester2];
        [_adImageView2 addGestureRecognizer:gester];
//        [gester2 requireGestureRecognizerToFail:gester];
        
        [gester release];
//        [gester2 release];
        CAGradientLayer * layer        = [[CAGradientLayer alloc]init];
        layer.frame                    = CGRectMake(0, _adImageView2.frame.size.height - 100, 320, 100);
        layer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor,(id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8].CGColor,nil];
        [_adImageView2.layer addSublayer:layer];
        [layer release];
        [self addButtons];
        return;
    }

    

}



-(void)timeOutEvent{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
	
//	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
//	
//	animation.duration = 0.3;
//	animation.delegate = self;
//	animation.removedOnCompletion = NO;
//	animation.fillMode = kCAFillModeForwards;
//	animation.fromValue = [NSValue valueWithCGPoint:self.layer.position];
//	animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.layer.position.x - self.layer.bounds.size.width, self.layer.position.y)];
//	
//	[self.layer addAnimation:animation forKey:FSLOADING_IMAGEVIEW_ANIMATION_KEY];
    
    
    [UIView beginAnimations:@"xxxxxxx" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationStop:)];
    CGRect xxx = self.frame;
    xxx.origin.x -= 320;
    self.frame = xxx;
    [UIView commitAnimations];
    
    
    
}

-(void)animationStop:(id)sender
{
    if ([_parentDelegate respondsToSelector:@selector(fsLoaddingImageViewDidDisappear:)]) {
        [_parentDelegate fsLoaddingImageViewDidDisappear:self];
    }
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.1];
    //[self removeFromSuperview];
}

//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//	if (flag) {
//
//		[self.layer removeAnimationForKey:FSLOADING_IMAGEVIEW_ANIMATION_KEY];
//		
//		
//		
//		if ([_parentDelegate respondsToSelector:@selector(fsLoaddingImageViewDidDisappear:)]) {
//			[_parentDelegate fsLoaddingImageViewDidDisappear:self];
//		}
//        //[self removeFromSuperview];
//
//	}
//}



@end
