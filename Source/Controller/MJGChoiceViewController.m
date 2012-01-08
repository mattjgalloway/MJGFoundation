//
//  MJGChoiceViewController.m
//  MJGFoundation
//
//  Created by Matt Galloway on 06/01/2012.
//  Copyright 2012 Matt Galloway. All rights reserved.
//

#if ! __has_feature(objc_arc)
#error This file requires ARC to be enabled. Either enable ARC for the entire project or use -fobjc-arc flag.
#endif

#import "MJGChoiceViewController.h"

@interface MJGChoiceViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSArray *origKeys;
@property (nonatomic, strong) NSArray *origValues;

- (void)cancel:(id)sender;
@end

@implementation MJGChoiceViewController

@synthesize tableView = _tableView, searchBar = _searchBar;
@synthesize showsClear = _showsClear;
@synthesize delegate = _delegate;
@synthesize keys = _keys, values = _values, origKeys = _origKeys, origValues = _origValues;

#pragma mark -

- (void)cancel:(id)sender {
    if([_delegate respondsToSelector:@selector(choiceViewControllerCancelled:)]) {
        [_delegate choiceViewControllerCancelled:self];
    }
}


#pragma mark -

- (void)setShowsClear:(BOOL)inShowsClear {
    _showsClear = inShowsClear;
    [_tableView reloadData];
}


#pragma mark -

- (id)initWithChoices:(NSDictionary*)inChoices {
    NSArray *keysNew = [inChoices allKeys];
    NSMutableArray *valuesNewMutable = [NSMutableArray arrayWithCapacity:_keys.count];
    for (id key in keysNew) {
        [valuesNewMutable addObject:[inChoices objectForKey:key]];
    }
    NSArray *valuesNew = [NSArray arrayWithArray:valuesNewMutable];
    
    return [self initWithKeys:keysNew andValues:valuesNew];
}

- (id)initWithKeys:(NSArray*)inKeys andValues:(NSArray*)inValues {
    if ((self = [super init])) {
        _origKeys = inKeys;
        _keys = [_origKeys copy];
        _origValues = inValues;
        _values = [_origValues copy];
        _showsClear = YES;
    }
    return self;
}


#pragma mark -

- (void)loadView {
    CGRect bounds = [[UIScreen mainScreen] applicationFrame];
    bounds.origin = CGPointZero;
    
    self.view = [[UIView alloc] initWithFrame:bounds];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, bounds.size.width, 44.0f)];
    _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, bounds.size.width, bounds.size.height - 88.0f) style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, bounds.size.height - 44.0f, bounds.size.width, 44.0f)];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:toolbar];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
    toolbar.items = [NSArray arrayWithObjects:cancelButton, nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    _tableView = nil;
    _searchBar = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (_showsClear) ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int keysCount = _keys.count;
    int valuesCount = _values.count;
    int minCount = (keysCount < valuesCount) ? keysCount : valuesCount;
    switch (section) {
        case 0:
            return (_showsClear) ? 1 : minCount; break;
        case 1:
            return minCount; break;
        default:
            return 0; break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int section = indexPath.section;
    int row = indexPath.row;
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"ChoiceCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChoiceCell"];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    if (section == 0 && _showsClear) {
        cell.textLabel.text = @"Clear Field";
    } else if (section == 1 || (!_showsClear && section == 0)) {
        id choice = [_values objectAtIndex:row];
        if ([choice isKindOfClass:[NSString class]]) {
            cell.textLabel.text = choice;
        } else {
            cell.textLabel.text = @"";
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int section = indexPath.section;
    int row = indexPath.row;
    
    if ([_delegate respondsToSelector:@selector(choiceViewController:finishedWithKey:andValue:)]) {
        id key = nil;
        id value = nil;
        if (section == 1 || (!_showsClear && section == 0)) {
            key = [_keys objectAtIndex:row];
            value = [_values objectAtIndex:row];
        }
        [_delegate choiceViewController:self finishedWithKey:key andValue:value];
    }
    
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar {
    [aSearchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)aSearchBar textDidChange:(NSString *)searchText {
    NSMutableArray *newKeys = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *newValues = [NSMutableArray arrayWithCapacity:10];
    for (int i=0; i<_origKeys.count && i<_origValues.count; i++) {
        NSString *key = [_origKeys objectAtIndex:i];
        NSString *value = [_origValues objectAtIndex:i];
        
        NSRange range = [value rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (range.location != NSNotFound) {
            [newKeys addObject:key];
            [newValues addObject:value];
        }
    }
    
    _keys = [[NSArray alloc] initWithArray:newKeys];
    _values = [[NSArray alloc] initWithArray:newValues];
    
    [_tableView reloadData];
}

@end

