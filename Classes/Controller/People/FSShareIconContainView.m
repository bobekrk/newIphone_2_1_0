//
//  FSShareIconContainView.m
//  PeopleNewsReaderPhone
//
//  Created by ganzf on 12-12-13.
//
//

#import "FSShareIconContainView.h"
#import "FSPeopleBlogShareViewController.h"
#import "FSNetEaseBlogShareViewController.h"
#import "FSSinaBlogShareViewController.h"
#define SHAREFONT 12.0f
@implementation WeiBoObject
-(id)initWithIndex:(int)index andPicName:(NSString*)picName andDisplayName:(NSString*)disPlayName;
{
    if (self = [super init]) {
        self.index   = index;
        self.picName = picName;
        self.disPlayName = disPlayName;
    }
    return self;
}
@end
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
//    NSArray * arry = [NSArray arrayWithObjects:@"人民微博",@"微信好友",@"微信朋友圈",@"新浪微博",@"网易微博",@"腾讯微博",@"信息",@"邮件",@"",@"", nil];
//    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"人民微博",@"1",@"微信好友",@"2",@"微信朋友圈",@"3",@"新浪微博",@"4",@"网易微博",@"5",@"腾讯微博",@"6",@"信息",@"7",@"邮件",nil];
    CGFloat iconHeight = 60;
    CGFloat iconWidth = iconHeight;
    CGFloat labHeight = 30;
    NSInteger lineNUM = 3;
    //NSInteger i = 0;
    CGFloat leftSpase = (320 - iconHeight * 4)/5;
    CGFloat spase = (self.frame.size.width-iconWidth*lineNUM)/lineNUM;
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    
    
    WeiBoObject * xx1 = [[WeiBoObject alloc]initWithIndex:0 andPicName:@"renmin" andDisplayName:@"人民微博"];
    [dict setValue:xx1 forKey:xx1.disPlayName];
    [xx1 release];
    
    
    WeiBoObject * xx2 = [[WeiBoObject alloc]initWithIndex:1 andPicName:@"weixin" andDisplayName:@"微信好友"];
    [dict setValue:xx2 forKey:xx2.disPlayName];
    [xx2 release];
    
    
    
    WeiBoObject * xx3 = [[WeiBoObject alloc]initWithIndex:2 andPicName:@"朋友圈" andDisplayName:@"微信朋友圈"];
    [dict setValue:xx3 forKey:xx3.disPlayName];
    [xx3 release];
    
    
    WeiBoObject * xx4 = [[WeiBoObject alloc]initWithIndex:3 andPicName:@"weibo" andDisplayName:@"新浪微博"];
    [dict setValue:xx4 forKey:xx4.disPlayName];
    [xx4 release];
    
    
    WeiBoObject * xx5 = [[WeiBoObject alloc]initWithIndex:4 andPicName:@"163" andDisplayName:@"网易微博"];
    [dict setValue:xx5 forKey:xx5.disPlayName];
    [xx5 release];
    
    
    
    WeiBoObject * xx6 = [[WeiBoObject alloc]initWithIndex:6 andPicName:@"短信" andDisplayName:@"信息"];
    [dict setValue:xx6 forKey:xx6.disPlayName];
    [xx6 release];
    
    
    
    WeiBoObject * xx7 = [[WeiBoObject alloc]initWithIndex:7 andPicName:@"mail" andDisplayName:@"邮件"];
    [dict setValue:xx7 forKey:xx7.disPlayName];
    [xx7 release];
    
    
    
    WeiBoObject * xx8 = [[WeiBoObject alloc]initWithIndex:5 andPicName:@"腾讯微博" andDisplayName:@"腾讯微博"];
    [dict setValue:xx8 forKey:xx8.disPlayName];
    [xx8 release];
    
    
    for (NSString * string in [dict allKeys]) {
        WeiBoObject * obj = [dict valueForKey:string];
        UIImageView *friendImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithNameString:obj.picName]];
        friendImageView.tag = obj.index;
        friendImageView.userInteractionEnabled = YES;
        friendImageView.frame = CGRectMake(leftSpase*(obj.index %4+1)+iconWidth *(obj.index %4), spase + (iconHeight + 50)* (obj.index/4)  , iconWidth, iconHeight);
        UILabel *friendLabel = [[UILabel alloc] init];
        friendLabel.userInteractionEnabled = YES;
        friendLabel.tag = obj.index;
        friendLabel.text = obj.disPlayName;
        friendLabel.textAlignment = UITextAlignmentCenter;
        friendLabel.backgroundColor = COLOR_CLEAR;
        friendLabel.font = [UIFont systemFontOfSize:SHAREFONT];
        friendLabel.frame = CGRectMake(leftSpase*(obj.index %4+1)+iconWidth *(obj.index %4), spase + (iconHeight + 50)* (obj.index/4) + 5 + iconHeight, iconWidth, labHeight);
        [self addSubview:friendImageView];
        [self addSubview:friendLabel];
        [friendImageView release];
        [friendLabel release];
    }
    
//    i=0;
//    UIImageView *friendImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"朋友圈.png"]];
//    friendImageView.tag = ShareSelectEvent_friend;
//    friendImageView.userInteractionEnabled = YES;
//    friendImageView.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase + iconHeight + 50  , iconWidth, iconHeight);
//    UILabel *friendLabel = [[UILabel alloc] init];
//    friendLabel.userInteractionEnabled = YES;
//    friendLabel.tag = ShareSelectEvent_friend;
//    friendLabel.text = @"朋友圈";
//    //friendLabel.textColor = COLOR_NEWSLIST_TITLE_WHITE;
//    friendLabel.textAlignment = UITextAlignmentCenter;
//    friendLabel.backgroundColor = COLOR_CLEAR;
//    friendLabel.font = [UIFont systemFontOfSize:SHAREFONT];
//    friendLabel.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase + iconHeight + 50 + 5 + iconHeight, iconWidth, labHeight);
//    [self addSubview:friendImageView];
//    [self addSubview:friendLabel];
//    [friendImageView release];
//    [friendLabel release];
//    i++;
//
//
//    
//    UIImageView *weixinIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weixin.PNG"]];
//    weixinIcon.tag = ShareSelectEvent_weixin;
//    weixinIcon.userInteractionEnabled = YES;
//    weixinIcon.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase, iconWidth, iconHeight);
//    UILabel *weixinName = [[UILabel alloc] init];
//    weixinName.userInteractionEnabled = YES;
//    weixinName.tag = ShareSelectEvent_weixin;
//    weixinName.text = @"微信好友";
//    //weixinName.textColor = COLOR_NEWSLIST_TITLE_WHITE;
//    weixinName.textAlignment = UITextAlignmentCenter;
//    weixinName.backgroundColor = COLOR_CLEAR;
//    weixinName.font = [UIFont systemFontOfSize:SHAREFONT];
//    weixinName.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase + 5 +iconHeight, iconWidth, labHeight);
//    [self addSubview:weixinIcon];
//    [self addSubview:weixinName];
//    [weixinIcon release];
//    [weixinName release];
//    
//    CGFloat iconHeight = 60;
//    CGFloat iconWidth = iconHeight;
//    CGFloat labHeight = 30;
//    NSInteger lineNUM = 3;
//    //NSInteger i = 0;
//    CGFloat leftSpase = (320 - iconHeight * 4)/5;
//    CGFloat spase = (self.frame.size.width-iconWidth*lineNUM)/lineNUM;
    
    {
//        NSString * string1 = [dict valueForKey:@"人民微博"];
//        int i = [string1 intValue];
//        UIImageView *peopleBlogIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"renmin.png"]];
//        peopleBlogIcon.tag = ShareSelectEvent_peopleBlog;
//        peopleBlogIcon.userInteractionEnabled = YES;
//        peopleBlogIcon.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i,spase, iconWidth,iconHeight);
//        UILabel *peopleBlogName = [[UILabel alloc] init];
//        peopleBlogName.userInteractionEnabled = YES;
//        peopleBlogName.tag = ShareSelectEvent_peopleBlog;
//        peopleBlogName.text = @"人民微博";
//        //peopleBlogName.textColor = COLOR_NEWSLIST_TITLE_WHITE;
//        peopleBlogName.textAlignment = UITextAlignmentCenter;
//        peopleBlogName.backgroundColor = COLOR_CLEAR;
//        peopleBlogName.font = [UIFont systemFontOfSize:SHAREFONT];
//        peopleBlogName.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase + 5 +iconHeight, iconWidth, labHeight);
//        [self addSubview:peopleBlogIcon];
//        [self addSubview:peopleBlogName];
//        [peopleBlogIcon release];
//        [peopleBlogName release];
        
   }
    
    
    {
//        NSString * string1 = [dict valueForKey:@"新浪微博"];
//        int i = [string1 intValue];
//        UIImageView *sinaIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weibo.png"]];
//        sinaIcon.tag = ShareSelectEvent_sina;
//        sinaIcon.userInteractionEnabled = YES;
//        sinaIcon.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase, iconWidth, iconHeight);
//        UILabel *sinaName = [[UILabel alloc] init];
//        sinaName.userInteractionEnabled = YES;
//        sinaName.tag = ShareSelectEvent_sina;
//        sinaName.text = @"新浪微博";
//        //sinaName.textColor = COLOR_NEWSLIST_TITLE_WHITE;
//        sinaName.textAlignment = UITextAlignmentCenter;
//        sinaName.backgroundColor = COLOR_CLEAR;
//        sinaName.font = [UIFont systemFontOfSize:SHAREFONT];
//        sinaName.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase + 5 +iconHeight, iconWidth, labHeight);
//        [self addSubview:sinaIcon];
//        [self addSubview:sinaName];
//        
//        [sinaIcon release];
//        [sinaName release];
    }
    

    
//    UIImageView *tencent = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"腾讯微博.png"]];
//    tencent.tag = ShareSelectEvent_tencent;
//    tencent.userInteractionEnabled = YES;
//    tencent.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase, iconWidth, iconHeight);
//    UILabel *tencentName = [[UILabel alloc] init];
//    tencentName.userInteractionEnabled = YES;
//    tencentName.tag = ShareSelectEvent_tencent;
//    tencentName.text = @"腾讯微博";
//    //tencentName.textColor = COLOR_NEWSLIST_TITLE_WHITE;
//    tencentName.textAlignment = UITextAlignmentCenter;
//    tencentName.backgroundColor = COLOR_CLEAR;
//    tencentName.font = [UIFont systemFontOfSize:SHAREFONT];
//    tencentName.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase + 5 +iconHeight, iconWidth, labHeight);
//    [self addSubview:tencent];
//    [self addSubview:tencentName];
//    
//    [tencent release];
//    [tencentName release];
//    i++;

    

    

    
    
    
    

//    UIImageView *neteaseIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"163.png"]];
//    neteaseIcon.tag = ShareSelectEvent_netease;
//    neteaseIcon.userInteractionEnabled = YES;
//    neteaseIcon.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase + iconHeight + 50, iconWidth, iconHeight);
//    UILabel *neteaseName = [[UILabel alloc] init];
//    neteaseName.userInteractionEnabled = YES;
//    neteaseName.tag = ShareSelectEvent_netease;
//    neteaseName.text = @"网易微博";
//    //neteaseName.textColor = COLOR_NEWSLIST_TITLE_WHITE;
//    neteaseName.textAlignment = UITextAlignmentCenter;
//    neteaseName.backgroundColor = COLOR_CLEAR;
//    neteaseName.font = [UIFont systemFontOfSize:SHAREFONT];
//    neteaseName.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase + iconHeight + 50 + 5 + iconHeight, iconWidth, labHeight);
//    [self addSubview:neteaseIcon];
//    [self addSubview:neteaseName];
//    [neteaseIcon release];
//    [neteaseName release];
//    i++;
    
    
//    UIImageView *messageIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"短信.PNG"]];
//    messageIcon.tag = ShareSelectEvent_message;
//    messageIcon.userInteractionEnabled = YES;
//    messageIcon.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase + iconHeight + 50, iconWidth, iconHeight);
//    UILabel *messageName = [[UILabel alloc] init];
//    messageName.userInteractionEnabled = YES;
//    messageName.tag = ShareSelectEvent_message;
//    messageName.text = @"信息";
//    //messageName.textColor = COLOR_NEWSLIST_TITLE_WHITE;
//    messageName.textAlignment = UITextAlignmentCenter;
//    messageName.backgroundColor = COLOR_CLEAR;
//    messageName.font = [UIFont systemFontOfSize:SHAREFONT];
//    messageName.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase + iconHeight + 50 + 5 + iconHeight, iconWidth, labHeight);
//    [self addSubview:messageIcon];
//    [self addSubview:messageName];
//    [messageIcon release];
//    [messageName release];
//    i++;
    
    
//    UIImageView *mailIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mail.png"]];
//    mailIcon.tag = ShareSelectEvent_mail;
//    mailIcon.userInteractionEnabled  = YES;
//    mailIcon.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase + iconHeight + 50, iconWidth, iconHeight);
//    UILabel *mailName = [[UILabel alloc] init];
//    mailName.userInteractionEnabled = YES;
//    mailName.tag = ShareSelectEvent_mail;
//    mailName.text = @"邮件";
//    //mailName.textColor = COLOR_NEWSLIST_TITLE_WHITE;
//    mailName.textAlignment = UITextAlignmentCenter;
//    mailName.backgroundColor = COLOR_CLEAR;
//    mailName.font = [UIFont systemFontOfSize:SHAREFONT];
//    mailName.frame = CGRectMake(leftSpase*(i+1)+iconWidth *i, spase + iconHeight + 50 + 5 + iconHeight, iconWidth, labHeight);
//    [self addSubview:mailIcon];
//    [self addSubview:mailName];
//    [mailIcon release];
//    [mailName release];
//    i++;
    
    [dict release];
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
