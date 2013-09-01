//
//  MyIndicatorView.m
//  PeopleNewsReaderPhone
//
//  Created by lygn128 on 13-8-31.
//
//

#import "MyIndicatorView.h"

@implementation MyIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame withImage:(UIImage*)aImage
{
    if ([self initWithFrame:frame]) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:frame];
        imageView.tag           = 100;
        [self addSubview:imageView];
        [imageView release];
        imageView.image         = aImage;
    }
    return self;
}
-(void)startAnimations
{
    [self animation:YES];
}
-(void)animation:(BOOL)isYES
{
    [UIView beginAnimations:nil context:nil];
    [UIView animateWithDuration:0.1 animations:^{
        UIView * view = [self viewWithTag:100];
        view.transform =  CGAffineTransformRotate(view.transform, -15*10*M_1_PI/180);
    } completion:^(BOOL isYES){
        [self animation:YES];
    }];
    
    
    [UIView commitAnimations];
}
-(void)changeAngel
{
    NSLog(@"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
    UIView * view = [self viewWithTag:100];
    view.transform =  CGAffineTransformRotate(view.transform, -15*5*M_1_PI/180);
}
-(void)stopAnimations
{
    [_myTimer invalidate];
    _myTimer = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
