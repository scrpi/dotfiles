#!/usr/bin/env python

import os
import sys

SUFFIX =       ".symlink"
DOTFILES_DIR = "dotfiles/"
    
HOME_DIR = os.path.expanduser("~")
if len(sys.argv) > 1: HOME_DIR = sys.argv[1]

def find_valid_files():
    ls = os.listdir(os.path.join(HOME_DIR, DOTFILES_DIR))
    new_list = []
    for f in ls:
        if len(f) > len(SUFFIX) and f[-len(SUFFIX):] == ".symlink":
            new_list.append(f)
    return new_list

def create_symlink(f):
    link = "." + f
    target = f + SUFFIX
    if not os.path.lexists(os.path.join(HOME_DIR, link)):
        print "Creating link \"" + link + "\" to target \"" + target + "\"."
        os.symlink(DOTFILES_DIR + target, os.path.join(HOME_DIR, link))
    else:
        print "%s already exists in home directory." % link

if __name__ == "__main__":
    dir_list = find_valid_files()

    print "Found %d files/directories that can be symlinked" % len(dir_list)

    for f in dir_list:
        link_name = f[:len(f)-len(SUFFIX)]
        create_symlink(link_name)
