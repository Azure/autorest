import sys
import subprocess
import os
import signal
from os.path import dirname, realpath
from unittest import TestLoader, TextTestRunner

from os.path import dirname, pardir, join, realpath

cwd = dirname(realpath(__file__))
root = realpath(join(cwd, pardir, pardir, pardir, pardir, pardir))
runtime = join(root, "ClientRuntimes", "Python", "msrest")
sys.path.append(runtime)
runtime = join(root, "ClientRuntimes", "Python", "msrestazure")
sys.path.append(runtime)

def sort_test(x, y):

    if x == 'test_ensure_coverage' :
        return 1
    if y == 'test_ensure_coverage' :
        return -1
    return (x > y) - (x < y)

#Ideally this would be in a common helper library shared between the tests
def start_server_process():
    cmd = "node ../../../../AutoRest/TestServer/server/startup/www.js"
    if os.name == 'nt': #On windows, subprocess creation works without being in the shell
        return subprocess.Popen(cmd)
    
    return subprocess.Popen(cmd, shell=True, preexec_fn=os.setsid) #On linux, have to set shell=True

#Ideally this would be in a common helper library shared between the tests
def terminate_server_process(process):
    if os.name == 'nt':
        process.kill()
    else:
        os.killpg(os.getpgid(process.pid), signal.SIGTERM)  # Send the signal to all the process groups    
    
if __name__ == '__main__':

    cwd = dirname(realpath(__file__))

    server = start_server_process()
    try:
        runner = TextTestRunner(verbosity=2)

        test_loader = TestLoader()    
        test_loader.sortTestMethodsUsing = sort_test

        suite = test_loader.discover(cwd, pattern="*_tests.py")
        result = runner.run(suite)
        if not result.wasSuccessful():
            sys.exit(1)

    finally:
        print "Killing server"
        terminate_server_process(server)
        print "Done killing server"
