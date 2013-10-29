#!/usr/bin/perl

#libraries
use lib qw{../lib};

#modules
use strict;
use IO::Socket;
use func::file;
use exc::exception;
use Try::Tiny;
use user::user2;
use saveFile::saveFile;
use retrieveFile::retrieveFile;
use parse::request;
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
        my $query = <$client>;
        print "Request Forked to Child ($child)\n";
        try{
            my $request = parse::request->new();
            print "\t$child> $query";
            $request->parse($query);
            my $user = user::user2->new($request->user, $request->password);
            switch($request->type){
                case 'UPLOAD'{
                    my $upload = saveFile::saveFile->new($user->name, $client, $request->lines);
                    $upload->saveFileToDir();
                }
                case 'DOWNLOAD'{
                    #my $download = retrieveFile::retrieveFile->new($user->name, $client);
                    #$download->retrieveFileFromDir();
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
        print "\t$child> Request Complete\n";
        exit(0);
    }
    else{
        
    }
}
close($sock);
