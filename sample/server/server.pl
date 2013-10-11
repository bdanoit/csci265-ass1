#!/usr/bin/perl
use IO::Socket;
use strict;

my $sock = new IO::Socket::INET (
    LocalHost => '',
    LocalPort => '1337',
    Proto => 'tcp',
    Listen => 3,
    Reuse => 1
);
die "Could not create socket: $!\n" unless $sock;

my $client = $sock->accept();
while ($client) {
    open FILE, ">test.txt" or die "Can't open: $!";
    while(<$client>){
        print FILE $_;
    }
    close FILE;
}

close($sock);

