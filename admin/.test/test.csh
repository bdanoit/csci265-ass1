#!/bin/csh

echo "" > results.txt
set CC = 0
set FC = 0
cd ..

foreach F ( .test/tinp/* )
    @ CC ++
	set N = ${F:t}
	set A = `cat .test/tinp/$N`
	./fsysadmin $A > .test/tact/result.tmp
    head -1 .test/tact/result.tmp > .test/tact/$N
	diff -u .test/tact/$N .test/texp/$N > /dev/null
    if ($status) then
        @ FC ++
        echo "FAILED { $N }" 
        echo "FAILED { $N }" >> results.txt
    endif
end
rm .test/tact/result.tmp
echo "TOTAL CASES: $CC" >> results.txt
echo "TOTAL FAILED CASES: $FC" >> results.txt
if($FC > 0) exit 1
exit 0