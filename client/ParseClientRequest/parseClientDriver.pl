#!/usr/bin/perl
use strict;
use warnings;

use lib '../';

use ParseClientRequest::parse;

my $parameters = join(' ', @ARGV);
my %hash = ParseClientRequest::parse->parseString($parameters);

if ($hash {Valid} eq "Valid")
{
   print "\nHashed UserName is: ", $hash{ UserName }, "\n";
   print "Hashed Password is: ",$hash{ UserPassword }, "\n";
   print "Hashed File name is: ",$hash{ FileName }, "\n";
   print "Hashed  request is: ",$hash{ UpOrDown }, "\n";
}