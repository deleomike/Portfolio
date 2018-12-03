#import visual
import get_pins
#import tkinter as tk
import os
import signal
import time
from threading import Thread
import data_util
import sys

#FILE: main.py
#AUTHOR: Mike DeLeo
#SUMMARY: Main sets up the thread for collecting data from the pins,
#and the thread for handling the visualization
#NOTE: config file MUST be in same folder as the data_util.py file

TIMER = 1/10

#TODO: Map out how access to the critical region, and how it will be synchronized
#TODO: Time the program, when it runs to verify the timing requirements

####################################################
#Precondition: CTRL+C signal
#Postcondition: nothing
#Summary: Handler for the SIGINT signal. Waits for SIGINT, and then closes everything in program
####################################################
def closing_handler(signum, frame):
    print ('Signal Handler Called with Signal', signum)
    print ('Closing Program')
    #signal.getsignal(signal.SIGINT) = original_SIGINT_handler #restore original handler
    signal.setitimer(signal.ITIMER_REAL,0)
    data_util.set_end_time(1)
    time.sleep(3)
    pin_t.join()
    #root.quit()
    quit()
    #Joins thread, closes visual, exits program

####################################################
#Precondition: x => Timer => 0
#Postcondition: nothing
#Summary: Handler for timer that is called when the timer
#reaches 0. Updates visuals with new data from data.txt
####################################################
def update_visual_handler(signum, frame):
    millis = int(round(time.time() * 1000))
    d = millis - init
    print ('Visual Update Handler Called with Signal', signum, 'Milliseconds:',millis-init)
    signal.setitimer(signal.ITIMER_REAL,TIMER)
    #TODO: Call routine to update visual with data
    print ('Visual is Updated')


#end time = 0: continue operations
#end time = 1: let thread finish
data_util.set_end_time(0)
#Setup the closing signal handler, for ctr+c
original_SIGINT_handler = signal.getsignal(signal.SIGINT)
signal.signal(signal.SIGINT,closing_handler)

#setup handler for updating the visual
signal.signal(signal.SIGALRM, update_visual_handler)

#TODO: Establish semaphores to protect the critical region
#Critical region is the data file for the pins
#TODO: Allow configurability, by having a config file
data_util.set_turn(1)
#turn = 0: visual program's turn to access data
#turn = 1: pin program's turn to access data

#THREAD
#create a new thread to poll the pins for data
#starts thread for getting data from pins
pin_t = Thread(target=get_pins.pins_loop)
pin_t.start()

#root = tk.Tk()
#Create the application
#app = Application(master=root)


#Start timer for the signal interrup to update visual
init = int(round(time.time()*1000))
signal.setitimer(signal.ITIMER_REAL,TIMER,TIMER)

#Starts the visual program
#app.mainloop()

#TODO: Cleanup after forking
#TODO: Restore original sigint interrupt
