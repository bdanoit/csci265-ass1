#!/usr/bin/perl
package retrieveFile;
use strict

sub new
{
   $class = shift @_;
   $username = shift @_;
   $socket = shift @_;

   if(defined($username)) {}
   else
   {
      die exc::exception -> new("no_username_provided");
   };

   if(defined($socket)) {}
   else
   {
      die exc::exception -> new("no_socket_provided");
   };

   $self = {
         username => $username,
         socketVar => $socket
           };

   bless($self, $class);
   return($self);
}

sub retrieveFileFromDir
{

}
