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
#import "FSAsyncImageView.h"
#import "FS_GZF_ForLoadingImageDAO.h"
//#import "FS_GZF_Fo"
@class LygAdsDao;

@interface FSLoadingImageView : UIView<MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate,FSBaseDAODelegate,UIActionSheetDelegate>{
@protected
    id                         _parentDelegate;
    NSTimer                   *_timer;
    LygAdsDao                 *_fs_GZF_ForLoadingImageDAO;
    
    FSShareIconContainView    *_fsShareIconContainView;
//    FSAsyncImageView          *_adImageView;
    
    
    FS_GZF_ForLoadingImageDAO *_fs_GZF_ForLoadingImageDAO2;
    int                        _adsStatus;
    int                        _headPicStatus;
}

-(void)imageLoadingComplete;
- (id)initWithFrame:(CGRect)frame andISNeedAutoClose:(BOOL)isClose;
@property (nonatomic,assign) id parentDelegate;
@property (nonatomic,retain) FSAsyncImageView  *adImageView;
@property (nonatomic,retain) FSAsyncImageView  *adImageView2;
@property (nonatomic,assign) BOOL               isNeedAutoClose;
@property (nonatomic,assign) BOOL               isHaveSaved;

@end

@protocol FSLoadingImageViewDelegate
@optional
- (void)fsLoaddingImageViewWillDisappear:(FSLoadingImageView *)sender;
- (void)fsLoaddingImageViewDidDisappear: (FSLoadingImageView *)sender;
@end
