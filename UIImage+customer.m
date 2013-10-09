//
//  UIImage+customer.m
//  PeopleNewsReaderPhone
//
//  Created by lygn128 on 13-9-24.
//
//

#import "UIImage+customer.h"

@implementation UIImage (customer)
+(UIImage*)imageWithNameString:(NSString*)picName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:picName ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];
}
-(UIImage*)initWithNameString:(NSString*)picName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:picName ofType:@"png"];
    return [self initWithContentsOfFile:path];
}
@end
