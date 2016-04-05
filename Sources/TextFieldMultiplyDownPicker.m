//
//  TextFieldMultiplyDownPicker.m
//  DropDown
//
//  Created by Simon Kostenko on 12/24/15.
//  Copyright © 2015 Simon Kostenko. All rights reserved.
//

#import "TextFieldMultiplyDownPicker.h"
#import "DropDownHeaderView.h"
#import "DropDownTableViewCell.h"
#import "TextFieldDownPickerProtected.h"

@interface TextFieldMultiplyDownPicker()<DropDownHeaderViewDelegate>

@property (nonatomic, strong) NSMutableArray *selectedIndexPathes;

@property (nonatomic, weak) DropDownHeaderView *headerView;

@end

@implementation TextFieldMultiplyDownPicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)showDownPicker {
    if (self.tableView) {
        [self hideDownPicker];
        return;
    }
    
    DropDownHeaderView *view = [[DropDownHeaderView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame), CGRectGetWidth(self.bounds), 0)];
    view.title = @"It is title";
    view.delegate = self;
    
    view.headerTitleTextColor = self.headerTitleTextColor;
    view.headerBackgroundColor = self.headerBackgroundColor;
    view.headerTitleTextFont = self.headerTitleTextFont;
    view.doneButtonImage = self.doneButtonImage;
    
    self.headerView = view;
    
    UITableView *tableView = [[UITableView alloc] init];
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = nil;
    
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    
    
    self.tableView.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame)+50, CGRectGetWidth(self.bounds), 0);
    
    [self reloadData];
    
    [self.superview addSubview:self.headerView];
    
    [self.superview addSubview:self.tableView];
    
    [UIView animateWithDuration:0.1f delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect rect = self.headerView.frame;
        rect.size.height = 50.f;
        self.headerView.frame = rect;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4f delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
            CGRect rect = self.tableView.frame;
            rect.size.height = 200.f;
            self.tableView.frame = rect;
        } completion:^(BOOL finished) {
            if ([self.downPickerDelegate respondsToSelector:@selector(textFieldDownPickerDidShow:)]) {
                [self.downPickerDelegate textFieldDownPickerDidShow:self];
            }
        }];
    }];
}

- (void)hideDownPicker {
    [UIView animateWithDuration:0.4f delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect rect = self.tableView.frame;
        rect.size.height = 0.f;
        self.tableView.frame = rect;
    } completion:^(BOOL finished) {
        [self.tableView removeFromSuperview];
        [UIView animateWithDuration:0.1f delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
            CGRect rect = self.headerView.frame;
            rect.size.height = 0.f;
            self.headerView.frame = rect;
        } completion:^(BOOL finished) {
            [self resignFirstResponder];
            [self.headerView removeFromSuperview];
            if ([self.downPickerDelegate respondsToSelector:@selector(textFieldDownPickerDidCancel:)]) {
                [self.downPickerDelegate textFieldDownPickerDidCancel:self];
            }
        }];
    }];
}

#pragma mark - Getters

- (NSMutableArray *)selectedIndexPathes {
    if (!_selectedIndexPathes) {
        _selectedIndexPathes = [[NSMutableArray alloc] init];
    }
    return _selectedIndexPathes;
}

- (UIColor *)headerBackgroundColor {
    if (!_headerBackgroundColor) {
        //        _headerBackgroundColor = [UIColor colorWithRed:0.4f green:0.4f blue:0.7f alpha:1.f];
        _headerBackgroundColor = [UIColor whiteColor];
    }
    return _headerBackgroundColor;
}

- (UIColor *)headerTitleTextColor {
    if (!_headerTitleTextColor) {
        //        _headerTitleTextColor = [UIColor colorWithRed:51/255.f green:90/255.f blue:1.f alpha:1.f];
        _headerTitleTextColor = [UIColor blackColor];
    }
    return _headerTitleTextColor;
}

- (UIImage *)doneButtonImage {
    if (!_doneButtonImage) {
        _doneButtonImage = [UIImage imageNamed:@"done"];
    }
    return _doneButtonImage;
}

- (UIFont *)headerTitleTextFont {
    if (!_headerTitleTextFont) {
        _headerTitleTextFont = [UIFont systemFontOfSize:22];
    }
    return _headerTitleTextFont;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.downPickerDelegate textFieldDownPicker:self didSelectRowAtIndexPath:[self.baseIndexPathesOfNewIndexPathes objectForKey:indexPath]];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([self.selectedIndexPathes containsObject:[self.baseIndexPathesOfNewIndexPathes objectForKey:indexPath]]){
        [self.selectedIndexPathes removeObject:[self.baseIndexPathesOfNewIndexPathes objectForKey:indexPath]];
    } else {
        [self.selectedIndexPathes addObject:[self.baseIndexPathesOfNewIndexPathes objectForKey:indexPath]];
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UITableViewDataSource

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
    cell.nameLabel.text = [self.stringsOfDataSourceNew objectForKey:indexPath];
    
    if ([self.selectedIndexPathes containsObject:[self.baseIndexPathesOfNewIndexPathes objectForKey:indexPath]]) {
        cell.checkMarkImageView.hidden = NO;
    }
    else {
        cell.checkMarkImageView.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - DropDownHeaderViewDelegate

- (void)doneButtonTapped:(DropDownHeaderView *)dropDownHeaderView {
    NSLog(@"done button tapped");
    [(id<TextFieldMultiplyDownPickerDelegate>)self.downPickerDelegate textFieldMultiplyDownPicker:self didSelectedRowsAtIndexPathes:self.selectedIndexPathes];
    [self hideDownPicker];
}

@end
