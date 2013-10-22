#!/usr/bin/perl
use strict;
use warnings;

use lib '../';

use strict;
use warnings;
use Try::Tiny;
use parseClientRequest::parse;

my $parameters = join(' ', @ARGV);


try{
   my $userRequest = parseClientRequest::parse->new();
   $userRequest->parseString($parameters);
   my %validRequest = (
      UserName => $userRequest->UserName,
      UserPassword => $userRequest->Password,
      Request => $userRequest->Request,
      FileName => $userRequest->FileName,
      );
}   
catch{
   my $ex = $_;
   if(ref($ex) eq "exc::exception"){
      print "Exception: {".$ex->get_exc_name()."}\n";
   }
   else{ print $ex;}
};
