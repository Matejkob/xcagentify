//
//  ViewController.h
//  objc_ios_legacy
//
//  Created by Mateusz Bąk on 8/18/25.
//

#import <UIKit/UIKit.h>

// Legacy delegate protocol without proper forward declaration
@protocol LegacyDataSource;

@interface ViewController : UIViewController <UITableViewDelegate>

// Properties using legacy memory management attributes
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign) NSString *unsafeStringProperty; // Warning: assign on object type
@property (nonatomic, copy) NSMutableArray *mutableArrayProperty; // Warning: copy on mutable type

// Legacy properties without proper attributes
@property NSArray *legacyArray;
@property id<LegacyDataSource> dataSource;

// Method declarations with legacy patterns
- (void)legacyMethodWithImplicitInt:(int)value;
- (id)methodReturningId;
- (void)methodWithDeprecatedParameter:(CGRect)rect;

// Missing method declaration (will be implemented but not declared here)
// - (void)missingDeclarationMethod;

// Method with deprecated API usage
- (void)useDeprecatedAPIs;

@end

