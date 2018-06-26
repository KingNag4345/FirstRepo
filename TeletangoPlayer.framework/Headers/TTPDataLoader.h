//
//  TTDataLoader.h
//  TeleTango
//
//  Created by Mitansh on 06/08/13.
//  Copyright (c) 2013 Tresbu Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTPSingleProgram.h"
#import "TTPConversation.h"
#import "TTPFriendWatching.h"


@interface TTPDataLoader : NSObject
@property(nonatomic,strong) NSMutableArray *loungeChannel;
@property(nonatomic,strong) NSMutableArray *loungeProgramList;
@property(nonatomic,strong) NSMutableArray *friendsPanelList;
@property(nonatomic,strong) NSMutableArray *channelsList;
@property(nonatomic,strong) NSMutableArray *channelLstWithoutPrg;
//@property(nonatomic,strong) NSSet *genreList;
@property(nonatomic,strong) NSMutableArray *genreList;
@property(nonatomic,strong) NSMutableDictionary *ttfriendList;
@property(nonatomic,strong) NSMutableArray *connectionRequest;
@property(nonatomic,strong) TTPSingleProgram *singleProgram;
@property(nonatomic,strong) NSString *sessionId;
@property(nonatomic,strong) NSMutableArray *fbPageFeedList;
@property(nonatomic,strong) NSMutableArray *fbFeedCommentList;
@property(nonatomic,strong) NSMutableArray *tangoFeedList;
@property(nonatomic,strong) NSMutableArray *tangoFeedListFiltered;
@property(nonatomic,strong) NSMutableArray *tangoFeedActionButtonList;
@property(nonatomic,strong) NSMutableArray *allSocialChats;
//@property(nonatomic,strong) FBGraphUserProfile *fbGraphUserProfile;
@property(nonatomic,strong) NSMutableArray *gamificationProfilesOfUserAndFrnds;
@property(nonatomic,strong) NSMutableArray *gamificationStatsDataList;
@property(nonatomic,strong) NSMutableArray *appUserAdsResponseList;
@property(nonatomic,strong) NSMutableArray *searchResultList;
@property(nonatomic,strong) NSMutableArray *categoryChannelList;
@property(nonatomic,strong) NSMutableArray *categoryGenreList;

+(id)sharedTeleTangoData;
+(TTPSingleProgramDetail *)createSingleProgramDetailWithProgramID:(NSString*)_program_id
                                                       created:(NSString *)_created
                                                      modified:(NSString *)_modified
                                                        status:(NSString *)_status
                                                          name:(NSString *)_name
                                           program_description:(NSString *)_program_description
                                             broadcasting_date:(NSString *)_broadcasting_date
                                                    start_time:(NSString *)_start_time
                                                      end_time:(NSString *)_end_time
                                              production_house:(NSString *)_production_house
                                                director_email:(NSString *)_director_email
                                                     thumbnail:(NSString *)_thumbnail
                                                recorded_video:(NSString *)_recorded_video
                                                     video_url:(NSString *)_videoURL
                                                      synopsis:(NSString *)_synopsis
                                                         genre:(NSString *)_genre
                                                      language:(NSString *)_language
                                                   is_regional:(NSString *)_is_regional
                                                   is_national:(NSString *)_is_national
                                                   fb_page_url:(NSString *)_fb_page_url
                                                       twitter:(NSString *)_twitter
                                           search_tag_keywords:(NSString *)_search_tag_keywords
                                                    feeds_link:(NSString *)_feeds_link
                                                jockey_user_id:(NSString *)_jockey_user_id
                                              jockey_user_name:(NSString *)_jockey_user_name
                                                    channel_id:(NSString *)_channel_id
                                                     nbr_views:(NSString *)_nbr_views
                                             nbr_conversations:(NSString *)_nbr_conversations
                                                   is_favorite:(NSString *)_is_favorite
                                                      nbr_favs:(NSString *)_nbr_favs
                                               nbr_fb_comments:(NSString *)_nbr_fb_comments
                                                  nbr_fb_likes:(NSString *)_nbr_fb_likes
                                                     nbr_feeds:(NSString *)_nbr_feeds
                                                 nbr_tw_tweets:(NSString *)_nbr_tw_tweets
                                             overlay_thumbnail:(NSString *)_overlay_thumbnail
                                                     posted_by:(NSString *)_posted_by
                                                     appUserId:(NSString *)_appUserId
                                                  program_type:(NSString *)_program_type
                                       computed_sentiment_name:(NSString *)_computed_sentiment_name
                                      computed_sentiment_value:(NSString *)_computed_sentiment_value
                                             insert_video_dict:(NSArray*)insert_videodict
                                              overlayads_array:(NSDictionary*)overlaysAdsArray
                                              programtextcolor:(NSString *)programcolor
                                                  documentpath:(NSString *)_documentUrl
                                                hasDescription:(NSString *)_hasDescription
                                                isDownloadable:(NSString *)_isDownloadable
                                             hasPersonalization:(NSString *)_hasPersonalization;
+(TTPChannel*)createChannel:(NSString *)channel_id name:(NSString *)name genre:(NSString *)genre language:(NSString *)language logo_url:(NSURL *)logo_url programArray:(NSMutableArray *)programArray;
+(TTPConversation *)createConversationWithAppUserId:(NSString *)_appUserId conversationId:(NSString *)_conversationId createdTime:(NSString *)_createdTime fbUserId:(NSString *)_fbUserId name:(NSString *)_name text:(NSString *)_text url:(NSString *)_url thumbnail:(NSString *)_thumbnail mimeType:(NSString *)_mimeType likes:(NSString *)_likes likedBy:(NSArray *)_likedBy islikedByMe:(NSString *)_islikedByMe profilePic:(NSString*)_profilePic;
+(TTPFriendWatching *)createFriendWatching:(NSString*)friend_id friendName:(NSString*)friend_name fb_user_id:(NSString*)fb_user_id profile_pic:(NSString*)profile_pic;
+(TTPFriendsFootPrint *)createFriendsFootPrint:(NSString *)program_id friendsWatchingArray:(NSMutableArray *)friendsWatchingArray;
+(TTPSingleProgram *)createSingleProgramWithProgObj:(TTPSingleProgramDetail *)_singlePrgObj channel:(TTPChannel *)_channelObj conversation:(NSMutableArray *)_conversation friendsConversation:(NSMutableArray *)_friendsConversation friendsWatchingInLounge:(NSMutableArray *)_friendsWatchingInLounge friendsPrograms:(NSMutableArray *)_friendsPrograms friendsFootPrint:(TTPFriendsFootPrint *)_friendsFootPrint likeUserList:(NSMutableArray *)_likeUserList;
@end
