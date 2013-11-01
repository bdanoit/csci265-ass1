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
    (my $user, my $pass, my $type, my $lines, my $checksum) = split /\|/, $args;
    
    die exc::exception->new("request_invalid_user") unless (defined($user) && $user =~ /^[a-z0-9]{4,16}$/i);
    die exc::exception->new("request_invalid_password") unless (defined($pass) && $pass =~ /^[a-z0-9]{4,12}$/i);
    die exc::exception->new("request_invalid_type") unless (defined($type) && $type =~ /^(DOWNLOAD|UPLOAD)$/i);
    die exc::exception->new("request_invalid_lines") unless (!defined($lines) || $lines =~ /^[0-9]+$/i);
    die exc::exception->new("request_invalid_checksum") if (defined($lines) && !defined($checksum));
    
    $self->{'user'} = uc($user);
    $self->{'password'} = $pass;
    $self->{'type'} = uc($type);
    $self->{'lines'} = $lines;
    $self->{'checksum'} = $checksum;
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

sub checksum{
    my $self = shift @_;
    return $self->{'checksum'};
}
