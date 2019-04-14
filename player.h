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
   NSArray * abilities;
}
@property (readonly) NSString * name;
@property int level;
@property int xp;
@property int class;
@property int location;
@property int medals;
@property int max_hp;
@property int health;
@property int strength;
@property int mana;
@property int max_mana;
@property int intelligence;
@property int speed;
@property (nonatomic, retain) NSArray * abilities;

+ (instancetype) PlayerWithName: (NSString *) name andClass: (int) cls;
- (id) initWithName: (NSString *) name andClass: (int) cls;
- (void) damage: (int) points;
- (int) attackWithAbility: (int) ability;
@end
