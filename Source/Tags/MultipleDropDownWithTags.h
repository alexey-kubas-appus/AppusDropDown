//
//  MultipleDropDownWithTags.h
//  TagsInputSample
//
//  Created by Simon Kostenko on 12/28/15.
//  Copyright © 2015 TheLightPrjg. All rights reserved.
//

#import "TLTagsControl.h"

@protocol MultipleDropDownPickerWithTagsDelegate;
@protocol MultipleDropDownPickerWithTagsDataSource;

@interface MultipleDropDownWithTags : TLTagsControl

@property (nonatomic, weak) id<MultipleDropDownPickerWithTagsDataSource> dataSource;
@property (nonatomic, weak) id<MultipleDropDownPickerWithTagsDelegate> downPickerDelegate;

- (void)showDownPicker;
- (void)hideDownPicker;

- (void)reloadDownPickerData;

- (void)reloadData;


@property (nonatomic, strong) UIColor *sectionTitleTextColor;
@property (nonatomic, strong) UIColor *sectionBackgroundColor;
@property (nonatomic, strong) UIFont *sectionTitleTextFont;

@property (nonatomic, strong) UIColor *headerTitleTextColor;
@property (nonatomic, strong) UIColor *headerBackgroundColor;
@property (nonatomic, strong) UIFont *headerTitleTextFont;
@property (nonatomic, strong) UIImage *doneButtonImage;

@end

@protocol MultipleDropDownPickerWithTagsDelegate <NSObject>

@required

- (void)downPicker:(MultipleDropDownWithTags *)downPicker didSelectedRowsAtIndexPathes:(NSArray *)indexPathes;

@optional

- (void)downPicker:(MultipleDropDownWithTags *)downPicker didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)downPickerDidShow:(MultipleDropDownWithTags *)downPicker;

- (void)downPickerDidCancel:(MultipleDropDownWithTags *)downPicker;

@end

@protocol MultipleDropDownPickerWithTagsDataSource <NSObject>

@required

- (NSUInteger)downPicker:(MultipleDropDownWithTags *)downPicker numberOfRowsInSection:(NSUInteger)section;

- (NSString *)downPicker:(MultipleDropDownWithTags *)downPicker stringForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (NSUInteger)numberOfSectionsInDownPicker:(MultipleDropDownWithTags *)downPicker; // Default is 1 if not implemented

- (NSString *)downPicker:(MultipleDropDownWithTags *)downPicker titleForHeaderInSection:(NSUInteger)section;

@end
