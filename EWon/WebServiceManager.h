//
//  WebServiceManager.h
//  EWon
//
//  Created by Seby Feier on 21/11/15.
//  Copyright © 2015 Seby Feier. All rights reserved.
//

//#import <AFHTTPSig/AFHTTPSig.h>
#import <Foundation/Foundation.h>
typedef void(^DictionaryAndErrorCompletionBlock)(NSDictionary *dictionary, NSError *error);

@interface WebServiceManager : NSObject

@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

+ (WebServiceManager *)sharedInstance;

- (void)loginWithAccount:(NSString *)account
                username:(NSString *)username
             andPassword:(NSString *)password
     withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)getAccountInfoWithCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)getEwonsWithPool:(NSString *)pool
     withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)getEwonWithName:(NSString *)name
                   pool:(NSString *)pool
    withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)wakeUpEwonWithName:(NSString *)name
                      pool:(NSString *)pool
       withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)sendOfflineEwonWithName:(NSString *)name
                           pool:(NSString *)pool
            withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)logoutWithCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)reachEwonWithIp:(NSString *)ip
                      port:(NSString *)port
                      name:(NSString *)name
       withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (NSURL *)reachEwonWithIp:(NSString *)ip
                      port:(NSString *)port
                      name:(NSString *)name;

@end
