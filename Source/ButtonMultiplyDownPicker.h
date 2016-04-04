//
//  ButtonMultiplyDownPicker.h
//  DropDown
//
//  Created by Simon Kostenko on 12/23/15.
//  Copyright © 2015 Simon Kostenko. All rights reserved.
//

#import "ButtonDownPicker.h"

@protocol ButtonMultiplyDownPickerDelegate;

@interface ButtonMultiplyDownPicker : ButtonDownPicker

@property (nonatomic, strong) UIColor *headerTitleTextColor;
@property (nonatomic, strong) UIColor *headerBackgroundColor;
@property (nonatomic, strong) UIFont *headerTitleTextFont;
@property (nonatomic, strong) UIImage *doneButtonImage;

@end

@protocol ButtonMultiplyDownPickerDelegate <ButtonDownPickerDelegate>

@required

- (void)buttonMultiplyDownPicker:(ButtonMultiplyDownPicker *)buttonMultiplyDownPicker didSelectedRowsAtIndexPathes:(NSArray *)indexPathes;

@end
