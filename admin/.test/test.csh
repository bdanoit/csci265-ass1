#!/bin/csh

echo "" > results.txt
set CC = 0
set FC = 0
cd ..

foreach F ( .test/tinp/* )
    @ CC ++
	set N = ${F:t}
	set A = `cat .test/tinp/$N`
	./fsysadmin $A > .test/tact/$N
    set E = "./fsysadmin $A"
	diff -u tact/$N .test/texp/$N > /dev/null
    if ($status) then
        @ FC ++
        echo "FAILED { $N }" 
        echo "FAILED { $N }" >> results.txt
    endif
end
echo "TOTAL CASES: $CC" >> results.txt
echo "TOTAL FAILED CASES: $FC" >> results.txt
