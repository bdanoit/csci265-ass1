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
    my $type;
    my $value;
    
    my $query = <$sock>;
    
    if(!defined($query)){
        $self->{'message'} = "No response from server.\n";
        return 0;
    }
    
    if($query =~ /^(SUCCESS|ERROR)\|?(.+)?$/){
        $type = $1;
        $value = $2;
    }
    else{ $self->{'message'} = "Server response was malformed.\n"; return 0; }
    
    if($type eq 'ERROR'){
        $self->{'message'} = "Server Exception: $value\n";
        return 0;
    }
    
    if(!defined($value)){
        $self->{'message'} = "Your request was successful.\n";
        return 1;
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
    
    open(my $handle, ">",$file) or die exc::exception('response_cannot_open_file');
    
    my $count = 0;
    while(defined(my $line = <$sock>)){
        print $handle $line;
        $count++;
    }
    
    if($count != $value){
        $self->{'message'} = "The file you received is corrupt, please try again or contact your Administrator for help.\n";
    }
    
    $self->{'message'} = "Your request was successful. File downloaded {$file}\n";
    
    return 1;
}

sub message{
    my $self = shift @_;
    return $self->{'message'};
}
