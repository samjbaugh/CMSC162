import sys

import re

import string

import random

import copy

class quarter:

  def __init__(self,my_year,my_term):

      self.year=my_year

      self.term=my_term

      self.num_classes=0

      self.remaining = 0

      self.classes = []

      self.filled = False
      
      self.id = -1
      
      

  def set_num_classes(self,my_var):

      self.num_classes = my_var

      self.remaining = my_var



  def set_list(self,my_classes):

      self.classes = my_classes

      self.check()



  def add(self,new_class):

      self.classes.append(new_class)

      self.check()



  def add_list(self,new_class_list):

      self.classes = self.classes + new_class_list

      self.check()



  def check(self):

      self.remaining = self.num_classes - len(self.classes)

      if self.remaining==0:

         self.filled = True



  def equal(self,other_quarter):

      return self.year==other_quarter.year and self.term==other_quarter.term
  
            
            


class class_entry:

    def __init__(self,my_class_name,my_class_number,my_prereqs,my_req_status,my_rank,my_avail):

        self.class_number = my_class_number

        self.class_name = my_class_name

        self.prerequisites = my_prereqs

        self.rank = my_rank

        self.req_status = my_req_status

        self.avail = my_avail

        self.prof_ranking = 0
        
        self.groupID = -1
        
        self.id = -1

    def setgroup(self,groupID):
        
        self.groupID = groupID


class group:

    def __init__(self,group_name,group_number):

        self.name = group_name

        self.optnum = group_number

        self.contents = []

        self.satisfied = self.optnum == 0

    def add(self,course_num):

        self.contents.append(course_num)

    def set_contents(self,course_list):

        self.contents = course_list

    def satisfy(self,course_num):

        self.contents.remove(course_num)

        self.optnum = self.optnum - 1

        self.check()

    def check(self):

        self.satisfied = self.optnum == 0
  
  
class map_entry:
    
    def __init__(self,node,id):
        
        self.node = node
        
        self.id = id
                
        self.mapTo = []
        
        self.mapFrom = []

    def add(self,entry):
        self.mapTo.append(entry) 
        

        
        
a = """-------------------------------
FUNCTIONS HERE: ------------------------------------------------
"""  

def indexc(my_list):
    
    for ii in range(0,len(my_list)):
    
        my_list[ii].id = ii
        
def find_class(class_name,master_list):
    
    for item in master_list:
    
        if item.class_number == class_name:
            
            return item.id
        
    return -1
        
def transform(master_list):
    
    for item in master_list:
        
        for ii in range(0,len(item.prerequisites)):
            
            d = find_class(item.prerequisites[ii],master_list)
            
            if d==-1: 
                
                print("Error: Invalid Prerequisite Name")
                
            else:
                
                item.prerequisites[ii] = d
                
        
def create_map(master_list):
            
    req_map = []
    
    for ii in range(0,len(master_list)):
        
        if master_list[ii].prerequisites == []:
        
             req_map.append(map_entry(True,ii))
                          
        else:
            
            temp_entry = map_entry(False,ii)
             
            temp_entry.mapFrom = master_list[ii].prerequisites
            
            req_map.append(temp_entry)


    for item in req_map:
        
        if not item.node:
            
            for id in item.mapFrom:
                
                req_map[id].add(item.id)
                
    for item in req_map:
        
        for id in item.mapTo:
            
            item.mapTo += req_map[id].mapTo
    
    return req_map
            




def req_up(class_list,group_list,master_list):
    
    found = False
    
    for myclass in class_list:
    
        group_list[master_list[myclass].groupID].optnum -= 1
        
        group_list[master_list[myclass].groupID].check()
        
    all_sat = True
    
    for ij in group_list:
        
        if not ij.satisfied: all_sat=False
        
    return all_sat



def cycle(my_start,my_end):

    quarter_list = []

   # print(my_end.year)

    for ii in range(my_start.year,my_end.year+1):



       if(ii==my_start.year): 

            for ij in range(my_start.term,4): quarter_list.append(quarter(ii,ij))

       else:

           if(ii==my_end.year):

               for ij in range(1,my_end.term+1): quarter_list.append(quarter(ii,ij))

           else:

               for ij in range(1,4): quarter_list.append(quarter(ii,ij))

    indexc(quarter_list)

    return quarter_list



def availability(my_string,quarter_list):

    return_list=[]

    years = [2014,2015,2016,2017]

    terms = []

    if(my_string.find('A')==-1):

         cyears = True

    else: cyears = False

    if(my_string.find('F')>=0): terms.append(1)

    if(my_string.find('W')>=0): terms.append(2)

    if(my_string.find('S')>=0): terms.append(3)
    
    return_list = []
    
    for my_quarter in quarter_list:
    
        if (my_quarter.term in terms) and (my_quarter.year in years):
        
            return_list.append(my_quarter.id)
            
    return return_list
    
def find_classes(currentq,reqs_satisfied,req_map,index_list,master_list):
    
    return_list = []
    
    for my_id in index_list:
                
        if currentq.id in master_list[my_id].avail:
    
            if len(set(req_map[my_id].mapFrom).difference(set(reqs_satisfied)))==0:
    
                return_list.append(my_id)
    
    return return_list
    
    
def dynamic_ranking(found_list,group_list,req_map,master_list):
    
    for index in found_list:
        
         my_rank = master_list[index].rank
         
         temp = master_list[index]
                 
         if not group_list[temp.groupID].satisfied: 
              
              temp.rank += 3
              
        # my_rank += len(req_map[index].mapFrom)
         
         print(len(req_map[index].mapFrom))
         
         if my_rank>10:
             
             print("overflow")
             
             my_rank = 10
         
         

def group_up(class_list,group_list):
    
    for my_class in class_list:
        
        for groupID in range(0,len(group_list)):
                        
            if my_class.class_number in group_list[groupID].contents:
            
                my_class.setgroup(groupID)





















def trySchedule(master_list,group_list,quarter_list):
    
    jay = len(quarter_list)
    num_classes = 1
    reqs_satisfied = []
    total_reqs_satisfied = []
    major_requirements = False
    
    
    
    master_list.append(class_entry("Empty","",[],"",0,[]))
    
    empty_id = len(master_list)-1
    
    indexc(master_list)
    
    group_up(master_list,group_list)
    
    transform(master_list)
    
    req_map = create_map(master_list)
    
    
    index_list = []
    
    for item in master_list:
        
        index_list.append(item.id)


    for ii in range(0,len(quarter_list)):

        quarter_list[ii].set_num_classes(num_classes)


    a = "LOAD CLASSES:"
  
    for currentq in quarter_list:
        
       if currentq.num_classes ==0: continue
        
       tempy4 = find_classes(currentq,total_reqs_satisfied,req_map,index_list,master_list)
       
       dynamic_ranking(tempy4,group_list,req_map,master_list)
       

       temp_len = len(tempy4)
       
       if currentq.remaining >= temp_len:

           currentq.add_list(tempy4)

           reqs_satisfied += tempy4
           
           for my_id in tempy4:
               index_list.remove(my_id)
               
           if currentq.num_classes>temp_len:
           
                while not currentq.remaining==0:
                    
                    currentq.add(empty_id)

       else:

           while not currentq.filled:

               for yy in range(0,11):
                   ip = 10-yy

                   if currentq.filled: break

                   for currentClassID in tempy4:
                                              
                       if master_list[currentClassID].rank > ip:

                           currentq.add(currentClassID)
        
                           index_list.remove(currentClassID)

                           reqs_satisfied.append(currentClassID)

                           if currentq.filled: break
       
       if currentq.year==2014:
           b="debug"


       if req_up(reqs_satisfied,group_list,master_list): 
            print("Fulfilled!")

            major_requirements = True

       total_reqs_satisfied += reqs_satisfied

       reqs_satisfied = []

    if major_requirements: return quarter_list

    else: return quarter_list
    

