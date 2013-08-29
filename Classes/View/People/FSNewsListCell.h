//
//  FSNewsListCell.h
//  PeopleNewsReaderPhone
//
//  Created by yuan lei on 12-8-2.
//  Copyright (c) 2012年 people. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTableViewCell.h"


@class FSAsyncImageView;

@interface FSNewsListCell : FSTableViewCell{
@protected
    UILabel          *_lab_NewsTitle;
    UILabel          *_lab_NewsType;
    FSAsyncImageView *_image_Onright;

    
}
@property(nonatomic,retain)UILabel * lab_NewsTitle;
-(BOOL)isDownloadPic;
-(NSString *)timeTostring:(NSNumber *)time;
@property(nonatomic,retain)UIView * leftView;

@end
