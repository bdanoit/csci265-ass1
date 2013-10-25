#!/usr/bin/perl

#libraries
use lib qw{../lib};

#modules
use IO::Socket;
use strict;
use func::file;
use exc::exception;
use Try::Tiny;
use user::user2;
use savefile::savefile;
use download::download;
use Switch;

my $sock = new IO::Socket::INET (
    LocalHost => '',
    LocalPort => '9337',
    Proto => 'tcp',
    Listen => 3,
    Reuse => 1
);
die "could_not_create_socket" unless $sock;

my $child = 0;
while (my $client = $sock->accept()) {
    print "Request Accepted on Parent\n";
    $child++;
    my $pid = fork();
    if($pid == 0){
        my $request = <$client>;
        print "Request Forked to Child ($child)\n";
        if($request =~ /^([^\|]+)\|([^\|]+)\|([^\|]+)(?:\|([^\|]+))\n$/){
            my $user = $1;
            my $password = $2;
            my $type = $3;
            my $lines = $4;
            try{
                $user = user::user2->new($user, $password);
                switch($type){
                    case 'UPLOAD'{
                        my $upload = savefile::savefile->new($user->name, $client, $lines);
                        $upload->savefileToDir();
                    }
                    case 'DOWNLOAD'{
                        #my $download = download::download->new($user->name, $client);
                        #$download->upload();
                        print "\t$child> Not implemented yet";
                    }
                }
            }
            catch{
                my $ex = $_;
                if(ref($ex) eq "exc::exception"){
                    my $exc_name = $ex->get_exc_name();
                    print "\t$child> $exc_name\n";
                }
                else{
                    print "\t$child> Unknown Exception: $ex\n";
                }
            };
        }
        else{
            print "\t$child> Invalid Request: $request";
        }
        print "\t$child> Request Complete\n";
        exit(0);
    }
    else{
        
    }
}
close($sock);
