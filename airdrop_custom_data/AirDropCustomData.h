//
//  AirDropData.h
//  airdrop_custom_data
//
//  Created by Maxim Bilan on 9/14/14.
//  Copyright (c) 2014 Maxim Bilan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AirDropCustomData : NSObject <UIActivityItemSource>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *subject;

- (id)initWithURL:(NSURL *)url subject:(NSString *)subject;

@end
