package parseClientRequest::request;

#Justin Waterhouse CSCI 265
use lib '../../lib';
#Modules
use IO::Socket;
use strict;
use exc::exception;
use warnings;
use func::file;
use Switch;

$| = 1;

sub new{
    my $class = shift @_;
    my $user = shift @_;
    my $password = shift @_;
    my $type = shift @_;
    my $file = shift @_;
    
    die exc::exception->new('user_not_defined') unless ($user);
    die exc::exception->new('password_not_defined') unless ($password);
    die exc::exception->new('type_not_defined') unless ($type);
    die exc::exception->new('file_not_defined') unless ($file);
    
    my $self = {
        'query'=>undef,
        'type'=>$type,
        'file'=>$file
    };
    
    die exc::exception->new('file_does_not_exist') unless (-e $file);
    my $lines = func::file->countLines($file);
    
    $self->{'query'} = join("|", $user,$password, $type, $lines);


    bless ($self, $class);
    return $self;
}

sub sendRequest{
    my $self = shift @_;
    my $sock = new IO::Socket::INET (
        PeerAddr => 'localhost',
        PeerPort => '1337',
        Proto => 'tcp'
    );
    die exc::exception->new('cannot_connect_to_server') unless $sock;
    print $sock $self->{'query'}."\n";
    
    my $file = $self->{'file'};
    my $handle;
    switch($self->{'type'}){
        case 'UPLOAD'{
            open $handle, '<', $file or die exc::exception->new('could_not_open_file_for_reading');
            while(defined (my $line = <$handle>)){
                print $sock $line;
            }
        }
        case 'DOWNLOAD'{
            open $handle, '>', $file or die exc::exception->new('could_not_open_file_for_writing');
            while(defined <$sock>){
                print $handle $_;
            }
        }
    }
    return 1;
}

