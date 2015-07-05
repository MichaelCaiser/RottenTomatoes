//
//  SwitchTableCell.h
//  Yelp
//
//  Created by Cheng-Yuan Wu on 6/28/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchCellDelegate.h"

@interface SwitchTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *uiSwitch;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (strong, nonatomic) id <SwitchCellDelegate> delegate;
@end
