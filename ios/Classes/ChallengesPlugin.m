#import "ChallengesPlugin.h"
#if __has_include(<challenges/challenges-Swift.h>)
#import <challenges/challenges-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "challenges-Swift.h"
#endif

@implementation ChallengesPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftChallengesPlugin registerWithRegistrar:registrar];
}
@end
