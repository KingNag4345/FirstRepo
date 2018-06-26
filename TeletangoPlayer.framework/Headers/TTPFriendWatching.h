//
//  FriendWatching.h
//  TeleTango
//
//  Created by Mitansh on 12/08/13.
//  Copyright (c) 2013 Tresbu Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTPFriendWatching : NSObject
@property(nonatomic,strong)NSString *friend_id;
@property(nonatomic,strong)NSString *friend_name;
@property(nonatomic,strong)NSString *fb_user_id;
@property(nonatomic,strong)NSString *profile_pic;
@property(nonatomic,strong)NSString*start_time;
-(id)initWithFriendID:(NSString*)_friend_id
                  friend_name:(NSString *)_friend_name
             fb_user_id:(NSString *)_fb_user_id
             profile_pic:(NSString *)_profile_pic;
@end
