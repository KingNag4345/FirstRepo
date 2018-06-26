//
//  SingleProgramDetail.h
//  TeleTango
//
//  Created by Mitansh on 04/09/13.
//  Copyright (c) 2013 Tresbu Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTPSingleProgramDetail : NSObject
@property(nonatomic,strong)NSString *program_id;
@property(nonatomic,strong)NSString *created;
@property(nonatomic,strong)NSString *modified;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *program_description;
@property(nonatomic,strong)NSString *broadcasting_date;
@property(nonatomic,strong)NSString *start_time;
@property(nonatomic,strong)NSString *end_time;
@property(nonatomic,strong)NSString *production_house;
@property(nonatomic,strong)NSString *director_email;
@property(nonatomic,strong)NSString *thumbnail;
@property(nonatomic,strong)NSString *recorded_video;
@property(nonatomic,strong)NSString *videoURL;
@property(nonatomic,strong)NSString *synopsis;
@property(nonatomic,strong)NSString *genre;
@property(nonatomic,strong)NSString *language;
@property(nonatomic,strong)NSString *is_regional;
@property(nonatomic,strong)NSString *is_national;
@property(nonatomic,strong)NSString *fb_page_url;
@property(nonatomic,strong)NSString *twitter;
@property(nonatomic,strong)NSString *search_tag_keywords;
@property(nonatomic,strong)NSString *feeds_link;
@property(nonatomic,strong)NSString *jockey_user_id;
@property(nonatomic,strong)NSString *jockey_user_name;
@property(nonatomic,strong)NSString *channel_id;
@property(nonatomic,strong)NSString *nbr_views;
@property(nonatomic,strong)NSString *nbr_conversations;
@property(nonatomic,assign)NSString *is_favorite;
@property(nonatomic,assign) NSString *programtextcolor;
@property(nonatomic,assign) NSString *documentUrl;
@property(nonatomic,assign) NSString *hasDescription;
@property(nonatomic,assign) NSString *hasPersonalization;
@property(nonatomic,strong)NSString *isDownloadable;

@property(nonatomic,strong)NSString *nbr_favs;
@property(nonatomic,strong)NSString *nbr_fb_comments;
@property(nonatomic,strong)NSString *nbr_fb_likes;
@property(nonatomic,strong)NSString *nbr_feeds;
@property(nonatomic,strong)NSString *nbr_tw_tweets;
@property(nonatomic,strong)NSString *overlay_thumbnail;
@property(nonatomic,strong)NSString *posted_by;
@property(nonatomic,strong)NSString *appUserId;
@property(nonatomic,strong)NSString *program_type;
@property(nonatomic,strong)NSString *computed_sentiment_name;
@property(nonatomic,strong)NSString *computed_sentiment_value;
@property(nonatomic,strong)NSArray *insertvideo_Dict;
@property(nonatomic,strong)NSArray *overlayadsArr;
-(id)initWithProgramID:(NSString*)_program_id
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
      overlayads_Array:(NSArray*)overlayadsArr
          programcolor:(NSString *)programclr
       documentUrlPath:(NSString *)_documentUrl
       hasDescription:(NSString *)_hasDescription
       isDownloadable:(NSString*)_isDownloadable
   hasPersonalization:(NSString *)_hasPersonalization;

@end
