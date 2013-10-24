#!/usr/bin/perl

#libraries
use lib qw{../lib};

#modules
use IO::Socket;
use strict;
use func::file;
use exc::exception;
use Try::Tiny;

my $sock = new IO::Socket::INET (
    LocalHost => '',
    LocalPort => '1337',
    Proto => 'tcp',
    Listen => 3,
    Reuse => 1
);
die exc::exception->new("could_not_create_socket") unless $sock;

while (my $client = $sock->accept()) {
    print ">Request Accepted on Parent\n";
    my $pid = fork();
    if($pid == 0){
        my $request = <$client>;
        print ">Request Forked to Child\n";
        if($request =~ /^([^\|]+)\|([^\|]+)\|([^\|]+)(?:\|([^\|]+))\n$/){
            my $username = $1;
            my $password = $2;
            my $type = $3;
            my $lines = $4;
            print "\tIncoming file from $username\n";
            open(my $handle, ">", "upload/$username") or die "Can't open: $!";
            while(defined(<$client>)){
                print $handle $_;
            }
            print "\tFile stored\n";
        }
        else{
            print "\tInvalid Request: $request";
        }
        print ">End Request\n";
        exit(0);
    }
    else{
        
    }
}

close($sock);
