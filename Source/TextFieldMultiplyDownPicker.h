//
//  TextFieldMultiplyDownPicker.h
//  DropDown
//
//  Created by Simon Kostenko on 12/24/15.
//  Copyright © 2015 Simon Kostenko. All rights reserved.
//

#import "TextFieldDownPicker.h"

@interface TextFieldMultiplyDownPicker : TextFieldDownPicker

@property (nonatomic, strong) UIColor *headerTitleTextColor;
@property (nonatomic, strong) UIColor *headerBackgroundColor;
@property (nonatomic, strong) UIFont *headerTitleTextFont;
@property (nonatomic, strong) UIImage *doneButtonImage;

@end

@protocol TextFieldMultiplyDownPickerDelegate <TextFieldDownPickerDelegate>

@required

- (void)textFieldMultiplyDownPicker:(TextFieldMultiplyDownPicker *)textFieldMultiplyDownPicker didSelectedRowsAtIndexPathes:(NSArray *)indexPathes;

@end