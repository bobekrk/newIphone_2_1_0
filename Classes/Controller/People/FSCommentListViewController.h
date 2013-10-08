//
//  FSCommentListViewController.h
//  PeopleNewsReaderPhone
//
//  Created by ganzf on 12-11-30.
//
//

#import <UIKit/UIKit.h>
#import "FSBasePeopleViewController.h"
#import "FSNewsContainerCommentListView.h"
#import "FSBaseSettingViewController.h"
#import "FSNewsCommentListView.h"


@class FS_GZF_CommentListDAO;

@interface FSCommentListViewController : FSBaseSettingViewController <UIGestureRecognizerDelegate,FSBaseContainerViewDelegate>{
@protected
    //FSNewsContainerCommentListView *_fsNewsContainerCommentListView;
    FS_GZF_CommentListDAO *_fs_GZF_CommentListDAO;
    
    //UINavigationBar *_navTopBar;
    
    NSString *_newsid;
    
    BOOL _withnavTopBar;
    
    FSNewsCommentListView *_fsNewsCommentListView;
}

@property (nonatomic,retain) NSString *newsid;
@property (nonatomic,assign) BOOL withnavTopBar;

@end
