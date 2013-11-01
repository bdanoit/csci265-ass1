package response::response;

#Baleze Danoit CSCI 265


#Libraries
use lib '../../lib';

#Modules
use strict;
use warnings;
use exc::exception;
use func::file;
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
    chop $query;
    
    if(!defined($query)){
        $self->{'message'} = "No response from server.\n";
        return 0;
    }
    (my $type, my $value, my $checksum) = split /\|/, $query;
    
    if($type !~ /^(?:SUCCESS|ERROR)$/){
        $self->{'message'} = "Server response was malformed.\n";
        return 0;
    }
    
    if($type eq 'SUCCESS' && !defined($value)){
        $self->{'message'} = "Your request was successful.\n";
        return 1;
    }
    
    if($type eq 'ERROR'){
        $self->{'message'} = "Server Exception: $value\n";
        return 0;
    }
    
    if(!defined($file)){
        $self->{'message'} = "Your must provide a location to write to.\n";
        return 0;
    }
    
    if(-e $file){
        print "The file {$file} you are writing to already exists. Would you like to overwrite it? (y/n): ";
        my $input = <STDIN>;
        if($input !~ /^(?:y|yes)\n$/i){
            $self->{'message'} = "File was not saved.\n";
            return 0;
        }
    }
    
    my $count = 0;
    my @data;
    while(defined(my $line = <$sock>)){
        push @data, $line;
        $count++;
    }
    
    unless(($checksum eq md5_hex(@data)) && ($count == $value)){
        $self->{'message'} = "The file you received from the server is corrupt.\n";
        return 0;
    }
    
    open(my $handle, ">",$file) or die exc::exception('response_cannot_open_file');
    foreach my $line (@data){
        print $handle $line;
    }
    
    $self->{'message'} = "Your request was successful. File downloaded {$file}\n";
    
    return 1;
}

sub message{
    my $self = shift @_;
    return $self->{'message'};
}
