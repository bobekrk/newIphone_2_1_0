//
//  FSShareIconContainView.m
//  PeopleNewsReaderPhone
//
//  Created by ganzf on 12-12-13.
//
//

#import "FSShareIconContainView.h"

@implementation FSShareIconContainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGes:)];
        [self addGestureRecognizer:tapGes];
        [tapGes release];
    }
    return self;
}




-(void)doSomethingAtDealloc{
    [_lab_title release];
    [_bt_return release];
}

-(void)doSomethingAtInit{
    self.backgroundColor = COLOR_NEWSLIST_TITLE_WHITE;
    _lab_title = [[UILabel alloc] init];
    _lab_title.backgroundColor = [UIColor redColor];
    _lab_title.textColor = COLOR_NEWSLIST_TITLE_WHITE;
    _lab_title.textAlignment = UITextAlignmentCenter;
    _lab_title.font = [UIFont systemFontOfSize:18.0f];
    _lab_title.tag = 99;
    [self addSubview:_lab_title];
    
    _bt_return = [[UIButton alloc] init];
    [_bt_return setBackgroundImage:[UIImage imageNamed:@"shareCancel.png"] forState:UIControlStateNormal];
    [_bt_return setTitle:NSLocalizedString(@"取消" ,nil) forState:UIControlStateNormal];
    [_bt_return setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_bt_return addTarget:self action:@selector(returnBTselect:) forControlEvents:UIControlEventTouchUpInside];
    _bt_return.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_bt_return];
    
    
    self.shareSelectEvent = ShareSelectEvent_return;
    self.isShow = NO;
    
    self.backgroundColor = COLOR_BLACK_FOR_SHAREVIEW;
}

-(void)doSomethingAtLayoutSubviews{
    
    _lab_title.text = @"分享";
    _lab_title.frame = CGRectMake(30, 10, 60, 25);
    _bt_return.frame = CGRectMake(20, self.frame.size.height - 60, self.frame.size.width - 40, 40);
    [self layoutIcons];
    
}

-(void)returnBTselect:(id)sender{
    NSLog(@"取消取消取消");
    self.shareSelectEvent = ShareSelectEvent_return;
    [self sendTouchEvent];
}

-(void)layoutIcons{
    
    CGFloat iconHeight = 60;
    CGFloat iconWidth = iconHeight;
    CGFloat labHeight = 30;
    NSInteger lineNUM = 3;
    NSInteger i = 0;
    CGFloat leftSpase = (320 - iconHeight * 4)/5;
    CGFloat spase = (self.frame.size.width-iconWidth*lineNUM)/lineNUM;
    
    
    UIImageView *peopleBlogIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"renmin.png"]];
    peopleBlogIcon.tag = ShareSelectEvent_peopleBlog;
    peopleBlogIcon.userInteractionEnabled = YES;
    peopleBlogIcon.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i,spase, iconWidth,iconHeight);
    UILabel *peopleBlogName = [[UILabel alloc] init];
    peopleBlogName.userInteractionEnabled = YES;
    peopleBlogName.tag = ShareSelectEvent_peopleBlog;
    peopleBlogName.text = @"人民微博";
    //peopleBlogName.textColor = COLOR_NEWSLIST_TITLE_WHITE;
    peopleBlogName.textAlignment = UITextAlignmentCenter;
    peopleBlogName.backgroundColor = COLOR_CLEAR;
    peopleBlogName.font = [UIFont systemFontOfSize:14];
    peopleBlogName.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase + 5 +iconHeight, iconWidth, labHeight);
    [self addSubview:peopleBlogIcon];
    [self addSubview:peopleBlogName];
    [peopleBlogIcon release];
    [peopleBlogName release];
    i++;
    
    UIImageView *sinaIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weibo.png"]];
    sinaIcon.tag = ShareSelectEvent_sina;
    sinaIcon.userInteractionEnabled = YES;
    sinaIcon.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase, iconWidth, iconHeight);
    UILabel *sinaName = [[UILabel alloc] init];
    sinaName.userInteractionEnabled = YES;
    sinaName.tag = ShareSelectEvent_sina;
    sinaName.text = @"新浪微博";
    //sinaName.textColor = COLOR_NEWSLIST_TITLE_WHITE;
    sinaName.textAlignment = UITextAlignmentCenter;
    sinaName.backgroundColor = COLOR_CLEAR;
    sinaName.font = [UIFont systemFontOfSize:14];
    sinaName.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase + 5 +iconHeight, iconWidth, labHeight);
    [self addSubview:sinaIcon];
    [self addSubview:sinaName];
    
    [sinaIcon release];
    [sinaName release];
    i++;
    
    UIImageView *tencent = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"腾讯微博.png"]];
    tencent.tag = ShareSelectEvent_tencent;
    tencent.userInteractionEnabled = YES;
    tencent.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase, iconWidth, iconHeight);
    UILabel *tencentName = [[UILabel alloc] init];
    tencentName.userInteractionEnabled = YES;
    tencentName.tag = ShareSelectEvent_tencent;
    tencentName.text = @"腾讯微博";
    //tencentName.textColor = COLOR_NEWSLIST_TITLE_WHITE;
    tencentName.textAlignment = UITextAlignmentCenter;
    tencentName.backgroundColor = COLOR_CLEAR;
    tencentName.font = [UIFont systemFontOfSize:14];
    tencentName.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase + 5 +iconHeight, iconWidth, labHeight);
    [self addSubview:tencent];
    [self addSubview:tencentName];
    
    [tencent release];
    [tencentName release];
    i++;

    

    
    UIImageView *weixinIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weixin.PNG"]];
    weixinIcon.tag = ShareSelectEvent_weixin;
    weixinIcon.userInteractionEnabled = YES;
    weixinIcon.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase, iconWidth, iconHeight);
    UILabel *weixinName = [[UILabel alloc] init];
    weixinName.userInteractionEnabled = YES;
    weixinName.tag = ShareSelectEvent_weixin;
    weixinName.text = @"微信好友";
    //weixinName.textColor = COLOR_NEWSLIST_TITLE_WHITE;
    weixinName.textAlignment = UITextAlignmentCenter;
    weixinName.backgroundColor = COLOR_CLEAR;
    weixinName.font = [UIFont systemFontOfSize:14];
    weixinName.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase + 5 +iconHeight, iconWidth, labHeight);
    [self addSubview:weixinIcon];
    [self addSubview:weixinName];
    [weixinIcon release];
    [weixinName release];
    
    
    i=0;
    UIImageView *friendImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"朋友圈.png"]];
    friendImageView.tag = ShareSelectEvent_friend;
    friendImageView.userInteractionEnabled = YES;
    friendImageView.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase + iconHeight + 50  , iconWidth, iconHeight);
    UILabel *friendLabel = [[UILabel alloc] init];
    friendLabel.userInteractionEnabled = YES;
    friendLabel.tag = ShareSelectEvent_friend;
    friendLabel.text = @"朋友圈";
    //friendLabel.textColor = COLOR_NEWSLIST_TITLE_WHITE;
    friendLabel.textAlignment = UITextAlignmentCenter;
    friendLabel.backgroundColor = COLOR_CLEAR;
    friendLabel.font = [UIFont systemFontOfSize:14];
    friendLabel.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase + iconHeight + 50 + 5 + iconHeight, iconWidth, labHeight);
    [self addSubview:friendImageView];
    [self addSubview:friendLabel];
    [friendImageView release];
    [friendLabel release];
    i++;
    
    

    UIImageView *neteaseIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"163.png"]];
    neteaseIcon.tag = ShareSelectEvent_netease;
    neteaseIcon.userInteractionEnabled = YES;
    neteaseIcon.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase + iconHeight + 50, iconWidth, iconHeight);
    UILabel *neteaseName = [[UILabel alloc] init];
    neteaseName.userInteractionEnabled = YES;
    neteaseName.tag = ShareSelectEvent_netease;
    neteaseName.text = @"网易微博";
    //neteaseName.textColor = COLOR_NEWSLIST_TITLE_WHITE;
    neteaseName.textAlignment = UITextAlignmentCenter;
    neteaseName.backgroundColor = COLOR_CLEAR;
    neteaseName.font = [UIFont systemFontOfSize:14];
    neteaseName.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase + iconHeight + 50 + 5 + iconHeight, iconWidth, labHeight);
    [self addSubview:neteaseIcon];
    [self addSubview:neteaseName];
    [neteaseIcon release];
    [neteaseName release];
    i++;
    
    
    UIImageView *messageIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"短信.PNG"]];
    messageIcon.tag = ShareSelectEvent_message;
    messageIcon.userInteractionEnabled = YES;
    messageIcon.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase + iconHeight + 50, iconWidth, iconHeight);
    UILabel *messageName = [[UILabel alloc] init];
    messageName.userInteractionEnabled = YES;
    messageName.tag = ShareSelectEvent_message;
    messageName.text = @"信息";
    //messageName.textColor = COLOR_NEWSLIST_TITLE_WHITE;
    messageName.textAlignment = UITextAlignmentCenter;
    messageName.backgroundColor = COLOR_CLEAR;
    messageName.font = [UIFont systemFontOfSize:14];
    messageName.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase + iconHeight + 50 + 5 + iconHeight, iconWidth, labHeight);
    [self addSubview:messageIcon];
    [self addSubview:messageName];
    [messageIcon release];
    [messageName release];
    i++;
    
    
    UIImageView *mailIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mail.png"]];
    mailIcon.tag = ShareSelectEvent_mail;
    mailIcon.userInteractionEnabled  = YES;
    mailIcon.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase + iconHeight + 50, iconWidth, iconHeight);
    UILabel *mailName = [[UILabel alloc] init];
    mailName.userInteractionEnabled = YES;
    mailName.tag = ShareSelectEvent_mail;
    mailName.text = @"邮件";
    //mailName.textColor = COLOR_NEWSLIST_TITLE_WHITE;
    mailName.textAlignment = UITextAlignmentCenter;
    mailName.backgroundColor = COLOR_CLEAR;
    mailName.font = [UIFont systemFontOfSize:14];
    mailName.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase + iconHeight + 50 + 5 + iconHeight, iconWidth, labHeight);
    [self addSubview:mailIcon];
    [self addSubview:mailName];
    [mailIcon release];
    [mailName release];
    i++;
    
    
    self.backgroundColor = COLOR_NEWSLIST_TITLE_WHITE;
}

-(CGFloat)getHeight{
    CGFloat height = 60.0f;
    
    height = height +98*2;
    
    height = height +60;
    
    
    return height;
}

- (void)handleGes:(UITapGestureRecognizer *)ges {
    
    if (ges.state == UIGestureRecognizerStateEnded) {
        
        CGPoint pt = [ges locationInView:self];
        UIView *hitView = [self hitTest:pt withEvent:nil];
        NSLog(@"UIGestureRecognizerStateEnded:%@",hitView);
        if ([hitView isKindOfClass:[UIImageView class]]) {
            UIImageView *asycImageView = nil;
            asycImageView = (UIImageView *)hitView;
            self.shareSelectEvent = asycImageView.tag;
            [self sendTouchEvent];
        }
        
        if ([hitView isKindOfClass:[UIButton class]]) {
            self.shareSelectEvent = ShareSelectEvent_return;
            [self sendTouchEvent];
        }
        
        if ([hitView isKindOfClass:[UILabel class]]) {
            UILabel *asycImageView = nil;
            asycImageView = (UILabel *)hitView;
            self.shareSelectEvent = asycImageView.tag;
            [self sendTouchEvent];
        }
        
    }else{
        return;
    }
}



@end
