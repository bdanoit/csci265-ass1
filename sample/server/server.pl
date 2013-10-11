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
    my $request = <$client>;
    chop $request;
    if($request =~ /^([^\|]+)\|([^\|]+)$/){
        my $username = $1;
        my $password = $2;
        print "Incoming file from $username\n";
        open(my $handle, ">", "upload/$username") or die "Can't open: $!";
        while(<$client>){
            last if $_ eq "|EOF|";
            print $handle $_;
        }
        print "\tFile accepted\n";
        close $handle;
    }
}

close($sock);

