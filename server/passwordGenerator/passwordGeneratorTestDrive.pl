#!/usr/bin/perl

use lib '../';
use strict;

use passwordGenerator::passwordGenerator;

my $password = passwordGenerator::passwordGenerator->new();

my $a = $password->generate();

print "$a\n";
