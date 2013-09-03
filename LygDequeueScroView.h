//
//  LygDequeueScroView.h
//  PeopleNewsReaderPhone
//
//  Created by lygn128 on 13-9-2.
//
//

#import <UIKit/UIKit.h>

@interface LygDequeueScroView : UIScrollView<UIScrollViewDelegate>
{
    id  _myDelegate;
    int _numOfRows;
    NSMutableArray * _views;
    int _lastPoint;
    int _count;
    int _currentIndex;
}
-(UIView *)dequeueResuableCellWithIdentifier:(NSString *)iDentifier;
- (id)initWithFrame:(CGRect)frame adMyDelegate:(id)mydelegate;
@end

@protocol LygDequeueScroViewDelegate <NSObject>
@required

- (NSInteger)myTableView:(LygDequeueScroView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UIView *)myTableView:(LygDequeueScroView *)tableView cellForRowAtIndexPath:(int)index;
//- (float)tableView:(LygDequeueScroView *)tableView widthForView;
@end
