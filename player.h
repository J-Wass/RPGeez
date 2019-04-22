#import <Foundation/Foundation.h>
#import "enemy.h"

@interface Player : NSObject {
    NSString * name;
    int level;
    int xp_cap;
    int xp;
    int class;
    int location;
    int medals;
    int gold;

    //stats
    int max_hp;
    int health;
    int max_str;
    int strength;
    int max_mana;
    int mana;
    int max_int;
    int intelligence;
    int max_speed;
    int speed;

    //items
    NSString * weapon_name;
    NSString * armor_name;
    int defense;
    int extra_str;
    int extra_intel;

    NSMutableArray * abilities;
}
@property (assign) NSString * name;
@property int level;
@property int xp_cap;
@property int xp;
@property int class;
@property int location;
@property int medals;
@property int max_hp;
@property int health;
@property int max_str;
@property int strength;
@property int max_mana;
@property int mana;
@property int max_int;
@property int intelligence;
@property int max_speed;
@property int speed;
@property int gold;
@property (assign) NSString * weapon_name;
@property (assign) NSString * armor_name;
@property int defense;
@property int extra_str;
@property int extra_intel;
@property (nonatomic, retain) NSMutableArray * abilities;

+ (instancetype) PlayerWithName: (NSString *) name andClass: (int) cls;
- (id) initWithName: (NSString *) name andClass: (int) cls;
- (void) damage: (int) points;
- (int) attackWithAbility: (int) ability atEnemy: (Enemy *) enemy;
- (void) awardXP: (int) xp;
- (void) levelUp;
- (void) printStatus;
- (void) resetStats;
- (void) equipWeapon: (NSString *) weaponname withStr: (int) str withIntel: (int) intel;
- (void) equipArmor: (NSString *) armorname withDefense: (int) def;
- (void) printEquipment;
- (void) printEquipment;
- (void) printAbilities;
@end
