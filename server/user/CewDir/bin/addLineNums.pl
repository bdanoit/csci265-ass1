#!/usr/bin/perl

while (<>) {

   $lineNo++;
   $line=$_;
   if ($line=~m/^#/) {
      goto yyy;
   }
   while ($line=~m/cew_[NE]case/) {
      print $`;
      print $&;
      $case=$&;
      $rem=$';
      $cindex=0; $level=0; $left=0; $right=0;
      for ($i=0; $i< length($rem); $i++) {
        if (substr($rem,$i,1) eq "(") {
           $level++;
           if ($level==1) {
              $left=$i;
           }
        }
        if (substr($rem,$i,1) eq ")") {
           $level--;
           if ($level==0) {
              $right=$i;
              goto xxx;
           }
        }
        if (substr($rem,$i,1) eq ",") {
           if ($level==1) {
              $cindex=$i;

           }
        }
     }
xxx: 
     if ($cindex!=0) {
        $trace= substr($rem,$left+1,$cindex-$left-1); 
        $nottrace=substr($rem,$cindex,$right-$cindex+1);
     } else {
        $trace= substr($rem,$left+1,$right-$left-1); 
        $nottrace=substr($rem,$right,1);
     }
     @traceArray=split(/;/, $trace);
     print "( $lineNo ,";
     for ($i=0; $i <= $#traceArray; $i++) {
        print "\n $traceArray[$i] \n";
     }
     print $nottrace;
     $line= substr($rem, $right+1, length($rem)-$right-1);
   } 
yyy:
   print $line;
}
