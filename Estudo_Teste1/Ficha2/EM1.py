import threading
import random

N = 5

s = threading.Lock()

def code():
    global x
    while True:
        # idle
        while True: 
            if random.choice([True, False]): break
        # wait
        s.acquire()
        # critical
        s.release()

ts = [threading.Thread(target=code) for i in range(N)]
for t in ts: t.start()
