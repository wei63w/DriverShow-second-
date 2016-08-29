//
//  Starts.h
//  DriverShow
//
//  Created by genilex3 on 16/8/24.
//  Copyright © 2016年 魏云超. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Result : NSObject
@property (nonatomic, assign) NSArray *banner;
@property (nonatomic, copy) NSString *onepic;
@property (nonatomic, copy) NSString *secondpic;
@property (nonatomic, copy) NSString *thirdpic;
@property (nonatomic, copy) NSString *onecname;
@property (nonatomic, copy) NSString *oneename;
@property (nonatomic, copy) NSString *secondcname;
@property (nonatomic, copy) NSString *secondename;
@property (nonatomic, copy) NSString *thirdcname;
@property (nonatomic, copy) NSString *thirdename;
@end


@interface Starts : NSObject

@property (nonatomic, strong) Result *result;
@property (nonatomic, copy) NSString *status;

@end
