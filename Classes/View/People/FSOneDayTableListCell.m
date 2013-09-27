//
//  FSOneDayTableListCell.m
//  PeopleNewsReaderPhone
//
//  Created by yuan lei on 12-9-4.
//  Copyright (c) 2012年 people. All rights reserved.
//

#import "FSOneDayTableListCell.h"
#import <CoreData/CoreData.h>
#import "FSCommonFunction.h"
#import "GlobalConfig.h"
#import "FSOneDayNewsObject.h"
#import "FSBaseDB.h"
#import "FSChannelObject.h"
//#import <UIStringDrawing.h>
#import <UIKit/UIStringDrawing.h>


#define move_down_space 13.0f


@implementation FSOneDayTableListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)doSomethingAtDealloc{

    [_lab_title release];
    [_image_Icon release];
    [_image_channelIcon release];
    [_image_newsimage release];

    [_lineView release];
    [_oneday_eastImage release];
}

-(void)doSomethingAtInit{
    [self.contentView removeFromSuperview];
    self.contentView.backgroundColor = COLOR_NEWSLIST_TITLE_WHITE;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    

    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithRed:199.0f/255.0f green:199.0f/255.0f blue:199.0f/255.0f alpha:1.0];
    
    _oneday_eastImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"oneday_east.png"]];
    
    [self addSubview:_lineView];
    [self addSubview:_oneday_eastImage];
    


    
    _image_channelIcon = [[FSAsyncImageView alloc] init];
    _image_channelIcon.borderColor = COLOR_CLEAR;
    [self addSubview:_image_channelIcon];

    _image_newsimage = [[FSAsyncImageView alloc] init];
    [self addSubview:_image_newsimage];
    
    
    _image_Icon = [[UIImageView alloc] init];
    _image_Icon.tag = arc4random();
     _image_Icon.backgroundColor = [UIColor whiteColor];
    //[self.contentView addSubview:_image_Icon];
    
    _lab_title = [[UILabel alloc] init];
    _lab_title.backgroundColor = COLOR_CLEAR;
    _lab_title.textColor = COLOR_NEWSLIST_TITLE;
    _lab_title.font = [UIFont systemFontOfSize:TODAYNEWSLIST_TITLE_FONT];
    _lab_title.textAlignment = UITextAlignmentLeft;
    _lab_title.userInteractionEnabled = NO;
    [self addSubview:_lab_title];
    
}
static void drawRoundCornerRect(CGContextRef context,CGRect aRect,CGFloat corneRadius,CGFloat lineWindth)
{
    CGContextMoveToPoint(context, aRect.origin.x + corneRadius, aRect.origin.y);
    CGContextAddLineToPoint(context, aRect.origin.x - corneRadius + aRect.size.width , aRect.origin.y);
    
    CGContextAddArcToPoint(context, aRect.origin.x  + aRect.size.width , aRect.origin.y, aRect.origin.x + aRect.size.width, aRect.origin.y + corneRadius,corneRadius);
    
    CGContextAddArcToPoint(context,aRect.origin.x + aRect.size.width ,aRect.origin.y + aRect.size.height  ,aRect.origin.x  + aRect.size.width - corneRadius, aRect.origin.y + aRect.size.height,corneRadius);
    
    

     CGContextAddLineToPoint(context, aRect.origin.x + corneRadius , aRect.origin.y + aRect.size.height);
    CGContextAddArcToPoint(context,aRect.origin.x ,aRect.origin.y + aRect.size.height  ,aRect.origin.x , aRect.origin.y + aRect.size.height -corneRadius,corneRadius);

    CGContextAddLineToPoint(context, aRect.origin.x , aRect.origin.y + corneRadius);
    CGContextAddArcToPoint(context,aRect.origin.x ,aRect.origin.y ,aRect.origin.x +corneRadius, aRect.origin.y ,corneRadius);
    
    CGContextStrokePath(context);

    
    
}
-(void)drawRect:(CGRect)rect
{
    
    CGRect tempRect      = CGRectMake(6, 4, self.frame.size.width - 12, self.frame.size.height - 8);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(context, 170.0/255, 170.0/255, 170.0/255, 1);
    CGContextSetLineWidth(context, 2);
    CGContextMoveToPoint(context, 27, 0);
    CGContextAddLineToPoint(context, 27, self.frame.size.height);

    CGContextStrokePath(context);
    
    
    CGContextSetRGBFillColor(context, 1, 1.0, 1.0, 1.0);
    //填充矩形
    CGContextFillRect(context, tempRect);

    
    CGContextSetRGBStrokeColor(context, 0.5, 0, 0, 1);
    CGContextSetLineWidth(context, 0.5);
    drawRoundCornerRect(context, tempRect, 3, 2);
    
       //执行绘画
    CGContextStrokePath(context);
    

    
    
    //_cellLeftLine.frame = CGRectMake(26.0f, 0, 2.0f, self.frame.size.height);
    
    CGRect tempRect2;
    if ([_image_newsimage.urlString length]>0 && [self isDownloadPic]) {
        FSOneDayNewsObject *o = (FSOneDayNewsObject *)_data;
        //tempRect2 = CGRectMake(46, 28 + move_down_space, self.frame.size.width - 128 + 5, self.frame.size.height -28);
        CGSize size = [o.news_abstract sizeWithFont:[UIFont systemFontOfSize:TODAYNEWSLIST_DESCRIPTION_FONT] constrainedToSize:CGSizeMake(320 - 128 + 5, 300) lineBreakMode:UILineBreakModeWordWrap];
        if (size.height > 57) {
            tempRect2 = CGRectMake(46, 28 + move_down_space, self.frame.size.width - 128 + 5, self.frame.size.height -28);
        }else
        {
            tempRect2 = CGRectMake(46, 28 + move_down_space - (size.height - 57)/2, self.frame.size.width - 128 + 5, self.frame.size.height -28);
        }
    }
    else{
        tempRect2 = CGRectMake(46, 28 + move_down_space, self.frame.size.width - 50-25, self.frame.size.height -28);
        //[o.news_abstract drawInRect:_lab_description.frame withFont:[UIFont systemFontOfSize:14] lineBreakMode:UILineBreakModeWordWrap];
        
    }

    
    CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
    FSOneDayNewsObject *o = (FSOneDayNewsObject *)_data;
    [o.news_abstract drawInRect:tempRect2 withFont:[UIFont systemFontOfSize:TODAYNEWSLIST_DESCRIPTION_FONT] lineBreakMode:UILineBreakModeWordWrap];
    
    

    
}

-(void)setContainer{
    
    FSOneDayNewsObject *o = (FSOneDayNewsObject *)_data;
    
    if (o==nil) {
        _lab_title.text = @"数据出问题了啦！";
        return;
    }
    
    
    _image_channelIcon.defaultFileName = @"人.png";
    if ([o.channalIcon length]>0) {
        _image_channelIcon.urlString = o.channalIcon;//@"http://mobile.app.people.com.cn:81/news2/images/channel/selected/1_18_2.png";
        _image_channelIcon.imageCuttingKind = ImageCuttingKind_fixrect;
        _image_channelIcon.localStoreFileName = getFileNameWithURLString(o.channalIcon, getCachesPath());
    }
    else{
        ;
    }
    
    if ([o.picture length]>0 && [self isDownloadPic]) {
        _image_newsimage.urlString = o.picture;
        _image_newsimage.localStoreFileName = getFileNameWithURLString(o.picture, getCachesPath());
        _image_newsimage.imageCuttingKind = ImageCuttingKind_fixrect;
    }else{
        _image_newsimage.urlString = @"";
    }
    

    _lab_title.text = o.title;

}


-(void)doSomethingAtLayoutSubviews{
    [self setContainer];
    //_cellLeftLine.frame = CGRectMake(26.0f, 0, 2.0f, self.frame.size.height);
    
    _image_channelIcon.frame = CGRectMake(13, 9, 30, 30);
    [_image_channelIcon updateAsyncImageView];
    
    
    

    _lineView.frame = CGRectMake(44, 34, self.frame.size.width - 56, 1);
    
    _oneday_eastImage.frame = CGRectMake(self.frame.size.width - 25, 15 + 3, 6, 8);
    if ([_image_newsimage.urlString length]>0 && [self isDownloadPic]) {
        
        FSOneDayNewsObject *o = (FSOneDayNewsObject *)_data;
        //tempRect2 = CGRectMake(46, 28 + move_down_space, self.frame.size.width - 128 + 5, self.frame.size.height -28);
        CGSize size = [o.news_abstract sizeWithFont:[UIFont systemFontOfSize:TODAYNEWSLIST_DESCRIPTION_FONT] constrainedToSize:CGSizeMake(320 - 128 + 5, 300) lineBreakMode:UILineBreakModeWordWrap];
        
        if (size.height < 57) {
            ///_image_newsimage.frame = CGRectMake(46 + self.frame.size.width - 128 + 5, 38+move_down_space -8 , 57, 57);
            _image_newsimage.frame = CGRectMake(46 + self.frame.size.width - 128 + 5, 28 + move_down_space, 57, 57);
            //tempRect2 = CGRectMake(46, 28 + move_down_space - (size.height - 57)/2, self.frame.size.width - 128 + 5, self.frame.size.height -28);
        }else
        {
            _image_newsimage.frame = CGRectMake(46 + self.frame.size.width - 128 + 5, 28 + move_down_space + (size.height - 57)/2, 57, 57);
        }
        
        _image_newsimage.alpha = 1.0f;
        
        
        
        [_image_newsimage updateAsyncImageView];
        //_lab_title.frame = CGRectMake(45, 6, self.frame.size.width - 46 - 25, 28);
    }
    else{
        _image_newsimage.alpha = 0.0f;
        
    }
    _lab_title.frame = CGRectMake(45, 8, self.frame.size.width - 50, 28);
}


-(BOOL)isDownloadPic{
    
    BOOL rest = NO;
    
    if (![[GlobalConfig shareConfig] isSettingDownloadPictureUseing2G_3G]) {
        //NSLog(@"isSettingDownloadPictureUseing2G_3G");
        rest = YES;
        return rest;
    }
    
    if ([[GlobalConfig shareConfig] isDownloadPictureUseing2G_3G]) {
        //NSLog(@"isDownloadPictureUseing2G_3G");
        rest = YES;
    }
    else{
        if (!checkNetworkIsOnlyMobile()) {
            //NSLog(@"checkNetworkIsOnlyMobile yes");
            rest = YES;
        }
        else{
            //NSLog(@"checkNetworkIsOnlyMobile no");
        }
    }
    return rest;
}

//*******************************
+(CGFloat)computCellHeight:(NSObject *)cellData cellWidth:(CGFloat)cellWidth{
     FSOneDayNewsObject *o = (FSOneDayNewsObject *)cellData;
    if (o!=nil) {
        if ([o.picture length]>0) {
            CGSize size = [o.news_abstract sizeWithFont:[UIFont systemFontOfSize:TODAYNEWSLIST_DESCRIPTION_FONT] constrainedToSize:CGSizeMake(320 - 128 + 5, 300) lineBreakMode:UILineBreakModeWordWrap];
            return (size.height > 57?size.height:57) + 60 ;
        }
        else{
            CGSize size = [o.news_abstract sizeWithFont:[UIFont systemFontOfSize:TODAYNEWSLIST_DESCRIPTION_FONT] constrainedToSize:CGSizeMake(320 - 50 - 25, 300) lineBreakMode:UILineBreakModeWordWrap];
            return size.height + 60 ;
        }
    }
    return 44;
}

@end
