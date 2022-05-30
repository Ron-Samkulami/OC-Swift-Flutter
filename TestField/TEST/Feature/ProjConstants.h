//
//  ProjConstants.h
//  TEST
//
//  Created by 111 on 2021/12/21.
//

#ifndef ProjConstants_h
#define ProjConstants_h

#ifdef DEBUG
#define kAddress [[NSUserDefaults standardUserDefaults]objectForKey:@"RSBaseUrl"]
//#define kAddress @"devapi.RS.com"
#else
#define kAddress @"api.RS.com"
#endif

#endif /* ProjConstants_h */
