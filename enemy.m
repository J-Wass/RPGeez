#import <Foundation/Foundation.h>
#import "enemy.h"
#include <stdlib.h>

typedef enum {Common_Lynx, Sand_Elemental, Rock_Golem, Wood_Elf, Dark_Elf, Griffin, Phoenix} monster_codes;
const int attack_types[] = {0, 1, 0, 1, 1, 2, 2};

@implementation Enemy
+ (instancetype) EnemyWithType: (int) t{
  switch(t){
    case Common_Lynx:;
      int health = rand() % 10 + 10;
      int str = rand() % 2 + 1;
      int mana = 1;
      int intelligence = 1;
      int speed = rand() % 2 + 1;
      NSString * n = @"Common Lynx";
      int value = 5;
      int type = attack_types[t];
      Enemy * e = [[Enemy alloc] initWithName: n withHealth: health withStr: str withMana: mana withIntel: intelligence withSpeed: speed withValue: value withAttackType: type];
      return e;
      break;
    default:
      break;
  }
  Enemy * e;
  return e;
}
- (id) initWithName: (NSString *) n withHealth: (int) health withStr: (int) str withMana: (int) mana withIntel: (int) intel withSpeed: (int) speed withValue: (int) val withAttackType: (int) type{
  self = [super init];
  self->name = n;
  self->max_hp = health;
  self->health = health;
  self->strength = str;
  self->max_mana = mana;
  self->mana = mana;
  self->intelligence = intel;
  self->speed = speed;
  self->value = val;
  self->attack_type = type;
  return self;
}
- (void) damage: (int) points{
    self = [super init];
    self->health -= points;
}

- (NSString *) getName{
    self = [super init];
    return self->name;
  }

- (int) attack{
    self = [super init];
    switch(self->attack_type){
      case 0:
        return rand() % 5 + self->strength;
        break;
      case 1:
        return rand() % 5 + self->intelligence;
        break;
      case 2:
        return rand() % 5 + self->strength + self->intelligence;
        break;
      default:
        break;
    }
  }
@end
