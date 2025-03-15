import threading

N = 2

x = 0

def inc():
    global x
    # pc = 0
    y = x
    print(y)
    # pc = 1
    x = y + 1
    print(x)
    # pc = 2

thread = [threading.Thread(target=inc) for i in range(N)]
for t in thread: t.start()
for t in thread: t.join()

assert x == N
