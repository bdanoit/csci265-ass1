package parseClientRequest::request;

#Justin Waterhouse CSCI 265
use lib '../../lib';
#Modules
use IO::Socket;
use strict;
use exc::exception;
use warnings;
use func::file;

$| = 1;

sub new{
    my $class = shift @_;
    my $self = {
        formatRequest=>'',
        handleRequest=>''
    };


    bless ($self, $class);
    return $self;
}


sub formatRequest{
   my $self = shift @_;
   my $UserName = shift @_;
   my $UserPassword = shift @_;
   my $Request = shift @_;
   my $FileName = shift @_;
   unless(-e $FileName)
   {
      die "file_does_not_exist\n";
   }
   my $NumLines = func::file->countLines($FileName);
   my $params = join("|", $UserName,$UserPassword, $Request, $NumLines);
   return $params;

}

sub createRequest{
   my $self = shift @_;
   my $request = shift @_;

   my $sock = new IO::Socket::INET (
                              PeerAddr => 'localhost',
                              PeerPort => '1337',
                              Proto => 'tcp'
                             );
   print "Request params are: $request\n";     
   die "Error: Unable To Connect To Password Server \n" unless $sock;
   print $sock "$request\n"; 
   #$username|$password|$type|$num_lines_in_file
   while (1) {
      my $token = <$sock>;
      chop $token;
      last if $token eq "CLOSE";
   }

   print $request;
}

