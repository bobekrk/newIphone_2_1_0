//
//  FSWithSwitchButtonCell.m
//  PeopleNewsReaderPhone
//
//  Created by yuan lei on 12-9-14.
//  Copyright (c) 2012年 people. All rights reserved.
//

#import "FSWithSwitchButtonCell.h"
#import "GlobalConfig.h"

@implementation FSWithSwitchButtonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}



-(void)doSomethingAtDealloc{
    [_swichButton release];
}

-(void)doSomethingAtInit{
    //self.backgroundColor = COLOR_NEWSLIST_TITLE_WHITE;
    self.backgroundColor = [UIColor clearColor];
    _swichButton = [[UISwitch alloc] init];
    self.textLabel.textColor = COLOR_NEWSLIST_TITLE;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        _swichButton.onTintColor = [UIColor colorWithRed:204.0/255.0 green:102.0/255 blue:102.0/255.0 alpha:1];
    }
    
    [_swichButton addTarget:self action:@selector(ButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    //[_swichButton addObserver:self forKeyPath:@"on" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

    [self.contentView addSubview:_swichButton];
}
//-(void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
//{
//    if ([keyPath isEqualToString:@"seton"]) {
//        [self performSelector:@selector(xxxx) withObject:nil afterDelay:0.1 inModes:nil];
//    }
//}
-(void)xxxx
{
    
}

-(void)doSomethingAtLayoutSubviews{
    self.textLabel.text = (NSString *)_data;
    self.textLabel.backgroundColor = COLOR_CLEAR;
    self.textLabel.font = [UIFont boldSystemFontOfSize:16];
    self.textLabel.autoresizingMask = UIViewAutoresizingNone;
    _swichButton.frame = CGRectMake(self.frame.size.width - 105, 5, 20, 30);
    [self setButtonState];
}

-(void)setButtonState{

    NSString * string = self.textLabel.text;
    if ([string isEqualToString:@"新闻推送"]) {
        [_swichButton setOn:[[GlobalConfig shareConfig] readImportantNewsPush]];

        
    }else if ([string isEqualToString:@"正文全屏功能"])
    {
        [_swichButton setOn:[[GlobalConfig shareConfig] readContentFullScreen]];

    }else if ([string hasPrefix:@"只"])
    {
         [_swichButton setOn:![[GlobalConfig shareConfig] isDownloadPictureUseing2G_3G]];
    }
}

-(void)ButtonSelect:(id)sender{
    UISwitch *b = (UISwitch *)sender;
    [self setSetting:b.on];
}
-(void)setSetting:(BOOL)isOn
{
    NSString * string = self.textLabel.text;
    if ([string isEqualToString:@"新闻推送"]) {
        [[GlobalConfig shareConfig] setImportantNewsPush:isOn];
        if (!isOn) {
             [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        }
    
    }else if ([string isEqualToString:@"正文全屏功能"])
    {
        [[GlobalConfig shareConfig] setContentFullScreen:isOn];
    }else if ([string hasPrefix:@"只"])
    {
        [[GlobalConfig shareConfig] setDownloadPictureUseing2G_3G:!isOn];
    }
}

//-(void)setYes:(NSInteger)row{
//    switch (row) {
//        case 0:
//            [[GlobalConfig shareConfig] setImportantNewsPush:YES];
//            //注册推送
//            [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
//            break;
//        case 1:
//            [[GlobalConfig shareConfig] setContentFullScreen:YES];
//            break;
//        case 2:
//            [[GlobalConfig shareConfig] setDownloadPictureUseing2G_3G:NO];
//            break;
//        default:
//            break;
//    }
//}
//
//-(void)setNO:(NSInteger)row{
////    switch (row) {
////        case 0:
////            [[GlobalConfig shareConfig] setImportantNewsPush:NO];
////            //注销推送
////            [[UIApplication sharedApplication] unregisterForRemoteNotifications];
////            break;
////        case 1:
////            [[GlobalConfig shareConfig] setContentFullScreen:NO];
////            break;
////        case 2:
////            [[GlobalConfig shareConfig] setDownloadPictureUseing2G_3G:YES];
////            break;
////        default:
////            break;
////    }
//    NSString * string = self.textLabel.text;
//    if ([string isEqualToString:@"新闻推送"]) {
//        <#statements#>
//    }
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
