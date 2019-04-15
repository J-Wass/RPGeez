#import <Foundation/Foundation.h>
#import "enemy.h"
#include <stdlib.h>

typedef enum {Common_Lynx, Sand_Elemental, Rock_Golem, Wood_Elf, Ent, Phoenix, Griffin, Great_Griffin, Champion_Aaron, General_Zweihander, Mercenary_Jill, Rosier, Mistake} monster_codes;
const int attack_types[] = {0, 1, 0, 1, 0, 2, 2, 2, 1, 1, 1, 2, 2};

@implementation Enemy
@synthesize name;
@synthesize max_hp;
@synthesize health;
@synthesize max_str;
@synthesize strength;
@synthesize max_int;
@synthesize intelligence;
@synthesize max_speed;
@synthesize speed;
//custum health setter to not allow speed to drop too low
- (void) setSpeed: (int) newSpeed{
    speed += newSpeed;
    if(speed < 1){
      speed = 1;
    }
}
@synthesize value;
@synthesize attack_type;
@synthesize monster_id;

+ (instancetype) EnemyWithType: (int) t{
  int health;
  int str;
  int intelligence;
  int speed;
  NSString * n;
  int value;
  int type;

  switch(t){
    case Common_Lynx:
      health = rand() % 10 + 10;
      str = rand() % 2 + 1;
      intelligence = 1;
      speed = rand() % 2 + 1;
      n = @"Common Lynx";
      value = 100;
      type = attack_types[t];
      break;
    case Sand_Elemental:
      health = rand() % 10 + 10;
      str = 1;
      intelligence = 2;
      speed = rand() % 3 + 2;
      n = @"Sand Elemental";
      value = 200;
      type = attack_types[t];
      break;
    case Rock_Golem:
      health = rand() % 10 + 30;
      str = 3;
      intelligence = 1;
      speed = rand() % 2 + 2;
      n = @"Rock Golem";
      value = 250;
      type = attack_types[t];
      break;
    case Wood_Elf:
      health = rand() % 10 + 25;
      str = 1;
      intelligence = 8;
      speed = rand() % 3 + 5;
      n = @"Wood Elf";
      value = 350;
      type = attack_types[t];
      break;
    case Ent:
      health = rand() % 10 + 50;
      str = 15;
      intelligence = 1;
      speed = rand() % 3 + 4;
      n = @"Ent";
      value = 500;
      type = attack_types[t];
      break;
    case Phoenix:
      health = rand() % 10 + 100;
      str = 10;
      intelligence = 20;
      speed = rand() % 3 + 25;
      n = @"Phoenix";
      value = 1000;
      type = attack_types[t];
      break;
    case Griffin:
      health = rand() % 10 + 150;
      str = 25;
      intelligence = 10;
      speed = rand() % 3 + 20;
      n = @"Griffin";
      value = 1200;
      type = attack_types[t];
      break;
      case Great_Griffin:
        health = rand() % 10 + 190;
        str = 30;
        intelligence = 15;
        speed = rand() % 3 + 20;
        n = @"Great Griffin";
        value = 1200;
        type = attack_types[t];
        break;
    case Champion_Aaron:
       health = rand() % 10 + 200;
       str = 50;
       intelligence = 1;
       speed = rand() % 3 + 20;
       n = @"Champion Aaron";
       value = 2000;
      type = attack_types[t];
      break;
    case General_Zweihander:
       health = rand() % 10 + 300;
       str = 75;
       intelligence = 1;
       speed = rand() % 3 + 25;
       n = @"General Zweihander";
       value = 4000;
       type = attack_types[t];
      break;
    case Mercenary_Jill:
       health = rand() % 10 + 250;
       str = 60;
       intelligence = 1;
       speed = rand() % 3 + 40;
       n = @"Jill the Mercenary";
       value = 5000;
       type = attack_types[t];
      break;
    case Rosier:
       health = rand() % 10 + 500;
       str = 50;
       intelligence = 50;
       speed = rand() % 3 + 50;
       n = @"Rosier the Risen";
       value = 10000;
       type = attack_types[t];
      break;
    case Mistake:
      health = rand() % 10 + 100;
      str = 10;
      intelligence = 10;
      speed = rand() % 3 + 10;
      n = @"m̶̟̓ỉ̵̪s̵͈̈t̵̺̋ã̵̳k̸͎͑e̶̿";
      value = 10000;
      type = attack_types[t];
      break;
    default:
      health = rand() % 10 + 10;
      str = rand() % 2 + 1;
      intelligence = 1;
      speed = rand() % 2 + 1;
      n = @"Common Lynx";
      value = 100;
      type = attack_types[Common_Lynx];
      break;
  }
  Enemy * e = [[Enemy alloc] initWithName: n withHealth: health withStr: str withIntel: intelligence withSpeed: speed withValue: value withAttackType: type];
  e.monster_id = t;
  return e;
}
- (id) initWithName: (NSString *) n withHealth: (int) _health withStr: (int) _str withIntel: (int) _intel withSpeed: (int) _speed withValue: (int) _val withAttackType: (int) _type{
  self = [super init];
  self->name = n;
  self->max_hp = _health;
  self->health = _health;
  self->strength = _str;
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
