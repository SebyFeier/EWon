//
//  WebServiceManager.m
//  EWon
//
//  Created by Seby Feier on 21/11/15.
//  Copyright © 2015 Seby Feier. All rights reserved.
//

#import "WebServiceManager.h"
#import <AFHTTPClient.h>
#import "AFNetworking.h"
#define kTWebServiceForEndpoint(endpoint) [WebServiceUrl stringByAppendingPathComponent:endpoint]

NSString *const WebServiceUrl = @"https://m2web.talk2m.com";
NSString *const WebServiceLogin = @"login";

NSString *const WebServiceDeveloperId = @"F3E469A5-577F-1D7B-FC0C-B42C4ED11537";


@implementation WebServiceManager

+ (WebServiceManager *)sharedInstance {
    static dispatch_once_t onceToken;
    static WebServiceManager *_sharedClient = nil;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[WebServiceManager alloc] init];
    });
    return _sharedClient;
}

- (void)loginWithAccount:(NSString *)account
                username:(NSString *)username
             andPassword:(NSString *)password
     withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString *urlString = [@"" stringByAppendingString:[NSString stringWithFormat:@"t2mapi/login?t2maccount=%@&t2musername=%@&t2mpassword=%@&t2mdeveloperid=%@", [account stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], username, password, WebServiceDeveloperId]];
    
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream",@"application/json",@"text/plain", @"text/html", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.account = account;
        self.username = username;
        self.password = password;
        [[NSUserDefaults standardUserDefaults] setObject:self.account forKey:@"account"];
        [[NSUserDefaults standardUserDefaults] setObject:self.username forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:self.password forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] setObject:JSON[@"t2msession"] forKey:@"sessionId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if ([JSON[@"success"] boolValue]) {
            self.account = account;
            self.username = username;
            self.password = password;
            [[NSUserDefaults standardUserDefaults] setObject:self.account forKey:@"account"];
            [[NSUserDefaults standardUserDefaults] setObject:self.username forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setObject:self.password forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] setObject:JSON[@"t2msession"] forKey:@"sessionId"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        completionBlock(JSON, error);

    }];
    [operation start];
    
}

- (void)getAccountInfoWithCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
//    NSString *urlString = [NSString stringWithFormat:@"t2mapi/getaccountinfo?t2maccount=%@&t2musername=%@&t2mpassword=%@&t2mdeveloperid=%@",[self.account stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],self.username,self.password,WebServiceDeveloperId];
    NSString *urlString = [NSString stringWithFormat:@"t2mapi/getaccountinfo?t2msession=%@&t2mdeveloperid=%@",self.sessionId, WebServiceDeveloperId];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream",@"application/json",@"text/plain", @"text/html", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)getEwonsWithPool:(NSString *)pool withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
//    NSString *urlString = [NSString stringWithFormat:@"t2mapi/getewons?t2maccount=%@&t2musername=%@&t2mpassword=%@&t2mdeveloperid=%@", self.account, self.username, self.password, WebServiceDeveloperId];
    NSString *urlString = [NSString stringWithFormat:@"t2mapi/getewons?t2msession=%@&t2mdeveloperid=%@",self.sessionId,WebServiceDeveloperId];
    if (pool) {
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&pool=%@", pool]];
    }
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)getEwonWithName:(NSString *)name pool:(NSString *)pool withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString *urlString = @"t2mapi/getewon?";
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"t2msession=%@&t2mdeveloperid=%@",self.sessionId, WebServiceDeveloperId]];

    if (name) {
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&name=%@",[name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    if (pool) {
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&id=%@",pool]];
    }
//    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"?t2maccount=%@&t2musername=%@&t2mpassword=%@&t2mdeveloperid=%@", self.account, self.username, self.password, WebServiceDeveloperId]];
    
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];

}

- (void)wakeUpEwonWithName:(NSString *)name pool:(NSString *)pool withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString *urlString = @"t2mapi/wakeup?";
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"t2msession=%@&t2mdeveloperid=%@",self.sessionId, WebServiceDeveloperId]];
    if (name) {
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&name=%@",[name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    if (pool) {
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&id=%@",pool]];
    }
//    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"?t2maccount=%@&t2musername=%@&t2mpassword=%@&t2mdeveloperid=%@", self.account, self.username, self.password, WebServiceDeveloperId]];
    
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)sendOfflineEwonWithName:(NSString *)name pool:(NSString *)pool withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString *urlString = @"t2mapi/sendoffline?";
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"t2msession=%@&t2mdeveloperid=%@",self.sessionId, WebServiceDeveloperId]];
    if (name) {
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&name=%@",[name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    if (pool) {
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&id=%@",pool]];
    }
//    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"?t2maccount=%@&t2musername=%@&t2mpassword=%@&t2mdeveloperid=%@", self.account, self.username, self.password, WebServiceDeveloperId]];
    
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)logoutWithCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString *urlString = @"";
    if (self.sessionId) {
        urlString = [NSString stringWithFormat:@"t2mapi/logout?t2msession=%@&t2mdeveloperid=%@",self.sessionId, WebServiceDeveloperId];
    } else {
        urlString = [NSString stringWithFormat:@"t2mapi/logout?t2msession=%@&t2mdeveloperid=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"sessionId"],WebServiceDeveloperId];
    }
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream",@"application/json",@"text/plain", @"text/html", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)reachEwonWithIp:(NSString *)ip port:(NSString *)port name:(NSString *)name withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
//    NSString *urlString = [NSString stringWithFormat:@"%@/%@/vnc/%@:%@/",[self.account stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],ip,port];
//    NSString *urlString = [NSString stringWithFormat:@"t2mapi/get/%@/%@:%@?query&t2msession=%@",[name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], ip, port, self.sessionId];
    NSString *urlString = [NSString stringWithFormat:@"t2mapi/get/%@/rcgi.bin/ParamForm?AST_Param=$dtIV$ftT&t2msession=%@&t2mdeveloperid=%@", [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], self.sessionId, WebServiceDeveloperId];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream",@"application/json",@"text/plain", @"text/html", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
    
}

- (NSURL *)reachEwonWithIp:(NSString *)ip
                      port:(NSString *)port
                      name:(NSString *)name {
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/vnc/%@:%@/",[self.account stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],ip,port];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:urlString
                                                      parameters:nil];
    NSLog(@"URL %@",request.URL);
    return request.URL;
    
}


@end
