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
@property (readonly) NSString * name;
@property int max_hp;
@property int health;
@property int strength;
@property int mana;
@property int max_mana;
@property int intelligence;
@property int speed;
@property int value;
@property int attack_type;

+ (instancetype) EnemyWithType: (int) t;
- (id) initWithName: (NSString *) n withHealth: (int) _health withStr: (int) _str withMana: (int) _mana withIntel: (int) _intel withSpeed: (int) _speed withValue: (int) _val withAttackType: (int) _type;
- (void) damage: (int) points;
- (int) attack;


@end
