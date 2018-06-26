//
//  TTTwitterManager.h
//  SocialNetworkingLibrary
//
//  Created by Apple on 24/08/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STTwitterAPI.h"
#import <UIKit/UIKit.h>

@interface TTTwitterManager : NSObject

@property(nonatomic,strong) STTwitterAPI *twitterAPI;
@property(nonatomic,strong) NSString *twitterConsumerKey;
@property(nonatomic,strong) NSString *twitterConsumerSecret;
@property(nonatomic,strong) NSString *verifierString;
@property(nonatomic,strong) NSString *APIType;
@property(nonatomic,strong) UIImage *twitterImage;
@property(nonatomic,strong) NSURL *twitterVideoPath;
@property(nonatomic,strong) NSDictionary *tweetDictionary;

+ (id)sharedTwitterAPI;
- (void)getTweetsWithHashTag:(NSString *)hashTag receiver:(id)aReceiver action:(SEL)receiverAction;
- (void)replyTweetWithMessage:(NSString *)message inReplyToFeedId:(NSString *)feedId receiver:(id)aReceiver action:(SEL)receiverAction;
- (void)reTweetFeedId:(NSString *)feedId receiver:(id)aReceiver action:(SEL)receiverAction;
- (void)callBackFromTwitterWithUrl:(NSURL *)url;
- (BOOL)isTwitterAccountConfigured;
- (void)tweetWithMessage:(NSString *)message inViewController:(UIViewController *)controller Withcompletion:(void(^)(BOOL,id responseObject))completion;

- (void)tweet:(NSString *)message inViewController:(UIViewController *)controller receiver:(id)aReceiver action:(SEL)receiverAction;

- (void)tweetWithMessage:(NSString *)message withImage:(UIImage *)image inViewController:(UIViewController *)controller Withcompletion:(void(^)(BOOL,id responseObject))completion;

- (void)tweet:(NSString *)message withImage:(UIImage *)image inViewController:(UIViewController *)controller receiver:(id)aReceiver action:(SEL)receiverAction;

-(void)tweet:(NSString *)message withVideoPathUrl:(NSURL *)videoPathUrl inViewController:(UIViewController *)controller Withcompletion:(void(^)(BOOL,id responseObject))completion;

- (void)tweet:(NSString *)message withVideoPathUrl:(NSURL *)videoPathUrl inViewController:(UIViewController *)controller receiver:(id)aReceiver action:(SEL)receiverAction;

@end
