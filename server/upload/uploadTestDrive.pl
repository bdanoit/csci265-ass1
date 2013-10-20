#!/usr/bin/perl

use lib '../';
use strict;

use upload;


open(my $DATA1, "<file1.txt");

my $up = uploadTest->new("HI",$DATA1);

$up->upload();

if( $up->status() eq "successful")
{
   
   print "HI";
}


close($DATA1);
