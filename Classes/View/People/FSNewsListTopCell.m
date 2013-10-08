//
//  FSNewsListTopCell.m
//  PeopleNewsReaderPhone
//
//  Created by yuan lei on 12-9-18.
//  Copyright (c) 2012年 people. All rights reserved.
//

#import "FSNewsListTopCell.h"
#import "FSNewsListTopCellTextFloatView.h"
#import "FSFocusTopObject.h"
#import "FSCommonFunction.h"
#import "LygAdsLoadingImageObject.h"
#define VISITICON_BEGIN_X 220.0f

@implementation FSNewsListTopCell

@synthesize typeMark = _typeMark;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)doSomethingAtDealloc{
    
    [_lab_time release];
    [_fsNewsListTopCellTextFloatView release];
    [_fsImagesScrInRowView release];
    [_lab_NewsType release];
    [_lab_VVBackground release];

}


-(void)doSomethingAtInit{

    _typeMark = 0;
    
    _lab_VVBackground = [[UILabel alloc] init];
    _lab_VVBackground.backgroundColor = COLOR_BLACK;
    _lab_VVBackground.alpha = 0.0;
    
    
    _fsImagesScrInRowView = [[FSImagesScrInRowView alloc] init];
    _fsImagesScrInRowView.parentDelegate = self;
    
    _lab_NewsType = [[UILabel alloc] init];

    
    [self.contentView addSubview:_fsImagesScrInRowView];
    [self.contentView addSubview:_lab_VVBackground];
    [self.contentView addSubview:_lab_NewsType];

    
    
    _lab_NewsType.backgroundColor = COLOR_CLEAR;
    _lab_NewsType.textColor = COLOR_NEWSLIST_TITLE_WHITE;
    _lab_NewsType.textAlignment = UITextAlignmentLeft;
    _lab_NewsType.numberOfLines = 1;
    _lab_NewsType.font = [UIFont systemFontOfSize:14];
    

    _lab_time = [[UILabel alloc] init];
    _lab_time.alpha = 0.0f;
    _fsNewsListTopCellTextFloatView = [[FSNewsListTopCellTextFloatView alloc] init];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setContent{
//    _image_Footprint.alpha = 1.0;
//    _lab_VisitVolume.alpha = 1.0;
    _lab_NewsType.alpha = 1.0;
    //_lab_VisitVolume.text = @"33";
    //_lab_NewsType.text = @"专题";
    _lab_time.font = [UIFont systemFontOfSize:12];
    _lab_time.backgroundColor = COLOR_CLEAR;
    //_lab_time.text = @"2012-9-28";
    
    if ([_fsImagesScrInRowView.objectList count]>0) {
        FSFocusTopObject *o = [_fsImagesScrInRowView.objectList objectAtIndex:0];
        _fsNewsListTopCellTextFloatView.data = o;
        
 //       _lab_VisitVolume.text = [NSString stringWithFormat:@"%d",[o.browserCount integerValue]];
        if ([o.title length]>16) {
            _lab_NewsType.text = [o.title substringToIndex:16];
        }
        else{
            _lab_NewsType.text = o.title;
        }

        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[o.timestamp doubleValue]];
        _lab_time.text = dateToString_YMD(date);
        
    }
    
}

-(void)setCellKind{
    
}

-(void)doSomethingAtLayoutSubviews{
    [self setCellKind];
    NSLog(@"_rowIndex:%d",_rowIndex);
        
    _fsImagesScrInRowView.frame = CGRectMake(0, 0, self.frame.size.width, ROUTINE_NEWS_LIST_TOP_HEIGHT);
    _fsImagesScrInRowView.imageSize = CGSizeMake(self.frame.size.width, ROUTINE_NEWS_LIST_TOP_HEIGHT);
    _fsImagesScrInRowView.pageControlViewShow = YES;
    _fsImagesScrInRowView.spacing = 0.0;
    _fsImagesScrInRowView.bottonHeigh = ROUTINE_NEWS_LIST_TOP_BOTTOM_HEIGHT;
    _fsImagesScrInRowView.objectList =  (NSArray *)_data;
    
    _fsNewsListTopCellTextFloatView.frame = CGRectMake(0, self.frame.size.height- ROUTINE_NEWS_LIST_TOP_TITLE_HEIGHT - ROUTINE_NEWS_LIST_TOP_BOTTOM_HEIGHT,self.frame.size.width, ROUTINE_NEWS_LIST_TOP_TITLE_HEIGHT);
    
//    _image_Footprint.frame = CGRectMake(VISITICON_BEGIN_X-5, self.frame.size.height - 11-9, 11, 11);
//    
//    _lab_VisitVolume.frame = CGRectMake(VISITICON_BEGIN_X+9, self.frame.size.height - TODAYNEWSLIST_TOP_BOTTOM_HEIGHT, self.frame.size.width, TODAYNEWSLIST_TOP_BOTTOM_HEIGHT);
    _lab_NewsType.frame = CGRectMake(4, self.frame.size.height - TODAYNEWSLIST_TOP_BOTTOM_HEIGHT, self.frame.size.width, TODAYNEWSLIST_TOP_BOTTOM_HEIGHT);
    
    _lab_VVBackground.frame = CGRectMake(0, self.frame.size.height - 42, self.frame.size.width - 156, ROUTINE_NEWS_LIST_TOP_BOTTOM_HEIGHT);
    
    
    
    //_lab_time.frame = CGRectMake(10, self.frame.size.height - ROUTINE_NEWS_LIST_TOP_TIME_BUTTON, self.frame.size.width - 20, ROUTINE_NEWS_LIST_TOP_TIME_BUTTON);
    
    [self setContent];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fsBaseContainerViewTouchEvent:(FSBaseContainerView *)sender{
    FSImagesScrInRowView *o = (FSImagesScrInRowView *)sender;
    if (o.isMove) {
        if ([_fsImagesScrInRowView.objectList count]>o.imageIndex) {
            id ooo = [_fsImagesScrInRowView.objectList objectAtIndex:o.imageIndex];
            if ([ooo isKindOfClass:[FSFocusTopObject class]]) {
            
                FSFocusTopObject *oo = ooo;
                _fsNewsListTopCellTextFloatView.data = oo;
                
                //            _lab_VisitVolume.text = [NSString stringWithFormat:@"%d",[oo.browserCount integerValue]];
                if ([oo.title length]>16) {
                    _lab_NewsType.text = [oo.title substringToIndex:16];
                }
                else{
                    _lab_NewsType.text = oo.title;
                }
                
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:[oo.timestamp doubleValue]];
                _lab_time.text = dateToString_YMD(date);
            }
            else
            {
                LygAdsLoadingImageObject *oo = ooo;
                _fsNewsListTopCellTextFloatView.data = oo;
                
                //            _lab_VisitVolume.text = [NSString stringWithFormat:@"%d",[oo.browserCount integerValue]];
                if ([oo.adTitle length]>16) {
                    _lab_NewsType.text = [oo.adTitle substringToIndex:16];
                }
                else{
                    _lab_NewsType.text = oo.adTitle;
                }
                
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:[oo.adCtime doubleValue]];
                _lab_time.text = dateToString_YMD(date);
            }

            
        }
    }
    else{
        NSLog(@"touch");
        if ([_fsImagesScrInRowView.objectList count]>o.imageIndex) {
            if ([_parentDelegate respondsToSelector:@selector(tableViewCellPictureTouched:)]) {
                [_parentDelegate tableViewCellPictureTouched:o.imageIndex];
            }
        }
    }
}


@end
