//
//  FSAppStoreViewController.m
//  PeopleNewsReaderPhone
//
//  Created by Qin,Zhuoran on 12-12-18.
//
//

#import "FSAppStoreViewController.h"

@interface FSAppStoreViewController ()

@end

@implementation FSAppStoreViewController

@synthesize url;
@synthesize isprsend = _isprsend;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isprsend = NO;
    }
    return self;
}

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
    [url release];
    [super dealloc];
}

#pragma mark - view life cycle
-(void)returnBack
{
    storeViewController.delegate = nil;
    [storeViewController release];
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}
-(void)loadChildView{
    [super loadChildView];
//    self.navTopBar.topItem.leftBarButtonItem = nil;
//    
////    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 40, 30)];
////    label.text      = @"取消";
//    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(10, 7, 40, 30)];
//    [button setTitle:@"取消" forState:UIControlStateNormal];
//    
////    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(returnBack)];
////    item.tintColor         = [UIColor whiteColor];
////    self.navTopBar.topItem.leftBarButtonItem = item;
//    
//    
//    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:label];
//    item.tintColor         = [UIColor whiteColor];
//    self.navTopBar.topItem.leftBarButtonItem = item;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view setAlpha:1];
    CGRect rect = self.view.frame;
    rect.origin.y = 44;
    UIActivityIndicatorView *_activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:rect];
    //[_activityIndicatorView setCenter:self.view.center];
    [_activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray];  //颜色根据不同的界面调整
    [_activityIndicatorView startAnimating];
    [self.view addSubview:_activityIndicatorView];
    
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //NSString *idstr = self.url;
    NSInteger number = [self.url integerValue];
    NSLog(@"integer is %d",number);
    storeViewController =
    [[SKStoreProductViewController alloc] init];
    
    storeViewController.delegate = self;
    storeViewController.view.backgroundColor = [UIColor whiteColor];
    
    

    NSDictionary * parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:number], SKStoreProductParameterITunesItemIdentifier,nil];
    NSLog(@"%@",parameters);
    __block UIViewController * xxx = self;
    [storeViewController loadProductWithParameters:parameters
                                   completionBlock:^(BOOL result, NSError *error) {
                                       if (result)
                                           [xxx presentViewController:storeViewController animated:NO completion:nil];
                                   }];
    
//    [returnButton release];
//    [returnBT release];

}

#pragma mark -
#pragma mark SKStoreProductViewControllerDelegate
-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
    if (self.isprsend) {
        [self dismissModalViewControllerAnimated:NO];
    }
    else{
        [self.navigationController popViewControllerAnimated:NO];
    }
}


-(void)returnBack:(id)sender{
    if (self.isprsend) {
        [self dismissModalViewControllerAnimated:YES];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)layoutControllerViewWithRect:(CGRect)rect{
        
} 

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
