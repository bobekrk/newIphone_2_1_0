//
//  FS_GZF_ForLoadingImageDAO.h
//  PeopleNewsReaderPhone
//
//  Created by ganzf on 13-3-5.
//
//

#import <Foundation/Foundation.h>
#import "FS_GZF_BaseGETXMLDataListDAO.h"


#define LOADINGIMAGE_LOADING_XML_COMPELECT @"LOADINGIMAGE_LOADING_XML_COMPELECT"

@class FSLoadingImageObject;

@interface LygAdsDao : FS_GZF_BaseGETXMLDataListDAO{
@protected
    FSLoadingImageObject *_obj;
    
}
@property (nonatomic,assign)int placeID;
@end
