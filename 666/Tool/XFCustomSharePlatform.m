//
//  XFCustomSharePlatform.m
//  666
//
//  Created by xiaofan on 2017/10/17.
//  Copyright © 2017年 xiaofan. All rights reserved.
//

#import "XFCustomSharePlatform.h"

@implementation XFCustomSharePlatform

+ (NSString *)platformNameWithPlatformType:(UMSocialPlatformType)platformType {
    return @"面对面";
}

-(void)umSocial_ShareWithObject:(UMSocialMessageObject *)object
          withCompletionHandler:(UMSocialRequestCompletionHandler)completionHandler {

}
-(BOOL)umSocial_handleOpenURL:(NSURL *)url {
    return YES;
}

-(UMSocialPlatformFeature)umSocial_SupportedFeatures {
    return UMSocialPlatformFeature_None;
}

-(NSString *)umSocial_PlatformSDKVersion {
    return [UMSocialGlobal umSocialSDKVersion];
}

-(BOOL)checkUrlSchema {
    return YES;
}

-(BOOL)umSocial_isInstall {
    return YES;
}

-(BOOL)umSocial_isSupport {
    return YES;
}

@end
