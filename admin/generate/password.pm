package generate::password;
#!/usr/bin/perl

#Daniel Deyaegher
#Mandip Sangha
#CSCI 265

$|=1;

use strict;

use lib '../../lib/x86_64-linux-gnu-thread-multi';
use Session::Token;

sub new {
   my $class = shift @_;
   my $length = shift @_;

   my $self = {passLength => 12};

   if(defined($length)&& $length =~ /^[0-9]+$/){
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
