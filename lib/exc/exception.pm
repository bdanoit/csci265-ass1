package exc::exception;
#================================================================--
# Design Unit  : exception module
#
# File Name    : exception.pm
#
# Purpose      : implements exception service routines
#
# Note         :
#
# Limitations  :
#
# Errors       : none known
#
# Modules      : none
#
# Dependences  : none
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#------------------------------------------------------------------
# Revision List
# Version      Author  Date    Changes
# 1.0          PW      Oct 12  New version
#=========================================================

$|=1;

use strict;
use warnings;

sub new {
   my $class=shift @_;
   my $d=shift @_;

   my $self = {
      exc_name => 0,
   };

   $self->{exc_name}=$d;

   bless ($self, $class);

   return $self;
}

sub get_exc_name {
   my $self = shift @_;

    return $self->{exc_name};
}

sub set_name {
   my $self = shift @_;
   my $val = shift @_;

   $self->{exc_name}=$val;

   return 0;
}


1;
