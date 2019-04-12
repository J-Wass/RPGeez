#import <Foundation/Foundation.h>
#import "player.h"

const char* Player_Classes[] = {"Warrior", "Mage", "Thief", "Paladin", "Wizard", "Assassin"};
const char* Player_Locations[] = {"Town", "Arena", "Grasslands", "Desert", "Forest", "Mountains"};
typedef enum {Town, Arena, Grasslands, Desert, Forest, Mountains} location_codes;

int main (int argc, const char * argv[]){
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
      while ([pl getHP] > 0 && [pl getMedals] < 10){
        printf("\n\n");
        printf("You are currently in the %s...\n", (char *)Player_Locations[[pl getLocation]]);
        printf("What do you want to do?\n> ");
        char action[2000];
        fgets(action, 2000, stdin);
        char delim[] = " ";
        char * nextWord = strtok(action, delim);
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
        else if (strcmp(nextWord, "search") == 0 || (strcmp(nextWord, "s") == 0){
          switch([pl getLocation]){
            case Town:
              
          }
        }
      }
      [player_name release];
      [pl release];
      [pool release];
      return 0;
}
