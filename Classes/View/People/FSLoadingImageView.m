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
#import "FS_GZF_ForLoadingImageDAO.h"
#import "FSLoadingImageObject.h"
#import "FSShareIconContainView.h"
#import "FSNewsContainerViewController.h"
#import "FSWebViewForOpenURLViewController.h"
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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		//self.multipleTouchEnabled = NO;
        self.userInteractionEnabled = YES;
        firstTime = YES;
    }
    return self;
}
-(void)buttonClick:(UIButton*)sender
{
    FSLoadingImageObject *obj = [_fs_GZF_ForLoadingImageDAO.objectList objectAtIndex:0];
    NSLog(@"%@",obj.adFlag);
    int flag                  = [obj.adLinkFlag intValue];
    int x = sender.tag;
    switch (x) {
        case -1:
        {
            [self timerEvent];
        }
            break;
        case -2:
        {
            _fsShareIconContainView = [[FSShareIconContainView alloc] initWithFrame:CGRectZero];
            _fsShareIconContainView.parentDelegate = self;
            [self addSubview:_fsShareIconContainView];
            [_fsShareIconContainView release];
            
            [self bringSubviewToFront:_fsShareIconContainView];
            _fsShareIconContainView.frame  = CGRectMake(0, 0, 300, 100);
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.6];
            _fsShareIconContainView.frame  = CGRectMake(0, 0, 300, 300);
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
                NSString * string =[NSString stringWithFormat:@"http://%@",obj.adLink];
                NSURL *url = [[NSURL alloc] initWithString:string];
                [[UIApplication sharedApplication] openURL:url];
                [url release];
            }
            else if (flag == 2){//内嵌浏览器
                FSWebViewForOpenURLViewController *fsWebViewForOpenURLViewController = [[FSWebViewForOpenURLViewController alloc] init];
                
                fsWebViewForOpenURLViewController.urlString = [NSString stringWithFormat:@"http://%@",obj.adLink];
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
    
    _fs_GZF_ForLoadingImageDAO = [[FS_GZF_ForLoadingImageDAO alloc] init];
    
    UIImageView *defaultImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //NSLog(@"11self.frame h:%f",[UIScreen mainScreen].bounds.size.height);
    if (ISIPHONE5) {
        defaultImage.image = [UIImage imageNamed:@"Default-568h@2x.png"];
    }
    else{
        defaultImage.image = [UIImage imageNamed:@"Default.png"];
    }
    
    [self addSubview:defaultImage];
   

    [defaultImage release];
    
    
    [_fs_GZF_ForLoadingImageDAO HTTPGetDataWithKind:GET_DataKind_Refresh];
    
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timeOutEvent) userInfo:nil repeats:NO];
    _fsShareIconContainView = [[FSShareIconContainView alloc] initWithFrame:CGRectZero];
    _fsShareIconContainView.parentDelegate = self;
    [self addSubview:_fsShareIconContainView];
    [_fsShareIconContainView release];
}



-(void)dealloc{
    [_fs_GZF_ForLoadingImageDAO release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOADINGIMAGE_LOADING_XML_COMPELECT object:nil];
    [super dealloc];
}


-(void)LoadingXMLComplete:(NSNotification *)notification{
    //NSLog(@"LoadingXMLComplete111");
    [self imageLoadingComplete];
}

-(void)addButtons
{
    FSLoadingImageObject *obj = [_fs_GZF_ForLoadingImageDAO.objectList objectAtIndex:0];
    UIImage * tempImage       = [UIImage imageNamed:@"翻页.png"];
    UIButton * button         = [[UIButton alloc]initWithFrame:CGRectMake(270, [UIScreen mainScreen].bounds.size.height/2, tempImage.size.width/2, tempImage.size.height/2)];
    [button setBackgroundImage:tempImage forState:UIControlStateNormal];
    button.tag                = -1;
    button.alpha              = 1;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button release];
    
    NSLog(@"%@",obj.adTitle);
    
    UIButton * titleButton    = [[UIButton alloc]initWithFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height - 55, 260, 40)];
    //titleButton.backgroundColor = [UIColor clearColor];
    titleButton.tag           = -3;
    [titleButton setTitle:obj.adTitle forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:titleButton];
    [titleButton release];
    
    UIImage * tempImage2 = [UIImage imageNamed:@"跳转.png.png"];
    UIButton * button2 = [[UIButton alloc]initWithFrame:CGRectMake(270, [UIScreen mainScreen].bounds.size.height - 40, tempImage2.size.width/2, tempImage2.size.height/2)];
    button2.alpha = 1;
    [button2 setBackgroundImage:tempImage2 forState:UIControlStateNormal];
    button2.tag = -2;
    [button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button2];
    [button2 release];
}
-(void)imageLoadingComplete{
    if ([_fs_GZF_ForLoadingImageDAO.objectList count]>0 && firstTime) {
        firstTime = NO;
        FSLoadingImageObject *obj = [_fs_GZF_ForLoadingImageDAO.objectList objectAtIndex:0];
        FSAsyncImageView *adImageView = [[FSAsyncImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        NSString *localStoreFileName = getFileNameWithURLString(obj.picUrl, getCachesPath());
        adImageView.alpha = 0.0f;
        
        adImageView.urlString = obj.picUrl;
        adImageView.localStoreFileName = localStoreFileName;
        adImageView.imageCuttingKind = ImageCuttingKind_fixrect;
        adImageView.borderColor = COLOR_CLEAR;
        
        [self addSubview:adImageView];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        adImageView.alpha = 1.0f;
        [UIView commitAnimations];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerEvent) userInfo:nil repeats:NO];
        
        if ([UIScreen mainScreen].bounds.size.height==568.0f) {
            
            adImageView.defaultFileName = @"Default-568h@2x.png";
        }
        else{
            adImageView.defaultFileName = @"Default.png";
        }
        
        [adImageView updateAsyncImageView];
        [adImageView release];
        [self addButtons];
    }
}

-(void)timerEvent{
    if (_switch == 1) {
        return;
    }
    _switch  = 1;
    if (firstTime) {
        return;
    }
    //firstTime = YES;
    
    //NSLog(@"timerEvent");
	if ([_parentDelegate respondsToSelector:@selector(fsLoaddingImageViewWillDisappear:)]) {
		[_parentDelegate fsLoaddingImageViewWillDisappear:self];
	}
    //i = 0;

	
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
	
	animation.duration = 0.3;
	animation.delegate = self;
	animation.removedOnCompletion = NO;
	animation.fillMode = kCAFillModeForwards;
	animation.fromValue = [NSValue valueWithCGPoint:self.layer.position];
	animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.layer.position.x - self.layer.bounds.size.width, self.layer.position.y)];
	
	[self.layer addAnimation:animation forKey:FSLOADING_IMAGEVIEW_ANIMATION_KEY];
    
	
}

-(void)timeOutEvent{
    
     NSLog(@"timeOutEvent");
    
    if (!firstTime) {
        return;
    }
   
    if ([_parentDelegate respondsToSelector:@selector(fsLoaddingImageViewWillDisappear:)]) {
		[_parentDelegate fsLoaddingImageViewWillDisappear:self];
	}
	
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
	
	animation.duration = 0.3;
	animation.delegate = self;
	animation.removedOnCompletion = NO;
	animation.fillMode = kCAFillModeForwards;
	animation.fromValue = [NSValue valueWithCGPoint:self.layer.position];
	animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.layer.position.x - self.layer.bounds.size.width, self.layer.position.y)];
	
	[self.layer addAnimation:animation forKey:FSLOADING_IMAGEVIEW_ANIMATION_KEY];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
	if (flag) {

		[self.layer removeAnimationForKey:FSLOADING_IMAGEVIEW_ANIMATION_KEY];
		
		[self removeFromSuperview];
		
		if ([_parentDelegate respondsToSelector:@selector(fsLoaddingImageViewDidDisappear:)]) {
			[_parentDelegate fsLoaddingImageViewDidDisappear:self];
		}

	}
}



@end
