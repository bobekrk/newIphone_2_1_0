//
//  LygDeepTableViewCell.m
//  PeopleNewsReaderPhone
//
//  Created by lygn128 on 13-8-27.
//
//

#import "LygDeepTableViewCell.h"
#import "FSTopicObject.h"
#import "FSCommonFunction.h"
#import <QuartzCore/QuartzCore.h>
#import "LygDeepListView.h"
@implementation LygDeepTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //[self otherInitCode];
    }
    return self;
}

-(void)doSomethingAtDealloc{
    
//    [_lab_NewsTitle release];
//    [_lab_NewsDescription release];
//    [_lab_NewsType release];
//    //   [_lab_VisitVolume release];
//    
//    //   [_image_Footprint release];
//    [_image_Onright release];
    
}

-(void)otherInitCode
{
    self.contentView.backgroundColor = [UIColor lightGrayColor];
    NSLog(@"%f",self.frame.size.height);
    UIView * view   = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 310, self.contentView.frame.size.height - 10)];
    view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    view.tag        = 100;
    [self.contentView addSubview:view];
    [view release];
    
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.backgroundColor = [UIColor whiteColor];
    
    
    _kindsLabel            = [[UILabel alloc] initWithFrame:CGRectMake(8, 6, 42, 21)];
    _kindsLabel.font       = [UIFont systemFontOfSize:8];
    _kindsLabel.textColor  = [UIColor redColor];
    _kindsLabel.textAlignment = NSTextAlignmentCenter;
    _kindsLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    
    _nameLabel             = [[UILabel alloc] initWithFrame:CGRectMake(58,0, 232, 34)];
    _nameLabel.font        = [UIFont systemFontOfSize:17];
    _nameLabel.textColor   = [UIColor blackColor];
    
    
    _dateLabel             = [[UILabel alloc] initWithFrame:CGRectMake(280, 27, 40, 21)];
    _dateLabel.font        = [UIFont systemFontOfSize:14];
    _dateLabel.textColor   = [UIColor lightGrayColor];
    
    
    _abstractLabel               = [[UILabel alloc] initWithFrame:CGRectMake(8, 48, 295, 61)];
    _abstractLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    _abstractLabel.font          = [UIFont systemFontOfSize:DEEPABSTRACTFONTSIZE];
    _abstractLabel.numberOfLines = 0;
    _dateLabel.textColor   = [UIColor lightGrayColor];
    
    
    
    [view addSubview:_kindsLabel];
    [view addSubview:_nameLabel];
    [view addSubview:_dateLabel];
    [view addSubview:_abstractLabel];
    
    
    [_kindsLabel     release];
    [_nameLabel      release];
    [_dateLabel      release];
    [_abstractLabel  release];
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

-(void)doSomethingAtInit{
    self.contentView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    NSLog(@"%f",self.frame.size.height);
    UIView * view   = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 310, self.contentView.frame.size.height - 10)];
    view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    view.tag        = 100;
    [self.contentView addSubview:view];
    [view release];
    
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor;
    view.backgroundColor = [UIColor whiteColor];
    
    
    _kindsLabel            = [[UILabel alloc] initWithFrame:CGRectMake(8, 20, 50, 21)];
    _kindsLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _kindsLabel.layer.borderWidth = 1;
    _kindsLabel.font       = [UIFont systemFontOfSize:10];
    _kindsLabel.textColor  = [UIColor redColor];
    
    
    
    _nameLabel             = [[UILabel alloc] initWithFrame:CGRectMake(58,0, 232, 34)];
    _nameLabel.font        = [UIFont systemFontOfSize:17];
    _nameLabel.textColor   = [UIColor blackColor];
    
    
    _dateLabel             = [[UILabel alloc] initWithFrame:CGRectMake(280, 27, 40, 21)];
    _dateLabel.font        = [UIFont systemFontOfSize:14];
    _dateLabel.textColor   = [UIColor lightGrayColor];
    
    
    _abstractLabel               = [[UILabel alloc] initWithFrame:CGRectMake(8, 48, 295, 61)];
    _abstractLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    _abstractLabel.font          = [UIFont systemFontOfSize:DEEPABSTRACTFONTSIZE];
    _abstractLabel.numberOfLines = 0;
    _abstractLabel.textColor   = [UIColor grayColor];
    
    _timerImageView            = [[UIImageView alloc]init];
    _timerImageView.image      = [UIImage imageWithNameString:@"时钟"];
    
    [view addSubview:_kindsLabel];
    [view addSubview:_nameLabel];
    [view addSubview:_dateLabel];
    [view addSubview:_abstractLabel];
    [view addSubview:_timerImageView];
    
    
    [_kindsLabel     release];
    [_nameLabel      release];
    [_dateLabel      release];
    [_abstractLabel  release];
    [_timerImageView release];
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setDayPattern:(BOOL)is_day{
    NSLog(@"setDayPattern");
}


-(void)doSomethingAtLayoutSubviews{
    NSLog(@"%f",self.frame.size.height);
    UIView * view      = [self.contentView viewWithTag:100];
    view.frame         =  CGRectMake(7, 7, 306, self.contentView.frame.size.height - 7);
    self.clipsToBounds = YES;
    self.contentView.clipsToBounds = YES;
    _kindsLabel.textAlignment = NSTextAlignmentCenter;
    _kindsLabel.numberOfLines = 0;
    _kindsLabel.Frame  = CGRectMake(8, 12, 0, 15);
    [_kindsLabel sizeToFit];
    _nameLabel.Frame   = CGRectMake(_kindsLabel.frame.size.width + 8 + 12,0, 220, 34);
    _abstractLabel.Frame = CGRectMake(8, 45 - 15, 295, view.frame.size.height - 48);
    _dateLabel.Frame     = CGRectMake(222, self.frame.size.height - 30, 300 - 222, 21);
    _timerImageView.frame= CGRectMake(222 - 20, self.frame.size.height - 30 + 3, 15, 15);
}

-(NSString *)timeTostring:(NSNumber *)time{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    NSString *hm = dateToString_HM(date);
    
    return hm;
}




//*******************************

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
