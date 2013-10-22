#!/usr/bin/perl
#Justin Waterhouse CSCI 265
package ParseClientRequest::parse;

use strict;
use warnings;

$| = 1;


sub parseString{
   my $class = shift @_;
   my $string = shift @_;
   my $user = "No User";
   my $password = "No Pass";
   my $UpDown = "Empty";
   my $FileName = "Empty";
   #Grab all of the keys and values from switches
   while ($string =~ /-([A-Z]+)(?:([^-]+))/gi)
   {
      #User Name
      if (($1 eq "U")||($1 eq "u"))
      {
         if ($2)
         {
            $user = $2;
            #Remove White Space
            $user =~ s/^\s+|\s+$//g;
         }
      }
      #User Password
      elsif (($1 eq "P")||($1 eq "p"))
      {
         $password = $2;
         $password =~ s/^\s+|\s+$//g;

      }
      #Upload Or Download
      elsif (($1 eq "uf")||($1 eq "UF"))
      {
         $UpDown = "UPLOAD";
         $FileName = $2;
         $FileName =~ s/^\s+|\s+$//g;

      }
      elsif (($1 eq "df")||($1 eq "DF"))
      {
         $UpDown = "DOWNLOAD";
         $FileName = $2;
         $FileName =~ s/^\s+|\s+$//g;
      }
   }
   
   #Check if user Name is Alphabetic and Exists
   if (($user =~ /^[a-z]+$/i)&&($user ne "No User"))
   {
      print $user,": User Name is Alphabetic\n";
   
      #Check if password is AlphaNumeric and Exists
      if (($password =~ /^[a-z0-9]+$/i)&&($password ne "No Pass"))
      {
         print $password,": Password is Alphanumeric\n";
         if ($UpDown ne "Empty")
         {
            print "UP/DOWN Switch is: ", $UpDown, "\n";
            my %hash = (
               UserName => $user,
               UserPassword => $password,
               UpOrDown  => $UpDown,
               FileName => $FileName,
               Valid => "Valid",
            );
            return %hash;
         }
      }
	  else
	  {
         print "Error: Invalid Password Type\n"
	  }
   }
   else
   {
		print "Error: Invalid USERNAME\n";
   }
   my %hash = (
      Valid => "Invalid",
      );
   return %hash;
}