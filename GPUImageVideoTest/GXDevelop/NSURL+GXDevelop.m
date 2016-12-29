//
//  NSURL+GXDevelop.m
//  GXDevelopDemo
//
//  Created by 高才新 on 16/4/1.
//  Copyright © 2016年 高才新. All rights reserved.
//

#import "NSURL+GXDevelop.h"


@implementation NSURL (GXDevelop)


+ (NSURL*)gxGenerateURL:(NSString*)baseURL params:(NSDictionary*)params
{
    if (params) {
        NSMutableArray* pairs = [NSMutableArray array];
        for (NSString* key in params.keyEnumerator) {
            NSString* value = [params objectForKey:key];
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
        }
        
        NSString* query = [pairs componentsJoinedByString:@"&"];
        NSString* url = [NSString stringWithFormat:@"%@?%@", baseURL, query];
        return [NSURL URLWithString:url];
    } else {
        return [NSURL URLWithString:baseURL];
    }
}

@end
