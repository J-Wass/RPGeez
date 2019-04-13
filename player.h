#import <Foundation/Foundation.h>

@interface Player : NSObject {
   NSString * name;
   int level;
   int xp;
   int class;
   int location;
   int medals;

   //stats
   int max_hp;
   int health;
   int strength;
   int mana;
   int max_mana;
   int intelligence;
   int speed;

   int abilities[4];
}
+ (instancetype) PlayerWithName: (NSString *) name andClass: (int) cls;
- (id) initWithName: (NSString *) name andClass: (int) cls;
- (void) damage: (int) points;
- (NSString *) getName;
- (int) getLevel;
- (int) getXP;
- (int) getHP;
- (char *) getClass;
- (int) getLocation;
- (void) setLocation: (int) loc;
- (int) getMedals;
- (void) addMedal;
- (int) attackWithAbility: (int) ability;
@end
