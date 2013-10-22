package download;
#!/usr/bin/perl

#Mandip Sangha CSCI 265

$|=1;

use strict;

sub new {
   my $class = shift @_;
   my $Usersname = shift @_;

   my $self = {username => 0,
               statusMessage => "unsuccessful",
               downFile => 0};

   if(defined($Usersname)){
      $self->{username} = $Usersname;
   }

   bless ($self, $class);

   return $self;
}

sub status {
   my $self = shift @_;
   return $self->{statusMessage};
}

sub downloadFile {
   my $self = shift @_;
   my $fileName = $self->{username};
   if(open(my $DATA1, "<",$fileName))
   {
      $self->{downFile} = $DATA1;
      $self->{statusMessage} = "successful";
   }
}

sub getFile {
   my $self = shift @_;
   return $self->{downFile};
}

sub downloadComplete {
   my $self = shift @_;
   my $f = $self->{downFile}
   #close $f;
}

