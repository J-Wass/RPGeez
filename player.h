#import <Foundation/Foundation.h>

@interface Player : NSObject {
   NSString * name;
   int level;
   int xp;
   int class;
   int location;
   int medals;

   //stats
   double hp;
   double strength;
   double mana;
   double intelligence;
   double speed;
}
+ (instancetype) PlayerWithName: (NSString *) name andClass: (int) cls;
- (id) initWithName: (NSString *) name andClass: (int) cls;
- (void) damage: (double) points;
- (NSString *) getName;
- (int) getLevel;
- (double) getXP;
- (double) getHP;
- (char *) getClass;
- (int) getLocation;
- (void) setLocation: (int) loc;
- (int) getMedals;
- (void) addMedal;
@end
