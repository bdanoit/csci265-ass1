package storage::storage;

# Baleze Danoit
# CSCI 265
# Error Types:
#       bad_array_ref
#       invalid_user_name
#       user_exists
#       sqlite_error
#       invalid_password

$|=1;

use lib '../../lib';
use strict;
use warnings;
use Capture::Tiny qw/capture/;
use exc::exception;

sub new{
    my $class= shift @_;
    my $db = 'fsys.sqlite';
    my $self = {
        db=>$db,
        result=>''
    };

    #Initialize DataBase from prototype if it does not exist
    unless(-e $db){
        unless(-e "$db.prototype"){ die exc::exception->new("DataBase Not Found") }
        qx{cp $db.prototype $db};
    }

    bless ($self, $class);
    return $self;
}

sub users{
    my $self = shift @_;
    my $list = shift @_; #reference to array
    die exc::exception->new("bad_array_ref") unless ref($list);
    
    my $result = $self->query("select * from users;");
    if($result){ return $self->formatResult($list); }
    return $result;
}

sub passwordsByUser{
    my $self = shift @_;
    my $user = shift @_;
    my $list = shift @_; #reference to array
    die exc::exception->new("bad_array_ref") unless ref($list);
    
    my $result = $self->query("select password from user_passwords where user_id = '$user';");
    if($result){ return $self->formatResult($list); }
    return $result;
}

sub addUser{
    my $self = shift @_;
    my $user = shift @_;
    
    return 0 unless $self->validateUser($user);
    
    return $self->query("insert into users values ('$user');");
    return 0;
}

sub addPasswordsByUser{
    my $self = shift @_;
    my $user = shift @_;
    my $list = shift @_; #reference to array
    die exc::exception->new("bad_array_ref") unless ref($list);
    
    return 0 unless $self->validateUser($user);
    
    foreach my $password (@$list){
        return 0 unless $self->validatePassword($password);
        $self->query("insert into user_passwords values ('$user', '$password')");
    }
    return 1;
}

sub deleteUser{
    my $self = shift @_;
    my $user = shift @_;
    
    return 0 unless $self->validateUser($user);
    
    return $self->query("delete from users where id = '$user';");
    return 1;
}

sub deletePasswordByUser{
    my $self = shift @_;
    my $user = shift @_;
    my $password = shift @_;
    
    return 0 unless $self->validateUser($user);
    return 0 unless $self->validatePassword($password);
    
    return $self->query("delete from user_passwords where user_id = '$user' and password = '$password';");
    return 1;
}

sub deletePasswordsByUser{
    my $self = shift @_;
    my $user = shift @_;
    return $self->query("delete from user_passwords where user_id = '$user';");
    return 1;
}

sub query{
    my $self = shift @_;
    my $sql = shift @_;
    my $db = $self->{'db'};
    
    undef $self->{'data'};
    
    my ($stdout, $stderr) = capture {
        system("sqlite3 $db \"PRAGMA foreign_keys = ON; $sql\"");
    };
    
    if($stderr){
        $stderr =~ s/\n//g;
        die exc::exception->new($stderr);
        return 0;
    }
    else{
        $self->{'result'} = $stdout;
        return 1;
    }
}

sub formatResult{
    my $self = shift @_;
    
    #Reference to array
    my $list = shift @_;
    die exc::exception->new("bad_array_ref") unless ref($list);
    
    my $result = $self->{'result'};
    return 0 unless $result;
    my @rows = split /\n/, $result;
    
    foreach my $row (@rows){
        push @$list, $row;
    }
    return scalar @$list;
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

1;