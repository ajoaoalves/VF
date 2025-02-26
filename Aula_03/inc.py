import threading

x = 0
l = threading.Lock()

def inc():
    global x 
    "pc = 0"
    l.acquire()
    "pc = 1"
    y = x
    "pc = 2"
    x = y+1
    "pc = 3"
    l.release()
    "pc = 4"
thread = {}

for i in range(10):
    thread[i] = threading.Thread(target=inc)
    thread[i].start()

for i in range(10):
    thread[i].join()
    
assert x == 10