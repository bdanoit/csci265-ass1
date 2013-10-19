#!/usr/bin/perl
#FSYS Admin

#libraries
use lib '../lib';
use lib '../server';

#modules
use strict;
use warnings;
use parse::params;
use storage::storage;
use Try::Tiny;
use Switch;

#parse parameters
my $args = join(' ', @ARGV);
my $command;
my $user;
try{
    my $params = parse::params->new();
    my $db = storage::storage->new();
    $params->parse($args);
    $command = $params->command();
    $user = $params->user();
    switch($command){
        case 'create'{
            $db->addUser($user);
            print "User {$user} added\n";
        };
        case 'addpw'{
            my @passwords = ('TestPass01','TestPass02','TestPass03');
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
    };
}
catch{
    my $ex = $_;
    if(ref($ex) eq "exc::exception"){
        print "Exception: {".$ex->get_exc_name()."}\n";
    }
    else{ print $ex;}
};