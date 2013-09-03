//
//  LygDequeueScroView.m
//  PeopleNewsReaderPhone
//
//  Created by lygn128 on 13-9-2.
//
//

#import "LygDequeueScroView.h"

@implementation LygDequeueScroView

- (id)initWithFrame:(CGRect)frame adMyDelegate:(id)mydelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.pagingEnabled = YES;
        _myDelegate        = mydelegate;
        _lastPoint    = 0;
        if (_views == nil) {
            _views = [[NSMutableArray alloc]init];
            for (int i =0; i< 3; i++) {
                UIView * view = [_myDelegate myTableView:self cellForRowAtIndexPath:i];
                view.frame    = CGRectMake(i*320, 0, 320, self.frame.size.height);
                [self addSubview:view];
                [_views addObject:view];
            }
            _count = [_myDelegate  myTableView:self numberOfRowsInSection:0];
        }
    }
    return self;
}
-(id)init
{
    if (self = [super init]) {
        self.delegate = self;
        self.pagingEnabled = YES;
    }
    return self;
}

-(UIView *)dequeueResuableCellWithIdentifier:(NSString *)iDentifier
{
    UIView * tempView = nil;
    //int x = self.contentOffset.x;
    
    for (UIView * aView in _views) {
        if (aView.frame.origin.x  < self.contentOffset.x - 330 || aView.frame.origin.x > self.contentOffset.x + 330) {
            tempView = aView;
        }
    }
    return tempView;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int x         = self.contentOffset.x/320;
    UIView * view = [_myDelegate myTableView:self cellForRowAtIndexPath:x];
    if (view.superview) {
        CGRect rect = view.frame;
        if (self.contentOffset.x > _lastPoint) {
            rect.origin.x += 640;
        }else
        {
            rect.origin.x -= 640;
        }
        _lastPoint = self.contentOffset.x;
    }else
    {
        if (self.contentOffset.x > _lastPoint) {
            view.frame = CGRectMake(self.contentOffset.x + 320, 0, 320, self.frame.size.height);
        }else
        {
            view.frame = CGRectMake(self.contentOffset.x - 320, 0, 320, self.frame.size.height);
        }
        [self addSubview:view];
        _lastPoint = self.contentOffset.x;
    }
}

@end
