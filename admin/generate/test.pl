#!/usr/bin/perl

use lib '../';
use strict;

use generate::password;

my $password = generate::password->new();

my $a = $password->generate();

print "$a\n";
