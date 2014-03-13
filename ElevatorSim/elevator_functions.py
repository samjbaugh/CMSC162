from elevator_classes import state, command_index, command, que 

#Loads a single command into the que (if available)
def load_command(current,my_command,my_que,command_index):
    if current.time>=my_command.time:
        my_que.add(my_command)
        return True
    return False

#Loads multiple commands into the que (in the case that there is a backup of commands)
def load_commands(current,command_list,command_index,my_que):
    return_value=False
    while (load_command(current,command_list[command_index.n],my_que,command_index.n)):
        command_index.add()
        return_value = True
        if command_index.n>=len(command_list): return True
    return return_value
 
#Moves the elevator at maximum of one floor (this way isn't the most efficient, but makes it easy to display the elevator's current floor at all times)
def move(current,my_que):
    temp0 = my_que.contents[0]
    temp=temp0.floor
    
    if not temp0.direction==0:
        if temp0.direction==1:
            current.upness = True
        if temp0.direction==-1:
            current.upness = False
    
    if current.floor==temp:
        my_que.pop()
        current.open_doors()
    else: 
        if current.upness:
            if current.floor<temp:
                current.up()
        if not current.upness:
            if current.floor>temp:
                current.down()
                

#This parses a simple elevator-command textfile
def parse_commands(fileArg):

    command_list = []

    with open(fileArg) as file:
        text = file.read()
        lines = text.split('\n')


    lines=lines[2:]

    direction = 0

    print(len(lines))


    for line in lines:
        words = []
        words = line.split('	')
    
        if len(words)<3:
            break

        if words[0]=='N/A': direction=0
        if words[0]=='Up': direction=1
        if words[0]=='Down': direction=-1

        command_list.append(command(direction,int(words[1]),int(words[2])))

    return command_list

