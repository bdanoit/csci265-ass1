package passwordGenerator::passwordGenerator;
#!/usr/bin/perl

#Mandip Sangha CSCI 265

$|=1;

use strict;

use lib '/home/student/sangham/csci265/assignment1/lib/x86_64-linux-gnu-thread-multi';
use Session::Token;

sub new {
   my $class = shift @_;
   my $length = shift @_;

   my $self = {passLength => 12};

   if(defined($length)){
      $self->{passLength} = $length;
   }

   bless ($self, $class);

   return $self;
}

sub generate {
   my $self = shift @_;

   my $password = Session::Token->new(length => $self->{passLength});
   return $password->get;
}
