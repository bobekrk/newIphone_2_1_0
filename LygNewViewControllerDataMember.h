//
//  LygNewViewControllerDataMember.h
//  PeopleNewsReaderPhone
//
//  Created by lygn128 on 13-9-3.
//
//

#import <Foundation/Foundation.h>
#import "FS_GZF_ForOnedayNewsFocusTopDAO.h"
#import "FS_GZF_ForOneDayNewsListDAO.h"
#import "FS_GZF_ForNewsListDAO.h"
#import "LygAdsDao.h"
@interface LygNewViewControllerDataMember : NSObject
{
    
}
@property(nonatomic,retain) FS_GZF_ForOnedayNewsFocusTopDAO *fs_GZF_ForOnedayNewsFocusTopDAO;
@property(nonatomic,retain) LygAdsDao                       *lygAdsDao;
@property(nonatomic,retain) FS_GZF_ForNewsListDAO           *fs_GZF_ForNewsListDAO;
@end
