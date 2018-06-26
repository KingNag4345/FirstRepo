//
//  APIHelper.h
//  Demo
//
//  Created by Nagaraju on 18/04/16.
//  Copyright © 2016 Apptarix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STTwitterAPI.h"

@interface TTPAPIHelper : NSObject
@property(nonatomic,strong) NSString *APIType;
@property(nonatomic,strong) UIImage *twitterImage;
@property(nonatomic,strong) NSURL *twitterVideoPath;
@property(nonatomic,strong) NSDictionary *tweetDictionary;
@property(nonatomic,strong) NSString *verifierString;
@property(nonatomic,strong) STTwitterAPI *twitterAPI;

-(void)requestForApikeyAndAppUserIdWithcompletion:(void(^)(BOOL,id responseObject))completion;
- (void)requesttoGetAllProgramesListWithcompletion:(void(^)(BOOL,id responseObject))completion;
-(void) getProgrameDetailOfSingleProgramWithId:(NSString *)program_Id Withcompletion:(void(^)(BOOL,id responseObject))completion;
-(void)logEvent:(NSString *)event withParameters:(NSDictionary *)parameters Withcompletion:(void(^)(BOOL,id responseObject))completion;
-(void)logEventofType:(NSString *)event_type withParameters:(NSDictionary *)parameters;
-(void)postAddevents:(NSString *)event withparameters:(NSDictionary *)parameters;

-(void) getPersonalizeddataWithSingleProgramWithId:(NSString *)program_Id Withcallback:(void(^)(BOOL,id responseObject))completion;
-(void)programeFavoriteWithId:(NSString *)programId Withcompletion:(void(^)(BOOL,id responseObject))completion;
-(void)postConversationWithProgramId:(NSString *)programId conversationType:(NSString *)conversationType message:(NSString *)message Withcompletion:(void(^)(BOOL,id responseObject))completion;
-(void)postConversationWithprogramid:(NSString *)programId conversationType:(NSString *)conversationType message:(NSString *)message attachedImage:(UIImage *)image Withcompletion:(void(^)(BOOL,id responseObject))completion;
-(void)postConversationWithprogramid:(NSString *)programId conversationType:(NSString *)conversationType message:(NSString *)message attachedVideoPath:(NSString *)attachedVideoPath Withcompletion:(void(^)(BOOL,id responsedata))completion;
-(void)likeConversation:(NSString *)conversation_id program_id:(NSString *)program_id isliked:(NSString*)isLiked conversationType:(NSString *)converation_type Withcompletion:(void(^)(BOOL,id responseObject))completion;
- (void)fetchTangoFeedsWithFeedLink:(NSString *)feedLink withparams:(NSMutableDictionary *)params Withcompletion:(void(^)(BOOL,id responseObject))completion;

-(void)getFBPageWithPageUrl:(NSString *)fbPageUrl withaccesToken:(NSString*)accessToken Withcompletion:(void(^)(BOOL,id responseObject))completion;

-(void)getTweetsWithHashTag:(NSString *)hashTag Withcompletion:(void(^)(BOOL,id responseObject))completion;
-(void)tweet:(NSString *)message inViewController:(UIViewController *)controller Withcompletion:(void(^)(BOOL,id responseObject))completion;
-(void)tweet:(NSString *)message withImage:(UIImage *)image inViewController:(UIViewController *)controller Withcompletion:(void(^)(BOOL,id responseObject))completion;
-(void)tweet:(NSString *)message withVideoPathUrl:(NSURL *)videoPathUrl inViewController:(UIViewController *)controller Withcompletion:(void(^)(BOOL,id responseObject))completion;
-(void)replyTweetWithMessage:(NSString *)message inReplyToFeedId:(NSString *)feedId Withcompletion:(void(^)(BOOL,id responseObject))completion;
-(void)reTweetFeedId:(NSString *)feedId Withcompletion:(void(^)(BOOL,id responseObject))completion;
-(void)callBackFromTwitterWithUrl:(NSURL *)url;

-(void)fetchUserProfileWithAppUserId:(NSString*)facebookId Withcompletion:(void(^)(BOOL,id responseObject))completion;
-(void)fetchGamificationProfileOfUserWithUserId:(NSString *)facebookid Withcompletion:(void(^)(BOOL,id responseObject))completion;
-(void)fetchLeaderBoardDetailsWithProgrameId:(NSString *)programeid Withcompletion:(void(^)(BOOL,id responseObject))completion;

@end
TTPAPIHelper *TTPWebserviceHelper(void);
