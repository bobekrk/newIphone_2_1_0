//
//  FSWeatherView.m
//  PeopleNewsReaderPhone
//
//  Created by yuan lei on 12-8-6.
//  Copyright (c) 2012年 people. All rights reserved.
//

#import "FSWeatherView.h"
#import "FSConst.h"
#import "FSAsyncImageView.h"
#import "FSCommonFunction.h"


#import "FSWeatherObject.h"

#define CITYNAME_FRONT_SIZE 18.0f
#define TEMPERATURE_FRONT_SIZE 35.0f


@implementation FSWeatherView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)doSomethingAtDealloc{
}


-(void)doSomethingAtInit{
    _image_WeatherIcon = [[UIImageView alloc] init];
    _lab_CityName = [[UILabel alloc] init];
    _lab_Temperature = [[UILabel alloc] init];
    _dateLabel       = [[UILabel alloc]init];
    
    [self addSubview:_image_WeatherIcon];
    [self addSubview:_lab_CityName];
    [self addSubview:_lab_Temperature];
    [self addSubview:_dateLabel];
    [_image_WeatherIcon release];
    [_lab_CityName release];
    [_lab_Temperature release];
    [_dateLabel release];

    [self initializationVariable];
}


-(void)doSomethingAtLayoutSubviews{
    if (self.data==nil) {
        return;
    }
    [self setContent];
    _image_WeatherIcon.frame = CGRectMake(0, 11, self.frame.size.height-8, self.frame.size.height-8);
    
    _lab_CityName.frame = CGRectMake(self.frame.size.height, 15, self.frame.size.width-self.frame.size.height + 16, self.frame.size.height/2-10);
    _lab_Temperature.frame = CGRectMake(self.frame.size.height, self.frame.size.height/2 - 3, self.frame.size.width-self.frame.size.height+8, self.frame.size.height/2-10);
    _dateLabel.frame    = CGRectMake(-35, 0, 200, 25);
    
}


-(void)initializationVariable{
    _lab_CityName.backgroundColor = COLOR_CLEAR;
    //_lab_CityName.textColor = COLOR_NEWSLIST_CHANNEL_TITLE;
    _lab_CityName.textColor   = [UIColor darkGrayColor];
    _lab_CityName.textAlignment = UITextAlignmentLeft;
    _lab_CityName.numberOfLines = 1;
    _lab_CityName.font = [UIFont systemFontOfSize:CITYNAME_FRONT_SIZE];
    
    _lab_Temperature.backgroundColor = COLOR_CLEAR;
    //_lab_Temperature.textColor = COLOR_NEWSLIST_CHANNEL_TITLE;
    _lab_Temperature.textColor = [UIColor blackColor];
    _lab_Temperature.textAlignment = UITextAlignmentLeft;
    _lab_Temperature.numberOfLines = 1;
    _lab_Temperature.font = [UIFont systemFontOfSize:TEMPERATURE_FRONT_SIZE];
    _dateLabel.textColor  = [UIColor grayColor];
    _dateLabel.font       = [UIFont systemFontOfSize:14];
    _dateLabel.backgroundColor = [UIColor clearColor];
}
-(NSString *)FromeDateFormat:(NSDate *)date{
    
    NSTimeInterval timeInterval_day = 60*60*24;
    
    NSDate *nextDay_date = [NSDate dateWithTimeInterval:timeInterval_day sinceDate:date];
    
    
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:nextDay_date];
    
    
    localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSString *key_str = [NSString stringWithFormat:@"%d月%d日",localeComp.month,localeComp.day];
    [localeCalendar release];
    return key_str;
}


-(NSString *)getCHineseDate:(NSDate *)date{
    
    
    NSTimeInterval timeInterval_day = 60*60*24;
    
    NSDate *nextDay_date = [NSDate dateWithTimeInterval:timeInterval_day sinceDate:date];
    
    
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:nextDay_date];
    
    if ( 1 == localeComp.month && 1 == localeComp.day ) {
        
        [localeCalendar release];
        
        return @"农历除夕";
    }
    
    
    
    NSDictionary *chineseHoliDay = [NSDictionary dictionaryWithObjectsAndKeys:
                                    
                                    @"春节", @"1-1",
                                    
                                    @"元宵", @"1-15",
                                    
                                    @"端午", @"5-5",
                                    
                                    @"七夕", @"7-7",
                                    
                                    @"中元", @"7-15",
                                    
                                    @"中秋", @"8-15",
                                    
                                    @"重阳", @"9-9",
                                    
                                    @"腊八", @"12-8",
                                    
                                    @"小年", @"12-24",
                                    
                                    nil];
    
    localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSString *key_str = [NSString stringWithFormat:@"%d-%d",localeComp.month,localeComp.day];
    
    
    NSString *jieri = [chineseHoliDay objectForKey:key_str];
    
    
    if (jieri!=nil) {
        [localeCalendar release];
        return [NSString stringWithFormat:@"农历%@",jieri];
    }
    
    
    
    NSDictionary *chineseDay = [NSDictionary dictionaryWithObjectsAndKeys:
                                
                                @"一", @"1",
                                @"二", @"2",
                                @"三", @"3",
                                @"四", @"4",
                                @"五", @"5",
                                @"六", @"6",
                                @"七", @"7",
                                @"八", @"8",
                                @"九", @"9",
                                @"十", @"10",
                                @"十一", @"11",
                                @"十二", @"12",
                                @"十三", @"13",
                                @"十四", @"14",
                                @"十五", @"15",
                                @"十六", @"16",
                                @"十七", @"17",
                                @"十八", @"18",
                                @"十九", @"19",
                                @"廿", @"20",
                                @"廿一", @"21",
                                @"廿二", @"22",
                                @"廿三", @"23",
                                @"廿四", @"24",
                                @"廿五", @"25",
                                @"廿六", @"26",
                                @"廿七", @"27",
                                @"廿八", @"28",
                                @"廿九", @"29",
                                @"卅", @"30",
                                @"卅一", @"31",
                                nil];
    
    localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSString *key_strday = [NSString stringWithFormat:@"%d",localeComp.day];
    
    NSString *key_strmonth = [NSString stringWithFormat:@"%d",localeComp.month];
    
    
    
    NSString *day = [chineseDay objectForKey:key_strday];
    NSString *month = [chineseDay objectForKey:key_strmonth];
    
    //NSLog(@"key_strday:%@ day:%@",key_strday,day);
    
    [localeCalendar release];
    if (localeComp.day>10) {
        return [NSString stringWithFormat:@"农历%@月%@",month,day];
    }
    else{
        return [NSString stringWithFormat:@"农历%@月初%@",month,day];
    }
    
    return @"";
    
}

-(void)setContent{
    
    FSWeatherObject *o = (FSWeatherObject *)self.data;
    //NSLog(@"FSWeatherObject:%@",o);
    
    NSString *time = dateToString_HM([NSDate dateWithTimeIntervalSinceNow:0.0f]);
    
    time = [time substringToIndex:2];
    //NSLog(@"time:%@",time);
    NSInteger h = [time integerValue];
    
    NSString *defaultDBPath;
    
    if (h>6 && h<18) {
        defaultDBPath = o.day_icon;
    }
    else{
        defaultDBPath = o.night_icon;
    }
    //NSLog(@"defaultDBPath%@",defaultDBPath);
    if (o.day_tp == nil || o.night_tp == nil) {
       _lab_Temperature.text = [NSString stringWithFormat:@""];
    }
    else{
        _lab_Temperature.text = [NSString stringWithFormat:@"%@",o.day_tp];
    }
    NSDate * date    = [NSDate date];
    NSString * day   = [self FromeDateFormat:date];
    NSString * day2  = [self getCHineseDate:date];
    _lab_CityName.text = o.cityname;
    _dateLabel.text    = [NSString stringWithFormat:@"%@  %@",day,day2];
    [self downloadImage:defaultDBPath];
    
}



-(void)downloadImage:(NSString *)url{
    NSString *loaclFile = getFileNameWithURLString(url, getCachesPath());
    if (![[NSFileManager defaultManager] fileExistsAtPath:loaclFile]) {
        [FSNetworkData networkDataWithURLString:url withLocalStoreFileName:loaclFile withDelegate:self];
    }
    else{
        _image_WeatherIcon.image = [UIImage imageWithContentsOfFile:loaclFile];
    }
}

-(void)networkDataDownloadDataComplete:(FSNetworkData *)sender isError:(BOOL)isError data:(NSData *)data{
    if (data!=nil) {
        _image_WeatherIcon.image = [UIImage imageWithData:data];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

/*
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([_parentDelegate conformsToProtocol:@protocol(FSWeatherViewDelegate)] && [_parentDelegate respondsToSelector:@selector(FSWeatherViewTouchEvent:)]) {
        [_parentDelegate FSWeatherViewTouchEvent:self];
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
 
 */

@end
