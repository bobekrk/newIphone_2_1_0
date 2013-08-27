//
//  LygDeepListView.m
//  PeopleNewsReaderPhone
//
//  Created by lygn128 on 13-8-27.
//
//

#import "LygDeepListView.h"
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
#import "LygDeepTableViewCell.h"
@implementation LygDeepListView
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

-(id)initWithDeepListDao:(FS_GZF_DeepListDAO*)aDao initDelegate:(id)aDeleagte
{
    if (self = [super init]) {
        _tvList.parentDelegate = self;
        _tvList.delegate     = self;
        _tvList.dataSource   = self;
        _oldCount            = 0;
        _isfirstShow         = YES;
       // [self initDataModel];
       // self.myDeepListDao   = aDao;
        _myDeepListDao = [[FS_GZF_DeepListDAO alloc]init];
        _myDeepListDao.parentDelegate = self;
        self.delegte         = aDeleagte;
        [_myDeepListDao HTTPGetDataWithKind:GET_DataKind_ForceRefresh];
    }
    //self.currentIndex        = index;
    return self;

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
- (void)dataAccessObjectSync:(FSBaseDAO *)sender withStatus:(FSBaseDAOCallBackStatus)status
{
    NSLog(@"%d",self.myDeepListDao.objectList.count);
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
    return;
    if (_oldCount==arrayCount && arrayCount!=0) {
        _tvList.assistantViewFlag = FSTABLEVIEW_ASSISTANT_TOP_VIEW;
    }
    else{
        _tvList.assistantViewFlag = FSTABLEVIEW_ASSISTANT_BOTTOM_BUTTON_VIEW | FSTABLEVIEW_ASSISTANT_TOP_VIEW | FSTABLEVIEW_ASSISTANT_BOTTOM_VIEW;
        _oldCount=arrayCount;
    }
}

-(NSString *)cellIdentifierStringWithIndexPath:(NSIndexPath *)indexPath{
    return @"RoutineNewsListCellx";
}

-(Class)cellClassWithIndexPath:(NSIndexPath *)indexPath{
    return [LygDeepTableViewCell class];
}

-(void)initializeCell:(UITableViewCell *)cell withData:(NSObject *)data withIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"initializeCellinitializeCell");
}



-(void)layoutSubviews{
    _tvList.frame = roundToRect(CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height));
	
	if (!CGSizeEqualToSize(_tvSize, _tvList.frame.size)) {
		_tvSize = _tvList.frame.size;
		//防止不重新装载数据
		[_tvList reloadData];
	}
    //_tvList.separatorStyle = YES;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[_tvList bottomScrollViewDidScroll:scrollView];
    
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
    
    /*if ([sender isEqual:_myDeepListDao]) {
        if (status == FSBaseDAOCallBack_SuccessfulStatus || status == FSBaseDAOCallBack_BufferSuccessfulStatus) {
            NSLog(@"FSNewsViewController:%d",[_fs_GZF_ForOnedayNewsFocusTopDAO.objectList count]);
            //[self loadDataWithOutCompelet];
            [self loadDataWithOutCompelet];
            if (status == FSBaseDAOCallBack_SuccessfulStatus) {
                [self loaddingComplete];
                [_myDeepListDao operateOldBufferData];
                
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
    }*/
    if ([sender isEqual:_myDeepListDao]) {
        if (status == FSBaseDAOCallBack_SuccessfulStatus || status == FSBaseDAOCallBack_BufferSuccessfulStatus) {
            //NSLog(@"_fs_GZF_ForNewsListDAO:%d",[_fs_GZF_ForNewsListDAO.objectList count]);
            if (status == FSBaseDAOCallBack_SuccessfulStatus) {
                [self reSetAssistantViewFlag:[_myDeepListDao.objectList count]];
                [self loadData];
                [_myDeepListDao operateOldBufferData];
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
        
        
        //[_fs_GZF_ForOnedayNewsFocusTopDAO HTTPGetDataWithKind:GET_DataKind_ForceRefresh];
        
        //_myDeepListDao.objectList = nil;
        //[_myDeepListDao HTTPGetDataWithKind:GET_DataKind_ForceRefresh];
        
    }
    if (dataSource == tdsNextSection) {
//        FSTopicObject *o = [_myDeepListDao.objectList lastObject];
//        _myDeepListDao.lastid = o.de;
//        
//        
//        if ([_fs_GZF_ForNewsListDAO.channelid isEqualToString:@"1_0"]) {
//            _fs_GZF_ForNewsListDAO.getNextOnline = NO;
//        }
//        else{
//            _fs_GZF_ForNewsListDAO.getNextOnline = YES;
//        }
//        
//        [_fs_GZF_ForNewsListDAO HTTPGetDataWithKind:GET_DataKind_Next];
       // _myDeepListDao.objectList = nil;
       // [_myDeepListDao HTTPGetDataWithKind:GET_DataKind_ForceRefresh];
    }
}

-(void)tableViewDataSourceDidSelected:(FSTableContainerView *)sender withIndexPath:(NSIndexPath *)indexPath{
   /* NSInteger row = [indexPath row];
    if ([_fs_GZF_ForOnedayNewsFocusTopDAO.objectList count]>0) {
        if (row== 0) {
            return;
        }
        FSNewsListCell * cell             = (FSNewsListCell*)[sender.tvList cellForRowAtIndexPath:indexPath];
        cell.leftView.backgroundColor     = [UIColor redColor];
        cell.lab_NewsTitle.textColor      = [UIColor grayColor];
        FSOneDayNewsObject *o = [_fs_GZF_ForNewsListDAO.objectList objectAtIndex:row-1];
        int i = 0;
        for (FSOneDayNewsObject * obj in _fs_GZF_ForNewsListDAO.objectList) {
            if ([obj.newsid isEqualToString:self.currentNewsId] && ![o.newsid isEqualToString:self.currentNewsId]) {
                FSNewsListCell * cell = (FSNewsListCell*)[sender.tvList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i+1 inSection:0]];
                cell.leftView.backgroundColor = [UIColor lightGrayColor];
                
            }
            i++;
        }
        
        _currentObject        = o;
        FSNewsContainerViewController *fsNewsContainerViewController = [[FSNewsContainerViewController alloc] init];
        fsNewsContainerViewController.obj                            = o;
        fsNewsContainerViewController.FCObj                          = nil;
        fsNewsContainerViewController.newsSourceKind                 = NewsSourceKind_PuTongNews;
        self.currentNewsId                                           = o.newsid;
        [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithInt:1] forKey:o.newsid];
        
        NSLog(@"%@ %@",self.aViewController,self.aViewController.navigationController);
        [self.aViewController.navigationController pushViewController:fsNewsContainerViewController animated:YES];
        [fsNewsContainerViewController release];
        [[FSBaseDB sharedFSBaseDB] updata_visit_message:o.channelid];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else{
        FSOneDayNewsObject *o                                        = [_fs_GZF_ForNewsListDAO.objectList objectAtIndex:row-1];
        FSNewsContainerViewController *fsNewsContainerViewController = [[FSNewsContainerViewController alloc] init];
        fsNewsContainerViewController.obj                            = o;
        fsNewsContainerViewController.FCObj                          = nil;
        fsNewsContainerViewController.newsSourceKind                 = NewsSourceKind_PuTongNews;
        [UIView commitAnimations];
        [self.aViewController.navigationController pushViewController:fsNewsContainerViewController animated:YES];
        [fsNewsContainerViewController release];
        [[FSBaseDB sharedFSBaseDB] updata_visit_message:o.channelid];
    }
    
    //[_fs_GZF_ForNewsListDAO.managedObjectContext save:nil];
    //[FSBaseDB saveDB];*/
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSString *cellIdentifierString = [self cellIdentifierStringWithIndexPath:indexPath];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierString];
    
    //cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CellBackground"]];
    
	if (cell == nil) {
		cell = (UITableViewCell *)[[[self cellClassWithIndexPath:indexPath] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierString];
        cell.backgroundColor  = [UIColor redColor];
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
//        FSNewsListCell     * xxcell          = (FSNewsListCell *)cell;
//        FSOneDayNewsObject * object          = [_fs_GZF_ForNewsListDAO.objectList objectAtIndex:indexPath.row -1];
//        xxcell.leftView.backgroundColor      = ([object.newsid isEqualToString:self.currentNewsId]?[UIColor redColor]:[UIColor lightGrayColor]);
//        NSNumber * num = [[NSUserDefaults standardUserDefaults]valueForKey:object.newsid];
        //xxcell.lab_NewsTitle.textColor       = (num?[UIColor lightGrayColor]:[UIColor blackColor]);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(NSObject *)tableViewCellData:(FSTableContainerView *)sender withIndexPath:(NSIndexPath *)indexPath{
	NSInteger row = [indexPath row];
            return [_myDeepListDao.objectList objectAtIndex:row];
}
-(void)reloadData
{
    [self.tvList reloadData];
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
    NSLog(@"%d",_myDeepListDao.objectList.count);
    return _myDeepListDao.objectList.count;
}
@end

