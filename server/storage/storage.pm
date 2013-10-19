package storage::storage;

# Baleze Danoit
# CSCI 265
# Error Types:
#       bad_array_ref
#       invalid_user_name
#       user_exists
#       sqlite_error

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
        error=>'',
        result=>''
    };

    #Initialize DataBase from prototype if it does not exist
    unless(-e $db){
        unless(-e "$db.prototype"){ die exc::exception->new("dbnf") }
        qx{cp $db.prototype $db};
        qx{sqlite3 $db "PRAGMA foreign_keys = ON;"};
    }

    bless ($self, $class);
    return $self;
}

sub users{
    my $self = shift @_;
    #reference to array
    my $array = shift @_;
    die exc::exception->new("bad_array_ref") unless ref($array);
    
    my $result = $self->query("select * from users;");
    if($result){ return $self->formatResult($array); }
    return $result;
}

sub passwordsByUser{
    my $self = shift @_;
    my $user = shift @_;
    #reference to array
    my $array = shift @_;
    die exc::exception->new("bad_array_ref") unless ref($array);
    
    my $result = $self->query("select password from user_passwords where user_id = '$user';");
    if($result){ return $self->formatResult($array); }
    return $result;
}

sub validateUser{
    my $self = shift @_;
    my $user = shift @_;
    return 1 if ($user =~ /^[a-z0-9_]{4,16}$/i);
    return 0;
}

sub addUser{
    my $self = shift @_;
    my $user = shift @_;
    
    die exc::exception->new("invalid_user_name") unless $self->validateUser($user);
    
    return $self->query("insert into users values ('$user');");
    return 0;
}

sub addPasswordsByUser{
    my $self = shift @_;
    my $user = shift @_;
    my $list = shift @_; #should be array reference
    
    die exc::exception->new("bad_array_ref") unless ref($list);
    die exc::exception->new("invalid_user_name") unless $self->validateUser($user);
    
    foreach(@$list){
        $self->query("insert into user_passwords values ('$user', '$_')");
    }
    return 1;
}

sub deleteUser{
    my $self = shift @_;
    my $user = shift @_;
    return $self->query("delete from users where id = '$user';");
    return 1;
}

sub deletePasswordByUser{
    my $self = shift @_;
    my $user = shift @_;
    my $password = shift @_;
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
        $self->{'error'} = $stderr;
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
    my $array = shift @_;
    die exc::exception->new("bad_array_ref") unless ref($array);
    
    my $result = $self->{'result'};
    return 0 unless $result;
    my @rows = split /\n/, $result;
    
    my $count = 0;
    foreach my $row (@rows){
        $count++;
        push @$array, $row;
    }
    return scalar $count;
}

sub error{
    my $self = shift @_;
    return $self->{'error'};
}

1;