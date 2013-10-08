//
//  FSBaseShareViewController.m
//  PeopleNewsReaderPhone
//
//  Created by ganzf on 12-11-7.
//
//

#import "FSBaseShareViewController.h"

#define FSSETTING_VIEW_NAVBAR_HEIGHT 44.0f


@interface FSBaseShareViewController ()

@end

@implementation FSBaseShareViewController
@synthesize withnavTopBar = _withnavTopBar;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//        _withnavTopBar = NO;
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)dealloc{
    [_fsBlogShareContentView release];
    [_fsShareNoticView release];
    [_navTopBar release];
    [super dealloc];
}


-(void)loadChildView{
    
    _navTopBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f)];
    _navTopBar.tintColor = [UIColor whiteColor];
#ifdef __IPHONE_5_0
    [_navTopBar setBackgroundImage:[UIImage imageNamed: @"navigatorBar.png"] forBarMetrics:UIBarMetricsDefault];
#endif
    if (_withnavTopBar) {
        
        UINavigationItem * item      = [[UINavigationItem alloc]init];
    
        
        UIBarButtonItem * backButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回.png"] style:UIBarButtonItemStylePlain target:self action:@selector(returnBack:)];
        backButton.tintColor         = [UIColor whiteColor];
        item.leftBarButtonItem       = backButton;
        [backButton release];
        
        
        NSDictionary * dict2            = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],UITextAttributeTextColor,[NSValue valueWithCGSize:CGSizeMake(0, 0)],UITextAttributeTextShadowOffset,nil];
        UIBarButtonItem * sharbutton = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStyleBordered target:self action:@selector(senderBt:)];
        [sharbutton setTitleTextAttributes:dict2 forState:UIControlStateNormal];
        sharbutton.tintColor         = [UIColor whiteColor];
        item.rightBarButtonItem      = sharbutton;
        [sharbutton release];
        
        
        
        NSDictionary * dict            = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18], UITextAttributeFont,[UIColor blackColor],UITextAttributeTextColor,nil];
        _navTopBar.titleTextAttributes = dict;
        _navTopBar.items               = [NSArray arrayWithObjects:item,nil];
        item.title                     = NSLocalizedString(self.title, nil);
        [item release];
        

        [self.view addSubview:_navTopBar];
 

    }
    else{
    }

    
    
    _fsBlogShareContentView = [[FSBlogShareContentView alloc] init];
    _fsBlogShareContentView.parentDelegate = self;
    _fsBlogShareContentView.shareContent = self.shareContent;
    _fsBlogShareContentView.dataContent = self.dataContent;
    [self.view addSubview:_fsBlogShareContentView];
    
    _fsShareNoticView = [[FSShareNoticView alloc] init];
    _fsShareNoticView.parentDelegate = self;
    _fsShareNoticView.alpha = 0.0f;
    [self.view addSubview:_fsShareNoticView];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGRect rect = self.view.frame;
    rect.origin.y = 0;
    self.view.frame = rect;
    
}

-(void)returnBack:(id)sender{
//    if (_withnavTopBar){
//        [self dismissModalViewControllerAnimated:YES];
//    }
//    else{
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if(self.presentingViewController)
    {
        [self dismissModalViewControllerAnimated:YES];
    }else
    {
        [self.view removeFromSuperview];
    }
}

-(void)senderBt:(id)sender{
    [self postShareMessage];
}

-(void)postShareMessage{
    
}

-(void)initDataModel{
    
}

-(void)layoutControllerViewWithRect:(CGRect)rect{
    if (self.withnavTopBar) {
        _fsBlogShareContentView.frame = CGRectMake(0, 44.0f, rect.size.width, rect.size.height-44.0f);
    }
    else{
        _fsBlogShareContentView.frame = CGRectMake(0, 0.0f, rect.size.width, rect.size.height);
    }
    
    _fsShareNoticView.frame = CGRectMake((rect.size.width - 219)/2, (rect.size.height-160)/2, 219, 70);
}


-(void)doSomethingForViewFirstTimeShow{
    
}

-(void)doSomethingWithDAO:(FSBaseDAO *)sender withStatus:(FSBaseDAOCallBackStatus)status{
    
}

-(void)returnToParentView{

    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.presentingViewController)
    {
        [self dismissModalViewControllerAnimated:YES];
    }else
    {
        [self.view removeFromSuperview];
    }
}




@end
