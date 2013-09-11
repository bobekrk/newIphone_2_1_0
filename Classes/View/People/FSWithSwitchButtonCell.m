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
    self.backgroundColor = COLOR_NEWSLIST_TITLE_WHITE;
    _swichButton = [[UISwitch alloc] init];
    self.textLabel.textColor = COLOR_NEWSLIST_TITLE;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        _swichButton.onTintColor = [UIColor colorWithRed:204.0/255.0 green:102.0/255 blue:102.0/255.0 alpha:1];
    }
    
    [_swichButton addTarget:self action:@selector(ButtonSelect:) forControlEvents:UIControlEventTouchUpInside];

    [self.contentView addSubview:_swichButton];
}

-(void)doSomethingAtLayoutSubviews{
    self.textLabel.text = (NSString *)_data;
    self.textLabel.backgroundColor = COLOR_CLEAR;
    _swichButton.frame = CGRectMake(self.frame.size.width - 105, 5, 20, 30);
    [self setButtonState];
}

-(void)setButtonState{
    switch (self.rowIndex) {
        case 0:
            [_swichButton setOn:[[GlobalConfig shareConfig] readImportantNewsPush]];
            break;
        case 1:
            [_swichButton setOn:[[GlobalConfig shareConfig] readContentFullScreen]];
            break;
        case 2:
            [_swichButton setOn:![[GlobalConfig shareConfig] isDownloadPictureUseing2G_3G]];
            break;
        default:
            break;
    }
}

-(void)ButtonSelect:(id)sender{
    UISwitch *b = (UISwitch *)sender;
    if (b.on == YES) {
        [self setYes:self.rowIndex];
        NSLog(@"ButtonSelect yes:%d",self.rowIndex);
    }
    else{
        [self setNO:self.rowIndex];
        NSLog(@"ButtonSelect OFF:%d",self.rowIndex);
    }
}

-(void)setYes:(NSInteger)row{
    switch (row) {
        case 0:
            [[GlobalConfig shareConfig] setImportantNewsPush:YES];
            //注册推送
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
            break;
        case 1:
            [[GlobalConfig shareConfig] setContentFullScreen:YES];
            break;
        case 2:
            [[GlobalConfig shareConfig] setDownloadPictureUseing2G_3G:NO];
            break;
        default:
            break;
    }
}

-(void)setNO:(NSInteger)row{
    switch (row) {
        case 0:
            [[GlobalConfig shareConfig] setImportantNewsPush:NO];
            //注销推送
            [[UIApplication sharedApplication] unregisterForRemoteNotifications];
            break;
        case 1:
            [[GlobalConfig shareConfig] setContentFullScreen:NO];
            break;
        case 2:
            [[GlobalConfig shareConfig] setDownloadPictureUseing2G_3G:YES];
            break;
        default:
            break;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
