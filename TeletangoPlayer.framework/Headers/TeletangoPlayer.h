//
//  TeletangoPlayer.h
//  TeletangoPlayer
//
//  Created by Nagaraju Surisetty on 10/4/17.
//  Copyright © 2017  Nagaraju Surisetty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <TwitterKit/TwitterKit.h>
#import <TwitterCore/TwitterCore.h>
#import "SVProgressHUD.h"


#import "UIImage+ImageEffects.h"
#import "ParallaxHeaderView.h"
#import "STTwitterAPI.h"
#import "TTTwitterManager.h"
#import "TTPAPIHelper.h"
#import "Reachability.h"
#import "TTCustomObjects.h"
#import "SQLiteManager.h"
#import "TTPTangoFeedActionButton.h"
#import "TTPParseProgramResponse.h"
#import "TTPFriendsDetail.h"
#import "TTPDataLoader.h"
#import "TTPSingleProgram.h"
#import "TTPChannel.h"
#import "TTPSingleProgramDetail.h"
#import "TTPFriendsFootPrint.h"
#import "TTPConversation.h"
#import "TTPFriendWatching.h"

//! Project version number for TeletangoPlayer.
FOUNDATION_EXPORT double TeletangoPlayerVersionNumber;

//! Project version string for TeletangoPlayer.
FOUNDATION_EXPORT const unsigned char TeletangoPlayerVersionString[];

/*********User Defaults*********/

#define TRIALMODE                        @"trialmode"
#define NextPageDefaults                 @"NextPageNumber"
#define ChannelNameDefaults              @"channel_name"
#define ChannelIdDefaults                @"channel_id"
#define timerefrenceDefaults             @"time_reference"
#define ProgrameTitleColor               @"program_title_color"
#define ShowProgrameLB                   @"ShowProgrameLB"
#define TempFirstnamedefaults            @"firstNametemp"
#define TempLastnamedefaults             @"lastNametemp"
#define TempEmaildefaults                @"emailtemp"
#define TempImagedefaults                @"imagetemp"
#define TwitterConsumerKey               @"TwitterConsumerKey"
#define TwitterSecretKey                 @"TwitterSecretKey"

/*********Font Strings*********/

#define Defaultfont                      @"Helvetica"
#define DefaultfontLight                 @"HelveticaNeue-Light"
#define DefaultfontMedium                @"HelveticaNeue-Medium"
#define DefaultfontRegular               @"HelveticaNeue"

/*********Genral Strings*********/
#define ErrorTitle                       @"Error"
#define SuccessTitle                     @"Confirmation"
#define APPNAME                          @"Dev"

/*********Event Logs*********/
#define CHECK_IN_TO_PROGRAM              @"CHECK_IN_TO_PROGRAM"
#define NEW_USER_CREATED                 @"NEW_USER_CREATED"
#define FACEBOOK_REGISTRATION            @"FACEBOOK_REGISTRATION"
#define YOUTUBE_SIGNUP                   @"YOUTUBE_SIGNUP"
#define TWITTER_SIGNUP                   @"TWITTER_SIGNUP"
#define CHECK_IN_TO_PROGRAM              @"CHECK_IN_TO_PROGRAM"
#define CHECK_OUT_FROM_PROGRAM           @"CHECK_OUT_FROM_PROGRAM"
#define LIKE_PROGRAM                     @"LIKE_PROGRAM"
#define POST_CONVERSATION                @"POST_COMMENT" 
#define POST_CONVERSATION_LIKE           @"POST_CONVERSATION_LIKE"
#define CONTENT_PLAY_START               @"CONTENT_PLAY_START"
#define CONTENT_PLAY_PAUSE               @"CONTENT_PLAY_PAUSE"
#define CONTENT_PLAY_RESUME              @"CONTENT_PLAY_RESUME"
#define CONTENT_PLAY_STOP                @"CONTENT_PLAY_STOP"
#define CONTENT_PLAY_FULLSCREEN          @"CONTENT_PLAY_FULLSCREEN"
#define CONTENT_PLAY_NORMALSCREEN        @"CONTENT_PLAY_NORMALSCREEN"
#define POSTED_FB_COMMENT                @"POSTED_FB_COMMENT"
#define POSTED_FB_LIKE                   @"POSTED_FB_LIKE"
#define POSTED_TW_TWEET                  @"POSTED_TW_TWEET"
#define POSTED_TW_RETWEET                @"POSTED_TW_RETWEET"
#define POSTED_TW_FAVORITE               @"POSTED_TW_FAVORITE"
#define POSTED_TW_REPLYTWEET             @"POSTED_TW_REPLYTWEET"
#define CONTACTS_REGISTRATION            @"CONTACTS_REGISTRATION"
#define INVITED_FB_FRIENDS_TO_PLATFORM   @"INVITED_FB_FRIENDS_TO_PLATFORM"
#define INVITED_FB_FRIENDS_TO_PROGRAM    @"INVITED_FB_FRIENDS_TO_PROGRAM"
#define INVITED_PHONEBOOK_CONTACTS_TO_PLATFORM  @"INVITED_PHONEBOOK_CONTACTS_TO_PLATFORM"
#define INVITED_PHONEBOOK_CONTACTS_TO_PROGRAM   @"INVITED_PHONEBOOK_CONTACTS_TO_PROGRAM"
#define POSTED_YT_COMMENT                       @"POSTED_YT_COMMENT"
#define POSTED_YT_LIKE                          @"POSTED_YT_LIKE"
#define CHECKED_PROGRAM_LEADERBOARD             @"CHECKED_PROGRAM_LEADERBOARD"
#define CHECKED_GLOBAL_LEADERBOARD              @"CHECKED_GLOBAL_LEADERBOARD"
#define ANSWERED_GAME_CORRECTLY                 @"ANSWERED_GAME_CORRECTLY"
#define ANSWERED_GAME_INCORRECTLY               @"ANSWERED_GAME_INCORRECTLY"
#define CLICKED_ON_PROGRAM_TANGO_BUTTONS        @"CLICKED_ON_PROGRAM_TANGO_BUTTONS"
#define CLICKED_ON_FEED_ACTION_BUTTON           @"CLICKED_ON_FEED_ACTION_BUTTON"
#define ACTION_ON_INTERACTIVE_OVERLAY           @"ACTION_ON_INTERACTIVE_OVERLAY"
#define SHOWN_INTERACTIVE_OVERLAY               @"SHOWN_INTERACTIVE_OVERLAY"
#define OVERLAY_ADS                             @"OVERLAY_ADS"
#define OVERLAY_VIDEOADS                        @"INSERT_VIDEO"

// In this header, you should import all the public headers of your framework using statements like #import <TeletangoPlayer/PublicHeader.h>


