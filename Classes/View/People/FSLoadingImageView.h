//
//  FSLoadingImageView.h
//  PeopleNewsReaderPhone
//
//  Created by yuan lei on 12-8-4.
//  Copyright (c) 2012年 people. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSShareIconContainView.h"
#import <MessageUI/MessageUI.h>
#import "LygAdsDao.h"
@class LygAdsDao;

@interface FSLoadingImageView : UIView<MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate>{
@protected
    id                         _parentDelegate;
    NSTimer                   *_timer;
    BOOL                       firstTime;
    LygAdsDao                 *_fs_GZF_ForLoadingImageDAO;
    
    BOOL                       _switch;
    FSShareIconContainView    *_fsShareIconContainView;
}

-(void)imageLoadingComplete;

@property (nonatomic,assign) id parentDelegate;


@end

@protocol FSLoadingImageViewDelegate
@optional
- (void)fsLoaddingImageViewWillDisappear:(FSLoadingImageView *)sender;
- (void)fsLoaddingImageViewDidDisappear: (FSLoadingImageView *)sender;
@end
