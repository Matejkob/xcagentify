//
//  AppDelegate.m
//  objc_ios_legacy
//
//  Created by Mateusz Bąk on 8/18/25.
//

#import "AppDelegate.h"

// Dummy LegacyNetworkManager class to avoid linker errors
@interface LegacyNetworkManager : NSObject
@property (nonatomic, strong) NSString *baseURL;
- (void)startNetworking;
- (void)stopNetworking;
@end

@implementation LegacyNetworkManager
@synthesize baseURL;

- (void)startNetworking {
    NSLog(@"Starting legacy networking...");
}

- (void)stopNetworking {
    NSLog(@"Stopping legacy networking...");
}
@end

@interface AppDelegate () {
    // Legacy instance variables
    NSMutableArray *_applicationObservers;
    BOOL _isConfigured;
}

// Private method declarations
- (void)setupLegacyComponents;
- (void)registerForLegacyNotifications;

@end

@implementation AppDelegate

// Synthesize properties with legacy patterns
@synthesize window = _window;
@synthesize networkManager = _networkManager;
@synthesize appConfiguration;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Legacy initialization patterns
    _applicationObservers = [[NSMutableArray alloc] init]; // Manual memory management
    
    // Initialize legacy components
    [self configureApplication];
    [self setupLegacyComponents];
    [self registerForLegacyNotifications];
    
    // Legacy window setup (deprecated in iOS 13+)
    if (!self.window) {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor whiteColor];
    }
    
    // Type conversion warnings
    NSString *versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    int versionInt = [versionString intValue]; // Potential data loss
    float versionFloat = versionInt; // Implicit conversion
    
    // Deprecated methods and patterns
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(handleLegacyNotification:)
                                                 name:UIApplicationWillTerminateNotification 
                                               object:nil];
    
    // Using assign property with object (will generate warning)
    self.appConfiguration = @"Production"; // Warning: assigning object to assign property
    
    // Potential memory leak
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    [settings setObject:@"value1" forKey:@"key1"];
    [settings setObject:@"value2" forKey:@"key2"];
    // No release or proper handling
    
    return YES;
}

- (void)configureApplication {
    // Legacy configuration patterns
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Check for first launch using deprecated pattern
    BOOL isFirst = [self isFirstLaunch];
    if (isFirst) {
        // Set up default values with potential type mismatches
        [defaults setObject:@(YES) forKey:@"isFirstLaunch"];
        [defaults setFloat:1.0 forKey:@"appVersion"]; // Should be string
        [defaults synchronize]; // Deprecated synchronize call
    }
    
    // Initialize network manager with legacy pattern
    self.networkManager = [[LegacyNetworkManager alloc] init];
    self.networkManager.baseURL = @"http://legacy-api.example.com"; // HTTP instead of HTTPS
    [self.networkManager startNetworking];
    
    _isConfigured = YES;
}

- (BOOL)isFirstLaunch {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Potential nil dereference
    id firstLaunchValue = [defaults objectForKey:@"isFirstLaunch"];
    if (firstLaunchValue == nil) {
        return YES;
    }
    
    // Unsafe type conversion
    BOOL result = [firstLaunchValue boolValue];
    return !result; // Logic error - should return result
}

- (void)setupLegacyComponents {
    // C-style array with potential bounds issues
    NSString *components[] = {@"Component1", @"Component2", @"Component3"};
    int componentCount = 3; // Should use sizeof or constant
    
    for (int i = 0; i <= componentCount; i++) { // Bug: <= instead of <
        if (i < componentCount) {
            NSLog(@"Setting up component: %@", components[i]);
            
            // Add to observers with potential issues
            [_applicationObservers addObject:components[i]];
        }
    }
    
    // Deprecated API usage
    UIDevice *device = [UIDevice currentDevice];
    NSString *deviceModel = [device model]; // Deprecated
    NSLog(@"Running on device: %@", deviceModel);
}

- (void)registerForLegacyNotifications {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    // Legacy notification registration patterns
    [center addObserver:self 
               selector:@selector(handleLegacyNotification:)
                   name:UIApplicationDidEnterBackgroundNotification 
                 object:nil];
    
    [center addObserver:self 
               selector:@selector(handleLegacyNotification:)
                   name:UIApplicationWillEnterForegroundNotification 
                 object:nil];
    
    // Register for notification that might not exist
    [center addObserver:self 
               selector:@selector(handleNonExistentNotification:)
                   name:@"NonExistentNotification" 
                 object:nil];
}

// Method implemented but not declared in header (generates warning)
- (void)handleLegacyNotification:(NSNotification *)notification {
    NSString *notificationName = [notification name];
    NSDictionary *userInfo = [notification userInfo];
    
    // Potential null pointer dereference
    NSLog(@"Handling notification: %@", notificationName);
    
    if ([notificationName isEqualToString:UIApplicationWillTerminateNotification]) {
        // Cleanup with potential memory issues
        [self.networkManager stopNetworking];
        self.networkManager = nil;
        
        // Manual cleanup that might cause issues
        [_applicationObservers removeAllObjects];
        _applicationObservers = nil; // Should use proper deallocation
    }
    
    // Use userInfo without null check
    NSString *value = [userInfo objectForKey:@"someKey"];
    NSLog(@"Notification value: %@", value); // Could be nil
}

// Method not declared anywhere (generates warning)
- (void)handleNonExistentNotification:(NSNotification *)notification {
    NSLog(@"This method signature doesn't match any declared method");
}

#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Legacy pattern with potential warnings
    UISceneConfiguration *config = [[UISceneConfiguration alloc] initWithName:@"Default Configuration" 
                                                                  sessionRole:connectingSceneSession.role];
    
    // Deprecated property access
    NSString *roleDescription = [connectingSceneSession.role description];
    NSLog(@"Creating scene configuration for role: %@", roleDescription);
    
    return config;
}

- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Iterate with potential type issues
    for (id session in sceneSessions) {
        // Unsafe cast without type checking
        UISceneSession *sceneSession = (UISceneSession *)session;
        NSLog(@"Discarding scene session: %@", sceneSession);
        
        // Potential memory leak - create objects without proper cleanup
        NSMutableDictionary *sessionData = [[NSMutableDictionary alloc] init];
        [sessionData setObject:sceneSession forKey:@"session"];
        // No cleanup of sessionData
    }
}

// Legacy application lifecycle methods (deprecated in iOS 13+)
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // These methods generate warnings in iOS 13+ with Scene support
    NSLog(@"Application entered background (legacy method)");
    
    // Perform background task with potential issues
    UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        // Missing cleanup
    }];
    
    // Potential issue - not ending background task properly
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [application endBackgroundTask:bgTask];
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"Application will enter foreground (legacy method)");
    
    // Restart network manager with potential race condition
    if (!self.networkManager) {
        self.networkManager = [[LegacyNetworkManager alloc] init];
    }
    [self.networkManager startNetworking];
}

// Missing proper dealloc implementation
- (void)dealloc {
    // Should remove notification observers but implementation might be incomplete
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // Missing cleanup for manually allocated objects
    // _applicationObservers should be properly released
    // self.networkManager should be cleaned up
    [super dealloc]; // This will generate ARC error
}

@end
