package reply::reply;

#Baleze Danoit CSCI 265

#Libraries
use lib '../../lib';

#Modules
use strict;
use warnings;
use exc::exception;
use Switch;

$| = 1;

sub new{
    my $class = shift @_;
    my $sock = shift @_;
    
    die exc::exception->new('reply_no_socket_provided') unless (defined $sock);
   
    my $self = {
        'sock'=>$sock
    };

    bless ($self, $class);
    return $self;
}

sub send{
    my $self = shift @_;
    my $sock = $self->{'sock'};
    my $type = 'SUCCESS';
    my $linecount = shift @_;
    my $checksum = shift @_;
    my $query;
    
    die exc::exception->new('reply_invalid_linecount') if (defined $linecount && $linecount !~ /^[0-9]+$/);
    die exc::exception->new('reply_checksum_required') if (defined $linecount && !defined $checksum);
    if(defined $linecount && defined $checksum){
        $query = join('|', ($type, $linecount, $checksum));
    }
    else{
        $query = join('|', ($type));
    }
    
    print $sock $query, "\n";
}

