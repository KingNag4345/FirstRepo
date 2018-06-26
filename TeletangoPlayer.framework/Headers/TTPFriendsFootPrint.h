//
//  FriendsFootPrint.h
//  TeleTango
//
//  Created by Apple on 24/02/15.
//  Copyright (c) 2015 Tresbu Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTPFriendsFootPrint : NSObject

@property(nonatomic,strong)NSString *program_id;
@property(nonatomic,strong)NSMutableArray *friendsWatchingArray;


-(id)initWithProgramID:(NSString*)_program_id
  friendsWatchingArray:(NSMutableArray *)_friendsWatchingArray;



@end
