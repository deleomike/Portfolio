import tkinter as tk
#tkinter is the gui
import data_util

#FILE: visual.py
#AUTHOR: Mike DeLeo
#SUMMARY: This file builds the visual. The visual includes the pumps, switches, and such

#CLASS: Application
#SUMMARY:
class Application(tk.Frame):
    ####################################################
    #Precondition:
    #Postcondition:
    #Summary:
    ####################################################
    def __init__(self, master=None):
        super().__init__(master)
        self.master = master
        self.pack()
        self.create_widgets()

    ####################################################
    #Precondition:
    #Postcondition:
    #Summary:
    ####################################################
    def create_widgets(self):
        self.hi_there = tk.Button(self)
        self.hi_there["text"] = "Hello World\n(Click Me)"
        self.hi_there["command"] = self.say_hi
        self.hi_there.pack(side="top")

        self.quit = tk.Button(self, text="QUIT", fg = "red", command = self.master.destroy)
        self.quit.pack(side="bottom")

    ####################################################
    #Precondition:
    #Postcondition:
    #Summary:
    ####################################################
    def say_hi(self):
        print("hi there, everyone")
        C = tk.Canvas(self, bg="white", height=250, width=300)
        
        coord = 10, 50, 240, 210
        arc = C.create_arc(coord, start=0, extent=150, fill="white")
        C.pack()


    #def update(self):
