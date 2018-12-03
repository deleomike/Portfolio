import signal, os, time

TIMER = 1/1000

def handler(signum, frame):
    millis = int(round(time.time() * 1000))
    d = millis - init
    print ('Signal Handler Called with Signal', signum, 'Milliseconds:',millis-init)
    signal.setitimer(signal.ITIMER_REAL,TIMER)

# Set the signal handler and a 5-second alarm
#original_SIGINT_handler = signal.getsignal(signal.SIGINT)
previous_time = 0
signal.signal(signal.SIGALRM, handler)
signal.setitimer(signal.ITIMER_REAL,TIMER,TIMER)

init = int(round(time.time()*1000))
