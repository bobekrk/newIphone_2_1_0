//
//  FSLoadingImageObject.h
//  PeopleNewsReaderPhone
//
//  Created by lygn128 on 13-10-2.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FSLoadingImageObject : NSManagedObject

@property (nonatomic, retain) NSString * newsid;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * browserCount;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * channelid;
@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * picture;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * flag;
@property (nonatomic, retain) NSString * shareContent;
@property (nonatomic, retain) NSString * shareUrl;
@property (nonatomic, retain) NSString * abStract;
@property (nonatomic, retain) NSString * bufferFlag;

@end
