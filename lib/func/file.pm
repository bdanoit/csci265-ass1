package func::file;
#libraries
use lib '../lib';

#modules
use exc::exception;

$|=1;

sub countLines{
    my $class = shift @_;
    my $filename = shift @_;
    my $handle;
    my $count = 0;
    
    open $handle, $filename or die exc::exception->new("file_cannot_be_opened");
    
    while (<$handle>){
        $count++;
    }
    
    return $count;
}
