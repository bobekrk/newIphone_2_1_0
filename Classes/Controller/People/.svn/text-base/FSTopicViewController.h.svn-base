//
//  FSTopicViewController.h
//  PeopleNewsReaderPhone
//
//  Created by people.com.cn on 12-8-13.
//  Copyright 2012 people.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSBasePeopleViewController.h"
#import "FSScrollPageView.h"
#import "FSDeepView.h"
#import "FSDeepFloatingTitleView.h"
#import "GlobalConfig.h"
#import "FSCommonFunction.h"
#import "FSTableView.h"
#import "LygDeepListView.h"
@class FS_GZF_DeepListDAO;

@interface FSTopicViewController : FSBasePeopleViewController <FSScrollPageViewPageDelegate,LygDeepListViewDelegate,UIScrollViewDelegate>{
    //FS_GZF_DeepListDAO          *_fs_GZF_DeepListDAO;
    
    //有图模式组件
    FSScrollPageView            *_scrollPageView;
    
    FSDeepFloatingTitleView     *_deepFloattingTitleView;
    
    //无图模式
    
    NSTimeInterval _TimeInterval;
}
@property(nonatomic,retain)LygDeepListView * myDeepListView;
@property(nonatomic,assign)BOOL              isListStyle;
@property(nonatomic,retain)FS_GZF_DeepListDAO * fs_GZF_DeepListDAO;
@end
