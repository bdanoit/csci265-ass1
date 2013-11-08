#!/usr/bin/perl
#FSYS Admin
#Baleze Danoit, CSCI 265

#libraries
use lib '../lib';
use lib '../server';

#modules
use strict;
use warnings;
use parse::params;
use storage::storage;
use generate::password;
use exc::exception;
use Try::Tiny;
use Switch;

#parse parameters
my $args = join(' ', @ARGV);
my $command;
my $user;
try{
    my $params = parse::params->new();
    my $db = storage::storage->new();
    my $password = generate::password->new();
    $params->parse($args);
    $command = $params->command;
    $user = $params->user;
    switch($command){
        case 'create'{
            $db->addUser($user);
            print "User {$user} added\n";
        };
        case 'addpw'{
            my @passwords;
            for(my $i = 0; $i < 6; $i++){
                push @passwords, $password->generate();
            }
            $db->addPasswordsByUser($user, \@passwords);
            print "Passwords added for {$user}\n";
            foreach my $password (@passwords){
                print "\t$password\n";
            }
        };
        case 'clean'{
            $db->deletePasswordsByUser($user);
            print "All passwords removed for {$user}\n";
        };
        case 'delete'{
            $db->deleteUser($user);
            print "Deleted {$user}\n";
        };
        case 'listpw'{
            my @passwords;
            $db->passwordsByUser($user, \@passwords);
            print "Passwords for {$user}\n";
            foreach my $password (@passwords){
                print "\t$password\n";
            }
        };
    };
}
catch{
    my $ex = $_;
    if(ref($ex) eq "exc::exception"){
        print "Exception: {".$ex->get_exc_name()."}\n";
    }
    else{ print $ex;}
};
