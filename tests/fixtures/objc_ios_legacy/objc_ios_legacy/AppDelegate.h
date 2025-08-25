//
//  AppDelegate.h
//  objc_ios_legacy
//
//  Created by Mateusz Bąk on 8/18/25.
//

#import <UIKit/UIKit.h>

// Forward declaration that might cause issues
@class LegacyNetworkManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

// Legacy window property (should be in SceneDelegate now)
@property (strong, nonatomic) UIWindow *window;

// Properties with legacy memory management
@property (nonatomic, retain) LegacyNetworkManager *networkManager;
@property (nonatomic, assign) NSString *appConfiguration; // Warning: assign on object

// Method declarations with legacy patterns
- (void)configureApplication;
- (BOOL)isFirstLaunch;

// Missing method declaration that will be implemented
// - (void)handleLegacyNotification:(NSNotification *)notification;

@end

