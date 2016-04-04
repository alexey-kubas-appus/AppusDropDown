//
//  DropDownHeaderView.m
//  DropDown
//
//  Created by Simon Kostenko on 12/16/15.
//  Copyright © 2015 Simon Kostenko. All rights reserved.
//

#import "DropDownHeaderView.h"

@interface DropDownHeaderView()

@property (nonatomic) CGRect imageRect;

@end

@implementation DropDownHeaderView

#pragma mark - Initialization

- (void)setup {
    self.backgroundColor = nil;
    self.opaque = NO;
}

- (void)awakeFromNib {
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

#pragma mark - Properties

- (void)setTitle:(NSString *)title {
    _title = title;
    [self setNeedsDisplay];
}

- (void)setHeaderBackgroundColor:(UIColor *)headerBackgroundColor {
    self.backgroundColor = headerBackgroundColor;
    [self setNeedsDisplay];
}

- (void)setHeaderTitleTextColor:(UIColor *)headerTitleTextColor {
    _headerTitleTextColor = headerTitleTextColor;
    [self setNeedsDisplay];
}

- (void)setHeaderTitleTextFont:(UIFont *)headerTitleTextFont {
    _headerTitleTextFont = headerTitleTextFont;
    [self setNeedsDisplay];
}

- (void)setDoneButtonImage:(UIImage *)doneButtonImage {
    _doneButtonImage = doneButtonImage;
    [self setNeedsDisplay];
}

- (CGFloat)leftRightOffset {
    return 8.f;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    UIImage *doneImage = self.doneButtonImage;
    self.backgroundColor = self.headerBackgroundColor;
    if (doneImage) {
        CGRect imageRect;
        imageRect.size = doneImage.size;
        imageRect.origin = CGPointMake(self.bounds.size.width - doneImage.size.width - [self leftRightOffset], self.bounds.size.height/2 - doneImage.size.height/2);
        [doneImage drawInRect:imageRect];
        self.imageRect = imageRect;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doneButtonTapped:)];
    [self addGestureRecognizer:tap];
    
    NSAttributedString *titleText = [[NSAttributedString alloc] initWithString:self.title attributes:@{NSFontAttributeName : self.headerTitleTextFont, NSForegroundColorAttributeName :  self.headerTitleTextColor}];
    
    CGRect textBounds;
    textBounds.size = [titleText size];
    textBounds.origin = CGPointMake([self leftRightOffset], self.bounds.size.height/2 - textBounds.size.height/2);
    
    [titleText drawInRect:textBounds];
}

- (void)doneButtonTapped:(UITapGestureRecognizer *)tap {
    UIView* view = tap.view;
    CGPoint loc = [tap locationInView:view];
    if (CGRectContainsPoint(self.imageRect, loc)) {
        [self.delegate doneButtonTapped:self];
    }
}

@end
