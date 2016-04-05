//
//  ButtonDownPicker.h
//  DropDown
//
//  Created by Simon Kostenko on 12/22/15.
//  Copyright © 2015 Simon Kostenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ButtonDownPickerDelegate;
@protocol ButtonDownPickerDataSource;

@interface ButtonDownPicker : UIButton<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<ButtonDownPickerDataSource> dataSource;
@property (nonatomic, weak) id<ButtonDownPickerDelegate> delegate;

- (void)showDownPicker;
- (void)hideDownPicker;

- (void)reloadData;

@property (nonatomic, strong) UIColor *sectionTitleTextColor;
@property (nonatomic, strong) UIColor *sectionBackgroundColor;
@property (nonatomic, strong) UIFont *sectionTitleTextFont;

@end

@protocol ButtonDownPickerDelegate <NSObject>

@required

- (void)buttonDownPicker:(ButtonDownPicker *)buttonDownPicker didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (void)buttonDownPickerDidShow:(ButtonDownPicker *)buttonDownPicker;

- (void)buttonDownPickerDidCancel:(ButtonDownPicker *)buttonDownPicker;

@end

@protocol ButtonDownPickerDataSource <NSObject>

@required

- (NSUInteger)buttonDownPicker:(ButtonDownPicker *)buttonDownPicker numberOfRowsInSection:(NSUInteger)section;

- (NSString *)buttonDownPicker:(ButtonDownPicker *)buttonDownPicker stringForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional


- (NSUInteger)numberOfSectionsInButtonDownPicker:(ButtonDownPicker *)buttonDownPicker; // Default is 1 if not implemented

- (NSString *)buttonDownPicker:(ButtonDownPicker *)buttonDownPicker titleForHeaderInSection:(NSUInteger)section;

@end
