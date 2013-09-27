//
//  LygDeepListView.h
//  PeopleNewsReaderPhone
//
//  Created by lygn128 on 13-8-27.
//
//
#import "FSTableContainerView.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FSTableContainerView.h"
#import "FS_GZF_ChannelListDAO.h"
#import "FSNewsListCell.h"
#import "FSOneDayNewsObject.h"
#import "FS_GZF_DeepListDAO.h"
#define DEEPABSTRACTFONTSIZE 15.0f
@class FS_GZF_ForOnedayNewsFocusTopDAO,FS_GZF_ForNewsListDAO,FSUserSelectObject,FS_GZF_ChannelListDAO;
@interface LygDeepListView : FSTableContainerView<FSTableContainerViewDelegate,UIScrollViewDelegate, UIGestureRecognizerDelegate,FSBaseDAODelegate,UITableViewDataSource,UITableViewDelegate>
{
}
@property(nonatomic,assign)id                   delegte;
@property(nonatomic,assign)FS_GZF_DeepListDAO * myDeepListDao;
@property(nonatomic,retain)NSDate             * reFreshDate;
@property(nonatomic,assign)BOOL                 isfirstShow;
@property(nonatomic,assign)int                  currentCount;
-(id)initWithDeepListDao:(FS_GZF_DeepListDAO*)aDao initDelegate:(id)aDeleagte;
-(void)reloadData;
@end
@protocol LygDeepListViewDelegate <NSObject>

-(void)LygDeepListViewCellTouched:(int)index;

@end
