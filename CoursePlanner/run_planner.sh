#\bin\bash

make 2>/dev/null
curl $1 >webpage.txt
./classesparse.exe <webpage.txt >classResults.txt 2>/dev/null
./groupparse.exe <webpage.txt >groupResults.txt 2>/dev/null
python3 course_planner.py classResults.txt groupResults.txt >output.txt 2>/dev/null

