#import <Foundation/Foundation.h>

@interface Enemy : NSObject {
   NSString * name;

   //stats
   int max_hp;
   int health;
   int strength;
   int mana;
   int max_mana;
   int intelligence;
   int speed;
   int value;
   int attack_type;
}
+ (instancetype) EnemyWithType: (int) t;
- (id) initWithName: (NSString *) n withHealth: (int) health withStr: (int) str withMana: (int) mana withIntel: (int) intel withSpeed: (int) speed withValue: (int) val withAttackType: (int) type;
- (NSString *) getName;
- (void) damage: (int) points;
- (int) attack;


@end
