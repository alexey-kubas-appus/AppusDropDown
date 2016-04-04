//
//  DropDownHeaderView.h
//  DropDown
//
//  Created by Simon Kostenko on 12/16/15.
//  Copyright © 2015 Simon Kostenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropDownHeaderViewDelegate;

@interface DropDownHeaderView : UIView

@property (strong, nonatomic) NSString *title;

@property (nonatomic, weak) id<DropDownHeaderViewDelegate> delegate;

@property (nonatomic, strong) UIColor *headerTitleTextColor;
@property (nonatomic, strong) UIColor *headerBackgroundColor;
@property (nonatomic, strong) UIFont *headerTitleTextFont;
@property (nonatomic, strong) UIImage *doneButtonImage;

@end

@protocol DropDownHeaderViewDelegate <NSObject>

- (void)doneButtonTapped:(DropDownHeaderView *)dropDownHeaderView;

@end
