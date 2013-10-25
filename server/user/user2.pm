package user::user2;
$|=1;

#libraries
use lib '../';
use lib '../../lib';

#packages
use strict;
use warnings;
use exc::exception;
use storage::storage;



### Validates user or dies trying

sub new {
    my $class = shift @_;
    my $user = uc(shift @_); #uppercase user name
    my $password = shift @_;
    my $storage = storage::storage->new();
    
    die exc::exception->new("user_not_exist") unless ($storage->userExists($user));
    die exc::exception->new("invalid_password") unless ($storage->passwordByUserExists($user, $password));
    die exc::exception->new("password_not_removed") unless ($storage->deletePasswordByUser($user, $password));
    
    my $self = {
        'user'=>$user
    };

    bless ($self, $class);
    return $self;
}

sub name {
    my $self = shift @_;
    return $self->{'user'};
}

1;
