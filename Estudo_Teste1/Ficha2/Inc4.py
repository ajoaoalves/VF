import threading

N = 5

x = 0
l = threading.Lock()

def inc():
    global x
    # 0
    l.acquire()
    # 1
    y = x
    # 2
    x = y + 1
    # 3
    l.release()
    # 4

thread = [threading.Thread(target=inc) for i in range(N)]
for t in thread: t.start()
for t in thread: t.join()

assert x == N
