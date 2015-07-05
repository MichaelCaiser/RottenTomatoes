//
//  YelpClient.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpClient.h"

@implementation YelpClient

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken accessSecret:(NSString *)accessSecret {
    NSURL *baseURL = [NSURL URLWithString:@"http://api.yelp.com/v2/"];
    self = [super initWithBaseURL:baseURL consumerKey:consumerKey consumerSecret:consumerSecret];
    if (self) {
        BDBOAuthToken *token = [BDBOAuthToken tokenWithToken:accessToken secret:accessSecret expiration:nil];
        [self.requestSerializer saveAccessToken:token];
    }
    return self;
}

- (AFHTTPRequestOperation *)searchWithDict:(NSMutableDictionary *)dict success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
//   NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary: @{@"term": @"thai", @"sort": @"2" ,@"ll" : @"37.774866,-122.394556"}];

 //   NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary: @{@"category_filter":@"vegetarian,coffee,french", @"sort": @"2" ,@"ll" : @"37.774866,-122.394556"}];
//    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:@"coffee", nil];
//    NSMutableArray *arr2 = [NSMutableArray arrayWithArray:arr];
    //[parameters setObject:arr2 forKey:@"category_filter"];
    
    NSMutableDictionary *dict_copy = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    NSMutableArray *category = dict_copy[@"category_filter"];
    if (category != nil) {
        NSString *query_string = [[NSString alloc] init];
        query_string = @"";
        for (int i=0; i<[category count]; ++i) {
            query_string = [query_string stringByAppendingString:category[i]];
            if (i+1 < [category count]) {
                query_string = [query_string stringByAppendingString:@","];
            }
            NSLog(@"arr=%@", category[0]);
            NSLog(@"querystr=%@",query_string);
        }
        [dict_copy setObject:query_string forKey:@"category_filter"];
    }
    return [self GET:@"search" parameters:dict_copy success:success failure:failure];
}

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
    NSDictionary *parameters = @{@"term": term, @"ll" : @"37.774866,-122.394556"};
    
    return [self GET:@"search" parameters:parameters success:success failure:failure];
}
@end
