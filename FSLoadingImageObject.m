//
//  FSLoadingImageObject.m
//  PeopleNewsReaderPhone
//
//  Created by lygn128 on 13-8-7.
//
//

#import "FSLoadingImageObject.h"


@implementation FSLoadingImageObject

@dynamic adEndTime;
@dynamic adFlagTime;
@dynamic adLinkFlag;
@dynamic adName;
@dynamic adFlag;
@dynamic picUrl;
@dynamic adId;
@dynamic adStartTime;
@dynamic adPlaceId;
@dynamic adLink;
@dynamic adType;
@dynamic adTitle;
@dynamic adDesc;
@dynamic adCtime;
-(NSString*)description
{
    return [NSString stringWithFormat:@"%@%@",self.adTitle,self.adDesc];
}
@end
