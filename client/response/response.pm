package response::response;

#Baleze Danoit CSCI 265


#Libraries
use lib '../../lib';

#Modules
use strict;
use warnings;
use exc::exception;
use Switch;
use Digest::MD5 qw{md5_hex};

$| = 1;

sub new{
    my $class = shift @_;
    my $sock = shift @_;
    
    die exc::exception->new('response_no_socket_provided') unless (defined $sock);
   
    my $self = {
        'sock'=>$sock,
        'message'=>undef
    };

    bless ($self, $class);
    return $self;
}

sub process{
    my $self = shift @_;
    my $sock = $self->{'sock'};
    my $file = shift @_;
    my $query = <$sock>;
    
    die exc::exception->new('response_not_received') unless defined $query;
    
    $query =~ s/\|?\n$//;
    (my $type, my $value, my $checksum) = split /\|/, $query;
    
    die exc::exception->new('response_malformed') unless $type =~ /^(?:SUCCESS|ERROR)$/;
    
    if($type eq 'ERROR'){
        $self->{'message'} = "Server Exception: $value\n";
        return 1;
    }
    else{
        my $linecount = $value;
        if(!defined $linecount){
            $self->{'message'} = "Your upload was successful.\n";
            return 1;
        }
        elsif(defined($linecount) && $linecount !~ /^[0-9]+$/){
            die exc::exception->new('response_invalid_line_count');
        }
        elsif(!defined($checksum)){
            die exc::exception->new('response_checksum_not_provided');
        }
        elsif(!defined($file)){
            die exc::exception->new('response_path_not_provided');
        }
        
        my $count = 0;
        my @data;
        while(defined(my $line = <$sock>)){
            push @data, $line;
            $count++;
            if($count == $linecount){ last; }
        }
        
        die exc::exception->new('response_corrupt_file') unless(($checksum eq md5_hex(@data)) && ($count == $linecount));
        
        open(my $handle, ">",$file) or die exc::exception->new('response_cannot_open_file');
        foreach my $line (@data){
            print $handle $line;
        }
        
        $self->{'message'} = "Your request was successful. File downloaded {$file}\n";
    }
    
    return 1;
}

sub message{
    my $self = shift @_;
    return $self->{'message'};
}
