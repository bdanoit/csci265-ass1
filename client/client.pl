#!/usr/bin/perl
use strict;
use warnings;

use lib '../';
use lib '../lib/';

use strict;
use warnings;
use Switch;
use Try::Tiny;
use parseClientRequest::parse;
use send::request;
use response::response;
use exc::exception;
use IO::Socket;

my $parameters = join(' ', @ARGV);


try
{
    my $sock = new IO::Socket::INET (
        PeerAddr => 'localhost',
        PeerPort => '9337',
        Proto => 'tcp'
    );
    die exc::exception->new('cannot_connect_to_server') unless $sock;
   
    #Validate user Request
    my $userRequest = parseClientRequest::parse->new();
    $userRequest->parseString($parameters);
    my $UserName = $userRequest->UserName;
    my $UserPassword = $userRequest->Password;
    my $Request = $userRequest->Request;
    my $FileName = $userRequest->FileName;
    
    #Format and send Request
    my $request = send::request->new($UserName,$UserPassword,$Request,$FileName);
    $request->sendRequest($sock);
    
    #Receive response
    my $response = response::response->new($sock);
    switch($Request){
        case 'UPLOAD'{
            $response->process();
        }
        case 'DOWNLOAD'{
            $response->process($FileName);
        }
    }
    my $message = $response->message();
    print $message if defined($message);
    
}
catch
{
    my $ex = $_;
    if(ref($ex) eq "exc::exception")
    {
        print "Exception: {".$ex->get_exc_name()."}\n";
    }
    else{ print $ex;}
};
