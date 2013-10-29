package saveFile::saveFile;
#!/usr/bin/perl

#Mandip Sangha CSCI 265

$|=1;

use strict;

use lib '../../lib';
use exc::exception;
use File::Copy 'move';

sub new {
   my $class = shift @_;
   my $Usersname = shift @_;
   my $socket = shift @_;
   my $linecount = shift @_;

   my $self = {username => undef,
               sockets => undef,
               linecount => undef};

   if(defined($Usersname)){
      $self->{username} = $Usersname;
   }
   else
   {
      die exc::exception->new("username_not_defined");
   }
   if(defined($socket)){
      $self->{sockets} = $socket;
   }
   else
   {
      die exc::exception->new("socket_not_defined");
   }
   if(defined($linecount)){
      $self->{linecount} = $linecount;
   }
   else
   {
      die exc::exception->new("linecount_not_defined");
   }

   bless ($self, $class);

   return $self;
}

sub saveFileToDir {
   my $self = shift @_;
   my $tempfile = "upload/".$self->{username}.".tmp";
   my $datafile = "upload/".$self->{username}.".dat";
   my $countline = 0;
   if (-e $tempfile)
   {
      die exc::exception->new("file_locked");
   }
   else
   {
      if (open(my $handle, ">",$tempfile))
      {
         my $sock = $self->{sockets};
         while(<$sock>)
         {
            print $handle $_;
            $countline++;
         }
         if( $countline != $self->{linecount})
         {
            unlink $tempfile if -e $tempfile;
            die exc::exception->new("corrupt_file");
         }
      }
      else
      {
         die exc::exception->new("can't_open_file");
      }
      if(move ($tempfile, $datafile))
      {
         return 1;
      } 
      else
      {
         unlink $tempfile if -e $tempfile;
         die exc::exception->new("could_not_move_file");
      }
      
   }
   
}
