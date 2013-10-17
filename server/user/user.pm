package user;
$|=1;


use strict;
use warnings;

my $defaultName = "Peter";



### creates a new user-object with default name "Peter"
### if a name was passed as a parameter, it will be set

sub new {
   my $class = shift @_;
   my $parameter = shift @_;

   my $self = {
	name => $defaultName,
              };

   if (defined($parameter)) {
      $self -> {name} = $parameter;
   }

   bless ($self, $class);

   return $self;
}

sub printName {

   my $reference = shift @_;
   my $parameter = shift @_;

   print "User's name is: $reference->{name} \n";

   return 0;

}

1;
