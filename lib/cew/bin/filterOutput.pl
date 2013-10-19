#!/usr/bin/perl

while (<>) {

   $line=$_;
   if ($line=~m/^__cew__/) {
      print $'; 
   } 
}
