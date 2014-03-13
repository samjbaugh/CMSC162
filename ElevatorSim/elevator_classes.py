import sys

floors=range(1,int(sys.argv[2]))


#This object keeps track of the elevator's state (whether or not it is going up or down, if it has opened its doors, et cetera)
class state:
    def __init__(self):
        self.floor = 1
        self.time = 0
        self.upness = True

    def up(self):
        new = self.floor+1
        if self.check(new): 
            self.floor = new
            self.time+=1

    def down(self):
        new = self.floor-1
        if self.check(new): 
            self.floor = new
            self.time+=1

    def check(self,new):
       if not new in floors:
           print("Error! Non applicable floor selected!")
           sys.exit()
       else: return True
    
    def open_doors(self):
        self.time+=5

#This object keeps track of the position in the command list
class command_index:
    def __init__(self,number):
        self.n=number
    def add(self):
        self.n+=1

#A simple que for commands
class que:
    def __init__(self):
        self.contents = []
    def pop(self):
        temp = self.contents[0]
        self.contents = self.contents[1:]
        return temp
    def add(self,item):
        self.contents.append(item)
    def empty(self):
        if len(self.contents)==0:
            return True
        return False

#An object representation of a command (has a direction, a time, and a floor. If the elevator is in motion, then the direction is N/A)
class command:
    def __init__(self,upness,time,floor):
        self.direction = upness
        self.time = time
        self.floor = floor
