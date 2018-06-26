//
//  Channel.h
//  TeleTango
//
//  Created by Mitansh on 06/08/13.
//  Copyright (c) 2013 Tresbu Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTPChannel : NSObject
@property(nonatomic,strong)NSString *channel_id;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *genre;
@property(nonatomic,strong)NSString *language;
@property(nonatomic,strong)NSURL *logo_url;
@property(nonatomic,strong)NSMutableArray *programsArray;
@property(nonatomic,strong)NSMutableArray *programsFliteredArray;
-(id)initWithChannelID:(NSString*)_channel_id
                  name:(NSString *)_name
                  genre:(NSString *)_genre
                  language:(NSString *)_language
                  logoUrl:(NSURL*)_logo_url
programsArray:(NSMutableArray *)_programsArray;
@end
