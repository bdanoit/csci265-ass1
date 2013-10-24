package storage::storage;

# Baleze Danoit
# CSCI 265
# Error Types:
#       bad_array_ref
#       invalid_user_name
#       invalid_password
#       user_exists
#       all sqlite errors

$|=1;

use lib '../../lib';
use strict;
use warnings;
use Capture::Tiny qw/capture/;
use exc::exception;
use Switch;
use DBI;
use DBD::SQLite;

sub new{
    my $class= shift @_;
    my $path = __FILE__;
    $path =~ s/[^\/]+$//;
    my $dbname = $path.'fsys.sqlite';
    my $self = {
        db=>undef,
        result=>''
    };

    my $db = DBI->connect("dbi:SQLite:dbname=$dbname","","") or $self->DBIException();
    
    my $fk = $db->do("PRAGMA foreign_keys = ON") or $self->DBIException();
    
    #turn off automatic warning
    $db->{'PrintError'} = 0;
    $db->{'PrintWarn'} = 0;
    
    $self->{'db'} = $db;

    bless ($self, $class);
    return $self;
}

sub users{
    my $self = shift @_;
    my $db = $self->{'db'};
    my $list = shift @_; #reference to array
    die exc::exception->new("bad_array_ref") unless ref($list);
    
    my $stmt = $db->prepare("select * from users;") or $self->DBIException();
    my $result = $stmt->execute() or $self->DBIException();
    
    my $all = $stmt->fetchall_arrayref() or $self->DBIException();
    foreach my $row (@$all) {
        my ($user) = @$row;
        push @$list, $user;
    }
    undef $all;
    
    $stmt->finish();
    return $result;
}

sub passwordsByUser{
    my $self = shift @_;
    my $db = $self->{'db'};
    my $user = shift @_;
    my $list = shift @_; #reference to array
    die exc::exception->new("bad_array_ref") unless ref($list);
    
    my $stmt = $db->prepare("select password from user_passwords where user_id = ?;") or $self->DBIException();
    my $result = $stmt->execute($user) or $self->DBIException();
    
    my $all = $stmt->fetchall_arrayref() or $self->DBIException();
    my $count = 0;
    foreach my $row (@$all) {
        my ($password) = @$row;
        push @$list, $password;
        $count++;
    }
    undef $all;
    
    $stmt->finish();
    return $count;
}

sub userExists{
    my $self = shift @_;
    my $db = $self->{'db'};
    my $user = shift @_;
    
    return 0 unless $self->validateUser($user);
    
    my $result = $db->selectrow_array("select count(id) from users where id = ?;", undef, $user) or $self->DBIException();
    return $result;
}

sub passwordByUserExists{
    my $self = shift @_;
    my $db = $self->{'db'};
    my $user = shift @_;
    my $password = shift @_;
    
    return 0 unless $self->validateUser($user);
    return 0 unless $self->validatePassword($password);
    
    my $result = $db->selectrow_array("select count(*) from user_passwords where user_id = ? and password = ?;", undef, $user, $password) or $self->DBIException();
    return $result;
}

sub addUser{
    my $self = shift @_;
    my $db = $self->{'db'};
    my $user = shift @_;
    
    return 0 unless $self->validateUser($user);
    
    my $result = $db->do("insert into users values (?);", undef, $user) or $self->DBIException();
    return $result;
}

sub addPasswordsByUser{
    my $self = shift @_;
    my $db = $self->{'db'};
    my $user = shift @_;
    my $list = shift @_; #reference to array
    die exc::exception->new("bad_array_ref") unless ref($list);
    
    return 0 unless $self->validateUser($user);
    
    foreach my $password (@$list){
        return 0 unless $self->validatePassword($password);
        my $result = $db->do("insert into user_passwords values (?, ?)", undef, $user, $password) or $self->DBIException();
    }
    return 1;
}

sub deleteUser{
    my $self = shift @_;
    my $db = $self->{'db'};
    my $user = shift @_;
    
    return 0 unless $self->validateUser($user);
    
    my $result = $db->do("delete from users where id = ?;", undef, $user) or $self->DBIException();
    return $result;
}

sub deletePasswordByUser{
    my $self = shift @_;
    my $db = $self->{'db'};
    my $user = shift @_;
    my $password = shift @_;
    
    return 0 unless $self->validateUser($user);
    return 0 unless $self->validatePassword($password);
    
    my $result = $db->do("delete from user_passwords where user_id = ? and password = ?;", undef, $user, $password) or $self->DBIException();
    return $result;
}

sub deletePasswordsByUser{
    my $self = shift @_;
    my $db = $self->{'db'};
    my $user = shift @_;
    my $result = $db->do("delete from user_passwords where user_id = ?;", undef, $user) or $self->DBIException();
    return $result;
}

sub validateUser{
    my $self = shift @_;
    my $entry = shift @_;
    return 1 if ($entry =~ /^[a-z0-9_]{4,16}$/i);
    die exc::exception->new("invalid_user_name");
    return 0;
}

sub validatePassword{
    my $self = shift @_;
    my $entry = shift @_;
    return 1 if ($entry =~ /^[a-z0-9_]{4,12}$/i);
    die exc::exception->new("invalid_password");
    return 0;
}

sub DBIException{
    my $self = shift @_;
    switch($DBI::err){
        case undef{}
        case 0{}
        default{
            die exc::exception->new($DBI::errstr);
        }
    }
}

1;