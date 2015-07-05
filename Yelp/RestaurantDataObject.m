//
//  RestaurantDataObject.m
//  Yelp
//
//  Created by Cheng-Yuan Wu on 6/25/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "RestaurantDataObject.h"

@implementation RestaurantDataObject

-(id)initWithRawData:(NSDictionary *)restaurantRawData {
    self = [self init];
    if (self) {
        NSLog(@"raw=====%@", restaurantRawData);
        self.mainImgUrl = restaurantRawData[@"image_url"];
        self.name =  restaurantRawData[@"name"];
        //cast number to string
        self.review =[ NSString stringWithFormat:@"%@",restaurantRawData[@"review_count"]];
        self.ratingImgUrl = restaurantRawData[@"rating_img_url"];
        if ([restaurantRawData[@"location"][@"address"] count] > 0) {
            self.address =  restaurantRawData[@"location"][@"address"][0];
        }
        else {
           self.address = @"";
        }
        self.distance = [NSString stringWithFormat:@"%ld", [restaurantRawData[@"distance"] integerValue]];
        self.type = restaurantRawData[@"categories"] ? restaurantRawData[@"categories"][0][0] : @"";
    }
    return self;
}
@end
