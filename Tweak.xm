#import <Foundation/Foundation.h>
#import "IGP_Config.h"
#import "IGP_Cheater.h"
#import "aslrwrite.h"

IGP_Config *config;

//#########YOUR HACKS HERE#########

BOOL hack1;

//#################################

@interface Cheater : IGP_Cheater {

NSMutableDictionary *selCheats;

}

-(void)getCheats;
-(void)applyCheats;

@end

@implementation Cheater

-(id)init {

self = [super init];

if (self) {

selCheats = [config getSelectedCheats];

[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCheats) name:@"CanApplyCheatsNow" object:nil];

}

return self;

}

//#########INITIALIZE HACKS HERE#########
-(void)getCheats {

hack1 = [[selCheats valueForKey:@"Hack 1"] boolValue];

[self applyCheats];

}
//######################################

//#########CHECK FOR HACKS AND APPLY THEM HERE#########

-(void)applyCheats {

if ([[self getGameVersion] isEqualToString:[self getTargetVersion]]) {

if (hack1) {

//do stuff to activate hack1

}

} 

}
//####################################################

@end

%ctor {

NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];

if (bundleID && [bundleID isEqualToString:@"com.gamedev.gamename"]) {

config = [[%c(IGP_Config) alloc] init];
[config createAlertWithTitle:@"Hacks" cancelButtonTitle:@"Apply" andSubtitle:@"by <YourName>"];
[config setCheatNames:@"Hack 1",@"Hack 2",nil];
[config start];

Cheater *cheater = [[%c(Cheater) alloc] init];
[cheater setTargetVersion:@"Game Version"];
[cheater startCheating];

}

}
