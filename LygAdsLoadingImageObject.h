//
//  LygAdsLoadingImageObject.h
//  PeopleNewsReaderPhone
//
//  Created by lygn128 on 13-10-2.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FSBatchNewsObject.h"


@interface LygAdsLoadingImageObject : FSBatchNewsObject

@property (nonatomic, retain) NSString * adCtime;
@property (nonatomic, retain) NSString * adName;
@property (nonatomic, retain) NSString * picUrl;
@property (nonatomic, retain) NSString * adId;
@property (nonatomic, retain) NSString * adTitle;
@property (nonatomic, retain) NSString * adFlagTime;
@property (nonatomic, retain) NSString * adPlaceId;
@property (nonatomic, retain) NSString * adLink;
@property (nonatomic, retain) NSString * adStartTime;
@property (nonatomic, retain) NSString * adType;
@property (nonatomic, retain) NSString * adDesc;
@property (nonatomic, retain) NSString * adFlag;
@property (nonatomic, retain) NSString * adLinkFlag;
@property (nonatomic, retain) NSString * adEndTime;
@property (nonatomic, retain) NSString * shareContent;
@property (nonatomic, retain) NSString * shareUrl;

@end
