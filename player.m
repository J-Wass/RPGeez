#import <Foundation/Foundation.h>
#import "player.h"
#include <stdlib.h>

const char* Classes[] = {"Warrior", "Mage", "Thief", "Paladin", "Wizard", "Assassin"};
typedef enum {Warrior, Mage, Thief, Paladin, Wizard, Assassin} class_codes;

const char* Locations[] = {"Town", "Arena", "Grasslands", "Desert", "Forest", "Mountains"};
typedef enum {Town, Arena, Grasslands, Desert, Forest, Mountains} location_codes;

const char* Abilities[] = {"None", "Slash", "Parry", "Disarm", "Heal", "Fireball", "Lifesteal", "Boom", "ManaGain", "Stab", "Knife", "Poison", "Assassinate"};
typedef enum {None, Slash, Haymaker, Disarm, Heal, Fireball, Lifesteal, Boom, ManaGain, Stab, Knife, Poison, Assassinate} ability_codes;
const int manaCosts[] = {0, 0, 0, 0, 5, 0, 10, 30, 0, 0, 0, 0, 0};

@implementation Player
@synthesize name;
@synthesize level;
@synthesize xp;
@synthesize class;
@synthesize location;
@synthesize medals;
@synthesize max_hp;
@synthesize health;
@synthesize strength;
@synthesize mana;
@synthesize max_mana;
@synthesize intelligence;
@synthesize speed;
@synthesize abilities;

+ (instancetype) PlayerWithName: (NSString *) n andClass: (int) cls{
  Player * p = [[Player alloc] initWithName:n andClass: cls];
  return p;
}
- (id) initWithName: (NSString *) n andClass: (int) c{
  self = [super init];
  self->name = n;
  self->class = c;
  self->xp = 0;
  self->level = 1;

  self->health = 100;
  self->max_hp = 100;
  self->strength = 3;
  self->mana = 3;
  self->max_mana = 3;
  self->intelligence = 3;
  self->speed = 2;

  //setup initial abilities for each class
  puts("switch");
  NSMutableArray *tempAbilities = [NSMutableArray array];
  switch(self->class){
    case Warrior:
      [tempAbilities addObject:[NSNumber numberWithInteger:Slash]];
      [tempAbilities addObject:[NSNumber numberWithInteger:None]];
      [tempAbilities addObject:[NSNumber numberWithInteger:None]];
      [tempAbilities addObject:[NSNumber numberWithInteger:None]];
      break;
    case Mage:
      [tempAbilities addObject:[NSNumber numberWithInteger:Fireball]];
      [tempAbilities addObject:[NSNumber numberWithInteger:None]];
      [tempAbilities addObject:[NSNumber numberWithInteger:None]];
      [tempAbilities addObject:[NSNumber numberWithInteger:None]];
      break;
    case Thief:
      [tempAbilities addObject:[NSNumber numberWithInteger:Stab]];
      [tempAbilities addObject:[NSNumber numberWithInteger:None]];
      [tempAbilities addObject:[NSNumber numberWithInteger:None]];
      [tempAbilities addObject:[NSNumber numberWithInteger:None]];
      break;
  }
  puts("ya?");
  self->abilities = tempAbilities;
  puts("ya.");
  return self;
}
- (void) damage: (int) points{
  self = [super init];
  self->health -= points;
}
- (int) attackWithAbility: (int) ability{
  self = [super init];
  switch (ability){
    case Slash:
      return self->strength + rand() % 5;
      break;
    default:
      return 0;
      break;
  }
}


@end
