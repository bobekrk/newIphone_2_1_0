//
//  MyNewsLIstView.m
//  PeopleNewsReaderPhone
//
//  Created by ark on 13-8-14.
//
//

#import "MyNewsLIstView.h"
#import "FSNewsListTopCell.h"
#import "FSNewsListCell.h"
#import "FS_GZF_ForOnedayNewsFocusTopDAO.h"
#import "FS_GZF_ForNewsListDAO.h"
#import "FSChannelObject.h"
#import "FSOneDayNewsObject.h"
#import "FSFocusTopObject.h"
#import "FSNewsContainerViewController.h"
#import "FSWebViewForOpenURLViewController.h"
#import <UIKit/UITableView.h>
#import "LygAdsDao.h"
#import "LygAdsLoadingImageObject.h"
#import "FSNewsViewController.h"
@implementation MyNewsLIstView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _tvList.assistantViewFlag = FSTABLEVIEW_ASSISTANT_BOTTOM_BUTTON_VIEW | FSTABLEVIEW_ASSISTANT_TOP_VIEW;
        _tvList.delegate = self;
        _oldCount = 0;
    }
    return self;
}
-(id)initWithChanel:(FS_GZF_ChannelListDAO*)aDao currentIndex:(int)index parentViewController:(UIViewController*)aController
{
    if (self = [super init]) {
        _tvList.parentDelegate = self;
        _tvList.delegate     = self;
        _tvList.dataSource   = self;
        _oldCount            = 0;
        _isfirstShow         = YES;
        _tvList.assistantViewFlag = FSTABLEVIEW_ASSISTANT_BOTTOM_BUTTON_VIEW | FSTABLEVIEW_ASSISTANT_TOP_VIEW | FSTABLEVIEW_ASSISTANT_BOTTOM_VIEW;
        [self initDataModel];
        self.aChannelListDAO = aDao;
        self.aViewController = aController;
    }
    self.currentIndex        = index;
    self.currentNewsId       = @"";
    return self;
}
-(void)setCurrentIndex:(int)currentIndex
{
    NSLog(@"%d",[self.aChannelListDAO.objectList count]);
    if ([self.aChannelListDAO.objectList count]>0) {
        FSChannelObject *xxx                       = [self.aChannelListDAO.objectList objectAtIndex:currentIndex];
        _fs_GZF_ForOnedayNewsFocusTopDAO.channelid = xxx.channelid;
        _fs_GZF_ForNewsListDAO.channelid           = xxx.channelid;
        _fs_GZF_ForNewsListDAO.lastid              = nil;
        currentIndex == 0?(_fs_GZF_ForNewsListDAO.isImportNews = YES):(_fs_GZF_ForNewsListDAO.isImportNews = NO);
        currentIndex == 0?(_fs_GZF_ForOnedayNewsFocusTopDAO.isImportentNews = YES):(_fs_GZF_ForOnedayNewsFocusTopDAO.isImportentNews = NO);
        _isfirstShow                               = NO;
        _channelName                               = [xxx.channelname copy];
        NSLog(@"%@",xxx.channelid);
        int x = [[[xxx.channelid componentsSeparatedByString:@"_"] objectAtIndex:1] intValue];
        switch (x) {
            case 0:
            {
                _lygAdsDao.placeID = 14;
            }
                break;
            case 9:
            {
                _lygAdsDao.placeID = 17;
            }
                break;
            case 1:
            {
                _lygAdsDao.placeID = 20;
            }
                break;
            case 8:
            {
                _lygAdsDao.placeID = 23;
            }
                break;
            case 11:
            {
                _lygAdsDao.placeID = 26;
            }
                break;
            case 29:
            {
                _lygAdsDao.placeID = 29;
            }
                break;
            case 18:
            {
                _lygAdsDao.placeID = 76;
            }
                break;
            case 20:
            {
                _lygAdsDao.placeID = 32;
            }
                break;
            case 24:
            {
                _lygAdsDao.placeID = 35;
            }
                break;
            case 6:
            {
                _lygAdsDao.placeID = 38;
            }
                break;
            case 7:
            {
                _lygAdsDao.placeID = 41;
            }
                break;
            default:
                break;
        }
    }
//    _lygAdsDao.placeID = 44;
    //dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//    dispatch_queue_t queue = dispatch_get_main_queue();
//    dispatch_async(queue, ^{
//        [_fs_GZF_ForNewsListDAO HTTPGetDataWithKind:GET_DataKind_OnlyBuffer];
//        [_fs_GZF_ForOnedayNewsFocusTopDAO HTTPGetDataWithKind:GET_DataKind_OnlyBuffer];
//        [_lygAdsDao HTTPGetDataWithKind:GET_DataKind_OnlyBuffer];
//    });
}
-(void)refreshDataSource
{
    [super refreshDataSource];
    _refreshTimer = time(NULL);
}

-(void)initDataModel{
    NSLog(@"initDataModelinitDataModel");
    //[self refreshDataSource];
    _fs_GZF_ForOnedayNewsFocusTopDAO = [[FS_GZF_ForOnedayNewsFocusTopDAO alloc] init];
    _fs_GZF_ForOnedayNewsFocusTopDAO.group          = PUTONG_NEWS_LIST_KIND;
    _fs_GZF_ForOnedayNewsFocusTopDAO.type           = @"news";
    _fs_GZF_ForOnedayNewsFocusTopDAO.channelid      = @"";
    _fs_GZF_ForOnedayNewsFocusTopDAO.count          = 3;
    _fs_GZF_ForOnedayNewsFocusTopDAO.parentDelegate = self;
    _fs_GZF_ForOnedayNewsFocusTopDAO.isGettingList  = YES;
    
    
    
    _fs_GZF_ForNewsListDAO                          = [[FS_GZF_ForNewsListDAO alloc] init];
    _fs_GZF_ForNewsListDAO.parentDelegate           = self;
    _fs_GZF_ForNewsListDAO.isGettingList            = YES;
    
    _lygAdsDao                                      = [[LygAdsDao alloc]init];
    _lygAdsDao.parentDelegate                       = self;
    _lygAdsDao.isGettingList                        = NO;
    _refreshTimer                                   = 0;
}
-(BOOL)isNeedRefresh
{
    time_t timeInterver = time(NULL) - _refreshTimer;
    if (timeInterver > 60 * 30) {
        return YES;
    }else
    {
        return NO;
    }
    
}

- (NSString *)indicatorMessageTextWithDAO:(FSBaseDAO *)sender withStatus:(FSBaseDAOCallBackStatus)status {
	NSString *rst = @"";
    NSLog(@"%d",status);
	switch (status) {
		case FSBaseDAOCallBack_WorkingStatus:
			rst = NSLocalizedString(@"DAOCallBack_Working", @"正在努力加载...");
			break;
		case FSBaseDAOCallBack_BufferWorkingStatus:
			//do nothing
			break;
		case FSBaseDAOCallBack_SuccessfulStatus:
			//rst = NSLocalizedString(@"DAOCallBack_Working", @"正在连接远程服务器...");
			break;
		case FSBaseDAOCallBack_BufferSuccessfulStatus:
			[FSIndicatorMessageView dismissIndicatorMessageViewInView:self];
			break;
		case FSBaseDAOCallBack_HostErrorStatus:
			rst = NSLocalizedString(@"DAOCallBack_HostError", @"休息一下，稍后再试");
			break;
		case FSBaseDAOCallBack_NetworkErrorStatus:
			rst = NSLocalizedString(@"DAOCallBack_NetworkError", @"网络不给力，再试一下哦");
			break;
		case FSBaseDAOCallBack_NetworkErrorAndNoBufferStatus:
			rst = NSLocalizedString(@"DAOCallBack_NetworkErrorAndNoBuffer", @"网络不给力，再试一下哦");
			break;
		case FSBaseDAOCallBack_NetworkErrorAndDataIsTailStatus:
			rst = NSLocalizedString(@"DAOCallBack_NetworkErrorAndDataIsTailStatus", @"网络不给力，再试一下哦");
			break;
		case FSBaseDAOCallBack_DataFormatErrorStatus:
			rst = NSLocalizedString(@"DAOCallBack_DataFormatError", @"网络不给力，再试一下哦");
			break;
		case FSBaseDAOCallBack_URLErrorStatus:
			rst = NSLocalizedString(@"DAOCallBack_URLError", @"休息一下，稍后再试");
			break;
		case FSBaseDAOCallBack_UnknowErrorStatus:
			rst = NSLocalizedString(@"DAOCallBack_UnknowError", @"休息一下，稍后再试");
			break;
		case FSBaseDAOCallBack_POSTDataZeroErrorStatus:
			rst = NSLocalizedString(@"DAOCallBack_POSTDataZeroError", @"提交数据不存在哦");
			break;
		default:
			break;
	}
	return rst;
}

-(void)dataAccessObjectSyncEnd:(FSBaseDAO *)sender
{
    NSLog(@"--------------------");
}
- (void)dataAccessObjectSync:(FSBaseDAO *)sender withStatus:(FSBaseDAOCallBackStatus)status{
    

	if (status == FSBaseDAOCallBack_WorkingStatus) {
		if (1) {
			FSIndicatorMessageView *indicatorMessageView = [[FSIndicatorMessageView alloc] initWithFrame:CGRectZero];
			[indicatorMessageView showIndicatorMessageViewInView:self withMessage:[self indicatorMessageTextWithDAO:sender withStatus:status]];
			[indicatorMessageView release];
		}
	} else {
		[FSIndicatorMessageView dismissIndicatorMessageViewInView:self];
		
		switch (status) {
			case FSBaseDAOCallBack_HostErrorStatus:
				
			case FSBaseDAOCallBack_NetworkErrorStatus:
                
			case FSBaseDAOCallBack_NetworkErrorAndNoBufferStatus:
                
			case FSBaseDAOCallBack_NetworkErrorAndDataIsTailStatus:
                
			case FSBaseDAOCallBack_DataFormatErrorStatus:
                
			case FSBaseDAOCallBack_URLErrorStatus:
                
			case FSBaseDAOCallBack_UnknowErrorStatus:
                
			case FSBaseDAOCallBack_POSTDataZeroErrorStatus:{
				FSInformationMessageView *informationMessageView = [[FSInformationMessageView alloc] initWithFrame:CGRectZero];
				informationMessageView.parentDelegate = self.parentDelegate;
				[informationMessageView showInformationMessageViewInView:self
															 withMessage:[self indicatorMessageTextWithDAO:sender withStatus:status]
														withDelaySeconds:0.2
														withPositionKind:PositionKind_Vertical_Horizontal_Center
															  withOffset:0.0f];
				[informationMessageView release];
				break;
			}
			default:
				break;
		}
		if (status == FSBaseDAOCallBack_HostErrorStatus) {
			
		}
	}
    
	[self doSomethingWithDAO:sender withStatus:status];
    
    
}




-(UITableViewStyle)initializeTableViewStyle{
    return UITableViewStylePlain;
}

-(void)reSetAssistantViewFlag:(NSInteger)arrayCount{
    if (_oldCount==arrayCount && arrayCount!=0) {
        _tvList.assistantViewFlag = FSTABLEVIEW_ASSISTANT_TOP_VIEW;
    }
    else{
        _tvList.assistantViewFlag = FSTABLEVIEW_ASSISTANT_BOTTOM_BUTTON_VIEW | FSTABLEVIEW_ASSISTANT_TOP_VIEW | FSTABLEVIEW_ASSISTANT_BOTTOM_VIEW;
        _oldCount=arrayCount;
    }
}

-(NSString *)cellIdentifierStringWithIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath row] == 0) {
        return @"RoutineNewsListTopCell";
    }
    return @"RoutineNewsListCell";
}

-(Class)cellClassWithIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row]==0){
        return [FSNewsListTopCell class];
    }
    return [FSNewsListCell class];
}

-(void)initializeCell:(UITableViewCell *)cell withData:(NSObject *)data withIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"initializeCellinitializeCell");
}



-(void)layoutSubviews{
    _tvList.frame = roundToRect(CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height));
	
	if (!CGSizeEqualToSize(_tvSize, _tvList.frame.size)) {
		_tvSize = _tvList.frame.size;
		//防止不重新装载数据
		//[_tvList reloadData];
	}
    //_tvList.separatorStyle = YES;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath row] == 0) {
        return ROUTINE_NEWS_LIST_TOP_HEIGHT;
    }
    else{
        _tvList.separatorStyle = YES;
        
        CGFloat height = [[self cellClassWithIndexPath:indexPath]
                          computCellHeight:[self cellDataObjectWithIndexPath:indexPath]
                          cellWidth:tableView.frame.size.width];
        
        return height;
        
        return ROUTINE_NEWS_LIST_HEIGHT;
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//	[_tvList bottomScrollViewDidScroll:scrollView];
//    
//}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//	[_tvList bottomScrollViewDidEndDragging:scrollView willDecelerate:decelerate];
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[_tvList bottomScrollViewDidScroll:scrollView];
    
    if (!_tvList.isRefreshing) {
        return;
    }
    
    CGFloat sectionHeaderHeight;
    if (scrollView.contentOffset.y<=0) {
        sectionHeaderHeight= 0;
    }
    else{
        sectionHeaderHeight= 37;
        
    }
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        if (_tvList.isRefreshing) {
            scrollView.contentInset = UIEdgeInsetsMake(64.0f, 0, 0, 0);
        }
        else{
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
        
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[_tvList bottomScrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}
-(void)dealloc{
    
    [super dealloc];
}

-(void)doSomethingWithDAO:(FSBaseDAO *)sender withStatus:(FSBaseDAOCallBackStatus)status{
    NSLog(@"doSomethingWithDAO：%@ :%d",sender,status);
    NSLog(@"   ----------- %d",[NSThread currentThread] == [NSThread mainThread]);
        
    if ([sender isEqual:_fs_GZF_ForOnedayNewsFocusTopDAO]) {
        if (status == FSBaseDAOCallBack_SuccessfulStatus || status == FSBaseDAOCallBack_BufferSuccessfulStatus) {
            NSLog(@"FSNewsViewController:%d",[_fs_GZF_ForOnedayNewsFocusTopDAO.objectList count]);
            //[self loadDataWithOutCompelet];
            [self loadDataWithOutCompelet];
            if (status == FSBaseDAOCallBack_SuccessfulStatus) {
                [self loaddingComplete];
                [_fs_GZF_ForOnedayNewsFocusTopDAO operateOldBufferData];

            }
        }else if(status ==FSBaseDAOCallBack_NetworkErrorStatus){
            
            //[_fs_GZF_ForNewsListDAO HTTPGetDataWithKind:GET_DataKind_Refresh];
            [self loaddingComplete];
        }
        else if(status ==FSBaseDAOCallBack_ListWorkingStatus){
            
        }else
        {
            [self loaddingComplete];
        }
        return;
    }
    if ([sender isEqual:_fs_GZF_ForNewsListDAO]) {
        if (status == FSBaseDAOCallBack_SuccessfulStatus || status == FSBaseDAOCallBack_BufferSuccessfulStatus) {
            NSLog(@"_fs_GZF_ForNewsListDAO:%d",[_fs_GZF_ForNewsListDAO.objectList count]);
            if (status == FSBaseDAOCallBack_SuccessfulStatus) {
                [self reSetAssistantViewFlag:[_fs_GZF_ForNewsListDAO.objectList count]];
                [self loadData];
                [_fs_GZF_ForNewsListDAO operateOldBufferData];
            }else{
                //[self loadData];
                [self loadDataWithOutCompelet];
            }
        }
        else if(status ==FSBaseDAOCallBack_ListWorkingStatus){
            //[_routineNewsListContentView refreshDataSource];
        }else if(status == FSBaseDAOCallBack_NetworkErrorStatus || status == FSBaseDAOCallBack_HostErrorStatus){
            [self loaddingComplete];
        }else
        {
            [self loaddingComplete];
        }
        return;
    }
    if ([sender isEqual:_lygAdsDao]) {
        if (status == FSBaseDAOCallBack_SuccessfulStatus || status == FSBaseDAOCallBack_BufferSuccessfulStatus) {
            NSLog(@"FSNewsViewController:%d",[_lygAdsDao.objectList count]);
            [self loadDataWithOutCompelet];
            if (status == FSBaseDAOCallBack_SuccessfulStatus) {
                [self loaddingComplete];
                [_lygAdsDao operateOldBufferData];
                
            }
        }else if(status ==FSBaseDAOCallBack_NetworkErrorStatus){
            
            //[_fs_GZF_ForNewsListDAO HTTPGetDataWithKind:GET_DataKind_Refresh];
            [self loaddingComplete];
        }
        else if(status ==FSBaseDAOCallBack_ListWorkingStatus){
            
        }else
        {
            [self loaddingComplete];
        }
        return;
    }

    

    [self loadDataWithOutCompelet];
    [self loaddingComplete];
}
-(NSString *)tableViewDataSourceUpdateMessage:(FSTableContainerView *)sender{
    NSString *REdatetime = timeIntervalStringSinceNow(_reFreshDate);
    
    return REdatetime;
}
-(void)tableViewDataSource:(FSTableContainerView *)sender withTableDataSource:(TableDataSource)dataSource{
    if (dataSource == tdsRefreshFirst) {
        FSLog(@"FSNewsViewController  tdsRefreshFirst");
        //[_routineNewsListContentView refreshDataSource];
        self.reFreshDate = [[[NSDate alloc] initWithTimeIntervalSinceNow:0] autorelease];
        [self reSetAssistantViewFlag:0];
        

        if ([_fs_GZF_ForNewsListDAO.channelid isEqualToString:@"1_0"]) {
            _fs_GZF_ForNewsListDAO.getNextOnline = NO;
        }
        else{
            _fs_GZF_ForNewsListDAO.getNextOnline = YES;
        }
        _fs_GZF_ForOnedayNewsFocusTopDAO.objectList = nil;
        [_fs_GZF_ForOnedayNewsFocusTopDAO HTTPGetDataWithKind:GET_DataKind_ForceRefresh];
        
        [_fs_GZF_ForNewsListDAO HTTPGetDataWithKind:GET_DataKind_ForceRefresh];
        _lygAdsDao.objectList = nil;
        [_lygAdsDao HTTPGetDataWithKind:GET_DataKind_ForceRefresh];
        
    }
    if (dataSource == tdsNextSection) {
        FSOneDayNewsObject *o = [_fs_GZF_ForNewsListDAO.objectList lastObject];
        _fs_GZF_ForNewsListDAO.lastid = o.newsid;
        
        
        if ([_fs_GZF_ForNewsListDAO.channelid isEqualToString:@"1_0"]) {
            _fs_GZF_ForNewsListDAO.getNextOnline = YES;
        }
        else{
            _fs_GZF_ForNewsListDAO.getNextOnline = YES;
        }
        
        [_fs_GZF_ForNewsListDAO HTTPGetDataWithKind:GET_DataKind_Next];
    }
}
-(void)tableViewTouchPicture:(FSTableContainerView *)sender index:(NSInteger)index{
    //NSLog(@"channel did selected!%d",index);
    if (_lygAdsDao.objectList.count > 0 && index == 1) {
        LygAdsLoadingImageObject *o = [_lygAdsDao.objectList objectAtIndex:0];
        NSLog(@"%@",o.adLink);
        int flag = [o.adLinkFlag intValue];
        if (flag == 1) {
            //                FSNewsContainerViewController *fsNewsContainerViewController = [[FSNewsContainerViewController alloc] init];
            //                fsNewsContainerViewController.FCObj = o;
            //                fsNewsContainerViewController.newsSourceKind = NewsSourceKind_ShiKeNews;
            //
            //                [self.navigationController pushViewController:fsNewsContainerViewController animated:YES];
            //                //[self.fsSlideViewController pres:fsNewsContainerViewController animated:YES];
            //
            //                [fsNewsContainerViewController release];
            //                [[FSBaseDB sharedFSBaseDB] updata_visit_message:o.channelid];
        }
        else if (flag == 3){
            NSString * string =[NSString stringWithFormat:@"%@",o.adLink];
            NSURL *url = [[NSURL alloc] initWithString:string];
            [[UIApplication sharedApplication] openURL:url];
            [url release];
        }
        else if (flag == 2){//内嵌浏览器
            FSWebViewForOpenURLViewController *fsWebViewForOpenURLViewController = [[FSWebViewForOpenURLViewController alloc] init];
            fsWebViewForOpenURLViewController.withOutToolbar                     = NO;
            fsWebViewForOpenURLViewController.urlString = o.adLink;
            [self.parentNavigationController pushViewController:fsWebViewForOpenURLViewController animated:YES];
        }
    }else
    {
        if (_lygAdsDao.objectList.count > 0) {
            if (index > 1) {
                index -= 1;
            }
        }
        NSLog(@"%@",_channelName);
        FSFocusTopObject *o = [_fs_GZF_ForOnedayNewsFocusTopDAO.objectList objectAtIndex:index];
        [PeopleNewsStati  headPicEvent:o.newsid nameOfEVent:_channelName andTitle:o.title];
        if ([o.flag isEqualToString:@"1"]) {
            FSNewsContainerViewController *fsNewsContainerViewController = [[FSNewsContainerViewController alloc] init];
            
            fsNewsContainerViewController.obj = nil;
            fsNewsContainerViewController.FCObj = o;
            fsNewsContainerViewController.newsSourceKind = NewsSourceKind_PuTongNews;
            
            [self.parentNavigationController pushViewController:fsNewsContainerViewController animated:YES];
            //[self.fsSlideViewController pres:fsNewsContainerViewController animated:YES];
            [fsNewsContainerViewController release];
            [[FSBaseDB sharedFSBaseDB] updata_visit_message:o.channelid];
        }
        else if ([o.flag isEqualToString:@"2"]){//内嵌浏览器
            
            NSURL *url = [[NSURL alloc] initWithString:o.link];
            [[UIApplication sharedApplication] openURL:url];
            [url release];
            
        }
        else if ([o.flag isEqualToString:@"3"]){
            
            FSWebViewForOpenURLViewController *fsWebViewForOpenURLViewController = [[FSWebViewForOpenURLViewController alloc] init];
            
            fsWebViewForOpenURLViewController.urlString = o.link;
            fsWebViewForOpenURLViewController.withOutToolbar = NO;
            [self.parentNavigationController pushViewController:fsWebViewForOpenURLViewController animated:YES];
            [fsWebViewForOpenURLViewController release];
        }

    }
    
}
-(void)newsSlecterStati:(FSOneDayNewsObject*)oo
{
    [PeopleNewsStati newsEvent:oo.newsid nameOfEVent:_channelName andTitle:oo.title];
}
-(void)tableViewDataSourceDidSelected:(FSTableContainerView *)sender withIndexPath:(NSIndexPath *)indexPath{
     @synchronized(self)
    {
        NSInteger row = [indexPath row];
        
        if ([_fs_GZF_ForOnedayNewsFocusTopDAO.objectList count]>0) {
            if (row== 0) {
                return;
            }
            FSNewsListCell * cell             = (FSNewsListCell*)[sender.tvList cellForRowAtIndexPath:indexPath];
            cell.leftView.backgroundColor     = [UIColor redColor];
            FSOneDayNewsObject *o = [_fs_GZF_ForNewsListDAO.objectList objectAtIndex:row-1];
            NSLog(@"%@",o);
            //[self newsSlecterStati:o];
            [self performSelectorInBackground:@selector(newsSlecterStati:) withObject:o];
            int i = 0;
            for (FSOneDayNewsObject * obj in _fs_GZF_ForNewsListDAO.objectList) {
                if ([obj.newsid isEqualToString:self.currentNewsId] && ![o.newsid isEqualToString:self.currentNewsId]) {
                    FSNewsListCell * cell = (FSNewsListCell*)[sender.tvList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i+1 inSection:0]];
                    cell.leftView.backgroundColor = [UIColor lightGrayColor];
                    break;
                }
                i++;
            }
            
            _currentObject        = o;
            FSNewsContainerViewController *fsNewsContainerViewController = [[FSNewsContainerViewController alloc] init];
            
            fsNewsContainerViewController.obj                            = [_fs_GZF_ForNewsListDAO.objectList objectAtIndex:row-1];
            __block FSOneDayNewsObject * xxx                             = [_fs_GZF_ForNewsListDAO.objectList objectAtIndex:row-1];
            fsNewsContainerViewController.FCObj                          = nil;
            fsNewsContainerViewController.newsSourceKind                 = NewsSourceKind_PuTongNews;
            fsNewsContainerViewController.isImportant                    = _fs_GZF_ForNewsListDAO.isImportNews;
            self.currentNewsId                                           = o.newsid;
            __block FSNewsListCell * blockCell = (FSNewsListCell*)[sender.tvList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
            FSNewsViewController * tempViewController = (FSNewsViewController*)self.aViewController;
            tempViewController.fpChangeTitleColor              = ^()
            {
                if (![xxx.isReaded isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                    return;
                }
                blockCell.lab_NewsTitle.textColor  = [UIColor lightGrayColor];
            };
            //[[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithInt:1] forKey:o.newsid];
            [self.parentNavigationController pushViewController:fsNewsContainerViewController animated:YES];
            [fsNewsContainerViewController release];
            [[FSBaseDB sharedFSBaseDB] updata_visit_message:o.channelid];
            //[[NSUserDefaults standardUserDefaults] synchronize];
        }
        else{
            FSOneDayNewsObject *o                                        = [_fs_GZF_ForNewsListDAO.objectList objectAtIndex:row-1];
            
            FSNewsContainerViewController *fsNewsContainerViewController = [[FSNewsContainerViewController alloc] init];
            fsNewsContainerViewController.obj                            = o;
            fsNewsContainerViewController.FCObj                          = nil;
            fsNewsContainerViewController.newsSourceKind                 = NewsSourceKind_PuTongNews;
            [UIView commitAnimations];
            [self.parentNavigationController pushViewController:fsNewsContainerViewController animated:YES];
            [fsNewsContainerViewController release];
            [[FSBaseDB sharedFSBaseDB] updata_visit_message:o.channelid];
        }

    }
    
    //[_fs_GZF_ForNewsListDAO.managedObjectContext save:nil];
    //[FSBaseDB saveDB];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSString *cellIdentifierString = [self cellIdentifierStringWithIndexPath:indexPath];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierString];
    
    //cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CellBackground"]];
    
	if (cell == nil) {
		cell = (UITableViewCell *)[[[self cellClassWithIndexPath:indexPath] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierString];
	}
	
	if ([cell isKindOfClass:[FSTableViewCell class]]) {
        
		FSTableViewCell *fsCell = (FSTableViewCell *)cell;
		[fsCell setParentDelegate:self];
		[fsCell setRowIndex:[indexPath row]];
		[fsCell setSectionIndex:[indexPath section]];
		[fsCell setCellShouldWidth:tableView.frame.size.width];
		[fsCell setData:[self cellDataObjectWithIndexPath:indexPath]];
        [fsCell setSelectionStyle:[self cellSelectionStyl:indexPath]];
        [fsCell doSomethingAtLayoutSubviews];
	} else {
		[self initializeCell:cell withData:[self cellDataObjectWithIndexPath:indexPath] withIndexPath:indexPath];
	} 
    if (indexPath.row > 0 ) {
        FSNewsListCell     * xxcell          = (FSNewsListCell *)cell;
        FSOneDayNewsObject * object          = [_fs_GZF_ForNewsListDAO.objectList objectAtIndex:indexPath.row -1];
        xxcell.leftView.backgroundColor      = ([object.newsid isEqualToString:self.currentNewsId]?[UIColor redColor]:[UIColor lightGrayColor]);
        NSNumber * num = [[NSUserDefaults standardUserDefaults]valueForKey:object.newsid];
        xxcell.lab_NewsTitle.textColor       = (num?[UIColor lightGrayColor]:[UIColor blackColor]);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsDisplay];
    return cell;
}
-(NSObject *)tableViewCellData:(FSTableContainerView *)sender withIndexPath:(NSIndexPath *)indexPath{
	NSInteger row = [indexPath row];
    
    if ([_fs_GZF_ForOnedayNewsFocusTopDAO.objectList count]>0) {
        if (row==0) {
            NSMutableArray *  xxx = [[NSMutableArray alloc] init];
            [xxx addObject:[_fs_GZF_ForOnedayNewsFocusTopDAO.objectList objectAtIndex:0]];
            if (_lygAdsDao.objectList.count > 0) {
                [xxx addObject:[_lygAdsDao.objectList objectAtIndex:0]];
            }
            for (int i = 1; i< _fs_GZF_ForOnedayNewsFocusTopDAO.objectList.count; i++) {
                [xxx addObject:[_fs_GZF_ForOnedayNewsFocusTopDAO.objectList objectAtIndex:i]];
            }
            return [xxx autorelease];
            return _fs_GZF_ForOnedayNewsFocusTopDAO.objectList;
        }
        else{
            if (row <= [_fs_GZF_ForNewsListDAO.objectList count]) {
                // FSOneDayNewsObject *o = [_fs_GZF_ForNewsListDAO.objectList objectAtIndex:row-1];
                //NSLog(@"FSOneDayNewsObject:%d  :%@",row,o.title);
                //NSLog(@"%@",sender.tvList.class);
//                FSNewsListCell * cell = (FSNewsListCell *)[sender.tvList cellForRowAtIndexPath:indexPath];
//                if (_currentIndex == indexPath.row) {
//                    cell.leftView.backgroundColor = [UIColor redColor];
//                }else
//                {
//                     cell.leftView.backgroundColor = [UIColor lightGrayColor];
//                }
                return [_fs_GZF_ForNewsListDAO.objectList objectAtIndex:row-1];
            }
            
        }
    }
    else{
        if (row==0) {
            return _fs_GZF_ForOnedayNewsFocusTopDAO.objectList;
        }
        else{
            if (row <= [_fs_GZF_ForNewsListDAO.objectList count]) {
                return [_fs_GZF_ForNewsListDAO.objectList objectAtIndex:row-1];
            }
            
        }
    }
    
    return nil;
    
}

#pragma mark -
#pragma FSTableContainerViewDelegate mark

-(void)doSomethingForViewFirstTimeShow{
    
    NSLog(@"doSomethingForViewFirstTimeShowdoSomethingForViewFirstTimeShow");
    
    self.reFreshDate = [[[NSDate alloc] initWithTimeIntervalSinceNow:0] autorelease];
    
    //[_fs_GZF_ChannelListDAO HTTPGetDataWithKind:GET_DataKind_Refresh];
    //[self addKindsScrollView];
}
-(NSInteger)tableViewSectionNumber:(FSTableContainerView *)sender{
    return 1;
}

-(NSInteger)tableViewNumberInSection:(FSTableContainerView *)sender section:(NSInteger)section{
    if ([_fs_GZF_ForOnedayNewsFocusTopDAO.objectList count]>0) {
        return [_fs_GZF_ForNewsListDAO.objectList count]+1;
    }
    else{
        return [_fs_GZF_ForNewsListDAO.objectList count];
    }
    return 0;
}
@end
