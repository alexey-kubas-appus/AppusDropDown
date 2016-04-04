//
//  ButtonDownPicker.m
//  DropDown
//
//  Created by Simon Kostenko on 12/22/15.
//  Copyright © 2015 Simon Kostenko. All rights reserved.
//

#import "ButtonDownPicker.h"
#import "DropDownTableViewCell.h"
#import "ButtonDownPickerProtected.h"

@interface ButtonDownPicker()

@end

@implementation ButtonDownPicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)showDownPicker {
    if (self.tableView) {
        return;
    }
   
    UITableView *tableView = [[UITableView alloc] init];
    
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = nil;
    
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    
    self.tableView.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame), CGRectGetWidth(self.bounds), 0);
    
    [self.superview addSubview:self.tableView];
    
    [UIView animateWithDuration:0.42f animations:^{
        CGRect rect = self.tableView.frame;
        rect.size.height = 200.f;
        self.tableView.frame = rect;
        
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(buttonDownPickerDidShow:)]) {
            [self.delegate buttonDownPickerDidShow:self];
        }
    }];
}

- (void)hideDownPicker {
    [UIView animateWithDuration:0.42f animations:^{
        CGRect rect = self.tableView.frame;
        rect.size.height = 0.f;
        self.tableView.frame = rect;
    } completion:^(BOOL finished) {
        [self.tableView removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(buttonDownPickerDidCancel:)]) {
            [self.delegate buttonDownPickerDidCancel:self];
        }
    }];
}

#pragma mark - Getters

- (UIColor *)sectionBackgroundColor {
    if (!_sectionBackgroundColor) {
        _sectionBackgroundColor = [UIColor colorWithRed:235/255.f green:235/255.f blue:242/255.f alpha:1.f];
    }
    return _sectionBackgroundColor;
}

- (UIColor *)sectionTitleTextColor {
    if (!_sectionTitleTextColor) {
        _sectionTitleTextColor = [UIColor colorWithRed:90/255.f green:90/255.f blue:95/255.f alpha:1.f];
    }
    return _sectionTitleTextColor;
}

#pragma mark - UITableView

- (void)reloadData {
    [self.tableView reloadData];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone]; // works correctly
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource buttonDownPicker:self numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DropDownTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DropDownTableViewCell"];
    if (!cell) {
        NSArray *topLevelObjects =
        [[NSBundle mainBundle] loadNibNamed:@"DropDownTableViewCell"
                                      owner:self
                                    options:nil];
        
        for (DropDownTableViewCell *object in topLevelObjects) {
            if ([object class] == [DropDownTableViewCell class]) {
                cell = object;
                break;
            }
        }
        NSAssert(cell, @"Cell must not be nil");
    }
    
    cell.nameLabel.text = [self.dataSource buttonDownPicker:self stringForRowAtIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    static const NSUInteger kDefaultNumberOfSections = 1;
    
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInButtonDownPicker:)]) {
        return [self.dataSource numberOfSectionsInButtonDownPicker:self];
    } else {
        return kDefaultNumberOfSections;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    if (![self.dataSource respondsToSelector:@selector(buttonDownPicker:titleForHeaderInSection:)] && tableView.numberOfSections == 1) {
        return 0.f;
    } else {
        return 30.f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
    view.backgroundColor = self.sectionBackgroundColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.tableView.frame.size.width, 30)];
    static NSString *kDefaaultHeaderString = @"";
    if ([self.dataSource respondsToSelector:@selector(buttonDownPicker:titleForHeaderInSection:)]) {
        label.text = [self.dataSource buttonDownPicker:self titleForHeaderInSection:section];
    } else {
        label.text = kDefaaultHeaderString;
    }
    
    label.font = self.sectionTitleTextFont;
    label.textColor = self.sectionTitleTextColor;
    
    
    [view addSubview:label];
    return view;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate buttonDownPicker:self didSelectRowAtIndexPath:indexPath];
    
    [self hideDownPicker];
}

@end
