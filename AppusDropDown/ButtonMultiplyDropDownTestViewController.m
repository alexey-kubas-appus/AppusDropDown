//
//  ButtonMultiplyDropDownTestViewController.m
//  DropDown
//
//  Created by Simon Kostenko on 12/25/15.
//  Copyright © 2015 Simon Kostenko. All rights reserved.
//

#import "ButtonMultiplyDropDownTestViewController.h"
#import "ButtonMultiplyDownPicker.h"

@interface ButtonMultiplyDropDownTestViewController ()<ButtonMultiplyDownPickerDelegate, ButtonDownPickerDataSource>

@property (weak, nonatomic) IBOutlet ButtonMultiplyDownPicker *button;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;

@property (nonatomic, strong) NSMutableArray<NSString *> *titlesForHeaders;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ButtonMultiplyDropDownTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titlesForHeaders = [[NSMutableArray alloc] initWithArray:@[@"Europe", @"Asia", @"Africa", @"South America", @"North America"]];
    
    self.dataSource = [[NSMutableArray alloc] initWithArray:@[@[@"Albania", @"Croatia", @"Spain", @"Ukraine", @"Germany"], @[@"Afghanistan", @"Bhutan", @"Bangladesh", @"China", @"India"], @[@"Algeria", @"Benin", @"Cameroon", @"Egypt", @"Gambia", @"Gabon"], @[@"Argentina", @"Brazil", @"Chile", @"Colombia", @"Ecuador" ], @[@"Belize", @"Canada", @"Costa Rica", @"Mexico"]]];
    
    self.button.delegate = self;
    self.button.dataSource = self;
    
    self.button.sectionTitleTextFont = [UIFont fontWithName:@"Palatino" size:22];
    
    self.button.headerTitleTextFont = [UIFont fontWithName:@"Palatino" size:25];
}

#pragma mark - User Actions

- (IBAction)buttonTapped:(ButtonMultiplyDownPicker *)sender {
    [sender showDownPicker];
}

- (IBAction)reloadData:(UIButton *)sender {
    [self.button reloadData];
}

#pragma mark - ButtonMultiplyDownPickerDelegate

- (void)buttonDownPicker:(ButtonDownPicker *)buttonDownPicker didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)buttonMultiplyDownPicker:(ButtonMultiplyDownPicker *)buttonMultiplyDownPicker didSelectedRowsAtIndexPathes:(NSArray *)indexPathes {
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    for (NSIndexPath *indexPath in indexPathes) {
        [mutableString appendString:[NSString stringWithFormat:@"Choose item in section %li, row = %li. It is %@\n", (long)indexPath.section, (long)indexPath.row, ((NSArray*)[self.dataSource objectAtIndex:indexPath.section])[indexPath.row]]];
    }
    self.informationLabel.text = mutableString;
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
