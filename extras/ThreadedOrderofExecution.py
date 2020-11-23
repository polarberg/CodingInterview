from threading import Thread
from time import sleep
import concurrent.futures
import logging

def threaded_function(n, result):
    logging.info("Thread %d: starting", n)
    sleep(n)
    print("Appending %d", n)
    result.append(n)
    logging.info("Thread %d: finishing", n)

def make_thread(n, result): # n = amount to sleep
    thread = Thread(target=threaded_function, args=(n,result))
    thread.start()

def sleep_sort(numbers):
    result = []
    for n in numbers:
        make_thread(n,result)   # make one thread at a time but we assume start about the same time 
    # So how can we wait here for all threads to finish 
    while len(result) != len(numbers):
        1
    return result 

if __name__ == "__main__":
    format = "%(asctime)s: %(message)s"
    logging.basicConfig(format=format, level=logging.INFO,
                        datefmt="%H:%M:%S")
    
    numbers = [3,2,1,50,2.5]
    # method 1 
    print(sleep_sort(numbers))

    # method 2 - Using a ThreadPoolExecutor
    size = len(numbers)
    with concurrent.futures.ThreadPoolExecutor(max_workers=size) as executor: 
        executor.map(threaded_function, range(size))