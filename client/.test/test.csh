#!/bin/csh

echo "" > results.txt
set CC = 0
set FC = 0
cd ..

foreach F ( .test/tinp/* )
    @ CC ++
	set N = ${F:t}
	set A = `cat .test/tinp/$N`
	./fsys $A > .test/tact/$N
	diff -u .test/tact/$N .test/texp/$N > /dev/null
    if ($status) then
        @ FC ++
        echo "FAILED { $N }" 
        echo "FAILED { $N }" >> results.txt
    endif
end
echo "TOTAL CASES: $CC" >> results.txt
echo "TOTAL FAILED CASES: $FC" >> results.txt
if($FC > 0) exit 1
exit 0