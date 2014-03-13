import sys
from elevator_classes import state, command_index, command, que
from elevator_functions import parse_commands, move, load_command, load_commands
 

#MAIN METHOD

fileArg = sys.argv[1]

floor_numbers = int(sys.argv[2])

floors = range(1,floor_numbers+1)

command_list = parse_commands(fileArg)

my_que = que()

current = state()

cid = command_index(0)

while not len(command_list)<=cid.n:

    while not load_commands(current,command_list,cid,my_que):
        current.time+=.5
    
    while not my_que.empty():
    
        move(current,my_que)
        
        print("Time: " + str(current.time) + "  Floor: " + str(current.floor))










