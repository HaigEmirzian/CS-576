#!/usr/bin/env python3

import sys
import os

if len(sys.argv) > 1:
    directory = sys.argv[1]
else:
    directory = "null.txt"

home = os.path.expanduser('~')
fn = home + "/" + directory

correct_path = os.path.realpath(fn)

print("Sending file: " + correct_path)

if ".." in correct_path:
    print("bad")
    exit(1)

if correct_path.startswith(home):
    print("good")
else:
    print("bad")
    exit(1)

if "&" in correct_path:
    print("bad")
    exit(1)

if ";" in correct_path:
    print("bad")
    exit(1)

ret = os.system("cat " + fn)

if ret:
    status = "with error"
else:
    status = "successfully"

print (">> Program finished %s" % status) 
