import threading
import random

N=10

s = threading.Lock()

def code():
    global x
    while True:
        while True:
            if random.choice([True, False]):
                break
        #non-critical section
        s.acquire()
        # critical section
        s.release()

ts = [threading.Thread(target=code) for i in range(N)]

for t in ts:t.start()