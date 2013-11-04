package retrieveFile::retrieveFile;
#!/usr/bin/perl

# Mandip Sangha CSCI 265

$|=1;

use strict;
use lib '../../lib';
use exc::exception;
use Digest::MD5 qw{md5_hex};

sub new {
   my $class = shift @_;
   my $username = shift @_;
   my $socket = shift @_;
   my @data;

   my $self = {username => undef,
               socket => undef,
               data => \@data};

   if(defined($username)) 
   {
      $self->{username} = $username;
   }
   else
   {
      die exc::exception -> new("username_not_defined");
   }

   if(defined($socket)) 
   {
      $self->{socket} = $socket;
   }
   else
   {
      die exc::exception -> new("socket_not_defined");
   }
   
   my $path = __FILE__;
   $path =~ s/[^\/]+$//;
   my $datafile = $path."../saveFile/upload/".$self->{username}.".dat";
   if(-e $datafile)
   {

      if (-s $datafile < 5000000)
      {
         if (open (my $handle, '<', $datafile))
         {
            while(defined (my $line = <$handle>)){
               push @data, $line;
            }
         }
         else
         {
            die exc::exception->new("can_not_find_file");
         }
      }
      else 
      {
         die exc::exception->new("file_size_to_big");
      }
   }
   else
   {
      die exc::exception->new("no_file_exist_for_user");
   }
 

   bless($self, $class);
   return $self;
}

sub md5_checksum{
   my $self = shift @_;
   my $data = $self->{data};
   return md5_hex(@$data);
}

sub retrieveFileFromDir {
   my $self = shift @_;
   my $data = $self->{data};
   my $sock = $self->{socket};
   for my $line (@$data){
      print $sock $line;
   }
   return 1;
}

sub getLineCount {
   my $self = shift @_;
   my $data = $self->{data};
   return scalar @$data;
}
