#import <Foundation/Foundation.h>
#import "enemy.h"
#include <stdlib.h>

typedef enum {Common_Lynx, Sand_Elemental, Rock_Golem, Wood_Elf, Dark_Elf, Griffin, Phoenix} monster_codes;
const int attack_types[] = {0, 1, 0, 1, 1, 2, 2};

@implementation Enemy
@synthesize name;
@synthesize max_hp;
@synthesize health;
@synthesize strength;
@synthesize mana;
@synthesize max_mana;
@synthesize intelligence;
@synthesize speed;
@synthesize value;
@synthesize attack_type;
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
    default:;
      int _health = rand() % 10 + 10;
      int _str = rand() % 2 + 1;
      int _mana = 1;
      int _intelligence = 1;
      int _speed = rand() % 2 + 1;
      NSString * _n = @"Common Lynx";
      int _value = 5;
      int _type = attack_types[t];
      Enemy * _e = [[Enemy alloc] initWithName: _n withHealth: _health withStr: _str withMana: _mana withIntel: _intelligence withSpeed: _speed withValue: _value withAttackType: _type];
      return _e;
      break;
  }
}
- (id) initWithName: (NSString *) n withHealth: (int) _health withStr: (int) _str withMana: (int) _mana withIntel: (int) _intel withSpeed: (int) _speed withValue: (int) _val withAttackType: (int) _type{
  self = [super init];
  self->name = n;
  self->max_hp = _health;
  self->health = _health;
  self->strength = _str;
  self->max_mana = _mana;
  self->mana = _mana;
  self->intelligence = _intel;
  self->speed = _speed;
  self->value = _val;
  self->attack_type = _type;
  return self;
}
- (void) damage: (int) points{
    self = [super init];
    self->health -= points;
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
        return rand() % 5 + self->strength;
        break;
    }
  }
@end
