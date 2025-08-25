//
//  SceneDelegate.m
//  objc_ios_legacy
//
//  Created by Mateusz Bąk on 8/18/25.
//

#import "SceneDelegate.h"
#import "ViewController.h"

// Dummy LegacySceneManager to avoid linker errors
@interface LegacySceneManager : NSObject
@property (nonatomic, weak) UIScene *managedScene;
- (void)activateScene;
- (void)deactivateScene;
@end

@implementation LegacySceneManager
@synthesize managedScene;

- (void)activateScene {
    NSLog(@"Activating legacy scene...");
}

- (void)deactivateScene {
    NSLog(@"Deactivating legacy scene...");
}
@end

@interface SceneDelegate () {
    // Legacy instance variables
    NSMutableDictionary *_sceneConfiguration;
    BOOL _isSceneConfigured;
}

@end

@implementation SceneDelegate

// Synthesize with legacy patterns
@synthesize window = _window;
@synthesize sceneManager = _sceneManager;
@synthesize currentScene;

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Legacy scene setup with potential issues
    _sceneConfiguration = [[NSMutableDictionary alloc] init]; // Manual allocation
    
    // Type conversion and casting issues
    UIWindowScene *windowScene = (UIWindowScene *)scene; // Unsafe cast
    
    if (windowScene) {
        // Create window with legacy patterns
        self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
        
        // Configure window with deprecated methods
        [self configureWindow:self.window];
        
        // Setup legacy components
        [self setupLegacyScene];
        
        // Assign object to assign property (generates warning)
        self.currentScene = scene;
        
        // Create and configure view controller with potential issues
        ViewController *viewController = [[ViewController alloc] init];
        
        // Legacy navigation setup
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        // Deprecated navigation bar styling
        navController.navigationBar.tintColor = [UIColor blueColor];
        navController.navigationBar.barTintColor = [UIColor whiteColor];
        
        self.window.rootViewController = navController;
        [self.window makeKeyAndVisible];
        
        // Store scene reference with potential memory issues
        [_sceneConfiguration setObject:scene forKey:@"mainScene"];
        [_sceneConfiguration setObject:session forKey:@"session"];
        
        _isSceneConfigured = YES;
    }
}

- (void)configureWindow:(UIWindow *)window {
    // Legacy window configuration
    window.backgroundColor = [UIColor whiteColor];
    
    // Deprecated appearance customization
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor blueColor]];
    
    // Type conversion warnings
    CGRect windowBounds = window.bounds;
    int windowWidth = windowBounds.size.width; // Loss of precision
    int windowHeight = windowBounds.size.height; // Loss of precision
    
    NSLog(@"Window configured with size: %dx%d", windowWidth, windowHeight);
    
    // Potential memory leak
    NSMutableArray *windowConfigs = [[NSMutableArray alloc] init];
    [windowConfigs addObject:@"config1"];
    [windowConfigs addObject:@"config2"];
    // No proper cleanup
}

- (void)setupLegacyScene {
    // Initialize legacy scene manager
    self.sceneManager = [[LegacySceneManager alloc] init];
    
    // Potential circular reference
    self.sceneManager.managedScene = (UIScene *)self.currentScene;
    
    [self.sceneManager activateScene];
    
    // Setup with C-style patterns
    const char *sceneTypes[] = {"main", "secondary", "background"};
    int typeCount = sizeof(sceneTypes) / sizeof(sceneTypes[0]);
    
    for (int i = 0; i < typeCount; i++) {
        NSString *sceneType = [NSString stringWithCString:sceneTypes[i] encoding:NSUTF8StringEncoding];
        NSLog(@"Configuring scene type: %@", sceneType);
        
        // Store in configuration with potential type issues
        NSNumber *typeIndex = [NSNumber numberWithInt:i];
        [_sceneConfiguration setObject:sceneType forKey:typeIndex]; // Using NSNumber as key
    }
}

- (void)sceneDidDisconnect:(UIScene *)scene {
    NSLog(@"Scene disconnecting...");
    
    // Cleanup with potential issues
    if (self.sceneManager) {
        [self.sceneManager deactivateScene];
        self.sceneManager = nil;
    }
    
    // Remove scene from configuration
    NSArray *keys = [_sceneConfiguration allKeys];
    for (id key in keys) {
        id value = [_sceneConfiguration objectForKey:key];
        if ([value isEqual:scene]) {
            [_sceneConfiguration removeObjectForKey:key];
            break; // Modifying dictionary while iterating (potential issue)
        }
    }
    
    // Set current scene to nil (assign property with object)
    self.currentScene = nil;
}

- (void)sceneDidBecomeActive:(UIScene *)scene {
    NSLog(@"Scene became active");
    
    // Reactivate components with potential race conditions
    if (!self.sceneManager) {
        [self setupLegacyScene];
    }
    
    [self.sceneManager activateScene];
    
    // Potential null pointer dereference
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    CGFloat statusBarHeight = windowScene.statusBarManager.statusBarFrame.size.height;
    
    // Type conversion warning
    int statusBarHeightInt = statusBarHeight;
    NSLog(@"Status bar height: %d", statusBarHeightInt);
}

- (void)sceneWillResignActive:(UIScene *)scene {
    NSLog(@"Scene will resign active");
    
    // Deactivate with potential issues
    if (self.sceneManager) {
        [self.sceneManager deactivateScene];
    }
    
    // Save state with deprecated methods
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"sceneActive"];
    [defaults synchronize]; // Deprecated synchronize
}

- (void)sceneWillEnterForeground:(UIScene *)scene {
    NSLog(@"Scene will enter foreground");
    
    // Restore state with potential type mismatches
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL wasActive = [defaults boolForKey:@"sceneActive"];
    
    if (!wasActive) {
        // Reinitialize components
        [self setupLegacyScene];
    }
    
    // Update current scene reference
    self.currentScene = scene; // Assign to assign property
}

- (void)sceneDidEnterBackground:(UIScene *)scene {
    NSLog(@"Scene entered background");
    
    // Save critical data with potential memory leaks
    NSMutableDictionary *backgroundData = [[NSMutableDictionary alloc] init];
    [backgroundData setObject:[NSDate date] forKey:@"backgroundTime"];
    [backgroundData setObject:scene forKey:@"scene"];
    
    // Store in configuration without proper cleanup
    [_sceneConfiguration setObject:backgroundData forKey:@"backgroundData"];
    
    // Deactivate scene manager
    if (self.sceneManager) {
        [self.sceneManager deactivateScene];
    }
    
    // Update user defaults with type issues
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"sceneActive"]; // Logic error - should be NO
    [defaults synchronize]; // Deprecated
}

// Missing implementation for proper cleanup
- (void)dealloc {
    // Incomplete cleanup
    if (self.sceneManager) {
        [self.sceneManager deactivateScene];
    }
    
    // Missing cleanup for _sceneConfiguration
    // Should remove all objects and release
}

@end
