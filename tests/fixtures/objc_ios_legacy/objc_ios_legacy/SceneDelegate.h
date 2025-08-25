//
//  SceneDelegate.h
//  objc_ios_legacy
//
//  Created by Mateusz Bąk on 8/18/25.
//

#import <UIKit/UIKit.h>

// Forward declaration that might cause linker issues
@class LegacySceneManager;

@interface SceneDelegate : UIResponder <UIWindowSceneDelegate>

@property (strong, nonatomic) UIWindow * window;

// Legacy properties that might cause warnings
@property (nonatomic, retain) LegacySceneManager *sceneManager;
@property (nonatomic, assign) id currentScene; // Warning: assign with object type

// Method declarations
- (void)configureWindow:(UIWindow *)window;
- (void)setupLegacyScene;

@end

