

import sys
import subprocess
from os.path import dirname, realpath
from unittest import TestLoader, TextTestRunner

from os.path import dirname, pardir, join, realpath

cwd = dirname(realpath(__file__))
root = realpath(join(cwd, pardir, pardir, pardir, pardir, pardir))
runtime = join(root, "ClientRuntimes", "Python", "msrest")
sys.path.append(runtime)


def sort_test(x, y):

    if x == 'test_ensure_coverage' :
        return 1
    if y == 'test_ensure_coverage' :
        return -1
    return (x > y) - (x < y)

if __name__ == '__main__':

    cwd = dirname(realpath(__file__))

    #server = subprocess.Popen("node ../../../../AutoRest/TestServer/server/startup/www.js")
    try:
        runner = TextTestRunner(verbosity=2)

        test_loader = TestLoader()    
        test_loader.sortTestMethodsUsing = sort_test

        suite = test_loader.discover(cwd, pattern="*_tests.py")
        runner.run(suite)
    
    finally:
        pass
        #server.kill()
