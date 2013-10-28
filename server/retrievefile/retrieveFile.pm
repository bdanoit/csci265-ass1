#!/usr/bin/perl
package retrieveFile;
use strict

$|=1;

use lib '../../lib';
use exc::exception;
use func::file;
use File::Copy 'move';

sub new {
   my $class = shift @_;
   my $username = shift @_;
   my $socket = shift @_;

   my $self = {username => 0,
               socket => 0,
               fileLineCount => 0};

   if(defined($username)) 
   {
      $self->{username} = $username;
   }
   else
   {
      die exc::exception -> new("username not defined");
   }

   if(defined($socket)) 
   {
      $self->{socket} = $socket;
   }
   else
   {
      die exc::exception -> new("socket not defined");
   }
   my $datafile = $self->{username}.".dat";
   die exc::exception->new("No file exist for user") unless (-e $datafile);
   $self->{fileLineCount} = func::file->countLines($datafile);

   bless($self, $class);
   return $self;
}

sub retrieveFileFromDir {
   my $self = shift @_;
   my $datafile = $self->{username}.".dat";
   my $sock = $self->{socket};
   
   if (open (my $handle, '<', $datafile))
   {
      while(defined (my $line = <$handle>)){
         print $sock $line;
      }
      return "successful";
   }
   else
   {
      die exc::exception->new("Can't find file");
   }
}

sub getLineCount {
   my $self = shift @_;
   return $self->{fileLineCount};
}
