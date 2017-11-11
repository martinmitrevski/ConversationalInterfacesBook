//
//  WITState.m
//  Wit
//
//  Created by Willy Blandin on 12. 10. 29..
//  Copyright (c) 2012년 Willy Blandin. All rights reserved.
//

#import "WITState.h"

@implementation WITState

#pragma mark - Util
+ (NSString *)UUID {
    static NSString* uuidString;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        uuidString = [NSUUID UUID].UUIDString;
    });
    
    return uuidString;
}

// Load the framework bundle.

#pragma mark - Defaults
- (void)readPlist {
    self.accessToken = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"WitAccessToken"];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"];
    if (accessToken && [accessToken length] > 0) self.accessToken = accessToken;
}

#pragma mark - Lifecycle
+ (WITState *)sharedInstance {
    static WITState* instance;
    static dispatch_once_t once;

    dispatch_once(&once, ^{
        instance = [[WITState alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self readPlist];
        _context = [[NSDictionary alloc] init];
    }
    return self;
}
@end
