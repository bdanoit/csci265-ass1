changecom(`#')

define(cew_Variables,
         `my $cew_Test_Count=0;
          my $cew_Error_Count=0;
          my $expectedExceptionThrown;'
)

define(cew_Summary,
         `print("\n**********Summary**********\n");
          print("Total number of test cases = ", $cew_Test_Count, "\n");
          print("Total number of test cases in error = ", $cew_Error_Count, "\n");'
)

define(cew_Ecase,
        ` $cew_Test_Count=$cew_Test_Count+1;
          $expectedExceptionThrown = 0;
          try {
            $2 ;
          }
          catch{
            $expectedExceptionThrown = 1;
            if (!(($3) eq ($_->get_exc_name()))) 
            { 
                $cew_Error_Count=$cew_Error_Count+1;
                print("Unexpected exception thrown at line ", $1, "\n");
                print("Expected exception was ", $3, "\n");
            }
          };
          if ($expectedExceptionThrown == 0) {
                $cew_Error_Count=$cew_Error_Count+1;
                print("Expected exception not thrown at line ", $1, "\n");
                print("Expected exception was ", $3, "\n");
          }
          '
)

define(cew_Ncase,
          `$cew_Test_Count=$cew_Test_Count+1;
do{
            try{
              $2;
            
            if (($3) $5 ($4)) {
              $cew_Error_Count=$cew_Error_Count+1;
              print("Test Case ERROR (Ncase) in script at line number ", $1, "\n");
              print("Actual Value is ", $3, " \n");
              print("Expected Value is ", $4, "\n");
}
}
	catch {
              $cew_Error_Count=$cew_Error_Count+1;
              print("Unexpected exception thrown at line ", $1, "\n");
            }
          };'
)
