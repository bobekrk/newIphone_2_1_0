//
//  FS_GZF_ForLoadingImageDAO.m
//  PeopleNewsReaderPhone
//
//  Created by ganzf on 13-3-5.
//
//

#import "FS_GZF_ForLoadingImageDAO.h"
#import "FSLoadingImageObject.h"

#define DEEPPICTURE_IMAGESIZE_4 @"640/940"
#define DEEPPICTURE_IMAGESIZE_5 @"640/1136"


#define FSLOADING_IMAGEVIEW_URL @"http://mobile.app.people.com.cn:81/paper_ipad/paper.php?act=headpic&type=4&appid=6&format=xml&count=1&resolution=%@"

/*
 
 <ITEM>
 <NSID>0</NSID>
 <TITLE><![CDATA[世界上看得最远预警机:中国造]]></TITLE>
 <ABSTRACT><![CDATA[]]></ABSTRACT>
 <PICURL><![CDATA[http://58.68.130.168/thumbs/1024/768/data/newsimages/client/130329/F201303291364540576352382.jpg]]></PICURL>
 <NSDATE>0000-00-00</NSDATE>
 <LINK><![CDATA[]]></LINK>
 <COMMENTCOUNT></COMMENTCOUNT>
 <FLAG>0</FLAG>
 </ITEM>
 
 */

#define Loading_item @"ITEM"
#define Loading_newsid @"NSID"
#define Loading_title @"TITLE"
#define Loading_browserCount @"browserCount"
#define Loading_type @"type"
#define Loading_channelid @"channelid"
#define Loading_timestamp @"NSDATE"
#define Loading_picture @"PICURL"
#define Loading_link @"LINK"
#define Loading_flag @"FLAG"


@implementation FS_GZF_ForLoadingImageDAO


@synthesize isIphone5 = _isIphone5;

- (id)init {
	self = [super init];
	if (self) {
        _isIphone5 = NO;
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
    //return FSFOUCS_URL;
    NSString *_url;
    if (self.isIphone5) {
        _url = [NSString stringWithFormat:FSLOADING_IMAGEVIEW_URL,@"640x1136"];
    }
    else{
        _url = [NSString stringWithFormat:FSLOADING_IMAGEVIEW_URL,@"640x960"];
    }
    
    return _url;
}



-(NSString *)predicateStringWithQueryDataKind:(Query_DataKind)dataKind{
    
    return [NSString stringWithFormat:@"bufferFlag!='3'"];
    
}


- (void)initializeSortDescriptions:(NSMutableArray *)descriptions {
	[self addSortDescription:descriptions withSortFieldName:@"newsid" withAscending:NO];
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
        
        //[self.objectList addObject:_obj];
        //[_obj release];
        //_obj = nil;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	NSLog(@"foundCharacters:%@",string);
    
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
    if ([_currentElementName isEqualToString:Loading_newsid]) {
        if (_obj.newsid == nil) {
            _obj.newsid = string;
        }
		
    }
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
    
    if ([_currentElementName isEqualToString:Loading_newsid]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        _obj.newsid = trimString(content);;
		[content release];
	} else if ([_currentElementName isEqualToString:Loading_title]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
		_obj.title = trimString(content);
		[content release];
        
	}
    else if ([_currentElementName isEqualToString:Loading_browserCount]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
		NSString *temp = trimString(content);
        NSNumber *tempNumber = [[NSNumber alloc] initWithInt:[temp intValue]];
        _obj.browserCount = tempNumber;
		[content release];
        [tempNumber release];
	}
    else if ([_currentElementName isEqualToString:Loading_type]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        int x = [trimString(content) intValue];
		_obj.type = [NSNumber numberWithInt:x];
		[content release];
	}
    else if ([_currentElementName isEqualToString:Loading_channelid]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
		_obj.channelid = trimString(content);
		[content release];
	}
    else if ([_currentElementName isEqualToString:Loading_timestamp]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        NSString *temp = trimString(content);
        NSNumber *tempNumber = [[NSNumber alloc] initWithInt:[temp intValue]];
		_obj.timestamp = tempNumber;
		[content release];
        [tempNumber release];
	}
    else if ([_currentElementName isEqualToString:Loading_picture]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        
       // NSString *picURL = [trimString(content) stringByReplacingOccurrencesOfString:DEEPPICTURE_IMAGESIZE_OLD withString:DEEPPICTURE_IMAGESIZE];
        
		_obj.picture = content;
		[content release];
	}
    else if ([_currentElementName isEqualToString:Loading_link]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
		_obj.link = trimString(content);
		[content release];
	}
    else if ([_currentElementName isEqualToString:Loading_flag]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
		_obj.flag = trimString(content);
		[content release];
	}
    else if ([_currentElementName isEqualToString:@"SHARE_CONTENT"]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
		_obj.shareContent = trimString(content);
		[content release];
	}
    else if ([_currentElementName isEqualToString:@"SHARE_URL"]) {
		NSString *content = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
		_obj.shareUrl = trimString(content);
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
