# Portfolio

Welcome to my Portfolio!

I have laid out a few of the reports here in the main of the repository, of these projects. 
For a quick overview of what I did, refer to those.

Table of Contents:
1. Acoustic Signals Research
    - This is my research with the Pennsylvania State University
    - I have included the proposal for the summer of 2018, as well as the product of my research
2. BattleShip Game
    - This is my final project for my Microprocessors Class, Junior Year
    - For this project, I used an object oriented coding style
    - The game is fully playable. To run it, download the Mars4_5 file, and if you have
        Java then it should run. Read the header of the battleship file for instructions on settings 
        you will need to choose to run the program.
3. FIR
    - For this project I implemented at 64 tap FIR filter
    - To do this, I first designed it in C++, so it would be easier to test
    - I made a script in matlab to evaluate the output so I was sure that it was providing the correct response
    - To test it, change the global variables indicated at the top of the file to your own file outputs/inputs
4. PLC Simulator
    - This is my capstone project.
    - Essentially my group and I designed a system to simulate a manufacturing process.
        - Refer to the report [PLC Simulator Report] for details, but it uses an MCU for real time simulation using the inputs from the PLC. 
        - Then creates a visualization with a raspberry pi.
    - The design is intended to be under $100 and will be used to replace existing hardware, as the existing hardware is expensive and does not allow varied simulations
    - This design is the infrastructure to whatever lab Penn State will want to run. Technically it can do any simulation they want.
5. Processor Simulation
    - I developed a simulation of a superscalar processor in C++
    - There are quite a few code files, but the one you should start at is main.cpp and follow the headers. That is the best way to understand it.
    - Essentially, the program takes an input of the form 
            .processor
            command
            command
        and creates an object for each processor, which contains the list of commands. Then the simulation
        pits each command from every processor against each other to test if there is a conflict. If there is,
        then it adds a stall inbetween until no conflict exists
6. Image2Haiku
    - This is a copy of the hackathon code of the Image2Haiku project
    - Dependencies
        1. Google GCP
        2. Clarifai API
        3. Flask
    - This won't run unless the dependencies and everything is properly installed
    - The project was made on the premise that technology is also useful for satisfying the human condition
    - How it Works:
        1. The user uploads a picture to the website, and it is stored on a server. 
        2. It is processed with Clarifai and Google GCP, and a list of relevant words is produced. 
        3. The the weather data for the location is accessed, and dictates the mood of the poem
        4. A list of synonyms is generated for the relevant words.
        5. The sentament value of the words is calculated with Google GCP, and based on this random arrangements are made
        6. Arrangements are checked to see if they match proper sentence structure and are reordered or discarded
        7. Three lines are made, and then displayed on screen.
