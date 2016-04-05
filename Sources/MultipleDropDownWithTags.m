//
//  MultipleDropDownWithTags.m
//  TagsInputSample
//
//  Created by Simon Kostenko on 12/28/15.
//  Copyright © 2015 TheLightPrjg. All rights reserved.
//

#import "MultipleDropDownWithTags.h"
#import "DropDownHeaderView.h"
#import "DropDownTableViewCell.h"
#import "TLTagsControlProtected.h"

@interface MultipleDropDownWithTags()<UITableViewDataSource, UITableViewDelegate, DropDownHeaderViewDelegate>

@property (nonatomic, strong) NSMutableArray *selectedIndexPathes;

@property (nonatomic, weak) DropDownHeaderView *headerView;


@property (nonatomic, strong) NSString *searchString;

// all data source from user
@property (nonatomic, strong) NSMutableArray<NSString *> *titlesForHeadersInSections;
@property (nonatomic, strong) NSMutableArray *numbersOfRowsInSections; // of NSNumber * with NSInteger
@property (nonatomic, strong) NSMutableDictionary *stringsOfDataSource; // for nsindexpath we have string


// data source for table with searching
@property (nonatomic, strong) NSMutableArray *existingSections;
@property (nonatomic, strong) NSMutableArray *numberOfRowsInSectionsNew; // of NSNumber * with NSInteger
@property (nonatomic, strong) NSMutableDictionary *stringsOfDataSourceNew; // for nsindexpath we have string
@property (nonatomic, strong) NSMutableDictionary *baseIndexPathesOfNewIndexPathes;

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation MultipleDropDownWithTags

#pragma mark - Initialization

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.tagInputField_ addTarget:self action:@selector(textFieldDidChangeText:) forControlEvents:UIControlEventEditingChanged];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.tagInputField_ addTarget:self action:@selector(textFieldDidChangeText:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

#pragma mark - Show and hide down picker

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
    } completion:nil];

    [UIView animateWithDuration:0.4f delay:0.1f options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect rect = self.tableView.frame;
        rect.size.height = 200.f;
        self.tableView.frame = rect;
    } completion:^(BOOL finished) {
        if ([self.downPickerDelegate respondsToSelector:@selector(downPickerDidShow:)]) {
            [self.downPickerDelegate downPickerDidShow:self];
        }
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
            [self.tagInputField_ resignFirstResponder];
            [self.headerView removeFromSuperview];
            if ([self.downPickerDelegate respondsToSelector:@selector(downPickerDidCancel:)]) {
                [self.downPickerDelegate downPickerDidCancel:self];
            }
        }];
    }];
}

#pragma mark - reload methods

- (void)reloadData {
    [self getDataSource]; // get dataSource from client
    [self reloadDownPickerData];
}

- (void)reloadDownPickerData {
    self.searchString = self.tagInputField_.text;
    [self generateDataSourceForPicker];
    [self.tableView reloadData]; // update table using data source for picker
    if (self.existingSections.count) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - Getters

- (NSMutableArray *)selectedIndexPathes {
    if (!_selectedIndexPathes) {
        _selectedIndexPathes = [[NSMutableArray alloc] init];
    }
    return _selectedIndexPathes;
}

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

#pragma mark - DropDownHeaderViewDelegate

- (void)doneButtonTapped:(DropDownHeaderView *)dropDownHeaderView {
    NSLog(@"done button tapped");
    [(id<MultipleDropDownPickerWithTagsDelegate>)self.downPickerDelegate downPicker:self didSelectedRowsAtIndexPathes:self.selectedIndexPathes];
    [self hideDownPicker];
}

#pragma mark - User Actions

- (void)deleteTagButton:(UIButton *)sender {
    NSArray *array = [self.tags copy];
    [super deleteTagButton:sender];
    
    for (NSString *string in array) {
        if (![self.tags containsObject:string]) {
            NSArray *keys = [self.stringsOfDataSource allKeysForObject:string];
            NSArray *newKeys = [self.stringsOfDataSourceNew allKeysForObject:string];
            if (keys.count == 1) {
                NSIndexPath *indexPath = keys.firstObject;
                NSIndexPath *indexPathNew = newKeys.firstObject;
                [self.selectedIndexPathes removeObject:indexPath];
                NSLog(@"Section = %li, row = %li", (long)indexPath.section, (long)indexPath.row);
                NSLog(@"Section = %li, row = %li", (long)indexPathNew.section, (long)indexPathNew.row);
                [self.tableView reloadRowsAtIndexPaths:@[indexPathNew] withRowAnimation:UITableViewRowAnimationNone];
            } else {
                NSAssert(keys, @"For object must be only one key");
            }
            break;
        }
    }
}

#pragma mark - get datasource from client

- (void)getDataSource {
    self.titlesForHeadersInSections = nil;
    self.numbersOfRowsInSections = nil;
    self.stringsOfDataSource = nil;
    
    NSUInteger numberOfSections;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInDownPicker:)]) {
        
        numberOfSections = [self.dataSource numberOfSectionsInDownPicker:self];
    } else {
        numberOfSections = 1;
    }
    
    for (NSUInteger section = 0; section < numberOfSections; section++) {
        if ([self.dataSource respondsToSelector:@selector(downPicker:titleForHeaderInSection:)]) {
            
            [self.titlesForHeadersInSections addObject:[self.dataSource downPicker:self titleForHeaderInSection:section]];
        } else {
            [self.titlesForHeadersInSections addObject:@""];
        }
        
        NSUInteger numberOfRowsInSection = [self.dataSource downPicker:self numberOfRowsInSection:section];
        [self.numbersOfRowsInSections addObject:[NSNumber numberWithUnsignedInteger:numberOfRowsInSection]];
        
        for (NSUInteger row = 0; row < numberOfRowsInSection; row++) {
            [self.stringsOfDataSource setObject:[self.dataSource downPicker:self stringForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]] forKey:[NSIndexPath indexPathForRow:row inSection:section]];
        }
    }
}

#pragma mark - data source with autocompletion

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
    
    if ([self.selectedIndexPathes containsObject:[self.baseIndexPathesOfNewIndexPathes objectForKey:indexPath]]) {
        cell.checkMarkImageView.hidden = NO;
    }
    else {
        cell.checkMarkImageView.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.existingSections.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    if (![self.dataSource respondsToSelector:@selector(downPicker:titleForHeaderInSection:)] && tableView.numberOfSections == 1) {
        return 0.f;
    } else {
        return 30.f;
    }
//    return 30.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
    view.backgroundColor = self.sectionBackgroundColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.tableView.frame.size.width, 30)];
    
    NSNumber *number = self.existingSections[section];
    NSInteger sectionIndex = [number integerValue];
    label.text = self.titlesForHeadersInSections[sectionIndex];
    
    label.font = self.sectionTitleTextFont;
    label.textColor = self.sectionTitleTextColor;
    
    [view addSubview:label];
    
    return view;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.downPickerDelegate respondsToSelector:@selector(downPicker:didSelectRowAtIndexPath:)]) {
        [self.downPickerDelegate downPicker:self didSelectRowAtIndexPath:[self.baseIndexPathesOfNewIndexPathes objectForKey:indexPath]];
    }
    
    if([self.selectedIndexPathes containsObject:[self.baseIndexPathesOfNewIndexPathes objectForKey:indexPath]]){
        [self.selectedIndexPathes removeObject:[self.baseIndexPathesOfNewIndexPathes objectForKey:indexPath]];
        [self.tags removeObject:[self.stringsOfDataSourceNew objectForKey:indexPath]];
        [self reloadTagSubviews];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        [self.selectedIndexPathes addObject:[self.baseIndexPathesOfNewIndexPathes objectForKey:indexPath]];
        [self addTag:[self.stringsOfDataSourceNew objectForKey:indexPath]];
        self.tagInputField_.text = @"";
        [self reloadDownPickerData];
    }
}

#pragma mark - textfield stuff

- (void)textFieldDidChangeText:(UITextField *)sender {
    [self reloadDownPickerData];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField; {
    [self showDownPicker];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self hideDownPicker];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
