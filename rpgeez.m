#import <Foundation/Foundation.h>
#import "player.h"
#import "enemy.h"
#include <time.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <dirent.h>

//ignore mass warnings for unused scanf and fgets calls
#pragma GCC diagnostic ignored "-Wunused-result"
#pragma GCC diagnostic ignored "-Wunused-but-set-variable"

const char* Player_Classes[] = {"Warrior", "Mage", "Thief", "Paladin", "Wizard", "Assassin"};
const char* Player_Locations[] = {"Town", "Arena", "Grasslands", "Desert", "Forest", "Mountains"};
const char* Player_Abilities[] = {"None", "Slash", "Herotime", "Haymaker", "Heal", "Fireball", "Lifesteal", "Boom", "ManaGain", "Stab", "Misdirect", "Steal", "Assassinate"};
typedef enum {Town, Arena, Grasslands, Desert, Forest, Mountains} location_codes;
typedef enum {Common_Lynx, Sand_Elemental, Rock_Golem, Wood_Elf, Ent, Phoenix, Griffin, Great_Griffin, Champion_Aaron, General_Zweihander, Mercenary_Jill, Rosier, Mistake} monster_codes;
typedef enum {None, Slash, Herotime, Haymaker, Heal, Fireball, Lifesteal, Boom, ManaGain, Stab, Misdirect, Steal, Assassinate} ability_codes;
const int player_manaCosts[] = {0, 0, 0, 0, 5, 0, 5, 13, 0, 0, 0, 0, 0};
const int max_casts[] = {0, 1000, 2, 2, 2, 1000, 4, 6, 2, 1000, 2, 2, 1};
int casts[] = {0, 1000, 2, 2, 2, 1000, 3, 4, 2, 1000, 2, 2, 1};

const char* Weapon_Adjectives[] = {"Fiery ", "Unnecessary ", "Gluten Free ", "Big ", "Unstoppable ", "Great ", "Heavy ", "Silver "};
const char* Weapon_Types[] = {"Spear", "Staff", "Sword", "Trident", "Crossbow", "Sling", "Lance", "Flail"};
const char* Armor_Adjectives[] = {"Rock ", "Obsidian ", "Meteor ", "Dragon ", "Immovable ", "Overachieving ", "Heavy ", "Silver "};
const char* Armor_Types[] = {"Plate Armor", "Chainmail", "Kite Shield", "Buckler", "Square Shield", "Wraps", "Headband", "Training Weights"};

int file_exist (char *filename){
  struct stat buffer;
  return (stat (filename, &buffer) == 0);
}

int load(Player * pl, char path[]){
  FILE * fp = fopen(path,"r");
  char line [128];
  int i = 0;
  while(fgets(line, sizeof(line), fp) != NULL){
     switch(i){
       case 0:{
         //checking for newline at end, remove if found
         char lastLetter = line[strlen(line) - 1];
         if(lastLetter == 10){
           line[strlen(line) - 1] = 0;
         }
         pl.name = [NSString stringWithUTF8String:line];
         break;
       }
       case 1:{
         pl.level = atoi(line);
         break;
       }
       case 2:{
         pl.xp_cap = atoi(line);
         break;
       }
       case 3:{
         pl.xp = atoi(line);
         break;
       }
       case 4:{
         pl.class = atoi(line);
         break;
       }
       case 5:{
         pl.location = atoi(line);
         break;
       }
       case 6:{
         pl.medals = atoi(line);
         break;
       }
       case 7:{
         pl.max_hp = atoi(line);
         break;
       }
       case 8:{
         pl.health = atoi(line);
         break;
       }
       case 9:{
         pl.max_str = atoi(line);
         break;
       }
       case 10:{
         pl.strength = atoi(line);
         break;
       }
       case 11:{
         pl.max_mana = atoi(line);
         break;
       }
       case 12:{
         pl.mana = atoi(line);
         break;
       }
       case 13:{
         pl.max_int = atoi(line);
         break;
       }
       case 14:{
         pl.intelligence = atoi(line);
         break;
       }
       case 15:{
         pl.max_speed = atoi(line);
         break;
       }
       case 16:{
         pl.speed = atoi(line);
         break;
       }
       case 17:{
         pl.gold = atoi(line);
         break;
       }
       case 18:{
         pl.weapon_name = [NSString stringWithUTF8String:line];
         break;
       }
       case 19:{
         pl.armor_name = [NSString stringWithUTF8String:line];
         break;
       }
       case 20:{
         pl.defense = atoi(line);
         break;
       }
       case 21:{
         pl.extra_str = atoi(line);
         break;
       }
       case 22:{
         pl.extra_intel = atoi(line);
         break;
       }
       case 23:{
         [pl.abilities replaceObjectAtIndex: 0 withObject: [NSNumber numberWithInteger:atoi(line)]];
         break;
       }
       case 24:{
         [pl.abilities replaceObjectAtIndex: 1 withObject: [NSNumber numberWithInteger:atoi(line)]];
         break;
       }
       case 25:{
         [pl.abilities replaceObjectAtIndex: 2 withObject: [NSNumber numberWithInteger:atoi(line)]];
         break;
       }
       case 26:{
         [pl.abilities replaceObjectAtIndex: 3 withObject: [NSNumber numberWithInteger:atoi(line)]];
         break;
       }
       default:{
         break;
       }
     }
     i++;
  }
  return 0;
}

int print_saves(){
  DIR *d;
  struct dirent *dir;
  d = opendir("saves");
  if(!d){
    mkdir("saves", 0777);
  }
  while((dir = readdir(d)) != NULL){
      if(strcmp(dir->d_name,".") != 0 && strcmp(dir->d_name,"..") != 0){
        printf("\t%s\n", dir->d_name);
      }
  }
  closedir(d);
  printf("\n\n");
  return 0;
}

int main (int argc, const char * argv[]){
      NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
      srand(time(NULL)); //setup randomness seed
      //set up initial game variables
      char name[20];
      char class_name[10];
      Player * pl = [Player PlayerWithName:@"Default" andClass: 0];

      //setup current store items
      NSMutableString * current_weapon_name = [NSMutableString stringWithUTF8String:Weapon_Adjectives[rand() % 8]];
      [current_weapon_name appendString: [NSString stringWithUTF8String:Weapon_Types[rand() % 8]]];
      int current_weapon_str = rand() % 2 + 2;
      int current_weapon_int = rand() % 2 + 2;

      NSMutableString * current_armor_name = [NSMutableString stringWithUTF8String:Armor_Adjectives[rand() % 8]];
      [current_armor_name appendString: [NSString stringWithUTF8String:Armor_Types[rand() % 8]]];
      int current_armor_defense = rand() % 2 + 2;

      char load_or_new[20] = "none";
      while(strcmp(load_or_new, "load") != 0 && strcmp(load_or_new, "new") != 0){
        printf("Welcome to RPGeez. Load game or new game? Type \"load\" or \"new\".\n> ");
        fgets(load_or_new,20,stdin);
        //checking for newline at end, remove if found
        char lastLetter = load_or_new[strlen(load_or_new) - 1];
        if(lastLetter == 10){
          load_or_new[strlen(load_or_new) - 1] = 0;
        }
      }
      if(strcmp(load_or_new, "load") == 0){
        char file[20] = "none";
        char path[1000] = "none";
        strcat(path, "saves/");
        strcat(path, file);
        while(!file_exist(path)){
          memset(path, 0, 255);
          printf("Valid saves: \n");
          print_saves();
          printf("Choose a save...\n> ");
          fgets(file, 20, stdin);
          //checking for newline at end
          char lastLetter = file[strlen(file) - 1];
          if(lastLetter == 10){
            file[strlen(file) - 1] = 0;
          }
          strcat(path, "saves/");
          strcat(path, file);
        }
        load(pl, path);
      }
      else if(strcmp(load_or_new, "new") == 0){
        //get name and class
        puts("What name will you be known as?");
        fgets(name,20,stdin);
        int i = 0;
        for(; i < strlen(name); i++){
          if(name[i] == ' '){
            name[i] = '_';
          }
        }
        printf("What is your profession?\nType a number 1-3.\n");
        printf("\t[1] Warrior\n\t[2] Mage\n\t[3] Thief\n> ");
        fgets(class_name, 10, stdin);
        int class = atoi(class_name);
        class--;
        //keep going until user requests a usable class
        while (class < 0 || class > 2){
          puts("Please type a number 1-3 to select a class.");
          fgets(class_name, 10, stdin);
          class = atoi(class_name);
        }
        //build player object
        strtok(name, "\n");
        NSString * player_name = [NSString stringWithUTF8String:name];
        //remove the player object that was made for loading, create new player
        [pl release];
        pl = [Player PlayerWithName:player_name andClass: class];
        pl.location = Town;
      }

      printf("\nWelcome %s the %s to RPGeez.\n", [pl.name UTF8String], Player_Classes[pl.class]);
      printf("::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::\n\n");
      printf("Type \"help\" for a list of available actions.\n\n");

      //main game loop
      short in_battle = 0;
      Enemy * enemy;
      while ([pl health] > 0 && [pl medals] < 10){
        while(in_battle){
          //gain 1 mana per turn in battle
          if(pl.mana < pl.max_mana){
            pl.mana++;
          }
          //print stats
          printf("\n----------------------------------------\n");
          printf("|Your Stats\t%s's Stats\n",[[enemy name] UTF8String]);
          printf("|---------\t-----------\n");
          printf("|HP %d/%d\tHP %d/%d\n",[pl health],[pl max_hp],[enemy health],[enemy max_hp]);
          printf("|MP %d/%d\n", [pl mana],[pl max_mana]);
          printf("|STR:%d  \tSTR:%d \n", [pl strength], [enemy strength]);
          printf("|INT:%d  \tINT:%d \n", [pl intelligence], [enemy intelligence]);
          printf("|SPD:%d  \tSPD:%d \n", [pl speed], [enemy speed]);
          printf("----------------------------------------\n\n");

          //ask for user attack
          int attack = -1;
          while(attack != [[pl.abilities objectAtIndex: 0] intValue] && attack != [[pl.abilities objectAtIndex: 1] intValue] && attack != [[pl.abilities objectAtIndex: 2] intValue] && attack != [[pl.abilities objectAtIndex: 3] intValue]){
            printf("Type a number 1-4 to use an ability.\n");
            printf("Valid abilities: \n");
            int i = 1;
            for(NSNumber * ability in pl.abilities){
              if([ability intValue] != None){
                printf("   [%d]  %s  (costs %d MP, %d casts left)\n", i, Player_Abilities[[ability intValue]], player_manaCosts[[ability intValue]], casts[[ability intValue]]);
              }
              i++;
            }
            printf("> ");
            int choice = -1;
            scanf("%d", &choice);
            choice -= 1;
            getchar(); //grab the trailing newline from stdin... its weird i know
            if (choice >= 0 && choice <= 3){
              if ([[pl.abilities objectAtIndex: choice] intValue] != None){
                attack = [[pl.abilities objectAtIndex: choice] intValue];
                if(casts[attack] <= 0){
                  attack = -1;
                  printf("You are out of casts for that move!\n");
                }
                if (player_manaCosts[attack] > pl.mana){
                  attack = -1;
                  printf("You don't have the mana for that!\n");
                }
              }
            }
          }

          //determine who can attack based on speed
          int attacker = rand() % (enemy.speed + pl.speed);
          if(attacker < pl.speed){
            //attack with chosen ability
            int damage = [pl attackWithAbility:attack atEnemy:enemy];
            if(damage == 0){
              printf("Did no damage to %s...\n", [enemy.name UTF8String]);
            }
            else{
              printf("\nHit %s for %d!\n", [enemy.name UTF8String], damage);
            }
            //use up a cast for the ability
            casts[attack]--;
            [enemy damage:damage];
          }
          else{
            int damage = [enemy attackWithDefense: pl.defense];
            [pl damage:damage];
            printf("You were hit for %d!\n", damage);
          }
          if(pl.health <= 0){
            printf("You are dead.\n");
            in_battle = 0;
            exit(0);
          }
          if(enemy.health <= 0){
            int gold = enemy.value + rand() % 5;
            int xp = enemy.value + rand() % 10;
            printf("Defeated %s. Gained %d xp and %d gold.\n\n", [enemy.name UTF8String], xp, gold);
            //reset health and casts
            int i = 0;
            for(; i < sizeof(casts)/sizeof(casts[0]); i++){
              casts[i] = max_casts[i];
            }
            if(pl.health > pl.max_hp){
              pl.health = pl.max_hp;
            }
            //if player just won at the arena
            if(enemy.monster_id >= Great_Griffin){
              pl.medals += 1;
              printf("Gained a medal!\n");

              //update current store items
              current_weapon_name = [NSString stringWithUTF8String:Weapon_Adjectives[rand() % 8]];
              [current_weapon_name appendString: [NSString stringWithUTF8String:Weapon_Types[rand() % 8]]];
              current_weapon_str = rand() % (pl.medals * 2) + 5 + pl.medals * 3;
              current_weapon_int = rand() % (pl.medals * 2) + 5 + pl.medals * 3;

              current_armor_name = [NSString stringWithUTF8String:Armor_Adjectives[rand() % 8]];
              [current_armor_name appendString: [NSString stringWithUTF8String:Armor_Types[rand() % 8]]];
              current_armor_defense = rand() % (pl.medals * 2) + 5 + pl.medals * 3;
              if(pl.medals >=5){
                printf("\n\nCongratulations! You have beaten RPGeez!!!\nYou can continue fighting at the arena or buying items, but the main game has ended.\n");
              }
            }
            [pl awardXP: xp];
            [pl resetStats];
            in_battle = 0;
            pl.gold += gold;
            [enemy release];
            continue;
          }
        }

        printf("\n\n");
        printf("You are currently in the %s...\n", (char *)Player_Locations[pl.location]);
        switch(pl.location){
          case Grasslands:
            printf("This area is recommended for all levels.\n");
            break;
          case Desert:
            printf("This area is recommended for levels 5+.\n");
            if(pl.level < 5){
              printf("Warning: You are only level %d!\n", pl.level);
            }
            break;
          case Forest:
            printf("This area is recommended for levels 10+.\n");
            if(pl.level < 10){
              printf("Warning: You are only level %d!\n", pl.level);
            }
            break;
          case Mountains:
            printf("This area is recommended for levels 15+.\n");
            if(pl.level < 15){
              printf("Warning: You are only level %d!\n", pl.level);
            }
            break;
          default:
            break;
        }
        printf("What do you want to do?\n> ");
        char action[2000];
        fgets(action, 2000, stdin);
        char delim[] = " ";
        char * nextWord = strtok(action, delim);
        char lastLetter = nextWord[strlen(nextWord) - 1];
        //checking for newline
        if(lastLetter == 10){
          nextWord[strlen(nextWord) - 1] = 0;
        }
        printf("\n\n");

        if (strcmp(nextWord, "help") == 0){
          printf("\n\nValid actions:\n");
          printf("\t go north/east/south/west\n");
          printf("\t search (shortcut: s)\n");
          printf("\t equipment\n");
          printf("\t abilities\n");
          printf("\t status\n");
          printf("\t map\n");
          printf("\t save\n");
          printf("\t load [player name]\n");
          printf("Only valid in town:\n");
          printf("\t buy\n");
          printf("\t inn\n");
          printf("\t arena\n");
          printf("Only valid in the arena:\n");
          printf("\t challenge\n");
          printf("\t bet\n");
        }
        else if (strcmp(nextWord, "go") == 0){
          char * dir = strtok(NULL, delim);
          char * direction = strtok(dir, "\n"); //remove trailing newline from input
          //                Grasslands = 2
          //
          // Mountains = 5   Town = 0 (Arena=1)     Desert = 3
          //
          //                  Forest = 4
          switch (pl.location){
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
          switch(pl.location){
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
                if(found_monster < 60){
                  enemy = [Enemy EnemyWithType:Rock_Golem];
                  printf("Rock Golem encountered!\n");
                }
                else{
                  enemy = [Enemy EnemyWithType:Sand_Elemental];
                  printf("Sand Elemental encountered!\n");
                }
                in_battle = 1;
              }
              else{
                printf("Didn't find much...\n");
              }
              break;
            case Forest:
              found_monster = rand() % 100;
              if(found_monster > 40){
                if(found_monster < 60){
                  enemy = [Enemy EnemyWithType:Ent];
                  printf("Ent encountered!\n");
                }
                else{
                  enemy = [Enemy EnemyWithType:Wood_Elf];
                  printf("Wood Elf encountered!\n");
                }
                in_battle = 1;
              }
              else{
                printf("Didn't find much...\n");
              }
              break;
            case Mountains:
              found_monster = rand() % 100;
              if(found_monster > 40){
                if(found_monster < 60){
                  enemy = [Enemy EnemyWithType:Griffin];
                  printf("Griffin encountered!\n");
                }
                else{
                  enemy = [Enemy EnemyWithType:Phoenix];
                  printf("Phoenix encountered!\n");
                }
              }
              else{
                printf("Didn't find much...\n");
              }
              in_battle = 1;
              break;
            default:
              break;
          }
        }
        else if (strcmp(nextWord, "status") == 0){
          [pl printStatus];
        }
        else if (strcmp(nextWord, "inn") == 0){
          if(pl.location != Town){
            printf("There's no inn here! Better go back to the nearest town.\n");
            continue;
          }
          printf("The room's mostly held together with stains but its got a warm bed.\nCosts 100 gold.\ntype \"y\" or \"n\"\n> ");
          if(pl.gold < 100){
            printf("Sorry, try the streets friend... (not enough gold)\n");
            continue;
          }
          int dumb_new_line_that_i_have_to_get_first;
          scanf("%d", &dumb_new_line_that_i_have_to_get_first);
          char decision = getchar();
          if(decision == 'y'){
            pl.gold -= 100;
            pl.health = pl.max_hp;
            printf("\n*Fully Rested*\n\n");
          }
        }
        else if (strcmp(nextWord, "arena") == 0){
          if(pl.location == Town){
            pl.location = Arena;
          }
          else if (pl.location == Arena){
            printf("You're already in the arena!\n");

          }
          else{
            printf("You must be in the town to travel to the arena!\n");
          }
        }
        else if (strcmp(nextWord, "challenge") == 0){
          if(pl.location != Arena){
            printf("You can only challenge at the arena in town!\n");
          }
          else{
            switch(pl.medals){
              case 0:
                in_battle = 1;
                enemy = [Enemy EnemyWithType:Great_Griffin];
                printf("Great Griffin encountered at the arena!\n");
                break;
              case 1:
                in_battle = 1;
                enemy = [Enemy EnemyWithType:Champion_Aaron];
                printf("Champion Aaron encountered at the arena!\n");
                break;
              case 2:
                in_battle = 1;
                enemy = [Enemy EnemyWithType:General_Zweihander];
                printf("General Zweihander encountered at the arena!\n");
                break;
              case 3:
                in_battle = 1;
                enemy = [Enemy EnemyWithType:Mercenary_Jill];
                printf("Jill the mercenary encountered at the arena!\n");
                break;
              case 4:
                in_battle = 1;
                enemy = [Enemy EnemyWithType:Rosier];
                printf("Rosier the risen encountered at the arena!\n");
                break;
              default:
                in_battle = 1;
                enemy = [Enemy EnemyWithType:Mistake];
                enemy.health *= pl.medals;
                enemy.strength *= pl.medals;
                enemy.intelligence *= pl.medals;
                enemy.speed *= pl.medals;
                enemy.value *= pl.medals;
                printf("m̶̟̓ỉ̵̪s̵͈̈t̵̺̋ã̵̳k̸͎͑ḙ̶̿ ̶̼͝è̵̱x̷̻͌ĩ̷̲s̷̰͝t̸̥̽s̵̟͌\n");
            }
          }
        }
        else if (strcmp(nextWord, "buy") == 0){
          if(pl.location != Town){
            printf("There's no store here! Better go back to the nearest town.\n");
            continue;
          }
          printf("Hit harder or get hit harder? \nType \"w\" for weapons, \"a\" for armor, or anything else to leave.\n> ");
          int cost = (pl.medals + 1) * 1000;
          if(pl.gold < cost){
            printf("Sorry, you'll need more gold... (not enough gold)\n");
            continue;
          }
          int decision = getchar();
          int newline = getchar();
          if(decision == 'w'){
            printf("The %s offers %d strength and %d intelligence. Thoughts?\n", [current_weapon_name UTF8String], current_weapon_str, current_weapon_int);
            printf("Costs %d gold.\nType \"b\" to buy.\n> ", cost);
            int buy = getchar();
            newline = getchar();
            if(buy == 'b'){
              printf("Sounds like a deal!\n");
              pl.gold -= cost;
              pl.extra_str = current_weapon_str;
              pl.extra_intel = current_weapon_int;
              pl.weapon_name = current_weapon_name;
            }
            else{
              printf("Another time then...\n");
            }
          }else if(decision == 'a'){
            printf("\nThe %s offers %d defense. Thoughts?\n", [current_armor_name UTF8String], current_armor_defense);
            printf("Costs %d gold.\nType \"b\" to buy.\n> ", cost);
            int buy = getchar();
            newline = getchar();
            if(buy == 'b'){
              printf("Sounds like a deal!\n");
              pl.gold -= cost;
              pl.defense = current_armor_defense;
              pl.armor_name = current_armor_name;
            }
            else{
              printf("Another time then...\n");
            }
          }
        }
        else if (strcmp(nextWord, "equipment") == 0){
          [pl printEquipment];
        }
        else if (strcmp(nextWord, "abilities") == 0){
          [pl printAbilities];
        }
        else if (strcmp(nextWord, "save") == 0){
          char filename[1000] = { };
          strcat(filename, "saves/");
          strcat(filename, [pl.name UTF8String]);
          FILE * fp = fopen(filename,"w+");
          fprintf(fp, "%s\n", [pl.name UTF8String]);
          fprintf(fp, "%d\n", pl.level);
          fprintf(fp, "%d\n", pl.xp_cap);
          fprintf(fp, "%d\n", pl.xp);
          fprintf(fp, "%d\n", pl.class);
          fprintf(fp, "%d\n", pl.location);
          fprintf(fp, "%d\n", pl.medals);
          fprintf(fp, "%d\n", pl.max_hp);
          fprintf(fp, "%d\n", pl.health);
          fprintf(fp, "%d\n", pl.max_str);
          fprintf(fp, "%d\n", pl.strength);
          fprintf(fp, "%d\n", pl.max_mana);
          fprintf(fp, "%d\n", pl.mana);
          fprintf(fp, "%d\n", pl.max_int);
          fprintf(fp, "%d\n", pl.intelligence);
          fprintf(fp, "%d\n", pl.max_speed);
          fprintf(fp, "%d\n", pl.speed);
          fprintf(fp, "%d\n", pl.gold);
          fprintf(fp, "%s\n", [pl.weapon_name UTF8String]);
          fprintf(fp, "%s\n", [pl.armor_name UTF8String]);
          fprintf(fp, "%d\n", pl.defense);
          fprintf(fp, "%d\n", pl.extra_str);
          fprintf(fp, "%d\n", pl.extra_intel);
          fprintf(fp, "%d\n", [[pl.abilities objectAtIndex: 0] intValue]);
          fprintf(fp, "%d\n", [[pl.abilities objectAtIndex: 1] intValue]);
          fprintf(fp, "%d\n", [[pl.abilities objectAtIndex: 2] intValue]);
          fprintf(fp, "%d\n", [[pl.abilities objectAtIndex: 3] intValue]);
          fclose(fp);
          printf("Save file written. Type \"load %s\" to load this save in the future.\n", [pl.name UTF8String]);
        }
        else if (strcmp(nextWord, "load") == 0){
          //dont read this code block its not good
          char * dir = strtok(NULL, delim);
          char * file = strtok(dir, "\n"); //remove trailing newline from input
          char path[1000] = { };
          strcat(path, "saves/");
          strcat(path, file);
          if(file_exist(path)){
            load(pl, path);
          }
          else{
            printf("Can't find the save file \"%s\"\nCheck your spelling!\n", file);
            printf("Valid saves:\n");
            print_saves();
          }
        }
      }
      [pl.name release];
      [pl release];
      [pool release];
      return 0;
}
