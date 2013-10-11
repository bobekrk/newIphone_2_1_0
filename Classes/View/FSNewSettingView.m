//
//  FSNewSettingView.m
//  PeopleNewsReaderPhone
//
//  Created by Qin,Zhuoran on 12-11-28.
//
//

#import "FSNewSettingView.h"
#import "FSConst.h"
#import "FSBaseDB.h"
#import "FSWeatherObject.h"
#import "PeopleNewsReaderPhoneAppDelegate.h"
#define HEIGHT  44
#define WEIGHT  280
@implementation settingDataObject
-(id)initWithString:(NSString*)aString titleString:(NSString*)titleString
{
    if (self = [super init]) {
        self.leftImage             = [UIImage imageNamed:[aString stringByAppendingString:@".png"]];
        self.leftHighLightedImage  = [UIImage imageNamed:[aString stringByAppendingString:@"h.png"]];
        self.titleString           = titleString;
    }
    return self;
}
@end
@implementation FSNewSettingView

//@synthesize btnClearMemory,btnDownLoad,btnMyCollection,btnNigthMode,btnUpdate;

@synthesize delegate;
-(void)addWeatherView
{
    _fsWeatherView = [[FSWeatherView alloc] init];
    _fsWeatherView.frame = CGRectMake(50, 0, 320, 100);
    _fsWeatherView.userInteractionEnabled = NO;
    _fsWeatherView.multipleTouchEnabled = NO;
    UIButton *weatcherBt = [[UIButton alloc] init];
    weatcherBt.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1];
    //weatcherBt.backgroundColor = [UIColor greenColor];
    weatcherBt.frame = CGRectMake(0, 0, 320, 100);
    [weatcherBt addSubview:_fsWeatherView];
    [weatcherBt addTarget:self action:@selector(weatherNewsAction:) forControlEvents:UIControlEventTouchUpInside];
    //[weatcherBt addTarget:self action:@selector(weatherNewsActionLock:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:weatcherBt];
    
}
-(void)weatherNewsAction:(UIButton*)sender
{
    NSLog(@"%@",self.delegate);
     if ([self.delegate respondsToSelector:@selector(weatherNewsViewButtonClick)]) {
        [self.delegate weatherNewsViewButtonClick];
     }
}
-(void)updataWeatherStatus{
    //NSArray *array = [[FSBaseDB sharedFSBaseDB] getObjectsByKeyWithName:@"FSWeatherObject" key:@"group" value:@""];
    @synchronized(self)
    {
        NSArray *array2 = [[FSBaseDB sharedFSBaseDBWithContext:[FSBaseDB sharedFSBaseDB].managedObjectContext] getObjectsByKeyWithName:@"FSWeatherObject" key:@"group" value:getCityName()];
        for (FSWeatherObject *obj in array2) {
            if ([obj.day isEqualToString:@"0"]) {
                _fsWeatherView.data = obj;
                [_fsWeatherView doSomethingAtLayoutSubviews];
            }
        }

    }
    
}
-(void)tableViewLoad
{
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, 320-44, 400)];
    [self addSubview:_myTableView];
    _myTableView.delegate   = self;
    _myTableView.dataSource = self;
    [_myTableView release];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        settingDataObject * one1 = [[settingDataObject alloc]initWithString:@"order"   titleString:@"订阅我的头条"];
        settingDataObject * one2 = [[settingDataObject alloc]initWithString:@"collect" titleString:@"我的收藏"];
        settingDataObject * one3 = [[settingDataObject alloc]initWithString:@"clear"   titleString:@"清理缓存"];
        settingDataObject * one4 = [[settingDataObject alloc]initWithString:@"update"  titleString:@"检查更新"];
        _dataObjectArry = [[NSArray alloc]initWithObjects:one1,one2,one3,one4,nil];
        [one1 release];
        [one2 release];
        [one3 release];
        [one4 release];
        
        
//        CGFloat top = 30;
//        CGFloat left = 0;
//        CGFloat space = 4.0f;
        [self addWeatherView];
        [self updataWeatherStatus];
        
        
        [self tableViewLoad];
    }
    return self;
}
#pragma mark tablevie delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d",[_dataObjectArry count]);
    return [_dataObjectArry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * xxx = @"xxxxxxx";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:xxx];
    BOOL isNeedAutoRelease = NO;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:xxx];
        UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(30, 10, cell.frame.size.height - 20, cell.frame.size.height - 20)];
        imageview.tag           =  100;
        [cell addSubview:imageview];
        [imageview release];
        
        isNeedAutoRelease = YES;
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, 150, cell.frame.size.height)];
        label.highlightedTextColor    = [UIColor redColor];
        [cell addSubview:label];
        label.tag       = 200;
        [label release];
        
        UIImageView * imageview2 = [[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width - 44 - 5, 0, 5, cell.frame.size.height)];
        imageview2.tag           =  300;
        [cell addSubview:imageview2];
        [imageview2 release];
        imageview2.image            = [UIImage imageNamed:@"bianxuan.png"];
        imageview2.highlightedImage = [UIImage imageNamed:@"bianxuanH.png"];
    }
    cell.selectionStyle        = UITableViewCellSelectionStyleGray;
    UIImageView * imageView    = (UIImageView*)[cell viewWithTag:100];
    imageView.image            = ((settingDataObject*)[_dataObjectArry objectAtIndex:indexPath.row]).leftImage;
    imageView.highlightedImage = ((settingDataObject*)[_dataObjectArry objectAtIndex:indexPath.row]).leftHighLightedImage;
    NSLog(@"%@",imageView.image);
    NSLog(@"%@",imageView.highlightedImage);
    
    UILabel     * label    = (UILabel*)[cell viewWithTag:200];
    label.text             = ((settingDataObject*)[_dataObjectArry objectAtIndex:indexPath.row]).titleString;
    return  (isNeedAutoRelease?[cell autorelease]:cell);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            [delegate tappedInSettingView:self downloadButton:nil];
        }
            break;
        case 1:
        {
            [delegate tappedInSettingView:self myCollectionButton:nil];
        }
            break;
        case 2:
        {
            [delegate tappedInSettingView:self clearMemoryButton:nil];
        }
            break;
        case 3:
        {
            [delegate tappedInSettingView:self updateButton:nil];
        }
            break;
        case 4:
        {
            [delegate tappedInSettingView:self nightModeButton:nil];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark costum method
//by Qin,Zhuoran

//btnDownLoad---字体设置
- (void)downloadButtonClicked:(UIButton *)button
{
    [delegate tappedInSettingView:self downloadButton:button];
}

//btnNigthMode---订阅中心
- (void)nigthModeButtonClicked:(UIButton *)button
{
    [delegate tappedInSettingView:self nightModeButton:button];
}

//btnMyCollection
- (void)myCollectionButtonClicked:(UIButton *)button
{
    [delegate tappedInSettingView:self myCollectionButton:button];
}

//btnClearMemory
- (void)clearMemoryButtonClicked:(UIButton *)button
{
    [delegate tappedInSettingView:self clearMemoryButton:button];
}

//btnUpdate
- (void)updateButtonClicked:(UIButton *)button
{
    [delegate tappedInSettingView:self updateButton:button];
}
@end
