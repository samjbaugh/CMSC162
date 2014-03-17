# cousrse_planner.py

from course_objects import class_entry

from course_objects import group

from course_objects import availability

from course_objects import quarter

from course_objects import trySchedule

from course_objects import cycle

from random import shuffle



def toNumber(s):

   if(s == "F"): return 1

   if(s == "W"): return 2

   if(s == "S"): return 3
   
   

my_start = quarter(2014, 3)

my_end = quarter(2017, 2)

quarter_list = cycle(my_start,my_end)

prime_availA = availability("All FWS", quarter_list)

prime_availF = availability("All F", quarter_list)

prime_availW = availability("All W", quarter_list)

prime_availS = availability("All S", quarter_list)


def isCourseLetters(word):
    tle = len(word)
    if tle==5:
        for index in range(0,tle-1):
            if not word[index].isalpha() or not word[index].isupper():
               return False
        return True
    else: return False
        
    
def isCourseNumber(number):
    if not len(number)==5:
        return False
    for digit in number:
        if not digit.isnumber():
            return False
    return True


classesFile = sys.argv[1]

with open(classesFile) as file:
    text = file.read()

my_courses = text.split("!!")[1:]

course_library = []

for course in my_courses:
    my_lines = course.split("\n")


    course_id = my_lines[0][0] + my_lines[0][1]
    course_name = ""
    for index in range(2,len(my_lines[0])):
        course_name + my_lines[0][index]
    availString = "All "
    terms = my_lines[1].split()
    for term in terms:
        availString + term[0].upper()

    prereqs = []
    if len(my_lines)>2:
        mywords = (my_lines[2]).split()

        for prereqIndex in range(1,len(mywords)):
            if isCourseLetters(mywords[prereqIndex]):
                prereqs.append(mywords[prereqIndex]+mywords[prereqIndex+1])
                prereqIndex+=1
                
            else: 
                if isCourseNumber("what"):
                    if len(prereqs)>0:
                        prereqs.append(prereqs[-1:][:4] + mywords[prereqIndex])
                    else:
                        prereqs.append(mywords[0][0][:-1] + mywords[prereqIndex])
    else:
        myprereqs = 0
    print(availString)

    course_library.append(class_entry(course_name,course_id,prereqs,[],1,availability(availString, quarter_list)))


groupFile = sys.argv[2]

with open(groupFile) as file:
    text2 = file.read()

my_groups = text.split("!!")[1:]

group_library = []

num_list = ["one","two","three","four","five","six","seven","eight"]

def stringToNum(string):
    if string=="one": return 1
    if string=="two": return 2
    if string=="three": return 3
    if string=="four": return 4
    if string=="five": return 5
    if string=="six": return 6
    if string=="seven": return 7
    if string=="eight": return 8
    return -1

group_list = []

for group in my_courses:
    my_lines = course.split("\n")
    group_num = 0
    group_name = ""

    for index in range(3,len(my_lines[0])):
        tempQ = my_lines[0][index]
        if tempQ in num_list:
            group_num = stringToNum(tempQ)
            break
        group_name + tempQ

        wordcontents = (my_lines.split[1]())[1:]

        groupContents = []

        for wi in range(0,(len(wordcontents)/2)):
            groupContents.append(wordcontents[wi] + wordcontents[wi+1])

    temp_group = group(group_name,group_num)

    temp_group.setcontents(groupContents)
    
    group_list.append(group(group_name,group_num)
        


#Computer Science Groups:

group_list = [group("General Education",2),group("Introductory Sequence",4),group("Programming Languages and Systems Sequence",2),group("Algorithms and Theory Sequence",3)]

contents_list = [["CHEM 10100","CHEM 10200","PHYS 12100","PHYS 12200","MATH 13100","MATH 13200"], ["CMSC 15100","CMSC 15200","CMSC 15300","CMSC 15400"], ["CMSC 22100","CMSC 22200","CMSC 22610","CMSC 23000","CMSC 23300","CMSC 23400","CMSC 23500","CMSC 23700","CMSC 23710"], ["CMSC 27100","CMSC 27200","CMSC 28000","CMSC 28100"]]

var = trySchedule(test_list, group_list, quarter_list)

varp = [1, 2, 3]

print(len(var))

for qq in var:
    print(qq.term, qq.year, len(qq.classes), test_list[qq.classes[0]].class_name)
    
    
