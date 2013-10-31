#!/usr/bin/perl

#libraries
use lib qw{../lib};

#modules
use strict;
use IO::Socket;
use func::file;
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
            my $user = user::user->new($request->user, $request->password);
            my $reply = reply::reply->new($client);
            switch($request->type){
                case 'UPLOAD'{
                    my $upload = saveFile::saveFile->new($user->username, $client, $request->lines);
                    print "\t$child> Upload started\n";
                    $upload->saveFileToDir();
                    $reply->send('SUCCESS');
                    #print $sock 'SUCCESS', "\n";
                    print "\t$child> Upload finished\n";
                }
                case 'DOWNLOAD'{
                    print "\t$child> DOWNLOAD STARTED\n";
                    my $retrieve = retrieveFile::retrieveFile->new($user->username, $client);
                    $reply->send('SUCCESS', $retrieve->getLineCount());
                    #print $sock 'SUCCESS|2', "\n";
                    $retrieve->retrieveFileFromDir();
                }
            }
        }
        catch{
            my $ex = $_;
            if(ref($ex) eq "exc::exception"){
                my $exc_name = $ex->get_exc_name();
                print "\t$child> $exc_name\n";
                print $client "ERROR|$exc_name";
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
