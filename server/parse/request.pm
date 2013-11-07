package parse::request;

# Baleze Danoit
# CSCI 265

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
        user=>undef,
        password=>undef,
        type=>undef,
        lines=>undef,
        checksum=>undef
    };

    bless ($self, $class);
    return $self;
}

sub parse{
    my $self = shift @_;
    my $args = shift @_;
    (my $user, my $pass, my $type, my $lines, my $checksum) = split /\|/, $args;
    
    die exc::exception->new("request_requires_user") unless defined $user;
    die exc::exception->new("request_requires_password") unless defined $pass;
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
