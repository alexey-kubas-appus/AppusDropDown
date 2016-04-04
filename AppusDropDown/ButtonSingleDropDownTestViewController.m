//
//  ButtonSingleDropDownTestViewController.m
//  DropDown
//
//  Created by Simon Kostenko on 12/25/15.
//  Copyright © 2015 Simon Kostenko. All rights reserved.
//

#import "ButtonSingleDropDownTestViewController.h"
#import "ButtonDownPicker.h"

@interface ButtonSingleDropDownTestViewController ()<ButtonDownPickerDelegate, ButtonDownPickerDataSource>

@property (weak, nonatomic) IBOutlet ButtonDownPicker *button;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;

@property (nonatomic, strong) NSMutableArray<NSString *> *titlesForHeaders;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ButtonSingleDropDownTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titlesForHeaders = [[NSMutableArray alloc] initWithArray:@[@"Europe", @"Asia", @"Africa", @"South America", @"North America"]];
    
    self.dataSource = [[NSMutableArray alloc] initWithArray:@[@[@"Albania", @"Croatia", @"Spain", @"Ukraine", @"Germany"], @[@"Afghanistan", @"Bhutan", @"Bangladesh", @"China", @"India"], @[@"Algeria", @"Benin", @"Cameroon", @"Egypt", @"Gambia", @"Gabon"], @[@"Argentina", @"Brazil", @"Chile", @"Colombia", @"Ecuador" ], @[@"Belize", @"Canada", @"Costa Rica", @"Mexico"]]];
    
    self.button.delegate = self;
    self.button.dataSource = self;
    
    self.button.sectionTitleTextFont = [UIFont fontWithName:@"Palatino" size:22];
}

#pragma mark - User Actions

- (IBAction)reloadData:(UIButton *)sender {
    [self.button reloadData];
}

- (IBAction)buttonTapped:(ButtonDownPicker *)sender {
    [sender showDownPicker];
}

#pragma mark - ButtonDownPickerDelegate

- (void)buttonDownPicker:(ButtonDownPicker *)buttonDownPicker didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.informationLabel.text = [NSString stringWithFormat:@"Choose item in section %li, row = %li. It is %@", (long)indexPath.section, (long)indexPath.row, ((NSArray*)[self.dataSource objectAtIndex:indexPath.section])[indexPath.row]];
}

#pragma mark - ButtonDownPickerDataSource

- (NSUInteger)buttonDownPicker:(ButtonDownPicker *)buttonDownPicker numberOfRowsInSection:(NSUInteger)section {
    return ((NSArray*)[self.dataSource objectAtIndex:section]).count;
}

- (NSString *)buttonDownPicker:(ButtonDownPicker *)buttonDownPicker stringForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((NSArray*)[self.dataSource objectAtIndex:indexPath.section])[indexPath.row];
}

- (NSUInteger)numberOfSectionsInButtonDownPicker:(ButtonDownPicker *)buttonDownPicker {
    return self.titlesForHeaders.count;
}

- (NSString *)buttonDownPicker:(ButtonDownPicker *)buttonDownPicker titleForHeaderInSection:(NSUInteger)section {
    return self.titlesForHeaders[section];
}


@end
