//
//  GetShopService.m
//  finder
//
//  Created by Joshua Balogun on 12/18/14.
//  Copyright (c) 2014 Etisalat. All rights reserved.
//

#import "GetShopService.h"
#import "AppConstants.h"
#import <Foundation/Foundation.h>


@implementation GetShopService

@synthesize soapResults;
@synthesize soapResponseCode;
@synthesize soapResponseMsg;
@synthesize soapResponseCodeMean;
@synthesize storesAr, storeDict;
@synthesize currentElement;

-(void) getShops
{
    
    NSLog(@"getShops ::: getShops");
    storesAr = [NSMutableArray array];
    storeDict =[[NSMutableDictionary alloc] init];
    
    // Live URL
    NSURL *url = [NSURL URLWithString: @"http://etisalat.com.ng/wp-content/themes/etisalat/stores/data/stores.xml"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"GET"];
    
    
    conn = [NSURLConnection connectionWithRequest:req delegate:self];
    if (conn)
    {
        webData = [NSMutableData data];
    }
    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *) response
{
    [webData setLength: 0];
}


-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *) dataReceived
{
    [webData appendData:dataReceived];
}


-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *) error
{
    
    NSLog(@"error ::: %@", [error localizedDescription]);
    [SVProgressHUD dismiss];
}


-(void) connectionDidFinishLoading:(NSURLConnection *) connection
{
    
    //NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    //NSString *theXML = [[NSString alloc] initWithBytes:[webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    
    //NSLog(@"About to print XML\n\n");
    //NSLog(@"%@\n", theXML);
    
    
    xmlParser = [[NSXMLParser alloc] initWithData: webData];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities: YES];
    [xmlParser parse];
    
    NSArray *stores = [NSArray arrayWithArray:storesAr];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStoreList" object:stores];
    
}


//---when the start of an element is found---
-(void)  parser:(NSXMLParser *) parserdidStartElement :(NSString *) elementName   namespaceURI :(NSString *) namespaceURI  qualifiedName :(NSString *) qName
     attributes:(NSDictionary *) attributeDict
{
    
    soapResults = @"";
}


-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{
    
    soapResults = [NSString stringWithFormat:@"%@", string];
    
    /*
    if([self.currentElement isEqualToString:@"name"])
    {
        if (!([soapResults isEqualToString:@"\n\t"] || [soapResults isEqualToString:@"NO \n    "]))
        {
            if ([soapResults rangeOfString:@"\n"].location == NSNotFound)
            {
                //NSLog(@"string does not contain bla");
            }
            else
            {
                soapResults = [soapResults stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [storeDict setObject:soapResults forKey:@"location"];
            }
        }
    }
    */
    
}


//---when the end of element is found---
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    //currentElement = elementName;
    //NSLog(@"elementName  ::: %@",elementName);
    
    if ([elementName isEqualToString:@"name"])
    {
        soapResponseMsg = soapResults;
        [storeDict setObject:soapResponseMsg forKey:@"name"];
        //NSLog(@"soapResponseMsg ::: %@",soapResponseMsg);
    }
    
    if ([elementName isEqualToString:@"description"])
    {
        soapResponseCode = soapResults;
        soapResponseCode = [soapResponseCode stringByReplacingOccurrencesOfString:@"<div dir=\"ltr\">" withString:@""];
        soapResponseCode = [soapResponseCode stringByReplacingOccurrencesOfString:@"</div>" withString:@""];
        [storeDict setObject:soapResponseCode forKey:@"description"];
        //NSLog(@"soapResponseCode ::: %@",soapResponseCode);
    }
    
    if ([elementName isEqualToString:@"coordinates"])
    {
        soapResponseCodeMean = soapResults;
        [storeDict setObject:soapResponseCodeMean forKey:@"coordinates"];
        //NSLog(@"soapResponseCodeMean ::: %@",soapResponseCodeMean);
    }
    if ([elementName isEqualToString:@"Placemark"])
    {
        [storesAr addObject:storeDict];
        storeDict = [NSMutableDictionary new];
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    soapResults = nil;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    soapResults = nil;
}


@end
