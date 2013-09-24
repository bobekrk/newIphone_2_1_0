//
//  FSBaseSettingViewController.m
//  PeopleNewsReaderPhone
//
//  Created by yuan lei on 12-9-12.
//  Copyright (c) 2012年 people. All rights reserved.
//

#import "FSBaseSettingViewController.h"

#define FSSETTING_VIEW_NAVBAR_HEIGHT 44.0f

@implementation FSBaseSettingViewController

@synthesize isnavTopBar = _isnavTopBar;

- (id)init {
	self = [super init];
	if (self) {
		self.isnavTopBar = NO;
	}
	return self;
}

- (void)dealloc {
    [_fsALLSettingContainerView release];
    [super dealloc];
}

- (void)loadChildView {
	[super loadChildView];
    _fsALLSettingContainerView = [[FSALLSettingContainerView alloc] init];
    _fsALLSettingContainerView.parentDelegate = self;
    [self.view addSubview:_fsALLSettingContainerView];
	//self.view.backgroundColor = [UIColor blueColor];
    
    if (self.isnavTopBar) {
        
         _navTopBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, FSSETTING_VIEW_NAVBAR_HEIGHT)];
        _navTopBar.tintColor = [UIColor whiteColor];
         #ifdef __IPHONE_5_0
         [_navTopBar setBackgroundImage:[UIImage imageNamed: @"navigatorBar.png"] forBarMetrics:UIBarMetricsDefault];
         #endif
         UINavigationItem *topItem = [[UINavigationItem alloc] init];
        
        
        UIBarButtonItem * backButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回.png"] style:UIBarButtonItemStylePlain target:self action:@selector(returnBack:)];
        backButton.tintColor = [UIColor whiteColor];
        _navTopBar.backItem.leftBarButtonItem  = backButton;
        
        UINavigationItem *leftItem = [[UINavigationItem alloc] init];
        leftItem.leftBarButtonItem = backButton;
        [backButton release];
         NSArray *items = [[NSArray alloc] initWithObjects:topItem,leftItem, nil];
         _navTopBar.items = items;
         _navTopBar.topItem.title = NSLocalizedString([self setTitle], nil);
        
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18], UITextAttributeFont,[UIColor blackColor],UITextAttributeTextColor,[NSValue valueWithCGSize:CGSizeMake(0, 0)],UITextAttributeTextShadowOffset,nil];
        _navTopBar.titleTextAttributes = dict;

         [topItem release];
         [items release];
         [self.view addSubview:_navTopBar];
        [_navTopBar release];
        

        
        
    }
    else{
        UIButton *returnBT = [[UIButton alloc] init];
        [returnBT setBackgroundImage:[UIImage imageNamed:@"returnbackBT.png"] forState:UIControlStateNormal];
        //[returnBT setTitle:NSLocalizedString(@"返回", nil) forState:UIControlStateNormal];
        returnBT.titleLabel.font = [UIFont systemFontOfSize:12];
        [returnBT addTarget:self action:@selector(returnBack:) forControlEvents:UIControlEventTouchUpInside];
        [returnBT setTitleColor:COLOR_NEWSLIST_TITLE_WHITE forState:UIControlStateNormal];
        returnBT.frame = CGRectMake(0, 0, 55, 30);
        
        UIBarButtonItem *returnButton = [[UIBarButtonItem alloc] initWithCustomView:returnBT];
        self.navigationItem.leftBarButtonItem = returnButton;
        [returnButton release];
        [returnBT release];
    }
   
    
    self.title = [self setTitle];
    
    
}

-(NSString *)setTitle{
    return @"";
}

-(void)returnBack:(id)sender{
    NSLog(@"returnBack");
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];

    }
}

- (void)layoutControllerViewWithRect:(CGRect)rect {
    if (self.isnavTopBar){
        _fsALLSettingContainerView.frame = CGRectMake(0, FSSETTING_VIEW_NAVBAR_HEIGHT, rect.size.width, rect.size.height -FSSETTING_VIEW_NAVBAR_HEIGHT);
    }
    else{
        _fsALLSettingContainerView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height -0);
    }
    
}


-(void)doSomethingForViewFirstTimeShow{
    [_fsALLSettingContainerView loadData];
}


#pragma mark - 
#pragma FSTableContainerViewDelegate mark

-(UITableViewCellSelectionStyle)tableViewCellSelectionStyl:(FSTableContainerView *)sender withIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellSelectionStyleNone;
}

-(NSInteger)tableViewSectionNumber:(FSTableContainerView *)sender{
    return 2;
}

-(NSInteger)tableViewNumberInSection:(FSTableContainerView *)sender section:(NSInteger)section{
    if (section == 0) {
        return 4;
    }
    
    if (section == 1) {
        return 3;
    }
    return 0;
}

-(NSString *)tableViewSectionTitle:(FSTableContainerView *)sender section:(NSInteger)section{
    return @"";
}

-(NSObject *)tableViewCellData:(FSTableContainerView *)sender withIndexPath:(NSIndexPath *)indexPath{
    return @"all_setting";
}


-(void)tableViewDataSourceDidSelected:(FSTableContainerView *)sender withIndexPath:(NSIndexPath *)indexPath{

}


-(void)tableViewTouchPicture:(FSTableContainerView *)sender withImageURLString:(NSString *)imageURLString withImageLocalPath:(NSString *)imageLocalPath imageID:(NSString *)imageID{
    NSLog(@"channel did selected!!");
}


-(void)tableViewTouchEvent:(FSTableContainerView *)sender cell:(FSTableViewCell *)cellSender{
    NSLog(@"tableViewTouchEvent");
    
}

@end
