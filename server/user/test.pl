

use FindBin;
use lib "$FindBin::Bin/.."; 
use user;


print "\n";
my $secondUser = user -> new("Carsten");

#$secondUser -> printName();

$secondUser -> addPassword("12345");
$secondUser -> addPassword("abcd");
$secondUser -> addPassword("a6s8dg0");
$secondUser -> printPasswords();

print "\n \nUsing password 12345 \n\n";

$secondUser -> usePassword("12345");
$secondUser -> printPasswords();

#print $secondUser -> getName(), "\n";
