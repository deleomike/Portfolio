import os
import csv
import sys
import time

#FILE: data_util.py
#AUTHOR: Mike DeLeo
#SUMMARY: This file has helper functions to assist in accessing global variables and  pin data
#Note: config.txt must be in same folder as this. It doesnt matter where the other csv files are,
#so long as the addresses in the file are correct

#TODO: Maybe make it so the header directs the program to the data

####################################################
#Precondition: Nothing
#Postcondition: Returns the turn value from the globals.txt file
#Summary: Parses the globals.txt file for the turn value, and returns it
####################################################
def get_turn():
    lst = configure()
    with open(lst[0],'r') as csvfile:
        creader = csv.reader(csvfile,delimiter=',', quotechar = '|')
        next(creader) #header
        address = next(creader)
    #returns turn
    return int(address[0])

####################################################
#Precondition: integer value
#Postcondition: nothing
#Summary: Sets the value of turn in the file to the value given
####################################################
def set_turn(val):
    lst = configure()
    with open(lst[0],'r') as csvfile:
        creader = csv.reader(csvfile,delimiter=',', quotechar = '|')
        lines = list(creader)
    lines[1][0] = val
    with open(lst[0], 'w') as csvfile:
        cwriter = csv.writer(csvfile)
        cwriter.writerows(lines)


####################################################
#Precondition: Nothing
#Postcondition: Value of end_time
#Summary: Parses the globals.txt file for end_time, returns it
####################################################
def get_end_time():
    lst = configure()
    with open(lst[0],'r') as csvfile:
        creader = csv.reader(csvfile,delimiter=',', quotechar = '|')
        next(creader) #header
        address = next(creader)
    #returns end_time
    return int(address[1])

####################################################
#Precondition: Integer value
#Postcondition: nothing
#Summary: Assigns the value of end_time in globals.txt to the value given
####################################################
def set_end_time(val):
    lst = configure()
    with open(lst[0],'r') as csvfile:
        creader = csv.reader(csvfile,delimiter=',', quotechar = '|')
        lines = list(creader)
    lines[1][1] = val
    with open(lst[0], 'w') as csvfile:
        cwriter = csv.writer(csvfile)
        cwriter.writerows(lines)

####################################################
#Precondition: nothing
#Postcondition: array of pin values (strings) from data.txt
#Summary: Parses the data.txt file for pin data, returns it
####################################################
def get_data():
    lst = configure()
    with open(lst[1],'r') as csvfile:
        creader = csv.reader(csvfile,delimiter=',', quotechar = '|')
        next(creader) #header
        address = next(creader)
    #returns data
    return address

####################################################
#Precondition: array of integers
#Postcondition: nothing
#Summary: Assigns the value of pin data to pin data in data.txt
####################################################
def set_data(arr):
    lst = configure()
    with open(lst[1],'r') as csvfile:
        creader = csv.reader(csvfile,delimiter=',', quotechar = '|')
        lines = list(creader)
    lines[1] = arr
    with open(lst[1], 'w') as csvfile:
        cwriter = csv.writer(csvfile)
        cwriter.writerows(lines)

####################################################
#Precondition: nothing
#Postcondition: list of file address
#Summary: Retrieves addresses of globals and data files from config.txt
####################################################
def configure():
    init = int(round(time.time()*1000))
    CONFIG_ADD = os.path.join(sys.path[0],"config.txt")
    with open(CONFIG_ADD,'r') as csvfile:
        creader = csv.reader(csvfile,delimiter=',', quotechar = '|')
        next(creader) #header
        address = next(creader)
        #print(address)
        GLOBAL_ADD, DATA_ADD = address
    #print(GLOBAL_ADD)
    #print(DATA_ADD)
    final = int(round(time.time()*1000))
    #print("time taken (ms)",final-init)
    return address


