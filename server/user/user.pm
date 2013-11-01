#John Tribe csci265

package user::user;

$|=1;

use strict;
use warnings;
use lib '../../lib';
use storage::storage;
use exc::exception;

sub new {
	my $class = shift @_;
	my $username = shift@_;
	my $password = shift@_;
	my $self = {
		username=>$username,
		password=>$password
	};

	my $storage = storage::storage->new();

	die exc::exception->new("invalid_username") unless $storage->userExists($username);
	#die exc::exception->new("invalid_password") unless $storage->passwordByUserExists($username, $password);
	#$storage->deletePasswordByUser($username, $password);
	bless($self, $class);
}

sub username {
	my $self = shift @_;
	return $self->{username};
}
1;
