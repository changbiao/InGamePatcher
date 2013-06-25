#import "IGP_Config.h"

@interface IGP_Config ()

@end

@implementation IGP_Config
@synthesize selectedCheats;

-(void)appDidFinishLaunching {

    SBTableAlert *alert;
    
    alert = [[SBTableAlert alloc] initWithTitle:theTitle cancelButtonTitle:theCancelTitle messageFormat:theSubTitle];
    [alert setStyle:SBTableAlertStyleApple];
    [alert setType:SBTableAlertTypeMultipleSelect];
    [alert setDelegate:self];
	[alert setDataSource:self];
	
	[alert show];

}

-(NSMutableDictionary *)getSelectedCheats {
    
    return self.selectedCheats;
}

-(void)setCheatNames:(NSString *)cheat, ... {
    
    va_list args;
    va_start(args, cheat);
    for (NSString *arg = cheat; arg != nil; arg = va_arg(args, NSString*))
    {
	
	[cheats addObject:arg];
	
    }
    va_end(args);
}

-(void)createAlertWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle andSubtitle:(NSString *)subTitle {
    
    theTitle = title;
    theCancelTitle = cancelTitle;
    theSubTitle = subTitle;
    
}

-(void)start {

[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidFinishLaunching) name:UIApplicationDidFinishLaunchingNotification object:nil];

}

-(id)init {

self = [super init];

if (self) {

    cheats = [[NSMutableArray alloc] init];
    selectedCheats = [[NSMutableDictionary alloc] init];

}

return self;

}

- (UITableViewCell *)tableAlert:(SBTableAlert *)tableAlert cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"MainCell";
    
	UITableViewCell *cell = [tableAlert.tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
	
       cell = [[SBTableAlertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
	
    }
	
	[cell.textLabel setText:[cheats objectAtIndex:indexPath.row]];
	
	return cell;
}


- (NSInteger)tableAlert:(SBTableAlert *)tableAlert numberOfRowsInSection:(NSInteger)section {
	
		return cheats.count;
}

- (NSInteger)numberOfSectionsInTableAlert:(SBTableAlert *)tableAlert {

		return 1;
}

- (NSString *)tableAlert:(SBTableAlert *)tableAlert titleForHeaderInSection:(NSInteger)section {
    
		return @"Available Cheats";

}

- (void)tableAlert:(SBTableAlert *)tableAlert didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidFinishSelecting" object:nil];
    
}

- (void)tableAlert:(SBTableAlert *)tableAlert didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (tableAlert.type == SBTableAlertTypeMultipleSelect) {
		UITableViewCell *cell = [tableAlert.tableView cellForRowAtIndexPath:indexPath];
		if (cell.accessoryType == UITableViewCellAccessoryNone) {
			[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
	    [selectedCheats setObject:[NSNumber numberWithBool:TRUE] forKey:cell.textLabel.text];
	}
		else {
			[cell setAccessoryType:UITableViewCellAccessoryNone];
	    [selectedCheats setObject:[NSNumber numberWithBool:FALSE] forKey:cell.textLabel.text];
	}
		
		[tableAlert.tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}


@end
