package parseClientRequest::parse;
#Justin Waterhouse CSCI 265

$| = 1;

use lib '../../lib/';
#Modules
use strict;
use exc::exception;
use warnings;


sub new{
    my $class = shift @_;
    my $self = {
        UserName=>undef,
        Password=>undef,
        Request=>undef,
        FileName=>undef
    };

    bless ($self, $class);
    return $self;
}

sub parseString{
   my $Count = 0;
   my $self = shift @_;
   my $string = shift @_;
   my $Data = "";
   #Grab all of the keys and values from switches   
   while ($string =~ /-([^-]+)/g)
   {
      
      (my $Command, my  $Data) = split(/ /, $1, 2);
      if (defined($Data)&&!($Data eq ''))
      {
         $Count++;
         #Grab Data Remove White Space
         $Data =~ s/^\s+|\s+$//g;         
         #User Name
         if ($Command =~ /^U$/i)
         {
            if ($Data =~ /^[a-z0-9]+$/i)
            {
               $self->{'UserName'} = $Data;         
            }
            else
            {
               die exc::exception->new("invalid_user_name");
            }
         }
         #User Password
         elsif ($Command =~ /^P$/i)
         {
            if ($Data =~ /^[a-z0-9]+$/i)
            {
               $self->{'Password'} = $Data;
            }
            else
            {  
                  die exc::exception->new("invalid_password");  
            }
         }
         #Upload Or Download
         elsif ($Command =~ /^UF$/i)
         {
            die exc::exception->new("file_does_not_exist") unless (-e $Data);
            my $fileSize = -s "$Data";           
            die exc::exception->new("file_too_large") unless ($fileSize < 5*(1024)*(1024));           
            $self->{'Request'} = "UPLOAD";
            $self->{'FileName'} = $Data;
         }
         elsif($Command =~ /^DF$/i)
         {
            $self->{'Request'} = "DOWNLOAD";
            $self->{'FileName'} = $Data;
         }
         #Invalid Switch
         else 
         {
            die exc::exception->new("invalid_switch");
         }
      }
      else
      {
         die exc::exception->new("missing_switch_data")
      }
   }
   if ($Count < 3)
   {
      die exc::exception->new("too_few_arguments");
   }
}

sub UserName{
    my $self = shift @_;
    return $self->{'UserName'};
}

sub Password{
    my $self = shift @_;
    return $self->{'Password'};
}

sub Request{
    my $self = shift @_;
    return $self->{'Request'};
}

sub FileName{
    my $self = shift @_;
    return $self->{'FileName'};
}
