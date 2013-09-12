//
//  MyNewsLIstView.h
//  PeopleNewsReaderPhone
//
//  Created by ark on 13-8-14.
//
//

#import <Foundation/Foundation.h>
#import "FSTableContainerView.h"
#import "FS_GZF_ChannelListDAO.h"
#import "FSNewsListCell.h"
#import "FSOneDayNewsObject.h"
#import "LygAdsDao.h"
@class FS_GZF_ForOnedayNewsFocusTopDAO,FS_GZF_ForNewsListDAO,FSUserSelectObject,FS_GZF_ChannelListDAO;
@interface MyNewsLIstView : FSTableContainerView<FSTableContainerViewDelegate,UIScrollViewDelegate, UIGestureRecognizerDelegate,FSBaseDAODelegate>
{
    FS_GZF_ForOnedayNewsFocusTopDAO *_fs_GZF_ForOnedayNewsFocusTopDAO;
    LygAdsDao                       *_lygAdsDao;
    FS_GZF_ForNewsListDAO           *_fs_GZF_ForNewsListDAO;
    NSDate                          *_reFreshDate;
    UIScrollView                    * _myScroview;
    BOOL                             _isfirstShow;
    int                              _currentIndex;
    FSOneDayNewsObject              *_currentObject;
    NSString                        *_channelName;
    time_t                           _refreshTimer;
}
@property(nonatomic,assign)UINavigationController * parentNavigationController;
@property(nonatomic,assign)BOOL                     isHaveLoad;
-(id)initWithChanel:(FS_GZF_ChannelListDAO*)aDao currentIndex:(int)index parentViewController:(UIViewController*)aController;
-(BOOL)isNeedRefresh;
@property(nonatomic,assign)int currentIndex;
@property(nonatomic,retain)FS_GZF_ChannelListDAO              *aChannelListDAO;
@property(nonatomic,assign)UIViewController                   *aViewController;
@property(nonatomic,retain)NSDate                             *reFreshDate;
@property(nonatomic,copy)  NSString                           *currentNewsId;
@end
