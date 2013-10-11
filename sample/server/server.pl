#!/usr/bin/perl
use IO::Socket;
use Strict;

$sock = new IO::Socket::INET (
    LocalHost => '',
    LocalPort => '7071',
    Proto => 'tcp',
    Listen => 3,
    Reuse => 1
);
die "Could not create socket: $!\n" unless $sock;

my $client = $sock->accept();
open FILE, ">test" or die "Can't open: $!";
while (<$client>) {
    print FILE $_;
}
close FILE;

close($sock);

