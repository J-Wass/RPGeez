# RPGeez
bad text-based rpg game I made to learn objective-c

#### Compiling
##### Debian, Ubuntu, etc
Download the GNU Objective-C Compiler: `sudo apt-get –y install gobjc gnustep gnustep-devel`

Compile: `gcc $(gnustep-config --objc-flags) -o RPGeez rpgeez.m player.m enemy.m $(gnustep-config --base-libs)`

##### macOS
Compile: `clang -framework Foundation rpgeez.m player.m enemy.m -o RPGeez`

##### Windows
Install GNUStep: http://wiki.gnustep.org/index.php/Installation_on_Windows

Compile: `gcc 'gnustep-config --objc-flags' -Wl, --no-as-needed -lgnustep-base -lobjc rpgeez.m player.m enemy.m -o RGeez`
##### Redhat based Linux
Install GNUStep via rpm: https://pkgs.org/download/gnustep-gui-devel

Compile: `gcc 'gnustep-config --objc-flags' -Wl, --no-as-needed -lgnustep-base -lobjc rpgeez.m player.m enemy.m -o RGeez`
