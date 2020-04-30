//
//  WebServiceCall.m
//  finder
//
//  Created by Joshua Balogun on 12/18/14.
//  Copyright (c) 2014 Etisalat. All rights reserved.
//

#import "WebServiceCall.h"
#import <Foundation/Foundation.h>

#define base_url @"http://41.190.16.170:8080/mobile-gateway/services/1.0/"
#define access_token @"33333"


@implementation WebServiceCall




- (NSDictionary *)validator:(NSDictionary *)requestData
{
    
    NSMutableString *URLString = [[NSMutableString alloc] initWithString:base_url];
    
    [URLString appendString:@"validateConfigParameters"];
    
    NSLog(@"body :: %@",requestData);
    
    
    id json = [self processRequestNResponse:URLString:requestData:@"POST"];
    
    NSDictionary *result = json;
    
    return result;
}


- (NSArray *)categories:(NSString *)catType
{
    
    NSMutableString *URLString = [[NSMutableString alloc] initWithString:base_url];
    
    [URLString appendString:[NSString stringWithFormat:@"findMobileServicePricingByCategory?category=%@",catType]];
    
    
    NSLog(@"body :: %@",URLString);
    
    id json = [self processRequestNResponse:URLString:nil:@"GET"];
    
    NSArray *result = json;
    
    return result;
}


- (NSArray *)gifting
{
    
    NSMutableString *URLString = [[NSMutableString alloc] initWithString:base_url];
    
    [URLString appendString:[NSString stringWithFormat:@"findAllDataGiftingPricePoints"]];
    
    
    NSLog(@"body :: %@",URLString);
    
    id json = [self processRequestNResponse:URLString:nil:@"GET"];
    
    NSArray *result = json;
    
    return result;
}



- (NSDictionary *)promotions
{
    
    NSMutableString *URLString = [[NSMutableString alloc] initWithString:base_url];
    
    [URLString appendString:@"getRandomImageAdvertData"];
    
    
    NSLog(@"body :: %@",URLString);
    
    id json = [self processRequestNResponse:URLString:nil:@"GET"];
    
    NSDictionary *result = json;
    
    return result;
}



- (NSDictionary *)controllers:(NSDictionary *)requestData
{
    
    NSMutableString *URLString = [[NSMutableString alloc] initWithString:base_url];
    
    [URLString appendString:@"serviceControllerDelegate"];
    
    NSLog(@"body :: %@",requestData);
    
    
    id json = [self processRequestNResponse:URLString:requestData:@"POST"];
    
    NSDictionary *result = json;
    
    return result;
}


- (NSData *)imageRequestNResponse:(NSMutableString *)URLString
{
    
    NSURL *URL = [NSURL URLWithString:URLString];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    
    NSDictionary *headers = @{ @"content-type": @"application/json", @"cache-control": @"no-cache" };
    
    //Request
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];

    
    //Response
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (data == nil)
    {
        //NSLog(@"%s: Error: %@", __PRETTY_FUNCTION__, [error localizedDescription]);
    }
    
    return data;
    
}



- (id)processRequestNResponse:(NSMutableString *)URLString :(NSDictionary *)requestData :(NSString *)method
{
    
    NSURL *URL = [NSURL URLWithString:URLString];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    
    NSDictionary *headers = @{ @"content-type": @"application/json", @"cache-control": @"no-cache" };
    
    //Request
    [request setHTTPMethod:method];
    [request setAllHTTPHeaderFields:headers];

    if ([method isEqualToString:@"POST"])
    {
        NSData *postData = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:nil];
        [request setHTTPBody:postData];
    }
    
    //Response
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (data == nil)
    {
        //NSLog(@"%s: Error: %@", __PRETTY_FUNCTION__, [error localizedDescription]);
        NSDictionary *errorData = @{ @"StatusCode":@"789", @"StatusDescription":[error localizedDescription] };
        //NSLog(@"errorData - %@",errorData);
        data = [NSJSONSerialization dataWithJSONObject:errorData options:NSJSONWritingPrettyPrinted error:&error];
    }
    
    /*
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%s: string: %@", __PRETTY_FUNCTION__, string);
    NSLog(@"%s: json: %@", __PRETTY_FUNCTION__, jsonData);
     */
    
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (json == nil)
    {
        //NSLog(@"%s: Error: %@", __PRETTY_FUNCTION__, [error localizedDescription]);
        NSDictionary *errorData = @{ @"StatusCode":@"123", @"StatusDescription":@"sorry operation failed, please try again later." };
        //NSLog(@"errorData - %@",errorData);
        data = [NSJSONSerialization dataWithJSONObject:errorData options:NSJSONWritingPrettyPrinted error:&error];
        json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    }
    
    return json;
    
}


@end
