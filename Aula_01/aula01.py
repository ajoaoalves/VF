import time
import threading
import random

turn = random.choice([1,2]) #qual a vez do processo que vai executar a cada momento
want1 = False #Indica quando os processos querem executar o seu codigo
want2 = False #Indica quando os processos querem executar o seu codigo

def t1():
    global want1
    global want2
    global turn 
    while True: 
        want1 = True
        turn = 2

        while want2 and turn == 2:
            pass

        #critical section
        for c in 'verificacao':
            print(c, end='')
        print()

        want1= False
        # non critical section
        time.sleep(1)

def t2():
    global want1
    global want2
    global turn 
    while True: 
        want2 = True
        turn = 1

        while want1 and turn == 1:
            pass
        
        #critical section
        for c in 'formal':
            print(c, end='')
        print()

        want2= False
        # non critical section
        time.sleep(1)

thread1 = threading.Thread(target=t1)
thread2 = threading.Thread(target=t2)

thread1.start()
thread2.start()