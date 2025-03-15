import threading

x = 0

def inc():
    global x
    # pc = 0
    x = x + 1
    # pc = 1

t0 = threading.Thread(target=inc)
t1 = threading.Thread(target=inc)
t0.start()
t1.start()
t0.join()
t1.join()

assert x == 2
