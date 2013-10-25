package savefile::savefile;
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

   my $self = {username => 0,
               sockets => 0,
               linecount => 0};

   if(defined($Usersname)){
      $self->{username} = $Usersname;
   }
   else
   {
      die exc::exception->new("username not defined");
   }
   if(defined($linecount)){
      $self->{linecount} = $linecount;
   }
   else
   {
      die exc::exception->new("linecount not defined");
   }
   if(defined($socket)){
      $self->{sockets} = $socket;
   }
   else
   {
      die exc::exception->new("socket not defined");
   }

   bless ($self, $class);

   return $self;
}

sub savefileToDir {
   my $self = shift @_;
   my $tempfile = $self->{username}.".tmp";
   my $datafile = $self->{username}.".dat";
   my $countline = 0;
   unless(-e $tempfile)
   {
      if (open(my $file, ">", $tempfile))
      {
         my $client = $self->{sockets};
         while(<$client>)
         {
            print $file $_;
            $countline++;
         }
         if( $countline != $self->{linecount})
         {
            unlink $tempfile if -e $tempfile;
            die exc::exception->new("Corrupt file");
         }
      }
      else
      {
         die exc::exception->new("can't open file");
      }
     # unlink $datafile if -e $datafile;
      move $tempfile, $datafile or die "Could not move file";
     # unlink $tempfile if -e $tempfile;

      return "successful";
   }
   die exc::exception->new("file locked");
}
