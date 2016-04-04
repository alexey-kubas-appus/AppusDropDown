//
//  MultipleDropDownWithTagsTestViewController.m
//  DropDown
//
//  Created by Simon Kostenko on 12/30/15.
//  Copyright © 2015 Simon Kostenko. All rights reserved.
//

#import "MultipleDropDownWithTagsTestViewController.h"
#import "MultipleDropDownWithTags.h"

@interface MultipleDropDownWithTagsTestViewController ()<TLTagsControlDelegate, MultipleDropDownPickerWithTagsDelegate, MultipleDropDownPickerWithTagsDataSource>

@property (weak, nonatomic) IBOutlet MultipleDropDownWithTags *scrollView;

@property (nonatomic, strong) NSMutableArray<NSString *> *titlesForHeaders;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation MultipleDropDownWithTagsTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.titlesForHeaders = [[NSMutableArray alloc] initWithArray:@[@"Europe", @"Asia", @"Africa", @"South America", @"North America"]];
    
    self.dataSource = [[NSMutableArray alloc] initWithArray:@[@[@"Albania", @"Croatia", @"Spain", @"Ukraine", @"Germany"], @[@"Afghanistan", @"Bhutan", @"Bangladesh", @"China", @"India"], @[@"Algeria", @"Benin", @"Cameroon", @"Egypt", @"Gambia", @"Gabon"], @[@"Argentina", @"Brazil", @"Chile", @"Colombia", @"Ecuador" ], @[@"Belize", @"Canada", @"Costa Rica", @"Mexico"]]];
    
    self.scrollView.tagPlaceholder = @"Country";
    
    self.scrollView.downPickerDelegate = self;
    self.scrollView.dataSource = self;
    
    self.scrollView.sectionTitleTextFont = [UIFont fontWithName:@"Palatino" size:22];
    
    self.scrollView.headerTitleTextFont = [UIFont fontWithName:@"Palatino" size:25];
}

#pragma mark - TLTagsControlDelegate
- (void)tagsControl:(TLTagsControl *)tagsControl tappedAtIndex:(NSInteger)index {
    NSLog(@"Tag \"%@\" was tapped", tagsControl.tags[index]);
}

#pragma mark - MultipleDropDownPickerWithTagsDataSource

- (NSUInteger)downPicker:(MultipleDropDownWithTags *)downPicker numberOfRowsInSection:(NSUInteger)section {
    return ((NSArray*)[self.dataSource objectAtIndex:section]).count;
}

- (NSString *)downPicker:(MultipleDropDownWithTags *)downPicker stringForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((NSArray*)[self.dataSource objectAtIndex:indexPath.section])[indexPath.row];
}

- (NSUInteger)numberOfSectionsInDownPicker:(MultipleDropDownWithTags *)downPicker {
    return self.titlesForHeaders.count;
}

- (NSString *)downPicker:(MultipleDropDownWithTags *)downPicker titleForHeaderInSection:(NSUInteger)section {
    return self.titlesForHeaders[section];
}

- (void)downPicker:(MultipleDropDownWithTags *)downPicker didSelectedRowsAtIndexPathes:(NSArray *)indexPathes {
    for (NSIndexPath *indexPath in indexPathes) {
        NSLog(@"%@", ((NSArray*)self.dataSource[indexPath.section])[indexPath.row]);
    }
}

@end
