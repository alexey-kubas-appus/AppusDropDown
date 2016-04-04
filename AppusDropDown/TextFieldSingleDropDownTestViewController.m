//
//  TextFieldSingleDropDownTestViewController.m
//  DropDown
//
//  Created by Simon Kostenko on 12/25/15.
//  Copyright © 2015 Simon Kostenko. All rights reserved.
//

#import "TextFieldSingleDropDownTestViewController.h"
#import "TextFieldDownPicker.h"

@interface TextFieldSingleDropDownTestViewController ()<TextFieldDownPickerDelegate, TextFieldDownPickerDataSource>

@property (weak, nonatomic) IBOutlet TextFieldDownPicker *textField;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;

@property (nonatomic, strong) NSMutableArray<NSString *> *titlesForHeaders;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation TextFieldSingleDropDownTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titlesForHeaders = [[NSMutableArray alloc] initWithArray:@[@"Europe", @"Asia", @"Africa", @"South America", @"North America"]];
    
    self.dataSource = [[NSMutableArray alloc] initWithArray:@[@[@"Albania", @"Croatia", @"Spain", @"Ukraine", @"Germany"], @[@"Afghanistan", @"Bhutan", @"Bangladesh", @"China", @"India"], @[@"Algeria", @"Benin", @"Cameroon", @"Egypt", @"Gambia", @"Gabon"], @[@"Argentina", @"Brazil", @"Chile", @"Colombia", @"Ecuador" ], @[@"Belize", @"Canada", @"Costa Rica", @"Mexico"]]];
    
    self.textField.downPickerDelegate = self;
    self.textField.dataSource = self;
    
    self.textField.sectionTitleTextFont = [UIFont fontWithName:@"Palatino" size:22];
}

- (IBAction)textFieldTextChanged:(TextFieldDownPicker *)sender {
    [sender reloadDownPickerData];
}

- (IBAction)textFieldDidBeginEditing:(TextFieldDownPicker *)sender {
    [sender showDownPicker];
}

- (IBAction)textFieldDidEndEditing:(TextFieldDownPicker *)sender {
    [sender hideDownPicker];
}

#pragma mark - TextFieldDownPickerDataSource

- (NSUInteger)textFieldDownPicker:(TextFieldDownPicker *)textFieldDownPicker numberOfRowsInSection:(NSUInteger)section {
    return ((NSArray*)[self.dataSource objectAtIndex:section]).count;
}

- (NSString *)textFieldDownPicker:(TextFieldDownPicker *)textFieldDownPicker stringForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((NSArray*)[self.dataSource objectAtIndex:indexPath.section])[indexPath.row];
}

- (NSUInteger)numberOfSectionsInTextFieldDownPicker:(TextFieldDownPicker *)textFieldDownPicker {
    return self.titlesForHeaders.count;
}

- (NSString *)textFieldDownPicker:(TextFieldDownPicker *)textFieldDownPicker titleForHeaderInSection:(NSUInteger)section {
    return self.titlesForHeaders[section];
}

#pragma mark - TextFieldDownPickerDelegate

- (void)textFieldDownPicker:(TextFieldDownPicker *)textFieldDownPicker didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.informationLabel.text = [NSString stringWithFormat:@"Choose item in section %li, row = %li. It is %@", (long)indexPath.section, (long)indexPath.row, ((NSArray*)[self.dataSource objectAtIndex:indexPath.section])[indexPath.row]];
}
#pragma mark - User Actions

- (IBAction)reloadData:(UIButton *)sender {
//    [self.titlesForHeaders insertObject:@"HELLO" atIndex:2];
//    [self.dataSource insertObject:@[@"1", @"2", @"3"] atIndex:2];
    [self.textField reloadData];
}
- (IBAction)reloadDownPickerData:(UIButton *)sender {
    [self.textField reloadDownPickerData];
}

@end
