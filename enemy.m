#import <Foundation/Foundation.h>
#import "enemy.h"
#include <stdlib.h>

typedef enum {Common_Lynx, Sand_Elemental, Rock_Golem, Wood_Elf, Ent, Phoenix, Griffin} monster_codes;
const int attack_types[] = {0, 1, 0, 1, 0, 2, 2};

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

+ (instancetype) EnemyWithType: (int) t{
  switch(t){
    case Common_Lynx:
    {
      int health = rand() % 10 + 10;
      int str = rand() % 2 + 1;
      int intelligence = 1;
      int speed = rand() % 2 + 1;
      NSString * n = @"Common Lynx";
      int value = 100;
      int type = attack_types[t];
      Enemy * e = [[Enemy alloc] initWithName: n withHealth: health withStr: str withIntel: intelligence withSpeed: speed withValue: value withAttackType: type];
      return e;
      break;
    }
    case Sand_Elemental:
    {
      int health = rand() % 10 + 10;
      int str = 1;
      int intelligence = 2;
      int speed = rand() % 3 + 2;
      NSString * n = @"Sand Elemental";
      int value = 200;
      int type = attack_types[t];
      Enemy * e = [[Enemy alloc] initWithName: n withHealth: health withStr: str withIntel: intelligence withSpeed: speed withValue: value withAttackType: type];
      return e;
      break;
    }
    case Rock_Golem:
    {
      int health = rand() % 10 + 30;
      int str = 3;
      int intelligence = 1;
      int speed = rand() % 2 + 2;
      NSString * n = @"Rock Golem";
      int value = 250;
      int type = attack_types[t];
      Enemy * e = [[Enemy alloc] initWithName: n withHealth: health withStr: str withIntel: intelligence withSpeed: speed withValue: value withAttackType: type];
      return e;
      break;
    }
    case Wood_Elf:
    {
      int health = rand() % 10 + 25;
      int str = 1;
      int intelligence = 8;
      int speed = rand() % 3 + 5;
      NSString * n = @"Wood Elf";
      int value = 350;
      int type = attack_types[t];
      Enemy * e = [[Enemy alloc] initWithName: n withHealth: health withStr: str withIntel: intelligence withSpeed: speed withValue: value withAttackType: type];
      return e;
      break;
    }
    case Ent:
    {
      int health = rand() % 10 + 50;
      int str = 15;
      int intelligence = 1;
      int speed = rand() % 3 + 4;
      NSString * n = @"Ent";
      int value = 500;
      int type = attack_types[t];
      Enemy * e = [[Enemy alloc] initWithName: n withHealth: health withStr: str withIntel: intelligence withSpeed: speed withValue: value withAttackType: type];
      return e;
      break;
    }
    case Phoenix:
    {
      int health = rand() % 10 + 100;
      int str = 10;
      int intelligence = 20;
      int speed = rand() % 3 + 25;
      NSString * n = @"Phoenix";
      int value = 1000;
      int type = attack_types[t];
      Enemy * e = [[Enemy alloc] initWithName: n withHealth: health withStr: str withIntel: intelligence withSpeed: speed withValue: value withAttackType: type];
      return e;
      break;
    }
    case Griffin:
    {
      int health = rand() % 10 + 150;
      int str = 25;
      int intelligence = 10;
      int speed = rand() % 3 + 20;
      NSString * n = @"Griffin";
      int value = 1200;
      int type = attack_types[t];
      Enemy * e = [[Enemy alloc] initWithName: n withHealth: health withStr: str withIntel: intelligence withSpeed: speed withValue: value withAttackType: type];
      return e;
      break;
    }
    default:
    {
      int _health = rand() % 10 + 10;
      int _str = rand() % 2 + 1;
      int _intelligence = 1;
      int _speed = rand() % 2 + 1;
      NSString * _n = @"Common Lynx";
      int _value = 100;
      int _type = attack_types[Common_Lynx];
      Enemy * _e = [[Enemy alloc] initWithName: _n withHealth: _health withStr: _str withIntel: _intelligence withSpeed: _speed withValue: _value withAttackType: _type];
      return _e;
      break;
    }
  }
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
