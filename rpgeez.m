#import <Foundation/Foundation.h>
#import "player.h"
#import "enemy.h"
#include <time.h>
#include <stdlib.h>

const char* Player_Classes[] = {"Warrior", "Mage", "Thief", "Paladin", "Wizard", "Assassin"};
const char* Player_Locations[] = {"Town", "Arena", "Grasslands", "Desert", "Forest", "Mountains"};
const char* Player_Abilities[] = {"None", "Slash", "Parry", "Disarm", "Heal", "Fireball", "Lifesteal", "Boom", "ManaGain", "Stab", "Knife", "Poison", "Assassinate"};
typedef enum {Town, Arena, Grasslands, Desert, Forest, Mountains} location_codes;
typedef enum {Common_Lynx, Sand_Elemental, Rock_Golem, Wood_Elf, Dark_Elf, Griffin, Phoenix} monster_codes;
typedef enum {None, Slash, Parry, Disarm, Heal, Fireball, Lifesteal, Boom, ManaGain, Stab, Knife, Poison, Assassinate} ability_codes;
const int player_manaCosts[] = {0, 0, 0, 0, 5, 0, 10, 30, 0, 0, 0, 0, 0};

int main (int argc, const char * argv[]){
      srand(time(NULL)); //setup randomness seed
      NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
      //set up initial game variables
      char name[20];
      char class_name[10];

      //get name and class
      puts("What name will you be known as?");
      fgets(name,20,stdin);
      puts("What is your profession? (warrior = 0, mage = 1, thief = 2)");
      fgets(class_name, 10, stdin);
      int class = atoi(class_name);
      //keep going until user requests a usable class
      while (class < 0 || class > 2){
        puts("I didn't understand that... What is your profession? (warrior = 0, mage = 1, thief = 2)");
        fgets(class_name, 10, stdin);
        class = atoi(class_name);
      }
      //build player object
      strtok(name, "\n");
      NSString * player_name = [NSString stringWithUTF8String:name];
      Player * pl = [Player PlayerWithName:player_name andClass: class];
      [pl setLocation:0]; //location 0 is Town

      printf("\nWelcome %s the %s to RPGeez.\n", [[pl getName] UTF8String], [pl getClass]);
      printf("::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::\n\n");
      printf("Type \"help\" for a list of available actions.\n\n");

      //main game loop
      short in_battle = 0;
      Enemy * enemy;
      while ([pl getHP] > 0 && [pl getMedals] < 10){
        while(in_battle){
          //print stats
          printf("----------------------------------------\n");
          printf("|HP %d/%d                 HP %d/%d\n",pl->health,pl->max_hp,enemy->health,enemy->max_hp);
          printf("|MP %d/%d                 MP %d/%d\n", pl->mana,pl->max_mana,enemy->mana,enemy->max_mana);
          printf("|Your Stats              %s's Stats\n",[enemy->name UTF8String]);
          printf("|---------               -----------\n");
          printf("|STR:%d                   STR:%d \n", pl->strength, enemy->strength);
          printf("|INT:%d                   INT:%d \n", pl->intelligence, enemy->intelligence);
          printf("|SPD:%d                   SPD:%d \n", pl->speed, enemy->speed);
          printf("----------------------------------------\n\n");

          //ask for user attack
          int attack = -1;
          while(attack != pl->abilities[0] && attack != pl->abilities[1] && attack != pl->abilities[2] && attack != pl->abilities[3]){
            printf("Valid abilities: \n");
            int i = 0;
            for(i = 0; i < 4; i++){
              if(pl->abilities[i] != None){
                printf("\t %s (%d MP) = type \"%d\" to use... \n", Player_Abilities[pl->abilities[i]], player_manaCosts[i], i);
              }
            }
            printf("> ");
            char choice_str[2] = "00";
            memset(choice_str, 0, sizeof(choice_str));
            gets(choice_str);
            int choice = atoi(choice_str);
            if (choice >= 0 && choice <= 3){
              if (pl->abilities[choice] != None){
                attack = pl->abilities[choice];
              }
            }
          }

          //determine who can attack based on speed
          int attacker = rand() % (enemy->speed + pl->speed);
          if(attacker < pl->speed){
            //attack with chosen ability
            int damage = [pl attackWithAbility:attack];
            printf("\nHit %s for %d\n", [enemy->name UTF8String], damage);
            [enemy damage:damage];
          }
          else{
            int damage = [enemy attack];
            [pl damage:damage];
            printf("You were hit for %d. (You were too slow to attack before the %s did!)\n", damage, [enemy->name UTF8String]);
          }
          if(pl->health <= 0){
            printf("You are dead.");
            in_battle = 0;
          }
          if(enemy->health <= 0){
            int gold = enemy->value + rand() % 5;
            int xp = enemy->value + rand() % 10;
            printf("Defeated %s. Gained %d xp and %d gold.\n", [enemy->name UTF8String], xp, gold);
            in_battle = 0;
          }
        }

        printf("\n\n");
        printf("You are currently in the %s...\n", (char *)Player_Locations[[pl getLocation]]);
        printf("What do you want to do?\n> ");
        char action[2000];
        fgets(action, 2000, stdin);
        char delim[] = " ";
        char * nextWord = strtok(action, delim);
        char lastLetter = nextWord[strlen(nextWord) - 1];
        if(lastLetter == 10){
          nextWord[strlen(nextWord) - 1] = 0;
        }
        printf("\n\n");

        if (strcmp(nextWord, "help") == 0){
          printf("\n\nValid actions:\n");
          printf("\t go north/east/south/west\n");
          printf("\t search (shortcut: s)\n");
          printf("\t where (shortcut: w)\n");
          printf("\t abilities\n");
          printf("\t status\n");
          printf("Only valid in town:\n");
          printf("\t sell\n");
          printf("\t heal\n");
          printf("\t arena\n");
          printf("Only valid in the arena:\n");
          printf("\t challenge\n");
          printf("\t bet\n");
          printf("Only valid in a battle:\n");
          printf("\t attack\n");
          printf("\t ability 1/2/3/4\n\n\n");
        }
        else if (strcmp(nextWord, "go") == 0){
          char * dir = strtok(NULL, delim);
          char * direction = strtok(dir, "\n"); //remove trailing newline from input
          //                Grasslands = 2
          //
          // Mountains = 5   Town = 0 (Arena=1)     Desert = 3
          //
          //                  Forest = 4
          switch ([pl getLocation]){
            case Town:
              if (strcmp(direction, "north") == 0){
                [pl setLocation:Grasslands];
              }
              if (strcmp(direction, "east") == 0){
                [pl setLocation:Desert];
              }
              if (strcmp(direction, "south") == 0){
                [pl setLocation:Forest];
              }
              if (strcmp(direction, "west") == 0){
                [pl setLocation:Mountains];
              }
              break;
            case Arena:
              [pl setLocation:Town];
              break;
            case Desert:
              if (strcmp(direction, "north") == 0){
                [pl setLocation:Grasslands];
              }
              if (strcmp(direction, "east") == 0){
                printf("There's a raging sandstorm, better go in a different direction...");
              }
              if (strcmp(direction, "south") == 0){
                [pl setLocation:Forest];
              }
              if (strcmp(direction, "west") == 0){
                [pl setLocation:Town];
              }
              break;
            case Grasslands:
              if (strcmp(direction, "north") == 0){
                printf("There's only tundra and ice up north, better go in a different direction...");
              }
              if (strcmp(direction, "east") == 0){
                [pl setLocation:Desert];
              }
              if (strcmp(direction, "south") == 0){
                [pl setLocation:Town];
              }
              if (strcmp(direction, "west") == 0){
                [pl setLocation:Mountains];
              }
              break;
            case Mountains:
              if (strcmp(direction, "north") == 0){
                [pl setLocation:Grasslands];
              }
              if (strcmp(direction, "east") == 0){
                [pl setLocation:Desert];
              }
              if (strcmp(direction, "south") == 0){
                [pl setLocation:Town];
              }
              if (strcmp(direction, "west") == 0){
                printf("The mountains get too steep if you go any further, better go in a different direction...");
              }
              break;
            case Forest:
              if (strcmp(direction, "north") == 0){
                [pl setLocation:Town];
              }
              if (strcmp(direction, "east") == 0){
                [pl setLocation:Desert];
              }
              if (strcmp(direction, "south") == 0){
                printf("The forest is uncharted this far south, better go in a different direction...");
              }
              if (strcmp(direction, "west") == 0){
                [pl setLocation:Mountains];
              }
              break;
            default:
              break;
          }
        }
        else if (strcmp(nextWord, "search") == 0 || strcmp(nextWord, "s") == 0){
          int found_monster = 0;
          switch([pl getLocation]){
            case Town:
              printf("There are no monsters to search for in the town...\n");
              break;
            case Arena:
              printf("There are no monsters to search for in the arena...\n");
              break;
            case Grasslands:
              found_monster = rand() % 100;
              if(found_monster > 40){
                in_battle = 1;
                enemy = [Enemy EnemyWithType:Common_Lynx];
                printf("Common Lynx encountered!\n");
              }
              else{
                printf("Didn't find much...\n");
              }
              break;
            case Desert:
              found_monster = rand() % 100;
              if(found_monster > 40){
                in_battle = 1;
                enemy = [Enemy EnemyWithType:Common_Lynx];
              }
              printf("Common Lynx encountered!\n");
              break;
            case Forest:
              found_monster = rand() % 100;
              if(found_monster > 40){
                in_battle = 1;
                enemy = [Enemy EnemyWithType:Common_Lynx];
              }
              printf("Common Lynx encountered!\n");
              break;
            case Mountains:
              found_monster = rand() % 100;
              if(found_monster > 40){
                in_battle = 1;
                enemy = [Enemy EnemyWithType:Common_Lynx];
              }
              printf("Common Lynx encountered!\n");
              break;
            default:
              break;
          }
        }
      }
      [player_name release];
      [pl release];
      [pool release];
      return 0;
}
