//
//  FS_GZF_ForLoadingImageDAO.m
//  PeopleNewsReaderPhone
//
//  Created by ganzf on 13-3-5.
//
//

#import "LygAdsDao.h"
#import "FSLoadingImageObject.h"

#define DEEPPICTURE_IMAGESIZE_4 @"640/940"
#define DEEPPICTURE_IMAGESIZE_5 @"640/1136"


#define FSLOADING_IMAGEVIEW_URL @"http://mobile.app.people.com.cn:81/paper_ipad/paper.php?act=ad&type=list&appid=6&place_id=%d&resolution=%@"




#define Loading_item         @"ITEM"
#define Loading_newsid       @"NSID"
#define Loading_title        @"TITLE"
#define Loading_browserCount @"browserCount"
#define Loading_type         @"type"
#define Loading_channelid    @"channelid"
#define Loading_timestamp    @"NSDATE"
#define Loading_picture      @"PICURL"
#define Loading_link         @"LINK"
#define Loading_flag         @"FLAG"


@implementation LygAdsDao


- (id)init {
	self = [super init];
	if (self) {
	}
    
	return self;
}

-(void)dealloc{
    [super dealloc];
}


- (NSString *)timestampFlag {
    NSString *flag = [NSString stringWithFormat:@"LoadingImage"];
    return flag;
}

-(NSString *)entityName{
    return @"FSLoadingImageObject";
}


-(NSTimeInterval)bufferDataExpireTimeInterval{
    return 60*10;
    
}



-(NSString *)readDataURLStringFromRemoteHostWithGETDataKind:(GET_DataKind)getDataKind{
    return [NSString stringWithFormat:FSLOADING_IMAGEVIEW_URL,self.placeID,(ISIPHONE5?@"640x1136&iswp=0":@"640x960&iswp=0")];
}










-(NSString *)predicateStringWithQueryDataKind:(Query_DataKind)dataKind{
    
    return [NSString stringWithFormat:@"bufferFlag!='3'"];
    
}


- (void)initializeSortDescriptions:(NSMutableArray *)descriptions {
	[self addSortDescription:descriptions withSortFieldName:@"adId" withAscending:NO];
}

#pragma mark -     
#pragma mark NSCMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    _currentElementName = elementName;
	if ([_currentElementName isEqualToString:Loading_item]) {
        _obj = (FSLoadingImageObject *)[self insertNewObjectTomanagedObjectContext];
        _obj.bufferFlag = @"1";
        
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:Loading_item]) {

    }
    return;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	//NSLog(@"foundCharacters:%@",string);
    
    /*
     NSString *strUnion = nil;
     if ([self.currentElementName isEqualToString:NEWS_COMMENT_CREATE_TIME]) {
     strUnion = [CommonFuncs strCat:_obj.create_time TwoStr:[CommonFuncs trimString:string]];
     _obj.create_time = strUnion;
     }else if([self.currentElementName isEqualToString:NEWS_COMMENT_CREATE_TIMEINSECONDS]){
     strUnion = [CommonFuncs strCat:_obj.time_inSeconds TwoStr:[CommonFuncs trimString:string]];
     _obj.time_inSeconds = strUnion;
     }
     [strUnion release];
     */
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
    
    if ([_currentElementName isEqualToString:@"AD_ID"]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        _obj.adId = trimString(content);;
		[content release];
	} else if ([_currentElementName isEqualToString:@"AD_PLACE_ID"]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
		_obj.adPlaceId = trimString(content);
		[content release];
        
	}
    else if ([_currentElementName isEqualToString:@"AD_NAME"]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
		NSString *temp = trimString(content);
        //NSNumber *tempNumber = [[NSNumber alloc] initWithInt:[temp intValue]];
        _obj.adName = temp;
		[content release];
        //[tempNumber release];
	}
    else if ([_currentElementName isEqualToString:@"AD_START_TIME"]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
		_obj.adStartTime = trimString(content);
		[content release];
	}
    else if ([_currentElementName isEqualToString:@"AD_END_TIME"]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
		_obj.adEndTime = trimString(content);
		[content release];
	}
    else if ([_currentElementName isEqualToString:@"PIC_URL"]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        NSString *temp = trimString(content);
//        NSNumber *tempNumber = [[NSNumber alloc] initWithInt:[temp intValue]];
//		_obj.timestamp = tempNumber;
        _obj.picUrl    = temp;
		[content release];
        //[tempNumber release];
	}
    else if ([_currentElementName isEqualToString:@"AD_LINK"]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        
       // NSString *picURL = [trimString(content) stringByReplacingOccurrencesOfString:DEEPPICTURE_IMAGESIZE_OLD withString:DEEPPICTURE_IMAGESIZE];
        
		_obj.adLink = trimString(content);
		[content release];
	}
    else if ([_currentElementName isEqualToString:@"AD_LINK_FLAG"]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
		_obj.adLinkFlag = trimString(content);
		[content release];
	}
    else if ([_currentElementName isEqualToString:@"AD_FLAG_TIME"]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
		_obj.adFlagTime   = trimString(content);
		[content release];
	}
    else if ([_currentElementName isEqualToString:@"AD_TYPE"]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
		_obj.adType   = trimString(content);
		[content release];
	}
    else if ([_currentElementName isEqualToString:@"AD_TITLE"]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
		_obj.adTitle   = trimString(content);
		[content release];
	}
    else if ([_currentElementName isEqualToString:@"AD_DESC"]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
		_obj.adDesc   = trimString(content);
		[content release];
	}
    else if ([_currentElementName isEqualToString:@"AD_CTIME"]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
		_obj.adCtime   = trimString(content);
		[content release];
	}
}




- (void)executeFetchRequest:(NSFetchRequest *)request {
	NSError *error = nil;
	NSArray *resultSet = [self.managedObjectContext executeFetchRequest:request error:&error];
	if (!error) {
        
		if ([resultSet count]>0) {
            //NSLog(@"loading[resultSet count]:%d",[resultSet count]);
            self.objectList = (NSMutableArray *)resultSet;
            self.isRecordListTail = [self.objectList count] < [self.fetchRequest fetchLimit];
            [self setBufferFlag];
            [[NSNotificationCenter defaultCenter] postNotificationName:LOADINGIMAGE_LOADING_XML_COMPELECT object:nil];
        }
	}
}

-(void)setBufferFlag{
    
    NSArray *array = [[FSBaseDB sharedFSBaseDBWithContext:self.managedObjectContext] getAllObjectsSortByKey:[self entityName] key:nil ascending:YES];
    
    if (self.currentGetDataKind == GET_DataKind_Next){
        for (FSLoadingImageObject *o in array) {
            if ([o.bufferFlag isEqualToString:@"1"]) {
                o.bufferFlag = @"2";
            }
        }
        [[FSBaseDB sharedFSBaseDBWithContext:self.managedObjectContext].managedObjectContext save:nil];
        return;
    }
    
    for (FSLoadingImageObject *o in array) {
        if (_isRefreshToDeleteOldData == YES && [o.bufferFlag isEqualToString:@"2"]) {
            ;//o.bufferFlag = @"3";
        }else if (_isRefreshToDeleteOldData == YES && [o.bufferFlag isEqualToString:@"1"]){
            o.bufferFlag = @"2";
        }
    }
    [[FSBaseDB sharedFSBaseDBWithContext:self.managedObjectContext].managedObjectContext save:nil];
}


-(void)setBufferFlag3{
    NSArray *array = [[FSBaseDB sharedFSBaseDBWithContext:self.managedObjectContext] getAllObjectsSortByKey:[self entityName] key:nil ascending:YES];
    
        
    for (FSLoadingImageObject *o in array) {
        if (_isRefreshToDeleteOldData == YES && [o.bufferFlag isEqualToString:@"2"]) {
            o.bufferFlag = @"3";
        }
    }
    [[FSBaseDB sharedFSBaseDBWithContext:self.managedObjectContext].managedObjectContext save:nil];
}



-(void)operateOldBufferData{
    if (self.currentGetDataKind == GET_DataKind_Refresh) {
		
        if (_isRefreshToDeleteOldData == YES) {
            NSArray *array = [[FSBaseDB sharedFSBaseDBWithContext:self.managedObjectContext] getAllObjectsSortByKey:[self entityName] key:nil ascending:YES];
            for (FSLoadingImageObject *o in array) {
                if ([o.bufferFlag isEqualToString:@"3"]) {
                    [[FSBaseDB sharedFSBaseDBWithContext:self.managedObjectContext] deleteObjectByObject:o];
                    //[self.managedObjectContext deleteObject:o];
                    
                }
            }
            //[self saveCoreDataContext];
            
        }
	}
}


@end
