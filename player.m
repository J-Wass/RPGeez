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
+ (instancetype) PlayerWithName: (NSString *) n andClass: (int) cls{
  Player * p = [[Player alloc] initWithName:n andClass: cls];
  return p;
}
- (id) initWithName: (NSString *) n andClass: (int) c{
  self = [super init];
  if (self){
    self->name = n;
    self->class = c;
    self->xp = 0;
    self->level = 1;

    self->health = 100;
    self->max_hp = 100;
    self->strength = 1;
    self->mana = 1;
    self->max_mana = 1;
    self->intelligence = 1;
    self->speed = 1;

    switch(self->class){
      case Warrior:
        self->abilities[0] = Slash;
        self->abilities[1] = None;
        self->abilities[2] = None;
        self->abilities[3] = None;
        break;
      case Mage:
        self->abilities[0] = Fireball;
        self->abilities[1] = None;
        self->abilities[2] = None;
        self->abilities[3] = None;
        break;
      case Thief:
        self->abilities[0] = Stab;
        self->abilities[1] = None;
        self->abilities[2] = None;
        self->abilities[3] = None;
        break;
    }
  }
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

- (int) getLevel{
  self = [super init];
  return self->level;
}

- (int) getXP{
  self = [super init];
  return self->xp;
}

- (int) getHP{
  self = [super init];
  return self->health;
}

- (char *) getClass{
  self = [super init];
  return (char *)Classes[self->class];
}

- (int) getLocation{
  self = [super init];
  return self->location;
}

- (void) setLocation: (int) loc{
  self = [super init];
  self->location = loc;
}

- (int) getMedals{
  self = [super init];
  return self->medals;
}

- (void) addMedal{
  self = [super init];
  self->medals += 1;
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
