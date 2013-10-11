//
//  FSNewsDitailToolBar.m
//  PeopleNewsReaderPhone
//
//  Created by Xu dandan on 12-10-31.
//
//

#import "FSNewsDitailToolBar.h"
#import "FSNewsContainerView.h"
#import "FSInformationMessageView.h"
@implementation FSNewsDitailToolBar

@synthesize touchEvenKind = _touchEvenKind;
@synthesize comment_content = _comment_content;
@synthesize isInFaverate = _isInFaverate;
@synthesize fontToolBarIsShow = _fontToolBarIsShow;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing codefs
}
*/


-(void)doSomethingAtDealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)doSomethingAtInit{
    //self.backgroundColor = COLOR_NEWSLIST_DESCRIPTION;
    
    //注册键盘事件
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification 
                                               object:nil];
    
    
    
    _backgroundBT = [[UIButton alloc] init];
    [_backgroundBT addTarget:self action:@selector(backSelect:) forControlEvents:UIControlEventTouchUpInside];
    _backgroundBT.alpha = 0.05;
    [self addSubview:_backgroundBT];
    [_backgroundBT release];
    
    _toolbarBackground = [[UIImageView alloc] init];
    _toolbarBackground.image = [UIImage imageNamed:@"newsDitail_bar.png"];
    [self addSubview:_toolbarBackground];
    [_toolbarBackground release];
    
    
    //_fontSelectBackground = [[UIImageView alloc] init];
    //_fontSelectBackground.image = [UIImage imageNamed:@"fonttoolbar.png"];
    
    _favNoticBackground = [[UIImageView alloc] init];
    _favNoticBackground.image = [UIImage imageNamed:@"content_tool_pop_favorited.png"];
    _favNoticBackground.alpha = 0.0f;
    [self addSubview:_favNoticBackground];
    [_favNoticBackground release];
    
    
    //[self addSubview:_fontSelectBackground];
    
    
    
    _lab_favNotic = [[UILabel alloc] init];
    _lab_favNotic.backgroundColor = COLOR_CLEAR;
    _lab_favNotic.textColor = COLOR_NEWSLIST_DESCRIPTION;
    _lab_favNotic.font = [UIFont systemFontOfSize:18];
    _lab_favNotic.textAlignment = UITextAlignmentCenter;
    _lab_favNotic.alpha = 0.0f;
    [self addSubview:_lab_favNotic];
    [_lab_favNotic release];
    
    _fontToolBarIsShow = NO;
    
    _goBackButton = [[UIButton alloc] init];
    [_goBackButton setBackgroundImage:[UIImage imageNamed:@"goBack.png"] forState:UIControlStateNormal];
    [_goBackButton addTarget:self action:@selector(onGoBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _goBackButton.frame = CGRectZero;
    [self addSubview:_goBackButton];
    [_goBackButton release];
    
    _bt_faverate = [[UIButton alloc] init];
    [_bt_faverate setBackgroundImage:[UIImage imageNamed:@"newsDitail_fav_1.png"] forState:UIControlStateNormal];
    [_bt_faverate addTarget:self action:@selector(faverate:) forControlEvents:UIControlEventTouchUpInside];
    _bt_faverate.frame = CGRectZero;
    [self addSubview:_bt_faverate];
    [_bt_faverate release];
    

    
    _bt_comment = [[UIButton alloc] init];
    [_bt_comment setBackgroundImage:[UIImage imageNamed:@"newsDitail_comment_1.png"] forState:UIControlStateNormal];
    [_bt_comment setBackgroundImage:[UIImage imageNamed:@"newsDitail_comment_2.png"] forState:UIControlStateHighlighted];
    [_bt_comment addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
    _bt_comment.frame = CGRectZero;
    [self addSubview:_bt_comment];
    [_bt_comment release];
    
    
    
    _bt_share = [[UIButton alloc] init];
    [_bt_share setBackgroundImage:[UIImage imageNamed:@"newsDitail_shear_1.png"] forState:UIControlStateNormal];
    [_bt_share setBackgroundImage:[UIImage imageNamed:@"newsDitail_shear_2.png"] forState:UIControlStateHighlighted];
    [_bt_share addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    _bt_share.frame = CGRectZero;
    [self addSubview:_bt_share];
    [_bt_share release];
    
    

    
    
    //可变文本背景图
    _gtv_backgroundTop = [[UIImageView alloc] init];
    _gtv_backgroundTop.image = [UIImage imageNamed:@"newsDitail_up1.png"];
    [self addSubview:_gtv_backgroundTop];
    [_gtv_backgroundTop release];
    
    _gtv_backgroundMin = [[UIImageView alloc] init];
    _gtv_backgroundMin.image = [UIImage imageNamed:@"newsDitail_mid1.png"];
    [self addSubview:_gtv_backgroundMin];
    [_gtv_backgroundMin release];
    
    _gtv_backgroundBt = [[UIImageView alloc] init];
    _gtv_backgroundBt.image = [UIImage imageNamed:@"newsDitail_down1.png"];
    [self addSubview:_gtv_backgroundBt];
    [_gtv_backgroundBt release];
    
    
    
    
    //可变高度文本框
    _growingText = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(11, 14, 230, 4)];
    _growingText.minNumberOfLines = 1;
    _growingText.maxNumberOfLines = 5;
    [_growingText setDataDetectorTypes:UIDataDetectorTypeNone];
    _growingText.delegate = self;
    _growingText.hidden = YES;
    _growingText.backgroundColor = COLOR_CLEAR;
    //textView.animateHeightChange = NO; //turns off animation
    
    [self addSubview:_growingText];
    [_growingText release];
    
    
    _sendBT = [[UIButton alloc] init];
    [_sendBT setBackgroundImage:[UIImage imageNamed:@"newsDitail_tijiao.png"] forState:UIControlStateNormal];
    [_sendBT setTitle:@"提交" forState:UIControlStateNormal];
    _sendBT.titleLabel.font = [UIFont systemFontOfSize:17];
    [_sendBT addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    _sendBT.frame = CGRectMake(10, self.frame.size.height - 40, 40, 30);
    _sendBT.alpha = 0.0f;
    [self addSubview:_sendBT];
    [_sendBT release];

}


-(void)doSomethingAtLayoutSubviews{
    
    _toolbarBackground.frame    = CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 40);
    //_bt_faverate.frame        = CGRectMake(75*0+27.5f, self.frame.size.height - 40, 40, 40);
    _bt_faverate.frame          = CGRectMake(75*3+27.5f, self.frame.size.height - 40, 40, 40);
    //_bt_font.frame            = CGRectMake(75*1+27.5f, self.frame.size.height - 40, 40, 40);
    //_bt_comment.frame         = CGRectMake(75*2+27.5f, self.frame.size.height - 40, 40, 40);
    _bt_comment.frame           = CGRectMake(75*1+27.5f, self.frame.size.height - 40, 40, 40);
    //_bt_share.frame           = CGRectMake(75*3+27.5f, self.frame.size.height - 40, 40, 40);
    _bt_share.frame             = CGRectMake(75*2+27.5f + 7.5, self.frame.size.height - 40 + 7.5, 25, 25);
    _goBackButton.frame         = CGRectMake(75*0+27.5f, self.frame.size.height - 40, 40, 40);
    
    //_fontSelectBackground.frame = CGRectMake(6, self.frame.size.height - 90, 229, 50);
    
    _favNoticBackground.frame   = CGRectMake(237, self.frame.size.height - 90, 80, 50);
    _lab_favNotic.frame         = CGRectMake(237, self.frame.size.height - 85, 80, 30);
    NSLog(@"self.frame:%@",NSStringFromCGRect(self.frame));
    if (self.isInFaverate) {
        [_bt_faverate setBackgroundImage:[UIImage imageNamed:@"newsDitail_fav_2.png"] forState:UIControlStateNormal];
    }
    else{
        [_bt_faverate setBackgroundImage:[UIImage imageNamed:@"newsDitail_fav_1.png"] forState:UIControlStateNormal];
    }
    
}

-(void)onGoBackButtonClicked
{
    UIViewController * temp = (UIViewController *)(((FSNewsContainerView*)(self.parentDelegate)).parentDelegate);
    if (temp.navigationController) {
        [temp.navigationController popViewControllerAnimated:YES];
    }else if (temp.presentingViewController)
    {
        [temp dismissModalViewControllerAnimated:YES];
    }
}

-(void)faverate:(id)sender{
    
    if (_fontToolBarIsShow==YES) {
        _fontToolBarIsShow = NO;
    }
    
    self.touchEvenKind = TouchEvenKind_FaverateSelect;
    self.isInFaverate = !self.isInFaverate;
    
    if (self.isInFaverate) {
        [_bt_faverate setBackgroundImage:[UIImage imageNamed:@"newsDitail_fav_2.png"] forState:UIControlStateNormal];
    }
    else{
        [_bt_faverate setBackgroundImage:[UIImage imageNamed:@"newsDitail_fav_1.png"] forState:UIControlStateNormal];
    }
    
    [self favNoticBar];
    
    [self sendTouchEvent];
}

//-(void)font:(id)sender{
//    _fontToolBarIsShow = !_fontToolBarIsShow;
//}


-(void)comment:(id)sender{
    _growingText.hidden = !_growingText.hidden;
    self.touchEvenKind = TouchEvenKind_CommentSelect;
    [self sendTouchEvent];
    [_growingText becomeFirstResponder];
    [_growingText clearContent];
}

-(void)share:(id)sender{
    self.touchEvenKind = TouchEvenKind_ShareSelect;
    [self sendTouchEvent];
}


-(void)send:(id)sender{
    self.touchEvenKind = TouchEvenKind_Commentsend;
    self.comment_content = _growingText.text;
    if (_growingText.text == nil || _growingText.text.length == 0) {
//        FSIndicatorMessageView *indicatorMessageView = [[FSIndicatorMessageView alloc] initWithFrame:CGRectZero andBool:YES];
//        [indicatorMessageView showIndicatorMessageViewInView:self.view withMessage:[self indicatorMessageTextWithDAO:sender withStatus:status]];
//        [indicatorMessageView release];
        FSInformationMessageView *informationMessageView = [[FSInformationMessageView alloc] initWithFrame:CGRectZero];
        informationMessageView.parentDelegate = self.parentDelegate;
        [informationMessageView showInformationMessageViewInView:self.superview
                                                     withMessage:@"请输入评论内容"
                                                withDelaySeconds:1
                                                withPositionKind:PositionKind_Vertical_Horizontal_Center
                                                      withOffset:0.0f];
        return;
    }
    [self sendTouchEvent];
    [_growingText resignFirstResponder];
}

-(void)favNoticBar{
    self.clipsToBounds = NO;
    if (self.isInFaverate) {
        
        _favNoticBackground.alpha = 1.0f;//已收藏
        _lab_favNotic.text = @"收藏成功";
        _lab_favNotic.alpha = 1.0f;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:2.8];
        _lab_favNotic.alpha = 0.0f;
        _favNoticBackground.alpha = 0.0f;//已收藏
        [UIView commitAnimations];
    }
    else{
        
        _favNoticBackground.alpha = 1.0f;
        _lab_favNotic.text = @"取消收藏";
        _lab_favNotic.alpha = 1.0f;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:2.8];
        _lab_favNotic.alpha = 0.0f;
        _favNoticBackground.alpha = 0.0f;//已收藏
        [UIView commitAnimations];
    }
}

#pragma mark -
#pragma mark HPGrowingTextViewDelegate


- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
	float diff = (growingTextView.frame.size.height - height);
	
	CGRect r = growingTextView.frame;
     r.origin.y += diff;
     growingTextView.frame = r;
    
    _gtv_backgroundTop.frame = CGRectMake(0, r.origin.y-10, self.frame.size.width, 10);
    _gtv_backgroundMin.frame = CGRectMake(0, r.origin.y-4, self.frame.size.width, r.size.height+40);
    //_gtv_backgroundBt.frame = CGRectMake(0, r.origin.y + r.size.height -2, self.frame.size.width, 10);
}

-(void)keyboardWillShow:(NSNotification *)Notification{
    
    FSLog(@"keyboardWillShow::");
    
    NSDictionary *info = [Notification userInfo];
	NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];//[info objectForKey:UIKeyboardBoundsUserInfoKey];//UIKeyboardFrameEndUserInfoKey
	
    _gtv_backgroundTop.alpha = 1.0f;
    _gtv_backgroundMin.alpha = 1.0f;
    _gtv_backgroundBt.alpha = 1.0f;
    _sendBT.alpha = 1.0f;
    
	CGSize keyboardSize = [value CGRectValue].size;
    
    
    CGRect rr = [UIScreen mainScreen].applicationFrame;
    
    self.frame = CGRectMake(0.0f, 0, rr.size.width, rr.size.height - keyboardSize.height + 44);
    _backgroundBT.frame = self.frame;
    
   // NSLog(@"rr y:%f  h:%f  k:%f",rr.origin.y,rr.size.height,keyboardSize.height);
    
    _growingText.frame = CGRectMake(10, self.frame.size.height - 44 - 8 - _growingText.frame.size.height,  _growingText.frame.size.width, _growingText.frame.size.height);
    
    CGRect r = _growingText.frame;
    _gtv_backgroundTop.frame = CGRectMake(0, r.origin.y-10, self.frame.size.width, 10);
    _gtv_backgroundMin.frame = CGRectMake(0, r.origin.y-4, self.frame.size.width, r.size.height+10);
    _gtv_backgroundBt.frame = CGRectMake(0, r.origin.y + r.size.height -2, self.frame.size.width, 10);
    
    _sendBT.frame = CGRectMake(self.frame.size.width - 65, r.origin.y + r.size.height -34, 50, 35);
    
}

-(void)backSelect:(id)sender{
    [_growingText resignFirstResponder];
}


-(void)keyboardWillHide:(NSNotification *)Notification{
    _growingText.hidden = YES;
    [_growingText resignFirstResponder];
    
    _gtv_backgroundTop.alpha = 0.0f;
    _gtv_backgroundMin.alpha = 0.0f;
    _gtv_backgroundBt.alpha = 0.0f;
    _sendBT.alpha = 0.0f;
    
    
    CGRect rr = [UIScreen mainScreen].applicationFrame;
    
    self.frame = CGRectMake(0.0f, rr.size.height - 44, rr.size.width, 44);
    
    
}




@end
