//
//  FS_GZF_DeepListDAO.m
//  PeopleNewsReaderPhone
//
//  Created by ganzf on 12-12-27.
//
//

#import "FS_GZF_DeepListDAO.h"
#import "FSTopicObject.h"

/*
<item>
<title><![CDATA[水鬼]]></title>
<news_abstract><![CDATA[又到年底了]]></news_abstract>
<timestamp><![CDATA[1356575487]]></timestamp>
<pubDate><![CDATA[2012-12-21 15:33:44]]></pubDate>
<pictureLogo><![CDATA[ ]]></pictureLogo>
<pictureLink><![CDATA[http://58.68.130.168/365755042.jpg]]></pictureLink>
<deepid><![CDATA[38]]></deepid>
 <sort><![CDATA[]]></sort>
</item>
 */

#define deep_item @"item"
#define deep_title @"title"
#define deep_news_abstract @"news_abstract"
#define deep_timestamp @"timestamp"
#define deep_pubDate @"pubDate"
#define deep_pictureLogo @"pictureLogo"
#define deep_pictureLink @"pictureLink"
#define deep_deepid @"deepid"
#define deep_sort @"sort"




//#define FSDEEPLIST_URL @"http://mobile.app.people.com.cn:81/topic/topic.php?act=info_list&rt=xml&type=list&iswp=0"
#define FSDEEPLIST_URL   @"http://mobile.app.people.com.cn:81/topic/topic.php?act=info_list&rt=xml&type=list&iswp=0&count=20"
#define FSDEEPLIST_URL2  @"http://mobile.app.people.com.cn:81/topic/topic.php?act=info_list&rt=xml&type=list&iswp=0&count=20&last_id=%@"

@implementation FS_GZF_DeepListDAO


- (id)init {
	self = [super init];
	if (self) {
        _oldcount = 1;
	}
	return self;
}

-(void)dealloc{
    [super dealloc];
}

-(NSTimeInterval)bufferDataExpireTimeInterval{
    return 60*30;
}

-(NSString *)entityName{
    return @"FSTopicObject";
}


-(NSString *)readDataURLStringFromRemoteHostWithGETDataKind:(GET_DataKind)getDataKind{
//    NSLog(@"FSDEEPLIST_URL:%@",FSDEEPLIST_URL);
//    return FSDEEPLIST_URL;
    for (FSTopicObject * obj in self.objectList) {
        //NSLog(@"<<<<<<<<<<<<<%@",obj.deepid);
    }
    if (getDataKind == GET_DataKind_Refresh) {
        _oldcount = 1;
        self.getNextOnline  = YES;
        //NSLog(@"%@",[NSString stringWithFormat:FS_NEWS_URL_IMPORT,FS_NEWS_PAGECOUNT,@""]);
		return [NSString stringWithFormat:FSDEEPLIST_URL];
	} else {
        //self.getNextOnline  = NO;
        _oldcount += 1;
        FSTopicObject * obj = self.objectList.lastObject;
        return [NSString stringWithFormat:FSDEEPLIST_URL2,obj.deepid];
	}
}
//-(void)reSetAssistantViewFlag:(NSInteger)arrayCount{
//    if (_oldcount==arrayCount && arrayCount!=0) {
//        _tvList.assistantViewFlag = FSTABLEVIEW_ASSISTANT_TOP_VIEW;
//    }
//    else{
//        _tvList.assistantViewFlag = FSTABLEVIEW_ASSISTANT_BOTTOM_BUTTON_VIEW | FSTABLEVIEW_ASSISTANT_TOP_VIEW | FSTABLEVIEW_ASSISTANT_BOTTOM_VIEW;
//        _oldcount=arrayCount;
//    }
//}


-(NSString *)timestampFlag{
    return @"FSTopicObject_flag";
    //FSTopicObject
}

-(NSString *)predicateStringWithQueryDataKind:(Query_DataKind)dataKind{
    
    return @"bufferFlag!='3'";
    
    if (dataKind == Query_DataKind_New) {
        return [NSString stringWithFormat:@"updata_date='%@'", dateToString_YMD([NSDate dateWithTimeIntervalSinceNow:0.0f])];
    }
    return nil;
}



- (void)initializeSortDescriptions:(NSMutableArray *)descriptions {
    //[self addSortDescription:descriptions withSortFieldName:@"deepid" withAscending:NO];
	[self addSortDescription:descriptions withSortFieldName:@"sort" withAscending:NO];
}

//-(NSInteger)fetchLimitWithGETDDataKind:(GET_DataKind)getDataKind{
//    return 20;
//}
//- (NSInteger)fetchLimitWithGETDDataKind:(GET_DataKind)getDataKind {
//    NSLog(@"%d",self.objectList.count);
//	if (getDataKind == GET_DataKind_Refresh) {
//		return 20;
//	} else {
//		return [self.objectList count] + 20;
//	}
//}
- (NSInteger)fetchLimitWithGETDDataKind:(GET_DataKind)getDataKind {
	if (getDataKind == GET_DataKind_Refresh || getDataKind == GET_DataKind_ForceRefresh) {
		return 20;
	} else if (getDataKind == GET_DataKind_Next){
		return [self.objectList count] + 20;
	}
    else if(getDataKind == GET_DataKind_Unlimited){
        return 0;
    }
    return  0;
}

#pragma mark -
#pragma mark NSCMLParserDelegate
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"%@",parseError);
}
- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
    NSLog(@"%@",validationError);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    _currentElementName = elementName;
	if ([_currentElementName isEqualToString:deep_item]) {
        _obj = (FSTopicObject *)[self insertNewObjectTomanagedObjectContext];
        _obj.bufferFlag = @"1";
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:deep_item]) {
        //NSLog(@"-------------------");
        //[_objectList addObject:_obj];
        //[_obj release];
        //_obj = nil;
    }
    if ([elementName isEqualToString:@"root"]) {
        [FSBaseDB saveDB];
    }
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
	
    if ([_currentElementName isEqualToString:@"title"]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
		_obj.title = trimString(content);
		[content release];
	} else if ([_currentElementName isEqualToString:@"news_abstract"]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
		_obj.news_abstract = trimString(content);
		[content release];
	}
    else if ([_currentElementName isEqualToString:@"timestamp"]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        NSString *temp = trimString(content);
        NSNumber *tempNumber = [[NSNumber alloc] initWithInt:[temp intValue]];
		_obj.timestamp = tempNumber;
		[content release];
        [tempNumber release];
	}
    else if ([_currentElementName isEqualToString:@"pubDate"]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
		_obj.pubDate = trimString(content);
		[content release];
	}
    else if ([_currentElementName isEqualToString:@"pictureLogo"]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
		_obj.pictureLogo = trimString(content);
		[content release];
	}
    else if ([_currentElementName isEqualToString:@"pictureLink"]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
		_obj.pictureLink = trimString(content);
		[content release];
	}
    else if ([_currentElementName isEqualToString:@"deepid"]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
		_obj.deepid = trimString(content);
        int x = trimString(content).intValue;
        _obj.sort   = [NSNumber numberWithInt:x];
		[content release];
	}
    else if ([_currentElementName isEqualToString:@"sort"]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        //NSString *temp = trimString(content);
        //NSNumber *tempNumber = [[NSNumber alloc] initWithInt:[temp intValue]];
		//_obj.sort = temp.intValue;
		[content release];
        //[tempNumber release];
	}
}


- (void)executeFetchRequest:(NSFetchRequest *)request {
    [self setBufferFlag];
	NSError *error = nil;
    
	NSArray *resultSet = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        
		if ([resultSet count]>0) {
            NSMutableArray *idArray = [[NSMutableArray alloc] init];
            NSMutableArray *TopicObjectArray = [[NSMutableArray alloc] init];
            NSInteger mark = 0;

            for (FSTopicObject *o in resultSet) {
                mark = 0;
                for (FSTopicObject *vi in TopicObjectArray) {
                    if ([vi.deepid isEqualToString:o.deepid]) {
                        mark = 1;
                        break;
                    }
                }
                if (mark == 0) {
                    [TopicObjectArray addObject:o];
                }
            }
            self.objectList = TopicObjectArray;//(NSMutableArray *)resultSet;
            self.isRecordListTail = [self.objectList count] < [self.fetchRequest fetchLimit];
            [idArray release];
            [TopicObjectArray release];
        }
	}
}

-(void)setBufferFlag{

    NSArray *array = [[FSBaseDB sharedFSBaseDBWithContext:self.managedObjectContext] getAllObjectsSortByKey:[self entityName] key:@"timestamp" ascending:NO];

    
    NSMutableDictionary * dicat = [[NSMutableDictionary alloc]init];
    for (FSTopicObject * obj1  in array) {
        NSString * string = [dicat objectForKey:obj1.deepid];
        if (!string) {
            [dicat setValue:@"1" forKey:obj1.deepid];
        }else{
            obj1.bufferFlag = @"3";
        }
    }
    [dicat release];
    [self saveCoreDataContext];
    [self operateOldBufferData];
    return;
}
-(void)operateOldBufferData{
    //if (self.currentGetDataKind == GET_DataKind_Refresh) {
		
       // if (_isRefreshToDeleteOldData == YES) {
             NSArray *array = [[FSBaseDB sharedFSBaseDBWithContext:self.managedObjectContext] getAllObjectsSortByKey:[self entityName] key:@"timestamp" ascending:YES];
            for (FSTopicObject *o in array) {
                if ([o.bufferFlag isEqualToString:@"3"]) {
                    [self.managedObjectContext deleteObject:o];
                    
                }
            }
            [self saveCoreDataContext];
            
    //    }
	//}
}


//- (void)executeFetchRequest:(NSFetchRequest *)request {
//	NSError *error = nil;
//	NSArray *resultSet = [self.managedObjectContext executeFetchRequest:request error:&error];
//	if (!error) {
//		NSMutableArray *tempResultSet = [[NSMutableArray alloc] initWithArray:resultSet];
//		self.objectList = (NSMutableArray *)tempResultSet;
//        NSLog(@"self.objectList:%d",[self.objectList count]);
//		self.isRecordListTail = NO;
//		[tempResultSet release];
//	}
//}
//
//
//-(void)operateOldBufferData{
//    if (self.currentGetDataKind == GET_DataKind_Refresh || self.currentGetDataKind == GET_DataKind_Unlimited) {
//		NSArray *resultSets = self.objectList;
//		if ([resultSets count] > 0) {
//#ifdef MYDEBUG
//            NSLog(@"resultSets:11111 %d",[resultSets count]);
//#endif
//            //NSInteger i = 0;
//            for (FSTopicObject *entityObject in resultSets) {
//#ifdef MYDEBUG
//                //NSLog(@"entityObject:%@", entityObject);
//#endif
//                //NSLog(@"%d",i);
//                //i++;
//                if (entityObject!=nil) {
//                    if (![entityObject isDeleted]) {
//                        [self.managedObjectContext deleteObject:entityObject];
//                        
//                    }
//                }
//                
//            }
//            //[_objectList removeAllObjects];
//            //NSLog(@"111111");
//            [self saveCoreDataContext];
//		}
//	}
//}


@end
