#!/usr/bin/perl
use lib '../../lib';
use IO::Socket;
use Switch;
use strict;
use func::file;
use exc::exception;

$SIG{__DIE__} = sub{
    my $err = shift @_;
    #print $err;
};


my $server = IO::Socket::INET->new(
    PeerAddr => 'localhost',
    PeerPort => 1337,
    Proto    => 'tcp'
);

die "Could not create socket: $!\n" unless $server;

#Command line arguments
my $args = join(' ', @ARGV);

#Store variables
my $file;
my $username;
my $password;

#Check arguments
while($args =~ /-([a-zA-Z]+)(?: +([^- ]+))?/g){
    my $switch = $1;
    my $value = $2;
    if($1 !~ /f|u|p/){
        die "Invalid switch\n";
    }
    else{
        switch($switch){
            case "f" { $file = $value; }
            case "u" { $username = $value; }
            case "p" { $password = $value; }
        }
    }
    
}

#All variables required
if(!$file){
    die "No file specified\n";
}
elsif(!$username){
    die "No username specified\n";
}
elsif(!$password){
    die "No password specified\n";
}

#Execute
else{
    open FILE, $file or die "File {$file} could not be opened\n";
    my $lines = func::file->countLines($file);
    print $server "$username|$password|$lines\n";
    while (<FILE>){
        print $server $_;
    }
    close FILE;
    print $server "|EOF|";
}
