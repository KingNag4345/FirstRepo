//
//  SingleProgram.h
//  TeleTango
//
//  Created by Mitansh on 12/08/13.
//  Copyright (c) 2013 Tresbu Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTPSingleProgramDetail.h"
#import "TTPChannel.h"
#import "TTPFriendsFootPrint.h"

@interface TTPSingleProgram : NSObject
@property(nonatomic,strong) TTPSingleProgramDetail *singlePrgDetail;
@property(nonatomic,strong) TTPChannel *channel;
@property(nonatomic,strong) NSMutableArray *conversations;
@property(nonatomic,strong) NSMutableArray *friendsConversation;
@property(nonatomic,strong) NSMutableArray *friendsWatchingInLounge;
@property(nonatomic,strong) NSMutableArray *friendsPrograms;
@property(nonatomic,strong) TTPFriendsFootPrint *friendsFootPrint;
@property(nonatomic,strong) NSMutableArray *likeUserList;

-(id) initWithSingleProgramObj:(TTPSingleProgramDetail *)_singlePrgDetail
                    channelObj:(TTPChannel *)_channel
                  conversation:(NSMutableArray *)_conversations
           friendsConversation:(NSMutableArray *)_friendsConversation
       friendsWatchingInLounge:(NSMutableArray *)_friendsWatchingInLounge
               friendsPrograms:(NSMutableArray *)_friendsPrograms
              friendsFootPrint:(TTPFriendsFootPrint *)_friendsFootPrint
                  likeUserList:(NSMutableArray *)_likeUserList;


@end
