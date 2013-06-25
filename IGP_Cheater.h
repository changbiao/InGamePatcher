@interface IGP_Cheater : NSObject {

    NSString *targetVersion;

}

-(void)didFinishChoosing;
-(void)setTargetVersion:(NSString *)version;
-(NSString *)getTargetVersion;
-(NSString *)getGameVersion;
-(void)startCheating;

@end
