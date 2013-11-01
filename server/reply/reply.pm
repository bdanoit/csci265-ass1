package reply::reply;

#Baleze Danoit CSCI 265

#Libraries
use lib '../../lib';

#Modules
use strict;
use warnings;
use exc::exception;
use func::file;
use Switch;

$| = 1;

sub new{
    my $class = shift @_;
    my $sock = shift @_;
    
    die exc::exception->new('reply_invalid_socket_provided') unless (defined $sock);
   
    my $self = {
        'sock'=>$sock
    };

    bless ($self, $class);
    return $self;
}

sub send{
    my $self = shift @_;
    my $sock = $self->{'sock'};
    my $type = uc(shift @_);
    my $value = shift @_;
    my $checksum = shift @_;
    my $query;
    
    die exc::exception->new('reply_invalid_type') unless ($type =~ /^(?:ERROR|SUCCESS)$/);
    switch($type){
        case 'ERROR'{
            die exc::exception->new('reply_error_requires_value') unless defined($value);
            $query = join('|', ($type));
        }
        case 'SUCCESS'{
            die exc::exception->new('reply_success_invalid_linecount') unless (!defined($value) || ($value =~ /^[a-z0-9]+$/));
            if(!defined($value)){
                $query = join('|', ($type));
            }
            else{ $query = join('|', ($type, $value, $checksum)); }
        }
    }
    
    print $sock "$query\n";
    
    return 1;
}

