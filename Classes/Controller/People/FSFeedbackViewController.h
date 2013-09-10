//
//  FSFeedbackViewController.h
//  PeopleNewsReaderPhone
//
//  Created by yuan lei on 12-8-31.
//  Copyright (c) 2012年 people. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSBaseDataViewController.h"
#import "FSFeedbackContainerView.h"
#import "FSBaseSettingViewController.h"

@class FS_GZF_FeedbackPOSTXMLDAO;

@interface FSFeedbackViewController : FSBaseSettingViewController<FSBaseContainerViewDelegate>{
@protected
    //UINavigationBar *_navTopBar;
    FSFeedbackContainerView *_fsFeedbackContainerView;
    FS_GZF_FeedbackPOSTXMLDAO *_fs_GZF_FeedbackPOSTXMLDAO;
}

@end
