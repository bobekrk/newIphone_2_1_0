//
//  FSSettingViewController.h
//  PeopleNewsReaderPhone
//
//  Created by people.com.cn on 12-8-13.
//  Copyright 2012 people.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSBaseDataViewController.h"
#import "FSSettingView.h"
#import "FS_GZF_GetNewsDataForOFFlineDAO.h"
#import "FSWeatherView.h"
#import "FSNewSettingView.h"
#import "FS_GZF_GetWeatherMessageDAO.h"
@class FS_GZF_AppUpdateDAO;

@interface FSSettingViewController : FSBaseDataViewController <FSGETForOFFlineDAODelegate,UIGestureRecognizerDelegate,FSNewSettingViewDelegate> {
@private
    FSNewSettingView *_settingView;
    
	UINavigationBar *_navTopBar;
    FS_GZF_GetNewsDataForOFFlineDAO *_fs_GZF_GetNewsDataForOFFlineDAO;
    FS_GZF_AppUpdateDAO             *fsAppUpdateDAO;
    FS_GZF_GetWeatherMessageDAO     * _myMessageDao;
}


@end
