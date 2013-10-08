//
//  FSNewsContainerView.m
//  PeopleNewsReaderPhone
//
//  Created by Xu dandan on 12-10-26.
//
//

#import "FSNewsContainerView.h"
#import "FSCommentObject.h"


#define ADBAR_HEIGHT 0.0f

@implementation FSNewsContainerView

@synthesize touchEvenKind = _touchEvenKind;
@synthesize comment_content = _comment_content;
@synthesize isInFaverate = _isInFaverate;
@synthesize isFirstShow = _isFirstShow;
@synthesize isFullScream = _isFullScream;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) { 
        // Initialization code
            }
    return self;
}
-(void)dealloc
{
    //[FSNewsContainerWebView  ]
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(BOOL)goBackToBeforePage
{

//    if (self.fsNewsContainerWebView.hasebeenLoad == 100) {
//        if ([self.fsNewsContainerWebView.webContent canGoBack]) {
//            [self.fsNewsContainerWebView.webContent goBack];
//        }else
//        {
//            [self.fsNewsContainerWebView loadWebPageWithContent:nil];
//        }
//        return NO;
//    }else
//    {
//        return YES;
//    }
    return YES;
}

-(void)doSomethingAtDealloc{
    _fsNewsContainerWebView.parentDelegate = nil;
//   [_fsNewsContainerCommentListView release];
//    [_scrollView release];
    [_comment_content release];
}

-(void)doSomethingAtInit{
    
    _isInFaverate = NO;
    
    _isFirstShow = YES;
    
    _isFullScream = NO;
    
    self.backgroundColor = [UIColor redColor];

    _fsNewsContainerWebView = [[FSNewsContainerWebView alloc] init];
    _fsNewsContainerWebView.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:240.0/255 alpha:1];
    _fsNewsContainerWebView.parentDelegate = self;
    [self addSubview:_fsNewsContainerWebView];
    [_fsNewsContainerWebView release];
    
    _fsNewsDitailToolBar = [[FSNewsDitailToolBar alloc] init];
    _fsNewsDitailToolBar.clipsToBounds = YES;
    _fsNewsDitailToolBar.parentDelegate = self;
    [self addSubview:_fsNewsDitailToolBar];
    if ([GlobalConfig shareConfig].readContentFullScreen) {
        _fsNewsDitailToolBar.alpha = 0;
    }
    //_fsNewsDitailToolBar.hidden = [GlobalConfig shareConfig].readContentFullScreen;
    [_fsNewsDitailToolBar release];
    
    _oldContentOfset = 0;
    
    
}



-(void)doSomethingAtLayoutSubviews{
  
    if (_isFirstShow) {
        _fsNewsDitailToolBar.frame = CGRectMake(0, self.frame.size.height - 40 , self.frame.size.width, 40);
        _isFirstShow = NO;
        
    }
    if (self.data==nil) {
        return;
    }
    
    if (self.data!=_fsNewsContainerWebView.data) {
        _fsNewsContainerWebView.hasebeenLoad = NO;
    }
    

    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
    _fsNewsDitailToolBar.isInFaverate = self.isInFaverate;
    _fsNewsDitailToolBar.frame = CGRectMake(0, self.frame.size.height - 40 , self.frame.size.width, 40);
    [UIView commitAnimations];
    
    
    _fsNewsContainerWebView.data = self.data;
    //_fsNewsContainerWebView.backgroundColor = [UIColor darkGrayColor];

    

    if (_isFullScream) {
        [self performSelector:@selector(showViewDelate) withObject:nil afterDelay:0.5];
    }
    else{
        [self showViewDelate];
    }
    
    //
}

-(void)didReciveComment:(NSArray *)CommentArray{
    
    _fsNewsContainerWebView.objectList = (NSArray *)CommentArray;
    [_fsNewsContainerWebView reSetCommentString:@""];
}

-(void)showViewDelate{
 //
    if ([self getCommentListHeight]==0) {
        _fsNewsContainerWebView.frame = CGRectMake(0, 0, self.frame.size.width,self.frame.size.height);
    }
    else{
        _fsNewsContainerWebView.frame = CGRectMake(0, 0, self.frame.size.width, _fsNewsContainerWebView.height);
    }
    
    [_fsNewsContainerWebView doSomethingAtLayoutSubviews];
    
    
}

#pragma mark - 
#pragma Delegate

-(void)fsBaseContainerViewTouchEvent:(FSBaseContainerView *)sender{
    
    //FSLog(@"sender:%@",sender);
    if ([sender isEqual:_fsNewsContainerWebView]) {
        self.touchEvenKind = _fsNewsContainerWebView.touchEvenKind;
        switch (_fsNewsContainerWebView.touchEvenKind) {
            case TouchEvenKind_PopCommentList:
                [self sendTouchEvent];
                break;
            case TouchEvenKind_ScrollUp:
//                if (_fsNewsDitailToolBar.fontToolBarIsShow) {
//                    return;
//                }
//                [self sendTouchEvent];
                break;
            case TouchEvenKind_ScrollDown:
//                if (_fsNewsDitailToolBar.fontToolBarIsShow) {
//                    return;
//                }
//                [self sendTouchEvent];
                break;
            default:
                break;
        }
    }
    
    if ([sender isEqual:_fsNewsDitailToolBar]) {
        self.touchEvenKind = _fsNewsDitailToolBar.touchEvenKind;
        switch (_fsNewsDitailToolBar.touchEvenKind) {
            case TouchEvenKind_FaverateSelect:
                [self sendTouchEvent];
                break;
            case TouchEvenKind_FontSelect:
                ;
                break;
            case TouchEvenKind_CommentSelect:
                ;
                break;
            case TouchEvenKind_Commentsend:
                self.comment_content = _fsNewsDitailToolBar.comment_content;
                [self sendTouchEvent];
                break;
            case TouchEvenKind_ShareSelect:
                [self sendTouchEvent];
                break;
            case TouchEvenKind_FontSizeChange:
                [_fsNewsContainerWebView fontSizeChange];
                break;
                
            default:
                break;
        }
    }
}


#pragma mark -
#pragma UIScrollViewDelegate mark

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (_fsNewsDitailToolBar.fontToolBarIsShow) {
        return;
    }
    
    if (scrollView.contentOffset.y > _oldContentOfset+5 && scrollView.contentOffset.y > 44) {
        //上
        _oldContentOfset = scrollView.contentOffset.y;
        if (self.touchEvenKind != TouchEvenKind_ScrollUp) {
            self.touchEvenKind = TouchEvenKind_ScrollUp;
            [self sendTouchEvent];
        }
    }
    
    if (scrollView.contentOffset.y < _oldContentOfset-5 && scrollView.contentOffset.y<scrollView.contentSize.height-self.frame.size.height-44) {
       //下
        _oldContentOfset = scrollView.contentOffset.y;
        if (self.touchEvenKind != TouchEvenKind_ScrollDown) {
            self.touchEvenKind = TouchEvenKind_ScrollDown;
            [self sendTouchEvent];
        }
    }
}



#pragma mark -
#pragma FSTableContainerViewDelegate mark


-(CGFloat)getCommentListHeight{
    
    return 0;
//    NSArray *array = [self.data valueForKey:@"CommentListDAO"];
//    
//    NSInteger mark =0;
//    if ([array count]>=5) {
//        _fsNewsContainerCommentListView.moreButtonisShow = YES;
//        NSInteger i = 0;
//        for (FSCommentObject *o in array) {
//            if (i>4) {
//                break;
//            }
//            if ([o.adminContent length]>0) {
//                mark = mark+1;//有管理员回帖？？？？
//            }
//            i++;
//        }
//    }
//    else{
//        _fsNewsContainerCommentListView.moreButtonisShow = NO;
//        for (FSCommentObject *o in array) {
//            if ([o.adminContent length]>0) {
//                mark = mark+1;//有管理员回帖？？？？
//            }
//        }
//    }
//    
//    if (_fsNewsContainerCommentListView.moreButtonisShow) {
//        return COMMENT_LIEST_CELL_HEIGHT*(5 + mark)+64.0f +40;
//    }
//    return COMMENT_LIEST_CELL_HEIGHT*([array count] + mark) +40;
}

//-(NSInteger)tableViewSectionNumber:(FSTableContainerView *)sender{
//    return 1;
//}
//
//-(NSInteger)tableViewNumberInSection:(FSTableContainerView *)sender section:(NSInteger)section{
//    
//    NSArray *array = [self.data valueForKey:@"CommentListDAO"];
//    FSLog(@"CommentListDAO:%d",[array count]);
//    
//    if ([array count]>=5) {
//        _fsNewsContainerCommentListView.moreButtonisShow = YES;
//        return 5;
//    }
//    return [array count];
//}
//
//
//- (NSObject *)tableViewCellData:(FSTableContainerView *)sender withIndexPath:(NSIndexPath *)indexPath {
//    NSInteger row = [indexPath row];
//    
//    NSArray *array = [self.data valueForKey:@"CommentListDAO"];
//    
//    if (_fsNewsContainerCommentListView.moreButtonisShow == YES && row > 4) {
//        return nil;
//    }
//    
//    if ([array count]>row) {
//        FSCommentObject *obj = [array objectAtIndex:row];
//        return obj;
//    }
//    return nil;
//    
//}
//
//-(NSString *)tableViewSectionTitle:(FSTableContainerView *)sender section:(NSInteger)section{
//    
//    
//    NSArray *array = [self.data valueForKey:@"CommentListDAO"];
//    if ([array count]==0) {
//        return @"暂无评论";
//    }
//    return @"网友热评";
//}
//
//
//
//-(void)tableViewDataSourceDidSelected:(FSTableContainerView *)sender withIndexPath:(NSIndexPath *)indexPath{
//    ;
//}
//
//-(void)tableViewTouchPicture:(FSTableContainerView *)sender index:(NSInteger)index{
//    NSLog(@"channel did selected!!");
//    if (index==-1) {
//        self.touchEvenKind = TouchEvenKind_PopCommentList;
//        [self sendTouchEvent];
//    }
//    
//}
//
//-(void)tableViewDataSource:(FSTableContainerView *)sender withTableDataSource:(TableDataSource)dataSource{
//    ;
//}
//
@end
