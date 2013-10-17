#!/usr/bin/perl

# Baleze Danoit
# CSCI 265

use strict;
use warnings;
use storage;

my $db = storage->new();
print $db->getUsers();
print $db->getPasswords();
print $db->getPasswordsByUser('Baleze');
