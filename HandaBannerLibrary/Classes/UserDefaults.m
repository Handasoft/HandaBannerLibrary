//
//  DKUserDefaults.m
//  SajuWithSNSpage
//
//  Created by dicadong on 11. 12. 15..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "UserDefaults.h"

@implementation UserDefaults

+ (BOOL) saveUserDefaults:(id)object forKey:(id)Key{
    BOOL returnValue = NO;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    @synchronized(userDefaults){
        if(userDefaults && Key && object){
            [userDefaults setObject:object forKey:Key];
        }
        else{
            [userDefaults removeObjectForKey:Key];
        }
        returnValue = [userDefaults synchronize];
    }
    return returnValue;
}

+ (id) loadUserDefaults:(id)Key{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    id returnValue = nil;
    if(userDefaults && Key){
        returnValue = [userDefaults objectForKey:Key];
    }
    return returnValue;
}

+ (void) removeUserDefaults:(id)Key{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    @synchronized(userDefaults){
        [userDefaults removeObjectForKey:Key];
        [userDefaults synchronize];
    }
}
@end
