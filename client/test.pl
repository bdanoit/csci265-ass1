use Digest::MD5 qw{md5_hex};
my @data = ("hello\n","world\n","\n","ITS BRENT LOL\n");

print md5_hex(@data), "\n";

