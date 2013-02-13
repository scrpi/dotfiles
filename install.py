import os

SUFFIX =       ".symlink"
DOTFILES_DIR = "dotfiles/"

def find_valid_files():
    ls = os.listdir(".")
    new_list = []
    for f in ls:
        if len(f) > len(SUFFIX) and f[-len(SUFFIX):] == ".symlink":
            new_list.append(f)
    return new_list

def create_symlink(f):
    home_dir = os.path.expanduser("~")
    link = ".{}".format(f)
    target = "{}{}".format(f, SUFFIX)
    if not os.path.lexists(os.path.join(home_dir, link)):
        print "Creating link \"{}\" to target \"{}\".".format(link, target)
        os.symlink(DOTFILES_DIR + target, os.path.join(home_dir, link))
    else:
        print "{} already exists in home directory.".format(link)

if __name__ == "__main__":
    dir_list = find_valid_files()

    print "Found {} files/directories that can be symlinked".format(len(dir_list))

    for f in dir_list:
        link_name = f[:len(f)-len(SUFFIX)]
        create_symlink(link_name)
