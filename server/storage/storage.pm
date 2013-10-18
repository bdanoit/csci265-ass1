package storage::storage;

# Baleze Danoit
# CSCI 265

$|=1;

use strict;
use warnings;
use Capture::Tiny qw/capture/;

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
        unless(-e "$db.prototype"){ die "DataBase not found..." }
        qx{cp $db.prototype $db};
        qx{sqlite3 $db "PRAGMA foreign_keys = ON;"};
    }

    bless ($self, $class);
    return $self;
}

sub users{
    my $self = shift @_;
    my $result = $self->query("select * from users;");
    if($result){ $self->formatResult('id'); }
    return $result;
}

sub passwords{
    my $self = shift @_;
    my $result = $self->query("select * from user_passwords;");
    if($result){ $self->formatResult('user,password'); }
    return $result;
}

sub passwordsByUser{
    my $self = shift @_;
    my $user = shift @_;
    my $result = $self->query("select password from user_passwords where user_id = '$user';");
    if($result){ $self->formatResult('password'); }
    return $result;
}

sub validateUser{
    my $self = shift @_;
    my $user = shift @_;
    return 1 if ($user =~ /[a-z0-9_]/i);
    return 0;
}

sub addUser{
    my $self = shift @_;
    my $user = shift @_;
    
    die "Username is invalid" unless $self->validateUser($user);
    
    my $result = $self->query("insert into users values ('$user');");
    return "User '$user' already exists\n" unless $result;
    return 0;
}

sub addPasswordsByUser{
    my $self = shift @_;
    my $user = shift @_;
    my $list = shift @_; #should be array reference
    
    die "Password list is not an array reference" unless ref($list);
    die "Username is invalid" unless $self->validateUser($user);
    
    foreach(@$list){
        die $self->error() unless $self->query("insert into user_passwords values ('$user', '$_')");
    }
    return 1;
}

sub deleteUser{
    my $self = shift @_;
    my $user = shift @_;
    die $self->error() unless $self->query("delete from users where id = '$user';");
    return 1;
}

sub deletePasswordByUser{
    my $self = shift @_;
    my $user = shift @_;
    my $password = shift @_;
    die $self->error() unless $self->query("delete from user_passwords where user_id = '$user' and password = '$password';");
    return 1;
}

sub deletePasswordsByUser{
    my $self = shift @_;
    my $user = shift @_;
    die $self->error() unless $self->query("delete from user_passwords where user_id = '$user';");
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
        return 0;
    }
    else{
        $self->{'result'} = $stdout;
        return 1;
    }
}

sub formatResult{
    my $self = shift @_;
    my $cols = shift @_;
    my @data;
    my $result = $self->{'result'};
    return 0 unless $result;
    die "No keys\n" unless $cols;
    my @keys = split /,/, $cols;
    my @rows = split /\n/, $result;
    foreach(@rows){
        my @columns = split /\|/, $_;
        die "Keys do not match number of columns...\n" if (scalar @keys != scalar @columns);
        my %row;
        for(my $i = 0; $i < scalar @keys; $i++){
            my $key = $keys[$i];
            my $column = $columns[$i];
            $row{$key} = $column;
        }
        push @data, \%row;
    }
    $self->{'data'} = \@data;
}

sub result{
    my $self = shift @_;
    return $self->{'data'};
}
sub error{
    my $self = shift @_;
    return $self->{'error'};
}
