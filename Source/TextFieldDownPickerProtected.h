//
//  TextFieldDownPickerProtected.h
//  DropDown
//
//  Created by Simon Kostenko on 12/24/15.
//  Copyright © 2015 Simon Kostenko. All rights reserved.
//

#import "TextFieldDownPicker.h"

@interface TextFieldDownPicker ()

// data source for table with searching
@property (nonatomic, strong) NSMutableArray *existingSections;
@property (nonatomic, strong) NSMutableArray *numberOfRowsInSectionsNew; // of NSNumber * with NSInteger
@property (nonatomic, strong) NSMutableDictionary *stringsOfDataSourceNew; // for nsindexpath we have string
@property (nonatomic, strong) NSMutableDictionary *baseIndexPathesOfNewIndexPathes;

@property (nonatomic, weak) UITableView *tableView;

@end
