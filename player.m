#import <Foundation/Foundation.h>
#import "player.h"

const char* Classes[] = {"Warrior", "Mage", "Thief", "Paladin", "Wizard", "Assassin"};
const char* Locations[] = {"Town", "Arena", "Grasslands", "Desert", "Forest", "Mountains"};
typedef enum {Town, Arena, Grasslands, Desert, Forest, Mountains} location_codes;

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

    self->hp = 100;
    self->strength = 1;
    self->mana = 1;
    self->strength = 1;
    self->intelligence = 1;
    self->speed = 1;
  }
  return self;
}
- (void) damage: (double) points{
  self = [super init];
  self->hp -= points;
}

- (NSString *) getName{
  self = [super init];
  return self->name;
}

- (int) getLevel{
  self = [super init];
  return self->level;
}

- (double) getXP{
  self = [super init];
  return self->xp;
}

- (double) getHP{
  self = [super init];
  return self->hp;
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


@end
