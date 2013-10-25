#!/usr/bin/perl
use strict;
use warnings;

use lib '../';
use lib '../lib/';

use strict;
use warnings;
use Try::Tiny;
use parseClientRequest::parse;
use send::request;
use exc::exception;

my $parameters = join(' ', @ARGV);


try
{
    #Validate user Request
    my $userRequest = parseClientRequest::parse->new();
    $userRequest->parseString($parameters);
    my $UserName = $userRequest->UserName;
    my $UserPassword = $userRequest->Password;
    my $Request = $userRequest->Request;
    my $FileName = $userRequest->FileName;
    #Format and send Request
    my $request = parseClientRequest::request->new($UserName,$UserPassword,$Request,$FileName);
    if($request->sendRequest()){
        print "Your request was sent\n";
    }
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