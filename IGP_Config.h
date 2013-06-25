#import <Foundation/Foundation.h>
#import "SBTableAlert.h"

@interface IGP_Config : NSObject <SBTableAlertDelegate, SBTableAlertDataSource> {

NSMutableArray *cheats;
NSMutableDictionary *selectedCheats;
    NSString *theTitle;
    NSString *theCancelTitle;
    NSString *theSubTitle;

}

@property (nonatomic,retain) NSMutableDictionary *selectedCheats;

-(void)start;
-(void)createAlertWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle andSubtitle:(NSString *)subTitle;
-(void)appDidFinishLaunching;
-(id)init;
-(void)setCheatNames:(NSString *)cheat,...;
-(NSMutableDictionary *)getSelectedCheats;

@end