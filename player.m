#import <Foundation/Foundation.h>
#import "player.h"
#include <stdlib.h>

const char* Classes[] = {"Warrior", "Mage", "Thief", "Paladin", "Wizard", "Assassin"};
typedef enum {Warrior, Mage, Thief, Paladin, Sorcerer, Assassin} class_codes;

const char* Locations[] = {"Town", "Arena", "Grasslands", "Desert", "Forest", "Mountains"};
typedef enum {Town, Arena, Grasslands, Desert, Forest, Mountains} location_codes;

const char* Abilities[] = {"None", "Slash", "Herotime", "Haymaker", "Heal", "Fireball", "Lifesteal", "Boom", "ManaGain", "Stab", "Misdirect", "Steal", "Assassinate"};
typedef enum {None, Slash, Herotime, Haymaker, Heal, Fireball, Lifesteal, Boom, ManaGain, Stab, Misdirect, Steal, Assassinate} ability_codes;
const int manaCosts[] = {0, 0, 0, 0, 5, 0, 5, 13, 0, 0, 0, 0, 0};

@implementation Player
@synthesize name;
@synthesize level;
@synthesize xp_cap;
@synthesize xp;
@synthesize class;
@synthesize location;
@synthesize medals;
@synthesize max_hp;
@synthesize health;
//custom health setter to not allow healing above max hp
- (void) setHealth: (int) newHP{
    health += newHP;
    if(health > max_hp){
      health = max_hp;
    }
}
@synthesize max_str;
@synthesize strength;
@synthesize max_mana;
@synthesize mana;
@synthesize max_int;
@synthesize intelligence;
@synthesize max_speed;
@synthesize speed;
@synthesize abilities;
@synthesize gold;
@synthesize weapon_name;
@synthesize armor_name;
@synthesize defense;
@synthesize extra_str;
@synthesize extra_intel;

+ (instancetype) PlayerWithName: (NSString *) n andClass: (int) cls{
    Player * p = [[Player alloc] initWithName:n andClass: cls];
    return p;
}
- (id) initWithName: (NSString *) n andClass: (int) c{
    self = [super init];
    self->name = n;
    self->class = c;
    self->xp_cap = 100;
    self->xp = 0;
    self->level = 1;
    self.gold = 1000;
    self.defense = 0;
    self.extra_str = 0;
    self.extra_intel = 0;
    self.weapon_name = @"Nothing";
    self.armor_name = @"Nothing";
    switch(c){
      case Warrior:
        self->max_str = 6;
        self->strength = 6;
        self->max_mana = 1;
        self->mana = 1;
        self->max_int = 1;
        self->intelligence = 1;
        self->max_speed = 4;
        self->speed = 4;
        break;
      case Mage:
        self->max_str = 1;
        self->strength = 1;
        self->max_mana = 5;
        self->mana = 5;
        self->max_int = 5;
        self->intelligence = 5;
        self->max_speed = 1;
        self->speed = 1;
        break;
      case Thief:
        self->max_str = 4;
        self->strength = 4;
        self->max_mana = 1;
        self->mana = 1;
        self->max_int = 1;
        self->intelligence = 1;
        self->max_speed = 6;
        self->speed = 6;
        break;
      default:
        break;
    }
    self->max_hp = 100;
    self->health = 100;

    //setup initial abilities for each class
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
    self->abilities = tempAbilities;
    return self;
}
- (void) damage: (int) points{
    self = [super init];
    self->health -= points;
}
- (int) attackWithAbility: (int) ability atEnemy: (Enemy *) enemy{
    self = [super init];
    int damage = 0;
    self.mana -= manaCosts[ability];
    switch (ability){
      case Slash:
        damage = self.strength + self.extra_str + rand() % 5;
        break;
      case Herotime:;
        int added_str = rand() % 6 + 5;
        printf("Increased strength by %d.\n", added_str);
        self.strength += added_str;
        break;
      case Haymaker:
        self.health -= rand() % 6 + 5;
        damage = self.strength + self.extra_str * 2 + rand() % 5;
      case Heal:
        self.health += rand() % 20 + 5;
      case Fireball:
        damage = self.intelligence + extra_intel + rand() % 5;
        break;
      case Lifesteal:;
        int steal = self.intelligence + extra_intel + rand() % 5;
        self.health += steal;
        damage = steal;
        break;
      case Boom:
        damage = self.intelligence + extra_intel + rand() % 50;
        break;
      case ManaGain:
        self.mana += rand() % 10 + 10;
        break;
      case Stab:
        damage = self.strength + self.extra_str + rand() % 5;
        break;
      case Misdirect:
        printf("Lowered %s's speed.\n", [enemy.name UTF8String]);
        enemy.speed -= (rand() % 3 + 1);
        break;
      case Steal:
        printf("Increased loot from %s\n", [enemy.name UTF8String]);
        enemy.value += (int)(enemy.value * 1 / 4);
        self.health -= 10;
        break;
      case Assassinate:
        self.speed /= 2;
        damage = self.speed + self.strength + self.extra_str + rand() % 50;
        break;
      default:
        return 0;
        break;
    }
    //chance of critical hit based on relative speeds
    int speedDifference = self.speed - enemy.speed;
    if(speedDifference > 0 && damage != 0){
      int critChance = 2 * speedDifference;
      int roll = rand() % 100 + 1;
      //don't have above a 50% chance of a crit
      if(critChance > 50){
        critChance = 50;
      }
      if(roll < critChance){
        printf("Critical hit!\n");
        damage *= 2;
      }
    }
    return damage;
}
- (void) awardXP: (int) _xp{
    self = [super init];
    self.xp += _xp;
    if (self.xp >= self.xp_cap){
      int hp1 = self.max_hp;
      int mana1 = self.max_mana;
      int str1 = self.max_str;
      int int1 = self.max_int;
      int speed1 = self.max_speed;
      printf("You have gained a new level!\n");
      [self levelUp];
      self.health = self.max_hp;
      int hp2 = self.max_hp;
      int mana2 = self.max_mana;
      int str2 = self.max_str;
      int int2 = self.max_int;
      int speed2 = self.max_speed;
      printf("Max HP: %d -> %d\n", hp1, hp2);
      printf("Max Mana: %d -> %d\n", mana1, mana2);
      printf("Max Strength: %d -> %d\n", str1, str2);
      printf("Max Intelligence: %d -> %d\n", int1, int2);
      printf("Max Speed: %d -> %d\n", speed1, speed2);
    }
}
- (void) resetStats{
    self = [super init];
    self.strength = self.max_str;
    self.speed = self.max_speed;
    self.intelligence = self.max_int;
    self.mana = self.max_mana;
}
- (void) printStatus{
    self = [super init];
    printf("--------------\n");
    printf("|%s - Level %d (XP %d/%d)\n", Classes[self.class], self.level, self.xp, self.xp_cap);
    printf("|HP %d/%d\n",self.health, self.max_hp);
    printf("|MP %d/%d\n", self.mana, self.max_mana);
    printf("|---------\n");
    printf("|STR:%d\n", self.strength);
    printf("|INT:%d\n", self.intelligence);
    printf("|SPD:%d\n", self.speed);
    printf("|Gold: %d\n", self.gold);
    printf("--------------\n");
}
- (void) printEquipment{
    self = [super init];
    printf("---------------------------------------------\n");
    printf("|Weapon: %s \t(+%d strength, +%d intelligence)\n",[self.weapon_name UTF8String], self.extra_str, self.extra_intel);
    printf("|Armor: %s \t(+%d defense)\n", [self.armor_name UTF8String], self.defense);
    printf("---------------------------------------------\n");
}
- (void) levelUp{
    self = [super init];
    if(self.xp >= self.xp_cap){
        self.xp = self.xp % self.xp_cap;
        self.xp_cap *= 2;
        self.level += 1;
        if(self.level == 10){
          switch(self.class){
            case Warrior:
              self.class = Paladin;
              [self.abilities replaceObjectAtIndex: 3 withObject: [NSNumber numberWithInteger:Heal]];
              printf("Class Advance - Welcome %s the Paladin!\n", [self.name UTF8String]);
              printf("Learned new ability: %s\n", Abilities[Heal]);
              break;
            case Mage:
              self.class = Sorcerer;
              [self.abilities replaceObjectAtIndex: 3 withObject: [NSNumber numberWithInteger:ManaGain]];
              printf("Class Advance - Welcome %s the Sorcerer!\n", [self.name UTF8String]);
              printf("Learned new ability: %s\n", Abilities[ManaGain]);
              break;
            case Thief:
              self.class = Assassin;
              [self.abilities replaceObjectAtIndex: 3 withObject: [NSNumber numberWithInteger:Assassinate]];
              printf("Class Advance - Welcome %s the Assassin!\n", [self.name UTF8String]);
              printf("Learned new ability: %s\n", Abilities[Assassinate]);
              break;
            default:
              break;
          }
        }
        switch(self.class){
          case Warrior:
            if(self.level == 2){
              [self.abilities replaceObjectAtIndex: 1 withObject: [NSNumber numberWithInteger:Herotime]];
              printf("Learned new ability: %s\n", Abilities[Herotime]);
            }
            if(self.level == 5){
              [self.abilities replaceObjectAtIndex: 2 withObject: [NSNumber numberWithInteger:Haymaker]];
              printf("Learned new ability: %s\n", Abilities[Haymaker]);
            }
            self.max_str += rand() % 3 + 1;
            self.max_speed += rand() % 2;
            self.max_hp += rand() % 2 + 1;
            break;
          case Mage:
            if(self.level == 2){
              [self.abilities replaceObjectAtIndex: 1 withObject: [NSNumber numberWithInteger:Lifesteal]];
              printf("Learned new ability: %s\n", Abilities[Lifesteal]);
            }
            if(self.level == 5){
              [self.abilities replaceObjectAtIndex: 2 withObject: [NSNumber numberWithInteger:Boom]];
              printf("Learned new ability: %s\n", Abilities[Boom]);
            }
            self.max_int += rand() % 3 + 1;
            self.max_speed += rand() % 2;
            self.max_mana += rand() % 2 + 1;
            self.max_hp += rand() % 2;
            break;
          case Thief:
            if(self.level == 2){
              [self.abilities replaceObjectAtIndex: 1 withObject: [NSNumber numberWithInteger:Misdirect]];
              printf("Learned new ability: %s\n", Abilities[Misdirect]);
            }
            if(self.level == 5){
              [self.abilities replaceObjectAtIndex: 2 withObject: [NSNumber numberWithInteger:Steal]];
              printf("Learned new ability: %s\n", Abilities[Steal]);
            }
            self.max_str += rand() % 2 + 1;
            self.max_speed += rand() % 3 + 1;
            self.max_hp += rand() % 2;
            break;
          case Paladin:
            self.max_str += rand() % 3 + 1;
            self.max_speed += rand() % 2;
            self.max_hp += rand() % 2 + 1;
            self.max_mana += rand() % 2 + 1;
            break;
          case Sorcerer:
            self.max_int += rand() % 3 + 1;
            self.max_speed += rand() % 2;
            self.max_mana += rand() % 3 + 1;
            self.max_hp += rand() % 2 + 1;
            break;
          case Assassin:
            self.max_str += rand() % 3 + 1;
            self.max_speed += rand() % 4 + 1;
            self.max_hp += rand() % 2 + 1;
            break;
          default:
            break;
          }
        }
    }
- (void) equipWeapon: (NSString *) weaponname withStr: (int) str withIntel: (int) intel{
  self = [super init];
  self.weapon_name = weaponname;
  self.extra_str = str;
  self.extra_intel = intel;
}
- (void) equipArmor: (NSString *) armorname withDefense: (int) def{
  self = [super init];
  self.armor_name = armorname;
  self.defense = def;
}
@end
