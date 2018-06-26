//
//  TangoFeedActionButton.h
//  TeleTango
//
//  Created by Mitansh on 07/10/13.
//  Copyright (c) 2013 Tresbu Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTPTangoFeedActionButton : NSObject
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *value;
@property(nonatomic,strong)NSString *logo;

-(id)initWithName:(NSString *)_name
             type:(NSString *)_type
            value:(NSString *)_value
          logourl:(NSString *)logoimage;

@end
