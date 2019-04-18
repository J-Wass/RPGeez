# RPGeez
bad text-based rpg game I made to learn objective-c

##### Compile
GNUStep (use the included makefile): `make`
Clang: `clang -framework Foundation RPGeez.m player.m enemy.m -o RPGeez`
GCC: `gcc 'gnustep-config --objc-flags' -Wl, --no-as-needed -lgnustep-base -lobjc RPGeez.m player.m enemy.m -o RGeez`
