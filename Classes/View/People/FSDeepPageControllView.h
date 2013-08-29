//
//  FSDeepPageControllView.h
//  PeopleNewsReaderPhone
//
//  Created by ganzf on 13-1-16.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface FSDeepPageControllView : UIView{
@protected
    
    NSInteger _pageCount;
    NSInteger _pageIndex;

    UIImageView *_leftArrow;
    UIImageView *_rightArrow;
    
    UIImageView *_midleImage;
    

    UILabel *_lab_pageIndex;
    UILabel *_lab_pageCount;


}

@property (nonatomic) NSInteger pageCount;
@property (nonatomic) NSInteger pageIndex;
@property (nonatomic,assign) id delegate;
@property (nonatomic,retain)CAGradientLayer * gradientLayer;

-(void)layoutImages;

@end
@protocol FSDeepPageControllViewDelegate <NSObject>
-(void)onButtonClick:(int)index;
@end
