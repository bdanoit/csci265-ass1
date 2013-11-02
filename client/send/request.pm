package send::request;
#Justin Waterhouse, Baleze Danoit CSCI 265
use lib '../../lib';
#Modules
use strict;
use warnings;
use exc::exception;
use Digest::MD5 qw{md5_hex};

$| = 1;
sub new{
    my $class = shift @_;
    my $user = shift @_;
    my $password = shift @_;
    my $type = shift @_;
    my $file = shift @_;
     
    die exc::exception->new('request_user_not_defined') unless ($user);
    die exc::exception->new('request_password_not_defined') unless ($password);
    die exc::exception->new('request_type_not_defined') unless ($type);
    die exc::exception->new('request_file_not_defined') unless ($file);
    
    my @data;
    
    my $self = {
        'user'=>$user,
        'password'=>$password,
        'type'=>$type,
        'file'=>$file,
        'data'=>\@data
    };
    
    if($type == "UPLOAD"){
        die exc::exception->new('request_file_not_exists') unless (-e $file);
        my $handle;
        open $handle, '<', $file;
        while(defined (my $line = <$handle>)){
            push @data, $line;
        }
        close $handle;
    }

    bless ($self, $class);
    return $self;
}

sub sendRequest{
    my $self = shift @_;
    my $sock = shift @_;
    my $data = $self->{'data'};
    my $query;
    
    if($self->{'type'} == "UPLOAD"){
        my $lines = scalar @$data;
        my $checksum = md5_hex(@$data);
        $query = join("|", $self->{'user'},$self->{'password'}, $self->{'type'}, $lines, $checksum);
    }
    else{
        $query = join("|", $self->{'user'},$self->{'password'}, $self->{'type'});
    }
    
    print $sock $query."\n";
    
    if($self->{'type'} eq 'UPLOAD'){
        foreach my $line (@$data){
            print $sock $line;
        }
    }
    return 1;
}
1;