import threading

x = 0

def inc():
    global x 
    "pc = 0"
    x = x+1
    "pc = 1"

thread = {}

for i in range(1000):
    thread[i] = threading.Thread(target=inc)
    thread[i].start()

for i in range(1000):
    thread[i].join()
    
assert x == 1000