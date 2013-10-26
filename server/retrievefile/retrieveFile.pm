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
   die exc::exception->new("file_does_not_exist") unless (-e $datafile);
   $self->{fileLineCount} = func::file->countLines($datafile);

   bless($self, $class);
   return $self;
}

sub retrieveFileFromDir {
   my $self = shift @_;
   my $datafile = $self->{username}.".dat";
   
}

sub getLineCount {
   my $self = shift @_;
   return $self->{fileLineCount};
}
