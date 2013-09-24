//
//  FSIndicatorMessageView.h
//  PeopleNewsReaderPhone
//
//  Created by people.com.cn on 12-8-8.
//  Copyright 2012 people.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface FSIndicatorMessageView : UIView {
@private
//	CALayer *_backgroundLayer;
	
	UILabel *_lblMessage;
	UIActivityIndicatorView *_indicator;
    BOOL    *_isNewsView;
	
}

- (void)showIndicatorMessageViewInView:(UIView *)parentView withMessage:(NSString *)message;
+ (FSIndicatorMessageView *)getIndicatorMessageViewInView:(UIView *)parentView;
+ (BOOL)dismissIndicatorMessageViewInView:(UIView *)parentView;
+ (void)layoutIndicatorMessageViewInView:(UIView *)parentView;
-(id)initWithFrame:(CGRect)frame andBool:(BOOL)isNewsView;


@end
