use inc::Module::Install;    #libmodule-install-perl

name 'mbot-plugins-est-related';

abstract 'Mbot plugins related to Estonia';
author 'Marko Punnar <marko@aretaja.org>';
version '1.2';
license 'gpl';

requires 'XML::Smart';       # libxml-smart-perl
requires 'Mbot';             # no package

auto_install;
WriteAll;
