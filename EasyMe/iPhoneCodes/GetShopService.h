//
//  GetShopService.h
//  TrustFund
//
//  Created by Joshua Balogun on 12/18/14.
//  Copyright (c) 2014 TrustFund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface GetShopService : UIViewController < NSXMLParserDelegate, NSURLConnectionDelegate>
{
    NSMutableData *webData;
    NSString *soapResults;
    NSString *soapResponseMsg;
    NSString *soapResponseCode;
    NSString *soapResponseCodeMean;
    NSString *currentElement;
    NSXMLParser *xmlParser;
    BOOL elementFound;
    NSURLConnection *conn;
    
}

@property (nonatomic, strong) NSString *soapResults;
@property (nonatomic, strong) NSString *soapResponseMsg;
@property (nonatomic, strong) NSString *soapResponseCode;
@property (nonatomic, strong) NSString *soapResponseCodeMean;
@property (nonatomic, strong) NSString *currentElement;

@property(nonatomic, strong) NSMutableArray *storesAr;
@property(nonatomic, strong) NSMutableDictionary *storeDict;

-(void) getShops;

@end
