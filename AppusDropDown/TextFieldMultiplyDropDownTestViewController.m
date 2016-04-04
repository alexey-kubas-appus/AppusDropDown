//
//  TextFieldMultiplyDropDownTestViewController.m
//  DropDown
//
//  Created by Simon Kostenko on 12/25/15.
//  Copyright © 2015 Simon Kostenko. All rights reserved.
//

#import "TextFieldMultiplyDropDownTestViewController.h"
#import "TextFieldMultiplyDownPicker.h"

@interface TextFieldMultiplyDropDownTestViewController ()<TextFieldMultiplyDownPickerDelegate, TextFieldDownPickerDataSource>

@property (weak, nonatomic) IBOutlet TextFieldMultiplyDownPicker *textField;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;

@property (nonatomic, strong) NSMutableArray<NSString *> *titlesForHeaders;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation TextFieldMultiplyDropDownTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titlesForHeaders = [[NSMutableArray alloc] initWithArray:@[@"Europe", @"Asia", @"Africa", @"South America", @"North America"]];
    
    self.dataSource = [[NSMutableArray alloc] initWithArray:@[@[@"Albania", @"Croatia", @"Spain", @"Ukraine", @"Germany"], @[@"Afghanistan", @"Bhutan", @"Bangladesh", @"China", @"India"], @[@"Algeria", @"Benin", @"Cameroon", @"Egypt", @"Gambia", @"Gabon"], @[@"Argentina", @"Brazil", @"Chile", @"Colombia", @"Ecuador" ], @[@"Belize", @"Canada", @"Costa Rica", @"Mexico"]]];
    
    self.textField.downPickerDelegate = self;
    self.textField.dataSource = self;
    

    self.textField.sectionTitleTextFont = [UIFont fontWithName:@"Palatino" size:22];

    self.textField.headerTitleTextFont = [UIFont fontWithName:@"Palatino" size:25];
    
//    self.textField addTarget:<#(nullable id)#> action:<#(nonnull SEL)#> forControlEvents:<#(UIControlEvents)#>
}

- (IBAction)textFieldDidChangeText:(TextFieldMultiplyDownPicker *)sender {
    [sender reloadDownPickerData];
}

- (IBAction)textFieldDidBeginEditing:(TextFieldMultiplyDownPicker *)sender {
    [sender showDownPicker];
}

- (IBAction)textFieldDidEndEditing:(TextFieldMultiplyDownPicker *)sender {
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

#pragma mark - TextFieldMultiplyDownPickerDelegate

- (void)textFieldMultiplyDownPicker:(TextFieldMultiplyDownPicker *)textFieldMultiplyDownPicker didSelectedRowsAtIndexPathes:(NSArray *)indexPathes {
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    for (NSIndexPath *indexPath in indexPathes) {
        [mutableString appendString:[NSString stringWithFormat:@"Choose item in section %li, row = %li. It is %@\n", (long)indexPath.section, (long)indexPath.row, ((NSArray*)[self.dataSource objectAtIndex:indexPath.section])[indexPath.row]]];
    }
    self.informationLabel.text = mutableString;
}

- (void)textFieldDownPicker:(TextFieldDownPicker *)textFieldDownPicker didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - User Actions

- (IBAction)reloadData:(UIButton *)sender {
    [self.textField reloadData];
}

- (IBAction)reloadDownPickerData:(UIButton *)sender {
    [self.textField reloadDownPickerData];
}

@end
