//
//  ViewController.m
//  objc_ios_legacy
//
//  Created by Mateusz Bąk on 8/18/25.
//

#import "ViewController.h"

// Define the protocol here to create a circular dependency issue
@protocol LegacyDataSource <NSObject>
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (id)objectAtIndex:(NSInteger)index;
@end

@interface ViewController () {
    // Instance variables using legacy patterns
    NSMutableArray *_internalArray;
    id _undefinedTypeVariable;
}

// Private methods without proper declarations
- (void)privateMethodWithoutDeclaration;

@end

@implementation ViewController

// Synthesize with legacy patterns
@synthesize tableView = _tableView;
@synthesize unsafeStringProperty;
@synthesize legacyArray = _legacyArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Legacy memory management patterns that will generate warnings
    _internalArray = [[NSMutableArray alloc] init]; // Missing release in dealloc
    
    // Deprecated method usage
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)]; // Hardcoded sizes
    [backgroundView setBackgroundColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]];
    
    // Type conversion warnings
    NSInteger integerValue = 42;
    float floatValue = integerValue; // Implicit conversion
    int implicitInt = floatValue; // Loss of precision warning
    
    // Assign object to assign property (will generate warning)
    self.unsafeStringProperty = @"This will generate a warning";
    
    // Copy mutable object to copy property (will generate warning)
    NSMutableArray *mutableSource = [NSMutableArray arrayWithObjects:@"one", @"two", nil];
    self.mutableArrayProperty = mutableSource;
    
    // Using uninitialized variables
    NSString *uninitializedString;
    NSLog(@"Uninitialized string: %@", uninitializedString); // Warning: may be uninitialized
    
    // Legacy table view setup
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    // Call method that's not declared in header
    [self missingDeclarationMethod];
    
    // Call deprecated APIs
    [self useDeprecatedAPIs];
    
    // Perform selector that might not exist
    if ([self respondsToSelector:@selector(nonExistentMethod)]) {
        [self performSelector:@selector(nonExistentMethod)];
    }
    
    // Use performSelector with potential warning
    [self performSelector:@selector(legacyMethodWithImplicitInt:) withObject:@(implicitInt)];
}

- (void)legacyMethodWithImplicitInt:(int)value {
    // Implicit int usage and potential overflow
    long longValue = value * 1000000; // Potential overflow
    NSLog(@"Legacy method called with value: %d, result: %ld", value, longValue);
    
    // Use of deprecated string methods
    NSString *testString = @"Hello, World!";
    NSRange range = [testString rangeOfString:@"World"];
    if (range.location != NSNotFound) {
        // Use deprecated method
        NSString *substring = [testString substringFromIndex:range.location];
        NSLog(@"Found substring: %@", substring);
    }
}

- (id)methodReturningId {
    // Return different types as id (potential warning)
    if (arc4random_uniform(2)) {
        return @"String as id";
    } else {
        return @(42); // NSNumber as id
    }
}

- (void)methodWithDeprecatedParameter:(CGRect)rect {
    // Use deprecated rect construction
    CGRect newRect = CGRectMake(rect.origin.x + 10, rect.origin.y + 10, 
                                rect.size.width - 20, rect.size.height - 20);
    
    // Deprecated UI methods
    UIView *testView = [[UIView alloc] initWithFrame:newRect];
    [testView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:testView];
    
    // Manual memory management in ARC environment (will generate error)
    [testView release]; // This will generate ARC error
}

// Method implemented but not declared in header (will generate warning)
- (void)missingDeclarationMethod {
    NSLog(@"This method is implemented but not declared in the header");
    
    // Use of C-style cast instead of Objective-C cast
    NSString *numberString = @"123";
    NSInteger number = (NSInteger)[numberString integerValue]; // Unnecessary cast
    
    // Potential memory leak with manual allocation
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:@"value" forKey:@"key"];
    // No release or assignment to autoreleased variable
}

- (void)privateMethodWithoutDeclaration {
    // This will generate a warning about missing method declaration
    NSLog(@"Private method without proper declaration");
}

// UITableViewDelegate methods with potential issues
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Using uninitialized or potentially nil array
    return [_internalArray count]; // Could be nil
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Legacy cell reuse pattern
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        // Legacy cell creation
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier:CellIdentifier];
    }
    
    // Potential array bounds issue
    if (indexPath.row < [_internalArray count]) {
        cell.textLabel.text = [_internalArray objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = @"Error: Index out of bounds";
    }
    
    return cell;
}

// Missing dealloc method for manual memory management
- (void)dealloc {
    // In a legacy app, you'd need to release manually allocated objects
    // _internalArray = nil; // Should be released properly
    // [super dealloc]; // Would be needed in non-ARC
}

@end
