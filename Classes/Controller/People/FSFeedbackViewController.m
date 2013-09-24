//
//  FSFeedbackViewController.m
//  PeopleNewsReaderPhone
//
//  Created by yuan lei on 12-8-31.
//  Copyright (c) 2012年 people. All rights reserved.
//

#import "FSFeedbackViewController.h"

#import "FS_GZF_FeedbackPOSTXMLDAO.h"

#define FSSETTING_VIEW_NAVBAR_HEIGHT 44.0f

@implementation FSFeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)dealloc{
    [_fs_GZF_FeedbackPOSTXMLDAO release];
    [super dealloc];
}

-(void)loadChildView{
    [super loadChildView];
    
//    UIButton *sendBT = [[UIButton alloc] init];
//    [sendBT setBackgroundImage:[UIImage imageNamed:@"top_2.png"] forState:UIControlStateNormal];
//    [sendBT setTitle:@"发送" forState:UIControlStateNormal];
//    sendBT.titleLabel.font = [UIFont systemFontOfSize:12];
//    [sendBT addTarget:self action:@selector(sendFeedBackMessage:) forControlEvents:UIControlEventTouchUpInside];
//    [sendBT setTitleColor:COLOR_NEWSLIST_TITLE_WHITE forState:UIControlStateNormal];
//    sendBT.frame = CGRectMake(self.view.frame.size.width-55, (FSSETTING_VIEW_NAVBAR_HEIGHT-34)/2, 55, 34);
//    
//    
//    [_navTopBar addSubview:sendBT];
//    [sendBT release];
//
//    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonItemStylePlain target:self action:@selector(sendFeedBackMessage:)];
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleBordered target:self action:@selector(sendFeedBackMessage:)];
    NSDictionary * dict2            = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],UITextAttributeTextColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,nil];
    [rightButton setTitleTextAttributes:dict2 forState:UIControlStateNormal];
    rightButton.tintColor         = [UIColor whiteColor];
    _navTopBar.topItem.rightBarButtonItem = rightButton;
    [rightButton release];
    _fsFeedbackContainerView = [[FSFeedbackContainerView alloc] init];
    _fsFeedbackContainerView.delegate      = self;
    [self.view addSubview:_fsFeedbackContainerView];
    [_fsFeedbackContainerView release];
}
-(void)changSendHide
{
    [_navTopBar.topItem.rightBarButtonItem setEnabled:!_navTopBar.topItem.rightBarButtonItem.isEnabled];
}

-(NSString *)setTitle{
    return @"意见反馈";
}

-(void)sendFeedBackMessage:(id)sender{
    
    NSString *message = [_fsFeedbackContainerView getFeedbackMessage];
    if ([message length]>0) {
        _fs_GZF_FeedbackPOSTXMLDAO.contact = _fsFeedbackContainerView.contact;//联系方式
        _fs_GZF_FeedbackPOSTXMLDAO.message = _fsFeedbackContainerView.message;//意见内容
        [_fs_GZF_FeedbackPOSTXMLDAO HTTPPostDataWithKind:HTTPPOSTDataKind_Normal];//发送数据
    }
    else{
        NSLog(@"请填写意见信息");
    }
}

-(void)initDataModel{
    _fs_GZF_FeedbackPOSTXMLDAO = [[FS_GZF_FeedbackPOSTXMLDAO alloc] init];
    _fs_GZF_FeedbackPOSTXMLDAO.parentDelegate = self;
}

-(void)layoutControllerViewWithRect:(CGRect)rect{
   _fsFeedbackContainerView.frame = CGRectMake(0, FSSETTING_VIEW_NAVBAR_HEIGHT, rect.size.width, rect.size.height - FSSETTING_VIEW_NAVBAR_HEIGHT); 
}


-(void)doSomethingForViewFirstTimeShow{
    
}


-(void)doSomethingWithDAO:(FSBaseDAO *)sender withStatus:(FSBaseDAOCallBackStatus)status{
    //发送结果回调
    if (status == FSBaseDAOCallBack_SuccessfulStatus) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"通知"
                                                       message:@"发送成功，感谢您的热心参与！"
                                                      delegate:self
                                             cancelButtonTitle:@"返回"
                                             otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if(status == FSBaseDAOCallBack_UnknowErrorStatus){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"通知"
                                                       message:@"发送失败！"
                                                      delegate:self
                                             cancelButtonTitle:@"返回"
                                             otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
