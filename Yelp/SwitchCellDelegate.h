//
//  SwitchCellDelegate.h
//  Yelp
//
//  Created by Cheng-Yuan Wu on 6/30/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SwitchCellDelegate <NSObject>

@required
- (void)switchCell:(UITableViewCell *)cell didUpdateValue:(BOOL)value;

@end
