//
//  MJGChoiceViewController.h
//  MJGFoundation
//
//  Created by Matt Galloway on 06/01/2012.
//  Copyright 2012 Matt Galloway. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJGChoiceViewController;

@protocol MJGChoiceViewControllerDelegate <NSObject>
- (void)choiceViewController:(MJGChoiceViewController*)viewController finishedWithKey:(id)key andValue:(id)value;
- (void)choiceViewControllerCancelled:(MJGChoiceViewController*)viewController;
@end

@interface MJGChoiceViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic) BOOL showsClear;

@property (nonatomic, unsafe_unretained) id <MJGChoiceViewControllerDelegate> delegate;

- (id)initWithChoices:(NSDictionary*)inChoices;
- (id)initWithKeys:(NSArray*)inKeys andValues:(NSArray*)inValues;

@end
