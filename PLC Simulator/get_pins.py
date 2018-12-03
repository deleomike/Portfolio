import os
import data_util

#FILE: pins.py
#AUTHOR: Mike DeLeo
#SUMMARY: Pins.py is in charge of getting the values of the pins,
#and placing them into a text file (Crit region).

####################################################
#Precondition: Nothing
#Postcondition: Nothing
#Summary: Loops till end_time is true. pulls and pushes
#data from pins to data files. Waits for turn, alternates with visual
####################################################
def pins_loop():
    end_time = data_util.get_end_time()
    turn = data_util.get_turn()
    while(end_time == 0):
        turn = data_util.get_turn()
        if (turn == 1):
            poll_pins()
            push_pins()
            data_util.set_turn(0)
            print('pins completed')
        end_time = data_util.get_end_time()

####################################################
#Precondition: Nothing
#Postcondition: Nothing
#Summary: Gets data from outgoing data set, pushes it to the the output pins
####################################################
def push_pins():
    print('pins: values pushed to pins')
    #TODO: Do a while loop to push data to pins, at some interval. Take data from a file

####################################################
#Precondition: Nothing
#Postcondition: Nothing
#Summary: Gets data from incoming pins, puts it into data.txt
####################################################
def poll_pins():
    #TODO: Write code to get data from pins
    data_util.set_data(['0','0','0','0','0'])
    print('pins: values polled from pins')
