//
//  FSAboutViewController.m
//  PeopleNewsReaderPhone
//
//  Created by yuan lei on 12-8-31.
//  Copyright (c) 2012年 people. All rights reserved.
//

#import "FSAboutViewController.h"

#import "FSAboutContaierView.h"

#define FSSETTING_VIEW_NAVBAR_HEIGHT 0.0f

@implementation FSAboutViewController

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
    //[_navTopBar release];
    [_fsAboutContaierView release];
    [super dealloc];
}
-(NSString *)setTitle{
    //_fsALLSettingContainerView.flag = 1;
    return @"关于我们";
}

-(void)loadChildView{
    [super loadChildView];
    _fsAboutContaierView = [[FSAboutContaierView alloc] init];
    [self.view addSubview:_fsAboutContaierView];
}

-(void)returnBack:(id)sender{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.presentingViewController)
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    
}

-(void)layoutControllerViewWithRect:(CGRect)rect{
    _fsAboutContaierView.backgroundColor = [UIColor whiteColor];
    _fsAboutContaierView.frame = CGRectMake(0, 44, rect.size.width, rect.size.height -FSSETTING_VIEW_NAVBAR_HEIGHT);
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
