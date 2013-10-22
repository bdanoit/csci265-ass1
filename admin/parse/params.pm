package parse::params;

# Baleze Danoit
# CSCI 265
# Error Types:
#       invalid_command
#       invalid_user_name
#       invalid_parameter_count

$|=1;

#libraries
use lib '../../lib';

#modules
use strict;
use warnings;
use exc::exception;


sub new{
    my $class = shift @_;
    
    my $self = {
        command=>'',
        user=>''
    };

    bless ($self, $class);
    return $self;
}

sub parse{
    my $self = shift @_;
    my $args = shift @_;
    if($args =~ /^([^\s]+)\s+([^\s]+)$/){
        my $command = $1;
        my $user = uc($2);
        die exc::exception->new("invalid_command") unless ($command =~ /^(create|addpw|clean)$/);
        die exc::exception->new("invalid_user_name") unless ($user =~ /^[a-z0-9]{4,16}$/i);
        $self->{'command'} = $command;
        $self->{'user'} = $user;
    }
    else{ die exc::exception->new("invalid_parameter_count"); }
    return 1;
}

sub command{
    my $self = shift @_;
    return $self->{'command'};
}

sub user{
    my $self = shift @_;
    return $self->{'user'};
}