package parse::request;

# Baleze Danoit
# CSCI 265
# Error Types:
#       invalid_user_name
#       invalid_password
#       invalid_type
#       invalid_lines
#       invalid_request


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
        command=>undef,
        user=>undef
    };

    bless ($self, $class);
    return $self;
}

sub parse{
    my $self = shift @_;
    my $args = shift @_;
    if($args =~ /^([^\|]+)\|([^\|]+)\|([^\|]+)(?:\|([^\|]+))?\n?$/){
        my $user = uc($1);
        my $password = $2;
        my $type = uc($3);
        my $lines = $4;
        die exc::exception->new("invalid_user_name") unless ($user =~ /^[A-Z0-9]{4,16}$/);
        die exc::exception->new("invalid_password") unless ($password =~ /^[a-z0-9]{4,12}$/i);
        die exc::exception->new("invalid_type") unless ($type =~ /^(DOWNLOAD|UPLOAD)$/);
        die exc::exception->new("invalid_lines") unless ($lines =~ /^[0-9]+$/i);
        $self->{'user'} = $user;
        $self->{'password'} = $password;
        $self->{'type'} = $type;
        $self->{'lines'} = $lines;
    }
    else{ die exc::exception->new("invalid_request"); }
    return 1;
}

sub user{
    my $self = shift @_;
    return $self->{'user'};
}

sub password{
    my $self = shift @_;
    return $self->{'password'};
}

sub type{
    my $self = shift @_;
    return $self->{'type'};
}

sub lines{
    my $self = shift @_;
    return $self->{'lines'};
}
