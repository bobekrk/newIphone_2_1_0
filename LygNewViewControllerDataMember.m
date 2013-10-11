//
//  LygNewViewControllerDataMember.m
//  PeopleNewsReaderPhone
//
//  Created by lygn128 on 13-9-3.
//
//

#import "LygNewViewControllerDataMember.h"

@implementation LygNewViewControllerDataMember
-(id)init
{
    if (self = [super init]) {
        self.fs_GZF_ForNewsListDAO = [[[FS_GZF_ForNewsListDAO alloc]init] autorelease];
        self.lygAdsDao             = [[LygAdsDao alloc] init];
        _fs_GZF_ForOnedayNewsFocusTopDAO  = [[FS_GZF_ForOnedayNewsFocusTopDAO alloc]init];
        
    }
    return self;
}
-(void)dealloc
{
    [super dealloc];
}


//@property(nonatomic,retain) FS_GZF_ForOnedayNewsFocusTopDAO *_fs_GZF_ForOnedayNewsFocusTopDAO;
//@property(nonatomic,retain) LygAdsDao                       *_lygAdsDao;
//@property(nonatomic,retain) FS_GZF_ForNewsListDAO           *_fs_GZF_ForNewsListDAO;
@end
