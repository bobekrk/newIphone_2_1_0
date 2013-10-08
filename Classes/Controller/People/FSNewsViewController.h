//
//  FSNewsViewController.h
//  PeopleNewsReaderPhone
//
//  Created by people.com.cn on 12-8-13.
//  Copyright 2012 people.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSBasePeopleViewController.h"
#import "FSTitleView.h"
#import "FSRoutineNewsListContentView.h"
#import "FS_GZF_GetWeatherMessageDAO.h"
@class FS_GZF_ForOnedayNewsFocusTopDAO,FS_GZF_ForNewsListDAO,FSUserSelectObject,FS_GZF_ChannelListDAO;

@interface FSNewsViewController : FSBasePeopleViewController <FSTableContainerViewDelegate,UIScrollViewDelegate, UIGestureRecognizerDelegate>{
@protected
    FSTitleView                        *_titleView;
    FS_GZF_ChannelListDAO              *_fs_GZF_ChannelListDAO;
    NSDate                             *_reFreshDate;
    UIScrollView                       *_myScroview;
    BOOL                                _isfirstShow;
    int                                 _currentIndex;
    
}
@property(nonatomic,retain)UIImageView * topRedImageView;
@property(nonatomic,copy)void (^fpChangeTitleColor)(void);
//@property(nonatomic,retain) FS_GZF_GetWeatherMessageDAO       *fs_GZF_GetWeatherMessageDAO;
-(FSUserSelectObject *)getUserChannelSelectedObject;

-(BOOL)channleISexp:(FSUserSelectObject *)obj;


@end
