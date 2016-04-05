//
//  TextFieldDownPicker.h
//  DropDown
//
//  Created by Simon Kostenko on 12/22/15.
//  Copyright © 2015 Simon Kostenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextFieldDownPickerDelegate;
@protocol TextFieldDownPickerDataSource;

@interface TextFieldDownPicker : UITextField<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<TextFieldDownPickerDataSource> dataSource;
@property (nonatomic, weak) id<TextFieldDownPickerDelegate> downPickerDelegate;


- (void)showDownPicker;
- (void)hideDownPicker;

- (void)reloadDownPickerData;

- (void)reloadData;

@property (nonatomic, strong) UIColor *sectionTitleTextColor;
@property (nonatomic, strong) UIColor *sectionBackgroundColor;
@property (nonatomic, strong) UIFont *sectionTitleTextFont;

@end

@protocol TextFieldDownPickerDelegate <NSObject>

@required

- (void)textFieldDownPicker:(TextFieldDownPicker *)textFieldDownPicker didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (void)textFieldDownPickerDidShow:(TextFieldDownPicker *)textFieldDownPicker;

- (void)textFieldDownPickerDidCancel:(TextFieldDownPicker *)textFieldDownPicker;



@end

@protocol TextFieldDownPickerDataSource <NSObject>

@required

- (NSUInteger)textFieldDownPicker:(TextFieldDownPicker *)textFieldDownPicker numberOfRowsInSection:(NSUInteger)section;

- (NSString *)textFieldDownPicker:(TextFieldDownPicker *)textFieldDownPicker stringForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (NSUInteger)numberOfSectionsInTextFieldDownPicker:(TextFieldDownPicker *)textFieldDownPicker; // Default is 1 if not implemented

- (NSString *)textFieldDownPicker:(TextFieldDownPicker *)textFieldDownPicker titleForHeaderInSection:(NSUInteger)section;

@end



