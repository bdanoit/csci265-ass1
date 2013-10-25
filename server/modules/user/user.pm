package server::user;

$|=1;

use strict;
use warnings;
use lib '..';
use storage::storage;

sub new {
	my $class = shift @_;
	my $username = shift@_;
	my $password = shift@_;
	my $self = {
		username => $username;
		password => $password;
	}

	my $storage = storage->new();

	die("Invalid Username") unless storage->userExists($username);
	die("Invalid Password") unless storage->passwordByUserExists($username, $password);

	storage->deletePasswordByUser($username, $password);
	bless($self, $class);
}