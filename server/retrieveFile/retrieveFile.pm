package retrieveFile::retrieveFile;
#!/usr/bin/perl

$|=1;

use strict;
use lib '../../lib';
use exc::exception;
use func::file;

sub new {
   my $class = shift @_;
   my $username = shift @_;
   my $socket = shift @_;

   my $self = {username => undef,
               socket => undef};

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
      return 1;
   }
   else
   {
      die exc::exception->new("can_not_find _file");
   }
}

sub getLineCount {
   my $self = shift @_;
   my $datafile = $self->{username}.".dat";
   die exc::exception->new("no_file_exist_for_user") unless (-e $datafile);
   return func::file->countLines($datafile);
}
