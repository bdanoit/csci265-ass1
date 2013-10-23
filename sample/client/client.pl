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
my $username;
my $password;
my $upload;
my $download;
my $handle;

#Check arguments
while($args =~ /-([a-zA-Z]+)(?: +([^- ]+))?/g){
    my $switch = $1;
    my $value = $2;
    if($1 !~ /u|p|uf|df/){
        die "Invalid switch\n";
    }
    else{
        switch($switch){
            case "u" { $username = $value; }
            case "p" { $password = $value; }
            case "uf" { $upload = $value; }
            case "df" { $download = 1; }
        }
    }
    
}

#All variables required
if(!$upload && !$download){
    die "No type specified\n";
}
elsif(!$username){
    die "No username specified\n";
}
elsif(!$password){
    die "No password specified\n";
}

#Execute
else{
    if($upload){
        open $handle, $upload or die "File {$upload} could not be opened\n";
        my $lines = func::file->countLines($upload);
        print $server "$username|$password|UPLOAD|$lines\n";
        if($upload){
            while (<$handle>){
                print $server $_;
            }
        }
        close $handle;
    }
    else{
        print $server "$username|$password|DOWNLOAD|0\n";
    }
    
}
close($server);

