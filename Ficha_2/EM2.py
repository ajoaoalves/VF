import threading
import random

turn = random.choice([0, 1])
want = [False, False]

def t(i):
    global want
    global turn

    while True:
        # idle
        while True: 
            if random.choice([True, False]): break
        want[i] = True
        # want
        turn = 1-i
        # waiting
        while want[1-i] and turn == 1-i: pass
        # critical
        want[i] = False

thread1 = threading.Thread(target=t, args=(0,))
thread2 = threading.Thread(target=t, args=(1,))
thread1.start()
thread2.start()
