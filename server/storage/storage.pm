package storage;

# Baleze Danoit
# CSCI 265

$|=1;

use strict;
use warnings;

sub new{
    my $class= shift @_;
    my $db = 'fsys.sqlite';
    my $self = {db=>$db};

    #Initialize DataBase from prototype if it does not exist
    unless(-e $db){
        unless(-e "$db.prototype"){ die "DataBase not found..." }
        my $cp = `cp $db.prototype $db`;
    }

    bless ($self, $class);
    return $self;
}

sub getUsers{
    my $self = shift @_;
    my $db = $self->{db};
    my $result = `sqlite3 $db "select * from users;"`;
    return $result;
}

sub getPasswords{
    my $self = shift @_;
    my $db = $self->{db};
    my $result = `sqlite3 $db "select * from user_passwords;"`;
    return $result;
}

sub getPasswordsByUser{
    my $self = shift @_;
    my $user = shift @_;
    my $db = $self->{db};
    my $result = `sqlite3 $db "select * from user_passwords where user_id = '$user';"`;
    return $result;
}

sub formatResult{
    my $self = shift @_;
    my $columns = shift @_;
    my $data = shift @_;
}
