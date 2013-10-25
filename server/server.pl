#!/usr/bin/perl
use IO::Socket;
use savefile;
use user;
use strict;

my $sock = new IO::Socket::INET (
    LocalHost => '',
    LocalPort => '1337',
    Proto => 'tcp',
    Listen => 3,
    Reuse => 1
);
die "Could not create socket: $!\n" unless $sock;

while (my $client = $sock->accept()) {
    print "Accepting Requests on Parent\n";

    my $pid = fork();
    if($pid == 0){ ## check if current proces is a child

        #### code for child process start
        my $request = <$client>;
        print "<Forked Request on Child\n";
        print "\t$request";
        if($request =~ /^([^\|]+)\|([^\|]+)\|([^\|]+)(?:\|([^\|]+))\n$/){
            my $username = $1;
            my $password = $2;
            my $type = $3;
            my $lines = $4;

            #create and authorize user
            try
            {
               $newUser = user -> new($username, $password);
            }
            catch
            {
               # return "invalid password" to client
            }

            
            try
            {            

               if($type eq 'savefile')
               {
                  $saveFileObject = savefile -> new($username, $client, $lines);
                  $saveFileObject -> savefileToDir();
                  
               }

               if($type eq 'download')
               {
                  #send download module the username
               }
         
            }

            catch
            {
               #check what was wrong, send message back to client accordingly
            }



            #print "\tIncoming file from $username\n";
            #open(my $handle, ">", "upload/$username") or die "Can't open: $!";
            #while(defined(<$client>)){
            #    print $handle $_;
            #}
            #print "\tFile stored\n";
        }
        print ">End Request\n";
        exit(0);
        }
        #### code for child process end

    else{
        
    }
}

close($sock);
