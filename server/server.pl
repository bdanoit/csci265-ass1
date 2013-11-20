#!/usr/bin/perl
#FSYS Server
#Baleze Danoit, CSCI 265

#libraries
use lib qw{../lib};

#modules
use strict;
use IO::Socket;
use exc::exception;
use Try::Tiny;
use user::user;
use saveFile::saveFile;
use retrieveFile::retrieveFile;
use parse::request;
use reply::reply;
use Switch;

my $sock = new IO::Socket::INET (
    LocalHost => '',
    LocalPort => '9339',
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
        my $query = <$client>;
        chop $query;
        print "Request Forked to Child ($child)\n";
        try{
            my $request = parse::request->new();
            print "\t$child> $query\n";
            $request->parse($query);
            my $user = user::user->new($request->user, $request->password);
            my $reply = reply::reply->new($client);
            switch($request->type){
                case 'UPLOAD'{
                    my $upload = saveFile::saveFile->new($user->username, $client, $request->lines, $request->checksum);
                    print "\t$child> Upload started\n";
                    $upload->saveFileToDir();
                    $reply->send();
                    print "\t$child> Upload finished\n";
                }
                case 'DOWNLOAD'{
                    print "\t$child> Retrieve started\n";
                    my $retrieve = retrieveFile::retrieveFile->new($user->username, $client);
                    $reply->send($retrieve->getLineCount, $retrieve->md5_checksum);
                    $retrieve->retrieveFileFromDir();
                    print "\t$child> Retrieve sent\n";
                }
            }
        }
        catch{
            my $ex = $_;
            if(ref($ex) eq "exc::exception"){
                my $exc_name = $ex->get_exc_name();
                print "\t$child> $exc_name\n";
                print $client "ERROR|$exc_name\n";
            }
            else{
                print "\t$child> Unknown Exception: $ex\n";
            }
        };
        print "\t$child> Request Complete\n";
        exit(0);
    }
    else{
        
    }
}
close($sock);
