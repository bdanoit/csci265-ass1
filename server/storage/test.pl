#!/usr/bin/perl

# Baleze Danoit
# CSCI 265

use lib '../';
use strict;
use warnings;
use storage::storage;


my $ontheline;
open($ontheline, "| cat |") or die ("Not on the line");
print $ontheline "select * from users;\n";

while(<$ontheline>){
    print $_;
}

print $ontheline ".exit\n";
exit;


my $db = storage::storage->new();

print "PRINT PASSWORDS (SHOULD BE EMPTY)\n";
if($db->passwordsByUser('Baleze')){
    my $ref = $db->result();
    foreach(@{ $ref }){
        my $hash = $_;
        print "\t".$hash->{'password'}."\n";
    }
}

print "CREATE USER BALEZE\n";
print $db->error() unless $db->addUser('Baleze');
print $db->error() unless $db->addUser('Baleze');

print "PRINT USERS (SHOULD DISPLAY BALEZE)\n";
if($db->users()){
    my $ref = $db->result();
    foreach(@{ $ref }){
        my $hash = $_;
        print "\t".$hash->{'id'}."\n";
    }
}

my @passwords = ("pimp","shizzle","barmitzvah");
print $db->error() unless $db->addPasswordsByUser('Baleze', \@passwords);
print "CHECK IF PASSWORDS EXIST FOR BALEZE\n";
if($db->passwordsByUser('Baleze')){
    my $ref = $db->result();
    foreach(@{ $ref }){
        my $hash = $_;
        print "\t".$hash->{'password'}."\n";
    }
}

print "DELETE PASSWORD shizzle FROM BALEZE\n";
print $db->error() unless $db->deletePasswordByUser('Baleze', 'shizzle');
if($db->passwordsByUser('Baleze')){
    my $ref = $db->result();
    foreach(@{ $ref }){
        my $hash = $_;
        print "\t".$hash->{'password'}."\n";
    }
}

print "DELETE USER BALEZE\n";
print $db->error() unless $db->deleteUser('Baleze');

if($db->passwordsByUser('Baleze')){
    my $ref = $db->result();
    foreach(@{ $ref }){
        my $hash = $_;
        print "\t".$hash->{'password'}."\n";
    }
}

#print $db->error() unless $db->deletePasswordByUser('Baleze', '123456');

#print $db->error() unless $db->addPasswordsByUser('Kam', \@passwords);
