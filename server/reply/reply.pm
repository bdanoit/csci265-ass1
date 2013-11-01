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
    my $type = uc(shift @_);
    my $value = shift @_;
    my $checksum = shift @_;
    my $query;
    
    die exc::exception->new('reply_invalid_type') unless ($type =~ /^(?:ERROR|SUCCESS)$/);
    switch($type){
        case 'ERROR'{
            die exc::exception->new('reply_error_requires_value') unless defined $value;
            $query = join('|', ($type));
        }
        case 'SUCCESS'{
            die exc::exception->new('reply_success_invalid_linecount') if (defined $value && $value !~ /^[0-9]+$/);
            die exc::exception->new('reply_success_checksum_required') if (defined $value && !defined $checksum);
            if(defined $value && defined $checksum){
                $query = join('|', ($type, $value, $checksum));
            }
            else{
                $query = join('|', ($type));
            }
        }
    }
    
    print $sock "$query\n";
    
    return 1;
}

