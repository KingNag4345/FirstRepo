//
//  Conversation.h
//  TeleTango
//
//  Created by Mitansh on 17/09/13.
//  Copyright (c) 2013 Tresbu Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTPConversation : NSObject
@property(nonatomic,strong) NSString *appUserId;
@property(nonatomic,strong) NSString *conversationId;
@property(nonatomic,strong) NSString *createdTime;
@property(nonatomic,strong) NSString *fbUserId;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *text;
@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) NSString *thumbnail;
@property(nonatomic,strong) NSString *mimeType;
@property(nonatomic,strong) NSString *likes;
@property(nonatomic,strong) NSArray *likedBy;
@property(nonatomic,strong) NSString *isLikedByMe;
@property(nonatomic,strong) NSString *profilePic;


-(id) initWtihAppUserId:(NSString *)_appUserId
         conversationId:(NSString *)_conversationId
         createdTime:(NSString *)_createdTime
            fbUserId:(NSString *)_fbUserId
                   name:(NSString *)_name
                   text:(NSString *)_text
                    url:(NSString *)_url
              thumbnail:(NSString *)_thumbnail
              mimeType:(NSString *)_mimeType
                  likes:(NSString *)_likes
               likedBy:(NSArray *)_likedBy
           isLikedByMe:(NSString *)_isLikedByMe
            profilePic:(NSString *)_profilePic;
@end
