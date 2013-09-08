//
//  ADZAristaFetcher.m
//  ArisDozer
//
//  Created by Jeroen Arnoldus on 08-09-13.
//  Copyright (c) 2013 Jeroen Arnoldus. All rights reserved.
//

#import "ADZAristaFetcher.h"
#include <NMSSH/NMSSH.h>
#import "ADZLLPDNeighbor.h"
#import "ADZLLPDDeviceInfo.h"

@implementation ADZAristaFetcher

- (NSString*)executeAristaCommand:(NSString*)command host:(NSArray*)host password:(NSString*)pw{
    NSString *sshhost =@"<the ssh host>";
    NSString *uid =@"uid";

    
    NMSSHSession *session = [NMSSHSession connectToHost:sshhost
                                           withUsername:uid];
    NSString *response = nil;
    if (session.isConnected) {
        [session authenticateByPassword:pw];
        
        if (session.isAuthorized) {
            NSError *error = nil;
            NSString *realCommand=[NSString stringWithFormat:@"sshpass -p '%@' ssh %@ -f '%@'", [host objectAtIndex:1], [host objectAtIndex:0],command];
            response = [session.channel execute:realCommand error:&error];


        }
    }
    [session disconnect];
    return response;
    
}

-(NSArray*)prepareString:(NSString*)string{
string =[string stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
string =[string stringByReplacingOccurrencesOfString:@"\r" withString:@" "];

NSError *error = nil;

NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"  +" options:NSRegularExpressionCaseInsensitive error:&error];
NSString *trimmedString = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@" "];
return [trimmedString componentsSeparatedByString:@" "];
}

- (NSMutableArray*)fetchLLPDNeighbors:(NSArray*)host password:(NSString*)pw{
    NSString *response =[self executeAristaCommand:@"show lldp neighbors" host:host password:pw];
    NSArray* theResultString = [self prepareString:response];
    NSUInteger index = 0;

    BOOL foundTTL =FALSE;
    while(!foundTTL && index < [theResultString count]){
        NSString *item = [theResultString objectAtIndex:index];
        if([item isEqualToString:@"TTL"]){
            foundTTL=TRUE;
        }
        index++;
        
    }
    NSMutableArray *LLPDNeighbors = [NSMutableArray new];

    while( index < ([theResultString count]-1)){
        ADZLLPDNeighbor *LLPDNeighbor = [ADZLLPDNeighbor alloc];
        LLPDNeighbor.port=[theResultString objectAtIndex:index];
        index++;
        LLPDNeighbor.deviceid=[theResultString objectAtIndex:index];
        index++;
        LLPDNeighbor.portid=[theResultString objectAtIndex:index];
        index++;
        index++;
        [LLPDNeighbors addObject:LLPDNeighbor];
    }
    return LLPDNeighbors;
}

- (ADZLLPDDeviceInfo*) fetchDeviceInfo:(NSString*)port host:(NSArray*)host password:(NSString*)pw{
    NSString *command=[NSString stringWithFormat:@"show lldp neighbor %@ detail", port];
    NSString *response =[self executeAristaCommand:command host:host password:pw];
    NSArray* theResultString = [self prepareString:response];
    NSUInteger index = 0;
    
    ADZLLPDDeviceInfo *deviceInfo = [ADZLLPDDeviceInfo alloc];
    deviceInfo.brand = @"Unknown";
    while(index < [theResultString count]){
        NSString *item = [theResultString objectAtIndex:index];
        if([item isEqualToString:@"Management"]){
            index++;
            if([[theResultString objectAtIndex:index] isEqualToString:@"Address"]){
                index++;
                if([[theResultString objectAtIndex:index] isEqualToString:@":"]){
                    index++;
                    NSString *ip = [theResultString objectAtIndex:index];
                    deviceInfo.ip = ip;
                    NSString *pathString=[NSString stringWithFormat:@"admin@%@", ip];
                    deviceInfo.loginPath = [host arrayByAddingObjectsFromArray:[[NSArray alloc] initWithObjects:pathString,@"lab123",nil]];

                }
            }
        }
        if([item isEqualToString:@"Chassis"]){
            index++;
            if([[theResultString objectAtIndex:index] isEqualToString:@"ID"]){
                index++;
                if([[theResultString objectAtIndex:index] isEqualToString:@":"]){
                    index++;
                    deviceInfo.mac = [theResultString objectAtIndex:index];
                }
            }
        }
        if([item isEqualToString:@"Enabled"]){
            index++;
            if([[theResultString objectAtIndex:index] isEqualToString:@"Capabilities:"]){
                index++;
                deviceInfo.deviceType = [theResultString objectAtIndex:index];
            }
        }
        if([item isEqualToString:@"Arista"]){
            deviceInfo.brand = @"Arista";
        }
        index++;
        
    }
    return deviceInfo;
}

- (NSMutableDictionary*)fetchTraversalNetwork:(NSMutableDictionary*)devices host:(NSArray*)host password:(NSString*)pw{

    ADZLLPDDeviceInfo *deviceInfo;
    NSMutableArray *LLPDNeighbors = [self fetchLLPDNeighbors:host password:pw];

    for(ADZLLPDNeighbor *neighbor in LLPDNeighbors){
        NSLog(@"Buurman: %@:", [neighbor toString]);
        NSString *port = neighbor.port;
        if([port rangeOfString:@"Et"].location != NSNotFound) {
            deviceInfo = [self fetchDeviceInfo:port host:host password:pw];
            NSLog(@"DeviceInfo: %@:", [deviceInfo toString]);
            if([devices objectForKey:deviceInfo.mac]==nil){
                [devices setObject:deviceInfo forKey:deviceInfo.mac];
//                devices=[self fetchTraversalNetwork:devices host:deviceInfo.loginPath password:pw];
            }
        }
        
    }
    

    return devices;
}

- (NSMutableDictionary*)fetchNetwork:(NSArray*)host password:(NSString*)pw{
    NSMutableDictionary *devices = [[NSMutableDictionary alloc] init];
    ADZLLPDDeviceInfo *deviceInfo = [ADZLLPDDeviceInfo alloc];
    deviceInfo.brand = @"Arista";
    deviceInfo.deviceType = @"Bridge";
    deviceInfo.brand = @"Arista";
    deviceInfo.ip = [host objectAtIndex:0];
    [devices setObject:deviceInfo forKey:@"0"];

    devices = [self fetchTraversalNetwork:devices host:host password:pw];
    NSArray *keys=[devices allKeys];

    for( NSString* key in keys){
        ADZLLPDDeviceInfo *deviceInfo = [devices objectForKey:key];
        NSLog(@"DeviceInfo: %@:", [deviceInfo toString]);
    }
    return devices;
}

@end






