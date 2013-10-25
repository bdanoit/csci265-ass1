#!/usr/bin/perl

use lib '../';
use strict;

use download;

my $down = download->new("HI");

if (open(my $file2, ">","download"))
{
   $down->downloadFile();
   if($down->status() eq "successful")
   {   
      my $file1 =  $down->getFile();
      while(<$file1>)
      {
         print $file2 $_;
      }
      close $file2;
      $down->downloadComplete();
   }
}
