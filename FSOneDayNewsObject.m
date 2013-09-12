//
//  FSOneDayNewsObject.m
//  PeopleNewsReaderPhone
//
//  Created by lygn128 on 13-8-19.
//
//

#import "FSOneDayNewsObject.h"


@implementation FSOneDayNewsObject

@dynamic isReaded;
@dynamic newsid;
@dynamic news_abstract;
@dynamic channelid;
@dynamic timestamp;
@dynamic picture;
@dynamic link;
@dynamic picdesc;
@dynamic source;
@dynamic title;
@dynamic order;
@dynamic group;
@dynamic browserCount;
@dynamic commentCount;
@dynamic channalIcon;
@dynamic realtimeid;
@dynamic kind;
@dynamic UPDATE_DATE;
@dynamic isRedColor;
-(NSString*)description
{
    return [NSString  stringWithFormat:@"%@ %@ %@",self.newsid,self.news_abstract,self.title];
}
@end
