package upload;
#!/usr/bin/perl

#Mandip Sangha CSCI 265

$|=1;

use strict;


sub new {
   my $class = shift @_;
   my $Usersname = shift @_;
   my $file = shift @_;

   my $self = {username => 0,
               statusMessage => "unsuccessful",
               uploadFile => 0};

   if(defined($Usersname)){
      $self->{username} = $Usersname;
   }
   if(defined($file)){
      $self->{uploadFile} = $file;
   }

   bless ($self, $class);

   return $self;
}

sub status {
   my $self = shift @_;
   return $self->{statusMessage};
}

sub upload {
   my $self = shift @_;
   my $fileName = $self->{username};
   my $file1 = $self->{uploadFile};
   if (open(my $file2, ">",$fileName))
   {
      while(<$file1>)
      {
         print $file2 $_;
      }
      close $file2;
      $self->{statusMessage} = "successful";
   }
   
}
