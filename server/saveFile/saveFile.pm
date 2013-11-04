package saveFile::saveFile;
#!/usr/bin/perl

#Mandip Sangha, Baleze Danoit CSCI 265

$|=1;

use strict;

use lib '../../lib';
use exc::exception;
use File::Copy 'move';
use Digest::MD5 qw{md5_hex};

sub new {
   my $class = shift @_;
   my $Usersname = shift @_;
   my $socket = shift @_;
   my $linecount = shift @_;
   my $checksum = shift @_;

   my $self = {username => undef,
               sockets => undef,
               linecount => undef,
               checksum => undef};

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
   if(defined($checksum)){
      $self->{checksum} = $checksum;
   }
   else
   {
      die exc::exception->new("checksum_not_defined");
   }

   bless ($self, $class);

   return $self;
}

sub saveFileToDir {
   my $self = shift @_;
   my $path = __FILE__;
   $path =~ s/[^\/]+$//;
   my $tempfile = $path."upload/".$self->{username}.".tmp";
   my $datafile = $path."upload/".$self->{username}.".dat";
   my $countline = 0;
   my @data;
   if (-e $tempfile)
   {
      die exc::exception->new("file_locked");
   }
   else
   {
      if (open(my $handle, ">",$tempfile))
      {
         my $sock = $self->{sockets};
         while(defined(my $line = <$sock>))
         {
            print $handle $line;
            push @data, $line;
            $countline++;
            if($countline == $self->{linecount}){ last; }
         }
         unless((md5_hex(@data) eq $self->{'checksum'}) && ($countline == $self->{'linecount'})){
            unlink $tempfile if -e $tempfile;
            die exc::exception->new("corrupt_file");
         }
      }
      else
      {
         die exc::exception->new("could_not_open_file");
      }
      if(!move ($tempfile, $datafile))
      {
         unlink $tempfile if -e $tempfile;
         die exc::exception->new("could_not_move_file");
      }
      
   }
   return 1;
   
}
