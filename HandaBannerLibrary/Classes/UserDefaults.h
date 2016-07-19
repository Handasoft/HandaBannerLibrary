//
//  DKUserDefaults.h
//  SajuWithSNSpage
//
//  Created by dicadong on 11. 12. 15..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaults : NSObject

+ (BOOL) saveUserDefaults:(id)object forKey:(id)Key;
+ (id) loadUserDefaults:(id)Key;
+ (void) removeUserDefaults:(id)Key;
@end
