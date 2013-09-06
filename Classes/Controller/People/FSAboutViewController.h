//
//  FSAboutViewController.h
//  PeopleNewsReaderPhone
//
//  Created by yuan lei on 12-8-31.
//  Copyright (c) 2012年 people. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSBaseDataViewController.h"
#import "FSBasePeopleViewController.h"
#import "FSBaseSettingViewController.h"
@class FSAboutContaierView;
 
@interface FSAboutViewController : FSBaseSettingViewController{
@protected
    FSAboutContaierView *_fsAboutContaierView;
}

@end
