package generate::token;
#!/usr/bin/perl

#Baleze Danoit
#CSCI 265


$|=1;

#libraries
use lib qw{../../lib/x86_64-linux-gnu-thread-multi};
use lib qw{../../lib};

#modules
use strict;
use Session::Token;
use exc::exception;

sub new {
    my $class = shift @_;
    my $length = shift @_;
    my $test = shift @_;

    my $self = {'length' => 128, 'test' => 0};

    if(defined($length)){
        $self->{'length'} = $length;
    }
    if(defined($test)){
        $self->{'test'} = $test;
    }

    bless ($self, $class);

    return $self;
}

sub generate {
    my $self = shift @_;
    my $file = shift @_;
    my $obj = Session::Token->new('length' => $self->{'length'});
    my $token;
    if($self->{'test'}){ $token = $self->{'test'} }
    else{ $token = $obj->get }
    my $handle;
    
    open ($handle, '<', $file) or die exc::exception->new("cannot_open_file");
    while(my $line = <$handle>){
        die exc::exception->new("token_found_in_file") if ($line =~ /$token/);
        #return $self->generate($file) if ($line =~ /$token/);
    }
    return $token;
}

1;
