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
@implementation LygDeepTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newslist_beijing.png"]];
        //        self.backgroundView = image;
        //        [image release];
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

-(void)doSomethingAtInit{
    
    //UIView * view = [UIView ]
    _kindsLabel     = [[UILabel alloc] init];
    _nameLabel      = [[UILabel alloc] init];
    _dateLabel      = [[UILabel alloc] init];
    _abstractLabel  = [[UILabel alloc] init];


    
    [self addSubview:_kindsLabel];
    [self addSubview:_nameLabel];
    [self addSubview:_dateLabel];
    [self addSubview:_abstractLabel];
    
    
    [_kindsLabel     release];
    [_nameLabel      release];
    [_dateLabel      release];
    [_abstractLabel  release];
    

    _kindsLabel.textColor    = [UIColor redColor];
    _nameLabel.textColor     = [UIColor whiteColor];
    _dateLabel.textColor     = [UIColor grayColor];
    _abstractLabel.textColor = [UIColor grayColor];
    
    
//    _lab_NewsTitle.backgroundColor = COLOR_CLEAR;
//    _lab_NewsTitle.textColor = COLOR_NEWSLIST_TITLE;
//    _lab_NewsTitle.textAlignment = UITextAlignmentLeft;
//    _lab_NewsTitle.numberOfLines = 1;
//    _lab_NewsTitle.font = [UIFont systemFontOfSize:TODAYNEWSLIST_TITLE_FONT];
//    
//    _lab_NewsDescription.backgroundColor = COLOR_CLEAR;
//    _lab_NewsDescription.textColor = COLOR_NEWSLIST_DESCRIPTION;
//    _lab_NewsDescription.textAlignment = UITextAlignmentLeft;
//    _lab_NewsDescription.numberOfLines = 3;
//    _lab_NewsDescription.font = [UIFont systemFontOfSize:TODAYNEWSLIST_DESCRIPTION_FONT];
//    
//    //    _lab_VisitVolume.backgroundColor = COLOR_CLEAR;
//    //    _lab_VisitVolume.textColor = COLOR_NEWSLIST_DESCRIPTION;
//    //    _lab_VisitVolume.textAlignment = UITextAlignmentLeft;
//    //    _lab_VisitVolume.numberOfLines = 1;
//    //    _lab_VisitVolume.font = [UIFont systemFontOfSize:LIST_BOTTOM_TEXT_FONT];
//    
//    _lab_NewsType.backgroundColor = COLOR_CLEAR;
//    _lab_NewsType.textColor = COLOR_NEWSLIST_DESCRIPTION;
//    _lab_NewsType.textAlignment = UITextAlignmentLeft;
//    _lab_NewsType.numberOfLines = 1;
//    _lab_NewsType.font = [UIFont systemFontOfSize:LIST_BOTTOM_TEXT_FONT];
//    
//    //self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setDayPattern:(BOOL)is_day{
    NSLog(@"setDayPattern");
}


-(void)doSomethingAtLayoutSubviews{
    
    //_leftView.frame = CGRectMake(0, 0, 4, self.frame.size.height);
    self.backgroundColor = [UIColor redColor];
    //   _image_Footprint.image = [UIImage imageNamed:@"xin.png"];
    
    if ([self.data isKindOfClass:[FSTopicObject class]]) {
        FSTopicObject *obj = (FSTopicObject *)self.data;
        _kindsLabel.text = obj.title;
        _nameLabel.text  = obj.title;
        _dateLabel.text  = obj.pubDate;
        _abstractLabel.text = obj.news_abstract;
        //        _lab_VisitVolume.text = [NSString stringWithFormat:@"%d",[obj.browserCount integerValue]];
        //_lab_NewsType.text = [NSString stringWithFormat:@"%@",[self timeTostring:obj.timestamp]];
        
//        NSString *defaultDBPath = obj.picture;
//        NSString *loaclFile = getFileNameWithURLString(defaultDBPath, getCachesPath());
//        //_image_Onright.urlString = defaultDBPath;
//        _image_Onright.localStoreFileName = loaclFile;
    }
    _kindsLabel.frame    = CGRectMake(5, 5, 80, 20);
    _nameLabel.frame     = CGRectMake(90, 5, 320 - 80, 40);
    _dateLabel.frame     = CGRectMake(5, 25, 320, 20);
    _abstractLabel.frame = CGRectMake(5, 45, 320, 70);
        
//    @property (nonatomic, retain) NSString * deepid;
//    @property (nonatomic, retain) NSString * pictureLogo;
//    @property (nonatomic, retain) NSString * news_abstract;
//    @property (nonatomic, retain) NSNumber * sort;
//    @property (nonatomic, retain) NSString * title;
//    @property (nonatomic, retain) NSString * pictureLink;
//    @property (nonatomic, retain) NSString * pubDate;
//    @property (nonatomic, retain) NSNumber * timestamp;
//    @property (nonatomic, retain) NSString * createtime;
    
//    if ([_image_Onright.urlString length]>0 && [self isDownloadPic]) {
//        _image_Onright.frame = CGRectMake(10, 30, 75, 52);
//        [_image_Onright updateAsyncImageView];
//        _image_Onright.alpha = 1.0f;
//        
//        
//        _lab_NewsTitle.frame = CGRectMake(10, 4, self.frame.size.width- 68 - 10, 25);
//        _lab_NewsDescription.frame = CGRectMake(92, 30, self.frame.size.width- 92 - 10, 52);
//        
//        
//        //        _image_Footprint.frame = CGRectMake(self.frame.size.width - 72, self.frame.size.height-15 - 12, 12, 12);
//        //        _lab_VisitVolume.frame = CGRectMake(self.frame.size.width - 60, self.frame.size.height-15 - 12, 60, 12);
//        _lab_NewsType.frame = CGRectMake(self.frame.size.width-50,4, 40, 22);
//        
//    }
//    else{
//        _lab_NewsTitle.frame = CGRectMake(10, 4, self.frame.size.width- 68-10, 25);
//        _lab_NewsDescription.frame = CGRectMake(10, 30, self.frame.size.width-20, 54);
//        
//        
//        _image_Onright.alpha = 0.0f;
//        //        _image_Footprint.frame = CGRectMake(self.frame.size.width - 72, self.frame.size.height-15 - 12, 12, 12);
//        //        _lab_VisitVolume.frame = CGRectMake(self.frame.size.width - 60, self.frame.size.height-15 - 12, 60, 12);
//        _lab_NewsType.frame = CGRectMake(self.frame.size.width-50,4 , 40, 22);
//    }
    
}


//-(BOOL)isDownloadPic{
//    
//    BOOL rest = NO;
//    
//    if (![[GlobalConfig shareConfig] isSettingDownloadPictureUseing2G_3G]) {
//        rest = YES;
//        return rest;
//    }
//    
//    if ([[GlobalConfig shareConfig] isDownloadPictureUseing2G_3G]) {
//        rest = YES;
//    }
//    else{
//        if (!checkNetworkIsOnlyMobile()) {
//            rest = YES;
//        }
//    }
//    return rest;
//}

-(NSString *)timeTostring:(NSNumber *)time{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    NSString *hm = dateToString_HM(date);
    
    return hm;
}


+(CGFloat)getCellHeight{
    return 0;
}



//*******************************
+(CGFloat)computCellHeight:(NSObject *)cellData cellWidth:(CGFloat)cellWidth{
    FSTopicObject * obj   = (FSTopicObject*)cellData;
    //FSOneDayNewsObject *o = (FSOneDayNewsObject *)cellData;
    if (obj!=nil) {
//        if ([o.picture length]>0) {
//            return ROUTINE_NEWS_LIST_WITHEIMAGE_HEIGHT;
//        }
//        else{
//            return ROUTINE_NEWS_LIST_HEIGHT;
//        }
        return 50;
    }
    return 44;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
