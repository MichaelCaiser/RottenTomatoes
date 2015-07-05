//
//  RestaurantDataObject.h
//  Yelp
//
//  Created by Cheng-Yuan Wu on 6/25/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestaurantDataObject : NSObject
@property (strong, nonatomic) NSString *mainImgUrl;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *review;
@property (strong, nonatomic) NSString *ratingImgUrl;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *distance;
-(id)initWithRawData:(NSDictionary *)restaurantRawData;
@end
