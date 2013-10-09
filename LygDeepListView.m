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
#import "FSTopicObject.h"
#import "LygDeepTableViewCell.h"

@implementation LygDeepListView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _tvList.assistantViewFlag = FSTABLEVIEW_ASSISTANT_BOTTOM_BUTTON_VIEW | FSTABLEVIEW_ASSISTANT_TOP_VIEW | FSTABLEVIEW_ASSISTANT_BOTTOM_VIEW;
        _tvList.parentDelegate    = self;
        _tvList.dataSource = self;
        _tvList.delegate = self;
        _oldCount = 0;
    }
    return self;
}

-(id)initWithDeepListDao:(FS_GZF_DeepListDAO*)aDao initDelegate:(id)aDeleagte
{
    if (self = [super init]) {
        self.parentDelegate    = self;
        _tvList.parentDelegate = self;
        _tvList.delegate     = self;
        _tvList.dataSource   = self;
        _oldCount            = 0;
        _isfirstShow         = YES;
        _myDeepListDao       = aDao;
        //_currentCount        = 20;
        //_myDeepListDao.parentDelegate = self;
        self.delegte         = aDeleagte;
        _tvList.assistantViewFlag = FSTABLEVIEW_ASSISTANT_BOTTOM_BUTTON_VIEW | FSTABLEVIEW_ASSISTANT_TOP_VIEW | FSTABLEVIEW_ASSISTANT_BOTTOM_VIEW;
        //[_myDeepListDao HTTPGetDataWithKind:GET_DataKind_ForceRefresh];
    }
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	//return _myDeepListDao.objectList.count > 20?20:_myDeepListDao.objectList.count;
	return _myDeepListDao.objectList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSTopicObject * top = [_myDeepListDao.objectList objectAtIndex:indexPath.row];
    CGSize size         = [top.news_abstract sizeWithFont:[UIFont systemFontOfSize:DEEPABSTRACTFONTSIZE] constrainedToSize:CGSizeMake(295, 200) lineBreakMode:0];
   
    //CGSize size = [top.news_abstract sizeWithFont:[UIFont systemFontOfSize:14] forWidth:295 lineBreakMode:0];
//    if(indexPath.row%3 == 0)
//        size.height = 130;
     NSLog(@"%d %@ %f",indexPath.row,top.news_abstract,size.height);
    return 48 + 5 + size.height + 5;
}


-(UITableViewStyle)initializeTableViewStyle{
    return UITableViewStylePlain;
}

-(void)reSetAssistantViewFlag:(NSInteger)arrayCount{
    if (_oldCount == arrayCount && arrayCount != 0 &&  _myDeepListDao.currentGetDataKind == GET_DataKind_Next) {
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
    _tvList.frame = roundToRect(CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height - 1));
	
	if (!CGSizeEqualToSize(_tvSize, _tvList.frame.size)) {
		_tvSize = _tvList.frame.size;
		//防止不重新装载数据
		[_tvList reloadData];
	}
    //_tvList.separatorStyle = YES;
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
    if ([sender isEqual:_myDeepListDao]) {
        if (status == FSBaseDAOCallBack_SuccessfulStatus || status == FSBaseDAOCallBack_BufferSuccessfulStatus) {
            //NSLog(@"_fs_GZF_ForNewsListDAO:%d",[_fs_GZF_ForNewsListDAO.objectList count]);
            if (status == FSBaseDAOCallBack_SuccessfulStatus) {
                [self reSetAssistantViewFlag:[_myDeepListDao.objectList count]];
                [self loaddingComplete];
                //[_myDeepListDao operateOldBufferData];
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
        [_myDeepListDao HTTPGetDataWithKind:GET_DataKind_ForceRefresh];
        
    }
    if (dataSource == tdsNextSection) {
        [_myDeepListDao HTTPGetDataWithKind:GET_DataKind_Next];
    }
}

-(void)tableViewDataSourceDidSelected:(FSTableContainerView *)sender withIndexPath:(NSIndexPath *)indexPath{
    [self.delegte LygDeepListViewCellTouched:indexPath.row];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSString *cellIdentifierString = [self cellIdentifierStringWithIndexPath:indexPath];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierString];
    
    //cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CellBackground"]];
    bool isAlloc = NO;
	if (cell == nil) {
		cell = (UITableViewCell *)[[[self cellClassWithIndexPath:indexPath] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierString];
        isAlloc = YES;
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
    if (indexPath.row == 11) {
        ; 
    }
    LygDeepTableViewCell * xxcell = (LygDeepTableViewCell*)cell;
    FSTopicObject * ddddddddd          = (FSTopicObject*)[_myDeepListDao.objectList objectAtIndex:indexPath.row];
    
    xxcell.nameLabel.text              = ddddddddd.title;
    xxcell.dateLabel.text              = ddddddddd.pubDate;
    xxcell.abstractLabel.text          = ddddddddd.news_abstract;
    FSTopicObject *obj    = (FSTopicObject *)[_myDeepListDao.objectList objectAtIndex:indexPath.row];
    NSArray * arry        = [obj.title componentsSeparatedByString:@"】"];
    if (arry.count > 1) {
        NSString * string     = [[arry objectAtIndex:0] substringFromIndex:1];
        xxcell.kindsLabel.text = string;
        xxcell.kindsLabel.hidden = NO;
        xxcell.dateLabel.hidden  = NO;
        xxcell.nameLabel.text  = [arry objectAtIndex:1];
    }else
    {
        xxcell.kindsLabel.text = nil;
        xxcell.kindsLabel.hidden = YES;
        xxcell.dateLabel.hidden  = YES;
        xxcell.nameLabel.text  = obj.title;
    }
    
    
    xxcell.dateLabel.text  = [[[obj.pubDate componentsSeparatedByString:@" "] objectAtIndex:0] stringByAppendingString:@""];
    xxcell.abstractLabel.text = obj.news_abstract;
    
    return (isAlloc?[cell autorelease]:cell);
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
    self.reFreshDate = [[[NSDate alloc] initWithTimeIntervalSinceNow:0] autorelease];
}
-(NSInteger)tableViewSectionNumber:(FSTableContainerView *)sender{
    return 1;
}

-(NSInteger)tableViewNumberInSection:(FSTableContainerView *)sender section:(NSInteger)section{
    NSLog(@"%d",_myDeepListDao.objectList.count);
    return _myDeepListDao.objectList.count;
}
@end

