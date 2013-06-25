#import "IGP_Cheater.h"

@interface IGP_Cheater ()

@end

@implementation IGP_Cheater

-(void)setTargetVersion:(NSString *)version {

targetVersion = version;

}

-(NSString *)getTargetVersion {

return targetVersion;

}

-(void)startCheating {

[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishChoosing) name:@"UserDidFinishSelecting" object:nil];

}

-(NSString *)getGameVersion {
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

-(void)didFinishChoosing {
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"CanApplyCheatsNow" object:nil];
}


@end
