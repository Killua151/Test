//
//  NSObject+ObjectMapping.m
//  fanto
//
//  Created by Ethan Nguyen on 10/1/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "NSObject+ObjectMapping.h"
#import "objc/runtime.h"

#undef DEBUG

@interface NSObject (ObjectMapping_Private)

static const char *getPropertyType(objc_property_t property);

@end

@implementation NSObject (ObjectMapping)

- (void)assignProperties:(NSDictionary *)dict {
  for (NSString *key in dict) {
    NSObject *value = [dict valueForKey:key];
    
//    NSString *name = [Utils convertToCamelCaseFromSnakeCase:key capitalizeFirstLetter:NO];
    NSString *name = key;
    
    objc_property_t property =
    class_getProperty([self class], [name cStringUsingEncoding:NSUTF8StringEncoding]);
    if (property == NULL) {
#ifdef DEBUG
      NSLog(@"no property for key %@", key);
#endif
      continue;
    }
    
    NSString *attributesString = [NSString stringWithUTF8String:property_getAttributes(property)];
    NSString *typeString = [[attributesString componentsSeparatedByString:@","][0] substringFromIndex:1];
    
    if ([typeString length] == 1 && [@"cdiflsb" rangeOfString:[typeString lowercaseString]].location != NSNotFound) {
      if ([value isKindOfClass:[NSNumber class]])
        [self setValue:value forKey:name];
#ifdef DEBUG
      else
        NSLog(@"property %@ does not match type %@", name, [value class]);
#endif
      continue;
    }
    
    if ([typeString rangeOfString:@"@"].location == NSNotFound) {
#ifdef DEBUG
      NSLog(@"unknown type %@", typeString);
      continue;
#endif
    }
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"@\"(.+)\""
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:typeString options:0 range:NSMakeRange(0, [typeString length])];
    
    if ([matches count] == 0) {
#ifdef DEBUG
      NSLog(@"unknown type %@", typeString);
#endif
      continue;
    }
    
    NSTextCheckingResult *match = [matches objectAtIndex:0];
    NSString *className = [typeString substringWithRange:[match rangeAtIndex:1]];
    Class aClass = NSClassFromString(className);
    
    if ([value isKindOfClass:[NSNull class]]) {
#ifdef DEBUG
      NSLog(@"do not set null value for property %@", name);
#endif
    } else if ([value isKindOfClass:NSClassFromString(className)])
      [self setValue:value forKey:name];
    else if (class_respondsToSelector(aClass, @selector(assignProperties:)) &&
             [value isKindOfClass:[NSDictionary class]]) {
      // Recursive
      id subObject = [[aClass alloc] init];
      [subObject assignProperties:(NSDictionary *)value];
      [self setValue:subObject forKey:name];
    }
#ifdef DEBUG
    else
      NSLog(@"property %@ has type %@, while value has type %@", name, className, [value class]);
#endif
  }
}

+ (NSDictionary *)allPropertiesWithType {
  Class klass = [self class];
  
  if (klass == NULL)
    return nil;
  
  NSMutableDictionary *results = [NSMutableDictionary dictionary];
  
  unsigned int outCount, i;
  objc_property_t *properties = class_copyPropertyList(klass, &outCount);
  
  for (i = 0; i < outCount; i++) {
    objc_property_t property = properties[i];
    const char *propName = property_getName(property);
    
    if (propName) {
      const char *propType = getPropertyType(property);
      NSString *propertyName = [NSString stringWithUTF8String:propName];
      NSString *propertyType = [NSString stringWithUTF8String:propType];
      results[propertyName] = [NSString normalizedString:propertyType];
    }
  }
  
  free(properties);
  
  return results;
}

+ (NSArray *)allPropertiesList {
  NSDictionary *properites = [[self class] allPropertiesWithType];
  return [[properites allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

#pragma mark - ObjectProperties_Private methods
static const char *getPropertyType(objc_property_t property) {
  const char *attributes = property_getAttributes(property);
  
  char buffer[1 + strlen(attributes)];
  strcpy(buffer, attributes);
  char *state = buffer, *attribute;
  
  while ((attribute = strsep(&state, ",")) != NULL) {
    // it's a C primitive type
    if (attribute[0] == 'T' && attribute[1] != '@')
      return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
    
    // it's an ObjC id type
    if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2)
      return "id";
    
    // it's another ObjC object type:
    if (attribute[0] == 'T' && attribute[1] == '@')
      return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
  }
  
  return "";
}

#ifndef DEBUG
#define DEBUG
#endif

@end
