//
//  APIHelper.m
//  Demo
//
//  Created by Nagaraju on 18/04/16.
//  Copyright © 2016 Apptarix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "TTPAPIHelper.h"

#define REPLYTWEET                       @"replytweet"
#define RETWEET                          @"retweet"
#define TWEET                            @"tweet"
#define TWEET_WITH_IMAGE                 @"tweetwithimage"
#define TWEET_WITH_VIDEO                 @"tweetwithvideo"
#define DEFAULT_API_KEY                  @"ac2fdfd5fec83138415b9f98c82f0aac"
#define SERVER_URL                       [[NSUserDefaults standardUserDefaults] valueForKey:@"ServerUrl"]//@"http://incdev.teletango.com/ApptarixTV"
#define APPTA_URL                        [[NSUserDefaults standardUserDefaults] valueForKey:@"ApptaUrl"]//@"http://incdev-appta.teletango.com:8080/appta"

/*//if([[[NSUserDefaults standardUserDefaults] valueForKey:@"AppName"] isEqualToString:@"FILMY FUN"]){
#define PROGRAM_PATH_URL                 @"/api/programs"
#define EVENT_API_PATH                   @"/api/log/events"
#define ADS_API_PATH                     @"/api/log/ads"
#define APPTA_LOGIN_SERVICE_PROVIDER     @"/api/users"
#define GETALLPROGRAMES_LIST             @"/api/programs/allMinified"
#define FAVORITE_PROGRAM                 @"/api/programs/favorite"
#define POST_COMMENTS                    @"/api/comments"
#define CONVERSATION_LIKE                @"/api/comments/like"
#define FEEDSURL                         @"/api/programs/feeds"
#define GAMIFICATION_USER_WALL_USERID    @"/api/gamification/userWalls"
#define GAMIFICATION_GLOBAL_LEADERBOARDS_USERID @"/api/gamification/globalLeaderBoards"
#define GAMIFICATION_PROGRAM_LEADERBOARDS @"/api/gamification/programLeaderBoards"
#define PERSONALIZED_DATA                 @"/api/programs/personalization"
#define APPNAME                           [[NSUserDefaults standardUserDefaults] valueForKey:@"AppName"]//@"Dev"//@"inFocus"
}
else{*/
#define PROGRAM_PATH_URL                 @"/api/v3/programs"
#define EVENT_API_PATH                   @"/api/log/events"
#define ADS_API_PATH                     @"/api/log/ads"
#define APPTA_LOGIN_SERVICE_PROVIDER     @"/api/v3/users"
#define GETALLPROGRAMES_LIST             @"/api/programs/allMinified"
#define FAVORITE_PROGRAM                 @"/api/programs/favorite"
#define POST_COMMENTS                    @"/api/v3/comments"
#define CONVERSATION_LIKE                @"/api/comments/like"
#define FEEDSURL                         @"/api/programs/feeds"
#define GAMIFICATION_USER_WALL_USERID    @"/api/gamification/V2/userWalls"
#define GAMIFICATION_GLOBAL_LEADERBOARDS_USERID @"/api/gamification/V2/globalLeaderBoards"
#define GAMIFICATION_PROGRAM_LEADERBOARDS @"/api/gamification/programLeaderBoards"
#define PERSONALIZED_DATA                 @"/api/programs/personalization"
#define APPNAME                           [[NSUserDefaults standardUserDefaults] valueForKey:@"AppName"]//@"Dev"//@"inFocus"
//}*/

@implementation TTPAPIHelper

-(void)requestForApikeyAndAppUserIdWithcompletion:(void(^)(BOOL,id responseObject))completion {

    NSString *apiKey = [[NSUserDefaults standardUserDefaults]valueForKey:@"ApiKey"];
    if (apiKey.length==0)
        [[NSUserDefaults standardUserDefaults]setValue:DEFAULT_API_KEY forKey:@"ApiKey"];
    
    NSMutableDictionary *postDataParams = [[NSMutableDictionary alloc]init];
    [postDataParams setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"ApiKey"] forKey:@"apikey"];
    [postDataParams setObject:[self getUniqueDeviceIdentifierAsString] forKey:@"mac_id"];
    [postDataParams setObject:@"ios/tablet" forKey:@"terminal"];
    if (![APPNAME isEqualToString:@"FILMY FUN"])
    [postDataParams setObject:APPNAME forKey:@"app_name"];
    [postDataParams setObject:@"123456789012345678" forKey:@"customer_unique_id"];
    NSLog(@"requestForApikeyAndAppUserId postDataParams %@",postDataParams);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postDataParams options:0 error:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APPTA_URL,APPTA_LOGIN_SERVICE_PROVIDER]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    request.timeoutInterval = 30.0;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (!error) {
                                          @try {
                                              NSError *error;
                                              id responseObject= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                              if([[responseObject objectForKey:@"responseCode"] intValue]==400){
                                                  completion(NO,responseObject);
                                              }
                                              else{
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [self parseResponse:responseObject];
                                                      });
                                                  completion(YES,responseObject);
                                              }
                                          }
                                          @catch (NSException *exception) {
                                          }
                                      }
                                      else {
                                          NSError*_error=nil;
                                          NSLog(@"Error %@",error.localizedDescription);
                                          NSMutableDictionary *errorDict = [[NSMutableDictionary alloc]init];
                                          if (error.code==-1009){
                                              [errorDict setValue:@"Please check your internet connection." forKey:@"responseMessage"];
                                              [errorDict setValue:[NSNumber numberWithInteger:200] forKey:@"responseCode"];
                                              
                                          }
                                          else{
                                              [errorDict setValue:error.localizedDescription forKey:@"responseMessage"];
                                              [errorDict setValue:[NSNumber numberWithInteger:200] forKey:@"responseCode"];
                                          }
                                          completion(NO,_error);
                                      }
                                  }];
    
    [task resume];
}
- (void)requesttoGetAllProgramesListWithcompletion:(void(^)(BOOL,id responseObject))completion{
    
    /*NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [[NSUserDefaults standardUserDefaults] valueForKey:@"ApiKey"], @"apikey", [[NSUserDefaults standardUserDefaults] valueForKey:@"AppUserId"], @"app_user_id",APPNAME,@"app",nil];
    NSString *urlWithQuerystring = [self addQueryStringToUrl:[NSString stringWithFormat:@"%@%@",APPTA_URL,GETALLPROGRAMES_LIST] params:parameters];
    NSLog(@"Lounge Parms %@",urlWithQuerystring);*/
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?apikey=%@&app_user_id=%@&app_name=%@",APPTA_URL,GETALLPROGRAMES_LIST,[self urlEscape:[[NSUserDefaults standardUserDefaults] valueForKey:@"ApiKey"]],[[NSUserDefaults standardUserDefaults] valueForKey:@"AppUserId"],APPNAME]];
    NSLog(@"Lounge Parms %@",[NSString stringWithFormat:@"%@%@?apikey=%@&app_user_id=%@&app_name=%@",APPTA_URL,GETALLPROGRAMES_LIST,[self urlEscape:[[NSUserDefaults standardUserDefaults] valueForKey:@"ApiKey"]],[[NSUserDefaults standardUserDefaults] valueForKey:@"AppUserId"],APPNAME]);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (!error) {
                                          @try {
                                              NSError *error;
                                              id responseObject= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                              if([[responseObject valueForKey:@"responseCode"] intValue]==400){
                                                  completion(NO,responseObject);
                                              }
                                              else
                                                  completion(YES,responseObject);
                                          }
                                          @catch (NSException *exception) {
                                              
                                          }
                                      }
                                      else{
                                          NSError*_error=nil;
                                          NSLog(@"Error %@",error.localizedDescription);
                                          NSMutableDictionary *errorDict = [[NSMutableDictionary alloc]init];
                                          if (error.code==-1009){
                                              [errorDict setValue:@"Please check your internet connection." forKey:@"responseMessage"];
                                              [errorDict setValue:[NSNumber numberWithInteger:200] forKey:@"responseCode"];
                                              
                                          }
                                          else{
                                              [errorDict setValue:error.localizedDescription forKey:@"responseMessage"];
                                              [errorDict setValue:[NSNumber numberWithInteger:200] forKey:@"responseCode"];
                                          }
                                          completion(NO,_error);
                                      }
                                  }];
    [task resume];
}
-(void) getProgrameDetailOfSingleProgramWithId:(NSString *)program_Id Withcompletion:(void(^)(BOOL,id responseObject))completion{

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [[NSUserDefaults standardUserDefaults] valueForKey:@"ApiKey"], @"apikey", [[NSUserDefaults standardUserDefaults] valueForKey:@"AppUserId"], @"app_user_id",@"ios/tablet",@"terminal",program_Id,@"program_id",nil];
    if (![APPNAME isEqualToString:@"FILMY FUN"])
        [params setObject:APPNAME forKey:@"app_name"];
    NSString *urlWithQuerystring = [self addQueryStringToUrl:[NSString stringWithFormat:@"%@%@",APPTA_URL,PROGRAM_PATH_URL] params:params];
    NSLog(@"getProgrameDetail urlWithQuerystring %@",urlWithQuerystring);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlWithQuerystring] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSError*_error=nil;
                                                        NSLog(@"getProgrameDetailOfSingleProgramWithId %@",error.localizedDescription);
                                                        if (error.code==-1009){
                                                            _error = [NSError errorWithDomain:@"Error" code:200 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Network error",@"title",@"Please check your internet connection.",@"description", nil]];
                                                        }
                                                        else{
                                                            _error = [NSError errorWithDomain:@"Error" code:200 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Error",@"title",@"There is some error from server. Please try again later.",@"description", nil]];
                                                        }
                                                        completion(NO,nil);
                                                    } else {
                                                        id responseObject= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                                        if([[responseObject objectForKey:@"responseCode"] intValue]==400){
                                                            completion(NO,responseObject);
                                                        }
                                                        else
                                                            completion(YES,responseObject);
                                                        NSLog(@"responseObject%@", responseObject);
                                                    }
                                                }];
    [dataTask resume];

}
-(void) getPersonalizeddataWithSingleProgramWithId:(NSString *)program_Id Withcallback:(void(^)(BOOL,id responseObject))completion{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [[NSUserDefaults standardUserDefaults] valueForKey:@"ApiKey"], @"apikey", [[NSUserDefaults standardUserDefaults] valueForKey:@"AppUserId"], @"app_user_id",program_Id,@"program_id",nil];
    if (![APPNAME isEqualToString:@"FILMY FUN"])
        [params setObject:APPNAME forKey:@"app_name"];
    NSString *urlWithQuerystring = [self addQueryStringToUrl:[NSString stringWithFormat:@"%@%@",APPTA_URL,PERSONALIZED_DATA] params:params];
    NSLog(@"getPersonalizeddataWithSingleProgramWithId %@",urlWithQuerystring);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlWithQuerystring] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSError*_error=nil;
                                                        NSLog(@"getProgrameDetailOfSingleProgramWithId %@",error.localizedDescription);
                                                        if (error.code==-1009){
                                                            _error = [NSError errorWithDomain:@"Error" code:200 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Network error",@"title",@"Please check your internet connection.",@"description", nil]];
                                                        }
                                                        else{
                                                            _error = [NSError errorWithDomain:@"Error" code:200 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Error",@"title",@"There is some error from server. Please try again later.",@"description", nil]];
                                                        }
                                                        completion(NO,nil);
                                                    } else {
                                                        id responseObject= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                                        if([[responseObject objectForKey:@"responseCode"] intValue]==400){
                                                            completion(NO,responseObject);
                                                        }
                                                        else
                                                            completion(YES,responseObject);
                                                        NSLog(@"responseObject%@", responseObject);
                                                    }
                                                }];
    [dataTask resume];
    
}
-(void)programeFavoriteWithId:(NSString *)programId Withcompletion:(void(^)(BOOL,id responseObject))completion{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [[NSUserDefaults standardUserDefaults] valueForKey:@"ApiKey"], @"apikey",programId,@"program_id",[[NSUserDefaults standardUserDefaults] valueForKey:@"AppUserId"],@"app_user_id",nil];

    NSError * error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APPTA_URL,FAVORITE_PROGRAM]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (!error) {
                                          @try {
                                              NSError *error;
                                              id responseObject= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                              if([[responseObject objectForKey:@"responseCode"] intValue]==400){
                                                  completion(NO,responseObject);
                                              }
                                              else
                                                  completion(YES,responseObject);
                                          }
                                          @catch (NSException *exception) {
                                          }
                                      }
                                      else{
                                          NSLog(@"programeFavoriteWithId %@",error.localizedDescription);
                                          if (error){
                                              NSError*_error=nil;
                                              if (error.code==-1009){
                                                  _error = [NSError errorWithDomain:@"Error" code:200 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Network error",@"title",@"Please check your internet connection.",@"description", nil]];
                                              }
                                              else{
                                                  _error = [NSError errorWithDomain:@"Error" code:200 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Error",@"title",@"There is some error from server. Please try again later.",@"description", nil]];
                                              }
                                              completion(NO,_error);
                                          }
                                      }
                                  }];
    [task resume];
}
-(void)postConversationWithProgramId:(NSString *)programId conversationType:(NSString *)conversationType message:(NSString *)message Withcompletion:(void(^)(BOOL,id responseObject))completion {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            [[NSUserDefaults standardUserDefaults] valueForKey:@"ApiKey"], @"apikey",[[NSUserDefaults standardUserDefaults] valueForKey:@"AppUserId"], @"app_user_id",
                            message,@"text",programId,@"program_id",conversationType,@"type",nil];
    if (![APPNAME isEqualToString:@"FILMY FUN"])
        [params setObject:APPNAME forKey:@"app_name"];
    NSString *requestParamString = [self convertDictionaryToString:params];
    NSData *jsonData = [requestParamString dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APPTA_URL,POST_COMMENTS]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    request.timeoutInterval = 30.0;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (!error) {
                                          @try {
                                              NSError *error;
                                              id responseObject= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                              if([[responseObject objectForKey:@"responseCode"] intValue]==400){
                                                  completion(NO,responseObject);
                                              }
                                              else
                                                  completion(YES,responseObject);
                                          }
                                          @catch (NSException *exception) {
                                          }
                                      }
                                      else{
                                          NSError*_error=nil;
                                          if (error.code==-1009){
                                              _error = [NSError errorWithDomain:@"Error" code:200 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Network error",@"title",@"Please check your internet connection.",@"description", nil]];
                                          }
                                          else{
                                              _error = [NSError errorWithDomain:@"Error" code:200 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Error",@"title",@"There is some error from server. Please try again later.",@"description", nil]];
                                          }
                                          completion(NO,_error);
                                      }
                                  }];

    [task resume];
}
-(void)postConversationWithprogramid:(NSString *)programId conversationType:(NSString *)conversationType message:(NSString *)message attachedVideoPath:(NSString *)attachedVideoPath Withcompletion:(void(^)(BOOL,id responsedata))completion{
    NSData *attachedData =[NSData dataWithContentsOfFile:attachedVideoPath];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            [[NSUserDefaults standardUserDefaults] valueForKey:@"ApiKey"], @"apikey",[[NSUserDefaults standardUserDefaults] valueForKey:@"AppUserId"], @"app_user_id",
                            message,@"text",programId,@"program_id",conversationType,@"type",nil];
    if (![APPNAME isEqualToString:@"FILMY FUN"])
        [params setObject:APPNAME forKey:@"app_name"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APPTA_URL,POST_COMMENTS]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"0xKhTmLbOuNdArY";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    // post body
    NSData *data = [self createBodyWithBoundary:boundary parameters:params mimeType:@"Video/mp4" fieldName:@"fileToUpload" fileName:@"tempVideo.mp4" imageData:attachedData];

    [request setHTTPBody:data];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    request.timeoutInterval = 30.0;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (!error) {
                                          @try {
                                              NSError *error;
                                              id responseObject= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                              if([[responseObject objectForKey:@"responseCode"] intValue]==400){
                                                  completion(NO,responseObject);
                                              }
                                              else
                                                  completion(YES,responseObject);
                                          }
                                          @catch (NSException *exception) {
                                          }
                                      }
                                      else{
                                          NSError*_error=nil;
                                          if (error.code==-1009){
                                              _error = [NSError errorWithDomain:@"Error" code:200 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Network error",@"title",@"Please check your internet connection.",@"description", nil]];
                                          }
                                          else{
                                              _error = [NSError errorWithDomain:@"Error" code:200 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Error",@"title",@"There is some error from server. Please try again later.",@"description", nil]];
                                          }
                                          completion(NO,_error);
                                      }
                                  }];

    [task resume];
}
-(void)likeConversation:(NSString *)conversation_id program_id:(NSString *)program_id isliked:(NSString*)isLiked conversationType:(NSString *)converation_type Withcompletion:(void(^)(BOOL,id responseObject))completion {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?apikey=%@&app_user_id=%@&app_name=%@&conversation_id=%@&program_id=%@&like=%@",APPTA_URL,CONVERSATION_LIKE,[[NSUserDefaults standardUserDefaults] valueForKey:@"ApiKey"],[[NSUserDefaults standardUserDefaults] valueForKey:@"AppUserId"],APPNAME,conversation_id,program_id,isLiked]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (!error) {
                                          if(data!=nil){
                                              NSMutableDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                              if([[resultData objectForKey:@"responseCode"] intValue]==400){
                                                  completion(NO,resultData);
                                              }
                                              else{
                                                  completion(YES,resultData);
                                              }
                                          }
                                      }
                                      else {
                                          NSError*_error=nil;
                                          NSLog(@"Error %@",error.localizedDescription);
                                          NSMutableDictionary *errorDict = [[NSMutableDictionary alloc]init];
                                          if (error.code==-1009){
                                              [errorDict setValue:@"Please check your internet connection." forKey:@"responseMessage"];
                                              [errorDict setValue:[NSNumber numberWithInteger:200] forKey:@"responseCode"];

                                          }
                                          else{
                                              [errorDict setValue:error.localizedDescription forKey:@"responseMessage"];
                                              [errorDict setValue:[NSNumber numberWithInteger:200] forKey:@"responseCode"];
                                          }
                                          completion(NO,_error);
                                      }
                                  }];

    [task resume];
}
- (void)fetchTangoFeedsWithFeedLink:(NSString *)feedLink withparams:(NSMutableDictionary *)params Withcompletion:(void(^)(BOOL,id responseObject))completion{
    NSString *urlWithQuerystring = [self addQueryStringToUrl:[NSString stringWithFormat:@"%@%@",SERVER_URL,FEEDSURL] params:params];
    NSURL *url = [NSURL URLWithString:urlWithQuerystring];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    request.timeoutInterval = 30.0;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (!error) {
                                          if(data!=nil){
                                              NSMutableDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                              if([[resultData objectForKey:@"responseCode"] intValue]==400){
                                                  completion(NO,resultData);
                                              }
                                              else{
                                                  completion(YES,resultData);
                                              }
                                          }
                                      }
                                      else {
                                          NSError*_error=nil;
                                          NSLog(@"Error %@",error.localizedDescription);
                                          NSMutableDictionary *errorDict = [[NSMutableDictionary alloc]init];
                                          if (error.code==-1009){
                                              [errorDict setValue:@"Please check your internet connection." forKey:@"responseMessage"];
                                              [errorDict setValue:[NSNumber numberWithInteger:200] forKey:@"responseCode"];

                                          }
                                          else{
                                              [errorDict setValue:error.localizedDescription forKey:@"responseMessage"];
                                              [errorDict setValue:[NSNumber numberWithInteger:200] forKey:@"responseCode"];
                                          }
                                          completion(NO,_error);
                                      }
                                  }];

    [task resume];
}
-(void)getFBPageWithPageUrl:(NSString *)fbPageUrl withaccesToken:(NSString*)accessToken Withcompletion:(void(^)(BOOL,id responseObject))completion{
        NSURL *datasourceURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/comments?fields=id,from,attachment,message,created_time,like_count&order=chronological&access_token=%@",fbPageUrl,accessToken]];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:datasourceURL
                                                      cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                  timeoutInterval:30];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          if (!error) {
                                              @try {
                                                  NSUInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
                                                  
                                                  NSError *error;
                                                  NSMutableDictionary *responseObject= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                                  completion(YES,responseObject);
                                              }
                                              @catch (NSException *exception) {
                                              }
                                          }
                                          else{
                                              completion(NO,error);
                                          }
                                      }];
        
        [task resume];
}
- (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
    
    for(NSString *s in queryComponents) {
        NSArray *pair = [s componentsSeparatedByString:@"="];
        if([pair count] != 2) continue;
        
        NSString *key = pair[0];
        NSString *value = pair[1];
        
        md[key] = value;
    }
    
    return md;
}
- (BOOL)isTwitterAccountConfigured{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

-(void)logEventofType:(NSString *)event_type withParameters:(NSDictionary *)parameters{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init]; //[[self getGenericParams]mutableCopy];
    [params addEntriesFromDictionary:parameters];
    if (![APPNAME isEqualToString:@"FILMY FUN"])
        [params setObject:APPNAME forKey:@"app_name"];
    [params setObject:@"ios/tablet" forKey:@"terminal"];
    if (((NSNull *)[[NSUserDefaults standardUserDefaults]valueForKey:@"Latitude"]!=[NSNull null]) && [[[NSUserDefaults standardUserDefaults]valueForKey:@"Latitude"] length]>0)
        [params setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"Latitude"] forKey:@"latitude"];
    if (((NSNull *)[[NSUserDefaults standardUserDefaults]valueForKey:@"Longitude"]!=[NSNull null]) && [[[NSUserDefaults standardUserDefaults]valueForKey:@"Longitude"] length]>0)
        [params setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"Longitude"] forKey:@"longitude"];
    if (((NSNull *)[[NSUserDefaults standardUserDefaults]valueForKey:@"City"]!=[NSNull null]) && [[[NSUserDefaults standardUserDefaults]valueForKey:@"City"] length]>0)
        [params setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"City"] forKey:@"city"];
    if (((NSNull *)[[NSUserDefaults standardUserDefaults]valueForKey:@"State"]!=[NSNull null]) && [[[NSUserDefaults standardUserDefaults]valueForKey:@"State"] length]>0)
        [params setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"State"] forKey:@"state"];
    if (((NSNull *)[[NSUserDefaults standardUserDefaults]valueForKey:@"Country"]!=[NSNull null]) && [[[NSUserDefaults standardUserDefaults]valueForKey:@"Country"] length]>0)
        [params setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"Country"] forKey:@"country"];
    NSError * error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?event_type=%@&apikey=%@&app_user_id=%@",APPTA_URL,EVENT_API_PATH,event_type,[self urlEscape:[self getApiKey]],[self getAppUserId]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    /*if([event_type isEqualToString:@"CHECK_OUT_FROM_PROGRAM"])
        [request setHTTPMethod:@"PUT"];
    else*/
        [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    NSLog(@" /n body is And With Event %@ +++ %@ With ApiKEy %@ And App USer ID %@",params,event_type,[[NSUserDefaults standardUserDefaults]valueForKey:@"ApiKey"],[[NSUserDefaults standardUserDefaults]valueForKey:@"AppUserId"]);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if(data!=nil){
                                          NSMutableDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                          NSLog(@"%@",[NSString stringWithFormat:@"Done with event %@ logging",event_type]);
                                          NSLog(@"resultData %@",resultData);
                                      }
                                      else{
                                          NSLog(@"error %@",error.localizedDescription);
                                      }
                                  }];
    
    [task resume];
}
-(void)logEvent:(NSString *)event withParameters:(NSDictionary *)parameters Withcompletion:(void(^)(BOOL,id responseObject))completion{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init]; //[[self getGenericParams]mutableCopy];
    [params addEntriesFromDictionary:parameters];
    if (![APPNAME isEqualToString:@"FILMY FUN"])
        [params setObject:APPNAME forKey:@"app_name"];
    [params setObject:@"ios/tablet" forKey:@"terminal"];
    if (((NSNull *)[[NSUserDefaults standardUserDefaults]valueForKey:@"Latitude"]!=[NSNull null]) && [[[NSUserDefaults standardUserDefaults]valueForKey:@"Latitude"] length]>0)
        [params setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"Latitude"] forKey:@"latitude"];
    if (((NSNull *)[[NSUserDefaults standardUserDefaults]valueForKey:@"Longitude"]!=[NSNull null]) && [[[NSUserDefaults standardUserDefaults]valueForKey:@"Longitude"] length]>0)
        [params setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"Longitude"] forKey:@"longitude"];
    if (((NSNull *)[[NSUserDefaults standardUserDefaults]valueForKey:@"City"]!=[NSNull null]) && [[[NSUserDefaults standardUserDefaults]valueForKey:@"City"] length]>0)
        [params setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"City"] forKey:@"city"];
    if (((NSNull *)[[NSUserDefaults standardUserDefaults]valueForKey:@"State"]!=[NSNull null]) && [[[NSUserDefaults standardUserDefaults]valueForKey:@"State"] length]>0)
        [params setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"State"] forKey:@"state"];
    if (((NSNull *)[[NSUserDefaults standardUserDefaults]valueForKey:@"Country"]!=[NSNull null]) && [[[NSUserDefaults standardUserDefaults]valueForKey:@"Country"] length]>0)
        [params setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"Country"] forKey:@"country"];
    NSError * error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    NSString *urlString = [self addQueryStringToUrl:[NSString stringWithFormat:@"%@%@?event_type=%@&apikey=%@&app_user_id=%@",APPTA_URL,EVENT_API_PATH,event,[self urlEscape:[self getApiKey]],[self getAppUserId]] params:nil];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    /*if([event isEqualToString:@"CHECK_OUT_FROM_PROGRAM"])
        [request setHTTPMethod:@"PUT"];
    else*/
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    //NSLog(@"Complete Url %@",urlString);
    //NSLog(@" /n body is And With Event %@ +++ %@ With ApiKEy %@ And App USer ID %@",params,event,[[NSUserDefaults standardUserDefaults]valueForKey:@"ApiKey"],[[NSUserDefaults standardUserDefaults]valueForKey:@"AppUserId"]);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if(data!=nil){
                                          NSMutableDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                           NSLog(@" /n body is And With Eventlog %@ Result  %@",event,resultData);
                                          if([[resultData objectForKey:@"responseCode"] intValue]==400){
                                              completion(NO,resultData);
                                          }
                                          else
                                              completion(YES,resultData);
                                      }
                                      else{
                                          NSLog(@"logEvent error %@",error.localizedDescription);
                                          NSError*_error=nil;
                                          if (error.code==-1009){
                                              _error = [NSError errorWithDomain:@"Error" code:200 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Network error",@"title",@"Please check your internet connection.",@"description", nil]];
                                          }
                                          else{
                                              _error = [NSError errorWithDomain:@"Error" code:200 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Error",@"title",@"There is some error from server. Please try again later.",@"description", nil]];
                                          }
                                      }
                                  }];
    
    [task resume];
}
-(void)postAddevents:(NSString *)event withparameters:(NSDictionary *)parameters
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init]; //[[self getGenericParams]mutableCopy];
    [params addEntriesFromDictionary:parameters];
    NSError * error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?event_type=%@&apikey=%@&app_user_id=%@&app_name=%@",APPTA_URL,ADS_API_PATH,event,[self getApiKey],[self getAppUserId],APPNAME]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    //NSLog(@" /n body is And With Event %@ +++ %@",params,event);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if(data!=nil){
                                          NSMutableDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                          NSLog(@"%@",[NSString stringWithFormat:@"Done with event %@ logging",event]);
                                          NSLog(@"resultData %@",resultData);
                                      }
                                      return ;
                                  }];
    [task resume];
}
-(void)fetchUserProfileWithAppUserId:(NSString*)facebookId Withcompletion:(void(^)(BOOL,id responseObject))completion{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [[NSUserDefaults standardUserDefaults] valueForKey:@"ApiKey"], @"apikey", [[NSUserDefaults standardUserDefaults] valueForKey:@"AppUserId"], @"app_user_id",
                            [[NSUserDefaults standardUserDefaults] valueForKey:@"AppUserId"],@"friend_app_user_id",nil];
    NSString *urlWithQuerystring = [self addQueryStringToUrl:[NSString stringWithFormat:@"%@%@",APPTA_URL,GAMIFICATION_USER_WALL_USERID] params:params];
    NSLog(@"urlWithQuerystring %@",urlWithQuerystring);
    NSURL *url = [NSURL URLWithString:urlWithQuerystring];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    request.timeoutInterval = 30.0;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (!error) {
                                          @try {
                                              NSError *error;
                                              id responseObject= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                              if([[responseObject objectForKey:@"responseCode"] intValue]==400){
                                                  completion(NO,responseObject);
                                              }
                                              else
                                                  completion(YES,responseObject);
                                              
                                          }
                                          @catch (NSException *exception) {
                                              
                                          }
                                      }
                                      else{
                                          NSError*_error=nil;
                                          if (error.code==-1009){
                                              _error = [NSError errorWithDomain:@"Error" code:200 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Network error",@"title",@"Please check your internet connection.",@"description", nil]];
                                          }
                                          else{
                                              _error = [NSError errorWithDomain:@"Error" code:200 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Network error",@"title",@"Please check your internet connection.",@"description", nil]];
                                          }
                                          completion(NO,_error);
                                      }
                                  }];
    
    [task resume];
}
-(void)fetchGamificationProfileOfUserWithUserId:(NSString *)facebookid Withcompletion:(void(^)(BOOL,id responseObject))completion{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [[NSUserDefaults standardUserDefaults] valueForKey:@"ApiKey"], @"apikey", [[NSUserDefaults standardUserDefaults] valueForKey:@"AppUserId"], @"app_user_id",
                            [[NSUserDefaults standardUserDefaults] valueForKey:@"AppUserId"],@"friend_app_user_id",nil];
    
    NSString *urlWithQuerystring = [self addQueryStringToUrl:[NSString stringWithFormat:@"%@%@",APPTA_URL,GAMIFICATION_GLOBAL_LEADERBOARDS_USERID] params:params];
    NSURL *url = [NSURL URLWithString:urlWithQuerystring];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    request.timeoutInterval = 30.0;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (!error) {
                                          @try {
                                              
                                              NSError *error;
                                              id responseObject= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                              if([[responseObject objectForKey:@"responseCode"] intValue]==400){
                                                  completion(NO,responseObject);
                                              }
                                              else
                                                  completion(YES,responseObject);
                                              
                                          }
                                          @catch (NSException *exception) {
                                              
                                          }
                                      }
                                      else{
                                          NSError*_error=nil;
                                          if (error.code==-1009){
                                              _error = [NSError errorWithDomain:@"Error" code:200 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Network error",@"title",@"Please check your internet connection.",@"description", nil]];
                                          }
                                          else{
                                              _error = [NSError errorWithDomain:@"Error" code:200 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Network error",@"title",@"Please check your internet connection.",@"description", nil]];
                                          }
                                          completion(NO,_error);
                                      }
                                  }];
    
    [task resume];
}
-(void)fetchLeaderBoardDetailsWithProgrameId:(NSString *)programeid Withcompletion:(void(^)(BOOL,id responseObject))completion{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [[NSUserDefaults standardUserDefaults] valueForKey:@"ApiKey"], @"apikey", [[NSUserDefaults standardUserDefaults] valueForKey:@"AppUserId"], @"app_user_id",
                            programeid,@"program_id",nil];
    
    NSString *urlWithQuerystring = [self addQueryStringToUrl:[NSString stringWithFormat:@"%@%@",APPTA_URL,GAMIFICATION_PROGRAM_LEADERBOARDS] params:params];
    NSLog(@"urlWithQuerystring %@",urlWithQuerystring);
    NSURL *url = [NSURL URLWithString:urlWithQuerystring];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    request.timeoutInterval = 30.0;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (!error) {
                                          @try {
                                              NSError *error;
                                              id responseObject= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                              if([[responseObject objectForKey:@"responseCode"] intValue]==400){
                                                  completion(NO,responseObject);
                                              }
                                              else
                                                  completion(YES,responseObject);
                                          }
                                          @catch (NSException *exception) {
                                              
                                          }
                                      }
                                      else{
                                          NSError*_error=nil;
                                          if (error.code==-1009){
                                              _error = [NSError errorWithDomain:@"Error" code:200 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Network error",@"title",@"Please check your internet connection.",@"description", nil]];
                                          }
                                          else{
                                              _error = [NSError errorWithDomain:@"Error" code:200 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Network error",@"title",@"Please check your internet connection.",@"description", nil]];
                                          }
                                          completion(NO,_error);
                                      }
                                  }];
    
    [task resume];
}
-(NSString *) getApiKey{
    return [[NSUserDefaults standardUserDefaults]valueForKey:@"ApiKey"];//@"kBVQzkSMSuUg3p2pm79nDA6STg0Z%2Ff2R5Un5lYx3Pe4%3D"
}

-(NSString *) getAppUserId {
    NSString *appUserId = [[NSUserDefaults standardUserDefaults]valueForKey:@"AppUserId"];//@"140712201342589"
    return appUserId.length>0?appUserId:@"";
}
-(NSString *) getUniqueDeviceIdentifierAsString {
    NSString *idfa = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return idfa;
}
-(void) parseResponse:(NSDictionary *)response {
    if (response[@"apikey"] !=nil) {
        [[NSUserDefaults standardUserDefaults]setValue:response[@"apikey"] forKey:@"ApiKey"];
        [[NSUserDefaults standardUserDefaults]setValue:response[@"app_user_id"] forKey:@"AppUserId"];
        [[NSUserDefaults standardUserDefaults]setValue:[self getUniqueDeviceIdentifierAsString] forKey:@"SpId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
-(NSString*)addQueryStringToUrl:(NSString *)url params:(NSDictionary *)params {
    NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:url];
    if (params) {
        for(id key in params) {
            NSString *sKey = [key description];
            NSString *sVal = [[params objectForKey:key] description];
            // Do we need to add ?k=v or &k=v
            if ([urlWithQuerystring rangeOfString:@"?"].location==NSNotFound) {
                [urlWithQuerystring appendFormat:@"?%@=%@", [self urlEscape:sKey], [self urlEscape:sVal]];
            } else {
                [urlWithQuerystring appendFormat:@"&%@=%@", [self urlEscape:sKey], [self urlEscape:sVal]];
            }
        }
    }
    return urlWithQuerystring;
}
-(NSString *)convertDictionaryToString:(NSDictionary *)dictionary {
    NSMutableString *paramString = [[NSMutableString alloc] init];
    if (dictionary) {
        for(id key in dictionary) {
            NSString *sKey = [key description];
            NSString *sVal = [[dictionary objectForKey:key] description];
            [paramString appendFormat:@"&%@=%@", [self urlEscape:sKey], [self urlEscape:sVal]];
        }
    }
    return paramString;
}
- (NSData *)createBodyWithBoundary:(NSString *)boundary
                        parameters:(NSDictionary *)parameters
                          mimeType:(NSString *)mimeType
                         fieldName:(NSString *)fieldName
                          fileName:(NSString *)fileName
                         imageData:(NSData *)imageData {
    
    NSMutableData *httpBody = [NSMutableData data];
    
    // add params (all params are strings)
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // add image data
    [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimeType] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:imageData];
    [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return httpBody;
}
-(NSString*)urlEscape:(NSString *)unencodedString {
    NSString *s = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                        (CFStringRef)unencodedString,
                                                                                        NULL,
                                                                                        (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                        kCFStringEncodingUTF8));
    return s;
}
@end
TTPAPIHelper *TTPWebserviceHelper(void)
{
    return [[TTPAPIHelper alloc]init];
}
