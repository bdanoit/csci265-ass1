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
    
    #for testing purposes
    my $testuser = 0;
    if($username eq "TESTUSER" && $password eq "safe1test2"){ $testuser = 1; }
    
	die exc::exception->new("invalid_username") unless $storage->userExists($username) || $testuser;
	die exc::exception->new("invalid_password") unless $storage->passwordByUserExists($username, $password) || $testuser;
	$storage->deletePasswordByUser($username, $password) unless $testuser;
	bless($self, $class);
}

sub username {
	my $self = shift @_;
	return $self->{username};
}
1;
