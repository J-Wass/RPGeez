# RPGeez
bad text-based rpg game I made to learn objective-c

#### Debian, Ubuntu, etc
Download the GNU Objective-C Compiler (GNUstep): `sudo apt-get –y install gobjc gnustep gnustep-devel`

Compile: `gcc $(gnustep-config --objc-flags) -o RPGeez rpgeez.m player.m enemy.m $(gnustep-config --base-libs)`

#### macOS
Compile: `clang -framework Foundation rpgeez.m player.m enemy.m -o RPGeez`

#### Redhat, Fedora, etc
Download the GNU Objective-C Compiler (GNUstep): https://pkgs.org/download/gnustep-gui-devel

Compile: ``gcc `gnustep-config --objc-flags` --no-see -lgnustep-base -lobjc rpgeez.m player.m enemy.m -o RGeez``

#### Windows
No fully supported or tested. You will need to install GNUStep MYSY System, GNUStep Core, and GNUStep Devel in that order to compile. Then, use the GNUstep shell from those installations to compile RPGeez.

Install GNUStep: http://www.gnustep.org/windows/installer.html
