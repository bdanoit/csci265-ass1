package parseClientRequest::parse;
#Justin Waterhouse CSCI 265

#Libraries
use lib '../../lib';
#Modules
use strict;
#use exc::exception;
use warnings;

$| = 1;

sub new{
    my $class = shift @_;
    my $string = shift @_;
    my $self = {
        UserName=>'',
        Password=>'',
        Request=>'',
        FileName=>''
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
   while ($string =~ /-([A-Z]+)(?: ([^-]+))/gi)
   {
      my $Command = $1;
      #User Name
      if ($2)
      {
         #Grab Data Remove White Space
         $Data = $2;
         $Data =~ s/^\s+|\s+$//g;
         #User Name
         if ($Command =~ /^U$/i)
         {
            $self->{'UserName'} = $Data;
            $Count = $Count+1;           
         }
         #User Password
         elsif ($Command =~ /^P$/i)
         {
            $self->{'Password'} = $Data;
            $Count = $Count+1;
         }
         #Upload Or Download
         elsif ($Command =~ /^UF$/i)
         {
            $self->{'Request'} = "UPLOAD";
            $self->{'FileName'} = $Data;
            $Count = $Count+1;

         }
         elsif($Command =~ /^DF$/i)
         {
            $self->{'Request'} = "DOWNLOAD";
            $self->{'FileName'} = $Data;
            $Count = $Count+1;
         }
         #Invalid Switch
         else 
         {
            die "invalid_switch\n";
         }
      }
      else
      {
         die "missing_switch_data\n";
      }
   }
   if ($Count < 3)
   {
      die "too_few_arguments\n";
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
