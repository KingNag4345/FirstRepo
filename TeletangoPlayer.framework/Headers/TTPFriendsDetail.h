//
//  FriendsDetail.h
//  TeleTango
//
//  Created by Apple on 15/06/15.
//  Copyright (c) 2015 Tresbu Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTPFriendsDetail : NSObject

@property(nonatomic,strong) NSString *userId;
@property(nonatomic,strong) NSString *fb_user_id;
@property(nonatomic,strong) NSString *fb_user_name;


-(id) initWithUserId:(NSString *)_userId
          fb_user_id:(NSString *)_fb_user_id
        fb_user_name:(NSString *)_fb_user_name;

@end
