//
//  SwitchTableCell.m
//  Yelp
//
//  Created by Cheng-Yuan Wu on 6/28/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "SwitchTableCell.h"

@implementation SwitchTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onSwitchPressed:(id)sender {
    [self.delegate switchCell:self didUpdateValue:((UISwitch *)sender).isOn];
}
@end
