changecom(`#')

define(cew_Variables,
         `my $cew_Test_Count=0;
          my $cew_Error_Count=0;'
)

define(cew_Summary,
         `print("\n**********Summary**********\n");
          print("Total number of test cases = ", $cew_Test_Count, "\n");
          print("Total number of test cases in error = ", $cew_Error_Count, "\n");'
)

define(cew_Ncase,`
do{
    $cew_Test_Count=$cew_Test_Count+1;
    try{
        $2 ;
        my $test_input = $3 ;
        if (($test_input) $5 ($4)) {
            $cew_Error_Count=$cew_Error_Count+1;
            print("Test Case ERROR (Ncase) in script at line number ", $1, "\n");
            print("\tActual Value is ", $test_input, " \n");
            print("\tExpected Value is ", $4, "\n");
        }
    }
    catch{
        my $exc=$_;
        if (ref($exc) eq "exc::exception") {
            my $eName = $exc->get_exc_name();
            print("Test Case ERROR (Ncase) Exception Thrown ($eName) in script at line number ", $1, "\n");
            $cew_Error_Count=$cew_Error_Count+1;
        }
        else {
            print "Unknown Exception Thrown ($exc) at line number $1\n";
        }
    }
};
')


define(cew_Ecase,`
do {
    
    $cew_Test_Count=$cew_Test_Count+1;
    try {
        $2;
        $cew_Error_Count=$cew_Error_Count+1;
        print("Test Case ERROR (Ecase) in script at line number ", $1, "\n");
        print("\tNo Exception thrown \n");
        print("\tExpected Exception is ", $3, "\n");
    }
    
    catch {
        my $exc=$_;
        if (ref($exc) eq "exc::exception") {
            my $eName = $exc->get_exc_name();
            if($eName eq $3){
                #print "Expected Exception Thrown ($eName) at line number $1\n";
            }
            else{
                $cew_Error_Count=$cew_Error_Count+1;
                print("Test Case ERROR (Ecase) in script at line number ", $1, "\n");
                print("\tActual Exception is ", $eName, " \n");
                print("\tExpected Exception is ", $3, "\n");
                
            }
        }
        else {
            print "Unknown Exception Thrown ($exc) at line number $1\n";
        }
    }
};
')
