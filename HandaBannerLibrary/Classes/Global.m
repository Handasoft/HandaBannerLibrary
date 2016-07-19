//
//  DKAppEnvironment.m
//  SajuWithSNSpage
//
//  Created by dicadong on 11. 12. 15..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "Global.h"

@implementation Global

static Global * globalValue = nil;

+ (id)alloc{
    @synchronized([Global class])
    {
        globalValue = [super alloc];
        return globalValue;
    }
    return nil;
}

+ (Global *)Access{
    @synchronized([Global class])
    {
        if(!globalValue)
        {
            globalValue = [[self alloc] init];
        }

        return globalValue;
    }
    return nil;
}

+ (void)logout{
    @synchronized([Global class])
    {
        if(globalValue)
        {

        }
    }
}

- (void)dealloc{

}

- (NSString*) SendPost:(NSString *)url withParam:(NSString *)parameter{
    // create the URL
    NSURL *postURL = [NSURL URLWithString:url];
    
    // create the connection
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:postURL
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:5.0];
    // change type to POST (default is GET)
    [postRequest setHTTPMethod:@"POST"];

    // add body to post
    [postRequest setHTTPBody:[parameter dataUsingEncoding:NSUTF8StringEncoding]];
    
    // pointers to some necessary objects
    NSURLResponse* response;
    NSError* error;
    
    // synchronous filling of data from HTTP POST response
    NSData *responseData = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&error];
    
    if (error){
        NSLog(@"Error: %@", [error localizedDescription]);
        return nil;
    }
    
    // convert data into string
    NSString *responseString = [[NSString alloc] initWithBytes:[responseData bytes]
                                                        length:[responseData length]
                                                      encoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@", responseString);
    NSString * strReturn = nil;
    if([responseString compare:@""]){
        NSString * strResult = [responseString substringToIndex:1];
        if([strResult compare:@"1"]){
            return nil;
        }
        strReturn = [responseString substringFromIndex:2];
    }
    
    return strReturn;
}

- (NSDictionary*) SendPostReceiveJson:(NSString *)url withParam:(NSString *)parameter{
    
    // create the URL
    NSURL *postURL = [NSURL URLWithString:url];
    
    // create the connection
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:postURL
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:5.0];
    // change type to POST (default is GET)
    [postRequest setHTTPMethod:@"POST"];
    
    // add body to post
    [postRequest setHTTPBody:[parameter dataUsingEncoding:NSUTF8StringEncoding]];
    
    // pointers to some necessary objects
    NSURLResponse* response;
    NSError* error;
    
    // synchronous filling of data from HTTP POST response
    NSData *responseData = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&error];
    
    if (error){
        NSLog(@"Error: %@", [error localizedDescription]);

        return nil;
    }
    NSString *responseString = [[[NSString alloc] initWithBytes:[responseData bytes]
                                                        length:[responseData length]
                                                      encoding:0x80000000 + kCFStringEncodingDOSKorean] stringByReplacingOccurrencesOfString:@"encoding=\"ecu-kr\"" withString:@"encoding=\"utf-8\""];
    NSLog(@"%@", responseString);
    NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    if (error){
        NSLog(@"Error: %@", [error localizedDescription]);

        return nil;
    }


    return jsonDic;
}

@end
