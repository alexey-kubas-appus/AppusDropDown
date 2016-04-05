//
//  TextFieldDownPicker.m
//  DropDown
//
//  Created by Simon Kostenko on 12/22/15.
//  Copyright © 2015 Simon Kostenko. All rights reserved.
//

#import "TextFieldDownPicker.h"
#import "DropDownTableViewCell.h"
#import "TextFieldDownPickerProtected.h"

@interface TextFieldDownPicker()


@property (nonatomic, strong) NSString *searchString;

// all data source from user
@property (nonatomic, strong) NSMutableArray<NSString *> *titlesForHeadersInSections;
@property (nonatomic, strong) NSMutableArray *numbersOfRowsInSections; // of NSNumber * with NSInteger
@property (nonatomic, strong) NSMutableDictionary *stringsOfDataSource; // for nsindexpath we have string

@end

@implementation TextFieldDownPicker

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
    
    [self reloadData];
    
    [self.superview addSubview:self.tableView];
    
    [UIView animateWithDuration:0.42f animations:^{
        CGRect rect = self.tableView.frame;
        rect.size.height = 200.f;
        self.tableView.frame = rect;
    } completion:^(BOOL finished) {
        if ([self.downPickerDelegate respondsToSelector:@selector(textFieldDownPickerDidShow:)]) {
            [self.downPickerDelegate textFieldDownPickerDidShow:self];
        }
    }];
}

- (void)hideDownPicker {
    [UIView animateWithDuration:0.42f animations:^{
        CGRect rect = self.tableView.frame;
        rect.size.height = 0.f;
        self.tableView.frame = rect;
    } completion:^(BOOL finished) {
        [self resignFirstResponder];
        [self.tableView removeFromSuperview];
        if ([self.downPickerDelegate respondsToSelector:@selector(textFieldDownPickerDidCancel:)]) {
            [self.downPickerDelegate textFieldDownPickerDidCancel:self];
        }
    }];
}

- (void)reloadData {
    [self getDataSource]; // get dataSource from client
    [self reloadDownPickerData];
}

- (void)reloadDownPickerData {
    self.searchString = self.text;
    [self generateDataSourceForPicker];
    [self.tableView reloadData]; // update table using data source for picker
    if (self.existingSections.count) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSNumber *number = self.numberOfRowsInSectionsNew[section];
    return [number integerValue];
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
    
    cell.nameLabel.text = [self.stringsOfDataSourceNew objectForKey:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.existingSections.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    if (![self.dataSource respondsToSelector:@selector(textFieldDownPicker:titleForHeaderInSection:)] && tableView.numberOfSections == 1) {
        return 0.f;
    } else {
        return 30.f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
    view.backgroundColor = self.sectionBackgroundColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.tableView.frame.size.width, 30)];

    NSNumber *number = self.existingSections[section];
    NSInteger sectionIndex = [number integerValue];
    if (sectionIndex < self.titlesForHeadersInSections.count) {
        label.text = self.titlesForHeadersInSections[sectionIndex];
    } else {
        label.text = @"";
    }
    
    label.font = self.sectionTitleTextFont;
    label.textColor = self.sectionTitleTextColor;
    
    [view addSubview:label];
    
    return view;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.downPickerDelegate textFieldDownPicker:self didSelectRowAtIndexPath:[self.baseIndexPathesOfNewIndexPathes objectForKey:indexPath]];
    self.text = [self.stringsOfDataSourceNew objectForKey:indexPath];
    [self hideDownPicker];
}

#pragma mark - Getters

- (NSMutableArray<NSString *> *)titlesForHeadersInSections {
    if (!_titlesForHeadersInSections) {
        _titlesForHeadersInSections = [[NSMutableArray alloc] init];
    }
    return _titlesForHeadersInSections;
}

- (NSMutableArray *)numbersOfRowsInSections {
    if (!_numbersOfRowsInSections) {
        _numbersOfRowsInSections = [[NSMutableArray alloc] init];
    }
    return _numbersOfRowsInSections;
}

- (NSMutableDictionary *)stringsOfDataSource {
    if (!_stringsOfDataSource) {
        _stringsOfDataSource = [[NSMutableDictionary alloc] init];
    }
    return _stringsOfDataSource;
}

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

- (void)getDataSource {
    self.titlesForHeadersInSections = nil;
    self.numbersOfRowsInSections = nil;
    self.stringsOfDataSource = nil;
    
    NSUInteger numberOfSections;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTextFieldDownPicker:)]) {
        numberOfSections = [self.dataSource numberOfSectionsInTextFieldDownPicker:self];
    } else {
        numberOfSections = 1;
    }
    
    for (NSUInteger section = 0; section < numberOfSections; section++) {
        if ([self.dataSource respondsToSelector:@selector(textFieldDownPicker:titleForHeaderInSection:)]) {
            [self.titlesForHeadersInSections addObject:[self.dataSource textFieldDownPicker:self titleForHeaderInSection:section]];
        } else {
            [self.titlesForHeadersInSections addObject:@""];
        }
        
        NSUInteger numberOfRowsInSection = [self.dataSource textFieldDownPicker:self numberOfRowsInSection:section];
        [self.numbersOfRowsInSections addObject:[NSNumber numberWithUnsignedInteger:numberOfRowsInSection]];

        for (NSUInteger row = 0; row < numberOfRowsInSection; row++) {
            [self.stringsOfDataSource setObject:[self.dataSource textFieldDownPicker:self stringForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]] forKey:[NSIndexPath indexPathForRow:row inSection:section]];
        }
    }
}

- (void) generateDataSourceForPicker {
    NSMutableArray *existingSections = [[NSMutableArray alloc] init];
    NSMutableArray *numberOfRowsInSectionsNew = [[NSMutableArray alloc] init];
    NSMutableDictionary *stringsOfDataSourceNew = [[NSMutableDictionary alloc] init];
    self.baseIndexPathesOfNewIndexPathes = [[NSMutableDictionary alloc] init];
    
    if ([self.searchString isEqualToString:@""] || !self.searchString) {
        numberOfRowsInSectionsNew = self.numbersOfRowsInSections;
        stringsOfDataSourceNew = self.stringsOfDataSource;
        for (int i = 0; i < numberOfRowsInSectionsNew.count; i++) {
            [existingSections addObject:[NSNumber numberWithInteger:i]];
        }
        
        self.existingSections = existingSections;
        self.numberOfRowsInSectionsNew = numberOfRowsInSectionsNew;
        self.stringsOfDataSourceNew = stringsOfDataSourceNew;
        for (NSIndexPath *indexPath in [self.stringsOfDataSource allKeys]) {
            [self.baseIndexPathesOfNewIndexPathes setObject:indexPath forKey:indexPath];
        }
        return;
    }
    
    NSInteger section = 0;
    NSInteger row = 0;
    NSIndexPath *prevIndexPath = nil;
    NSInteger section1;
    NSInteger row1;
    BOOL isOne = NO;
    for (section1 = 0; section1 < self.numbersOfRowsInSections.count; section1++) {
        for (row1 = 0; row1 < [(NSNumber*)self.numbersOfRowsInSections[section] integerValue]; row1++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row1 inSection:section1];
            
            NSLog(@"section = %li, row = %li", (long)indexPath.section, (long)indexPath.row);
            NSString *string = [self.stringsOfDataSource objectForKey:indexPath];
            
            if ([[string lowercaseString] containsString:[self.searchString lowercaseString]]) {
                isOne = YES;
                if (prevIndexPath && indexPath.section != prevIndexPath.section) {
                    if (prevIndexPath) {
                        [existingSections addObject:[NSNumber numberWithInteger:prevIndexPath.section]];
                        [numberOfRowsInSectionsNew addObject:[NSNumber numberWithInteger:row]];
                    }
                    section++;
                    row = 0;
                }
                
                [stringsOfDataSourceNew setObject:string forKey:[NSIndexPath indexPathForRow:row inSection:section]];
                [self.baseIndexPathesOfNewIndexPathes setObject:indexPath forKey:[NSIndexPath indexPathForRow:row inSection:section]];
                row++;
                prevIndexPath = indexPath;
            }
        }
    }

    if (isOne) {
        [existingSections addObject:[NSNumber numberWithInteger:prevIndexPath.section]];
        [numberOfRowsInSectionsNew addObject:[NSNumber numberWithInteger:row]];
    }
    
    self.existingSections = existingSections;
    self.numberOfRowsInSectionsNew = numberOfRowsInSectionsNew;
    self.stringsOfDataSourceNew = stringsOfDataSourceNew;
    
    
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////// NEED FOR BEST VERSION
//    NSMutableArray *correctedIndexPathes = [[NSMutableArray alloc] init];
//    
//    for (NSInteger section = 0; section < [self.dataSource numberOfSectionsInTextFieldDownPicker:self]; section++) {
//        for (NSInteger row = 0; row < [self.dataSource textFieldDownPicker:self numberOfRowsInSection:section]; row++) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
//            
//            NSLog(@"section = %i, row = %i", indexPath.section, indexPath.row);
//            NSString *string = [self.dataSource textFieldDownPicker:self stringForRowAtIndexPath:indexPath];
//            
//            if ([[string lowercaseString] containsString:[self.searchString lowercaseString]]) {
//                [correctedIndexPathes addObject:indexPath];
//            }
//        }
//    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////
}


@end
