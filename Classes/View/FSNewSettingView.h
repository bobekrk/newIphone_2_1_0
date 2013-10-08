//
//  FSNewSettingView.h
//  PeopleNewsReaderPhone
//
//  Created by Qin,Zhuoran on 12-11-28.
//
//

#import <UIKit/UIKit.h>
#import "FSWeatherView.h"
#define BUTTON_LENGTH 150
#define BUTTON_WIDTH 50
#define BUTTON_SPACE 10


@protocol FSNewSettingViewDelegate <NSObject>

@optional
-(void)weatherNewsViewButtonClick;
- (void)tappedInSettingView:(UIView *)settingView downloadButton:(UIButton *)button;//正文字号
- (void)tappedInSettingView:(UIView *)settingView nightModeButton:(UIButton *)button;//订阅中心
- (void)tappedInSettingView:(UIView *)settingView myCollectionButton:(UIButton *)button;//我的收藏
- (void)tappedInSettingView:(UIView *)settingView clearMemoryButton:(UIButton *)button;//清理内存
- (void)tappedInSettingView:(UIView *)settingView updateButton:(UIButton *)button;//检查更新

@end



@interface FSNewSettingView : UIView <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,FSNewSettingViewDelegate>{
@protected
    UIScrollView *scrollView;
}

-(void)weatherNewsViewButtonClick;
@property (nonatomic, assign, readwrite) id <FSNewSettingViewDelegate> delegate;
@property(nonatomic,retain)FSWeatherView  * fsWeatherView;
@property(nonatomic,retain)UITableView    * myTableView;
@property(nonatomic,retain)NSArray * dataObjectArry;
-(void)updataWeatherStatus;
@end
@interface settingDataObject : NSObject
{
    
}
@property(nonatomic,retain)UIImage*leftImage;
@property(nonatomic,retain)UIImage*leftHighLightedImage;
@property(nonatomic,copy)NSString * titleString;

@end
