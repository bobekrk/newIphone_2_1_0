//
//  MyIndicatorView.h
//  PeopleNewsReaderPhone
//
//  Created by lygn128 on 13-8-31.
//
//

#import <UIKit/UIKit.h>

@interface MyIndicatorView : UIView
@property(nonatomic,retain)NSTimer * myTimer;
-(id)initWithFrame:(CGRect)frame withImage:(UIImage*)aImage;
-(void)startAnimations;
-(void)stopAnimations;

@end
