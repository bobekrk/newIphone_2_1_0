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
        self.clipsToBounds = YES;
        _myDelegate        = mydelegate;
        _lastPoint    = 0;
        if (_views == nil) {
            _views = [[NSMutableArray alloc]init];
            for (int i =0; i< 2; i++) {
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
            break;
        }
    }
    return tempView;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int x         = (self.contentOffset.x+1)/320;
    int oo        = (self.contentSize.width + 1 -320)/320;
    if (x == _currentIndex || x == 0 || x == oo) {
        return;
    }
    _currentIndex = x;
    int xxxxxxx   = -1000;
    if (self.contentOffset.x > _lastPoint) {
        xxxxxxx = 1;
    }else
    {
        xxxxxxx = -1;
    }
    int index = x + xxxxxxx;
    if (index == -1) {
        index = 0;
    }else if(index == oo + 1)
    {
        index = oo;
        
    }
    UIView * view = [_myDelegate myTableView:self cellForRowAtIndexPath:index];
    if (view.superview) {
        CGRect rect = view.frame;
        if (self.contentOffset.x > _lastPoint) {
            rect.origin.x += 960;
        }else
        {
            rect.origin.x -= 960;
        }
        view.frame = rect;
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
        [_views addObject:view];
        _lastPoint = self.contentOffset.x;
    }
}

@end
