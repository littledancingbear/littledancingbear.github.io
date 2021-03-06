"""
Script to edit ldb.org website seeking an arbitrary
NEEDLE and replacing it with REPLACEMENT; both being
global variables set at the top of the script.

by: Gauden Galea http://gaudengalea.com
date: 14-Mar-2014
license: Public Domain
"""

from path import path

DEBUG = True

NEEDLE = '<a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/deed.en_US"><span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">Website</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="ldb.org" property="cc:attributionName" rel="cc:attributionURL">Eberhard Wenzel</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/deed.en_US">Creative Commons Attribution-NonCommercial 4.0 International License</a>'

REPLACEMENT = '<a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/deed.en_US"><span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">Website</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="http://ldb.org" property="cc:attributionName" rel="cc:attributionURL">Eberhard Wenzel</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/deed.en_US">Creative Commons Attribution-NonCommercial 4.0 International License</a>'

LDB = path('..')


def save_file(f, data):
    result = False
    try:
        with open(f, 'wb') as fh:
            fh.write(data)
        result = True
    except:
        result = False
    return result


def walk(ndl, rep):
    count = 0
    for f in LDB.walk():
        top_dir = f.splitall()[1]
        if top_dir in ['src', '.git'] or f.isdir() or not f.endswith('htm'):
            continue
        data = f.text()
        if ndl not in data:
            print 'No NEEDLE found in: "{}"'.format(f)
        else:
            data = data.replace(ndl, rep)
            if save_file(f, data):
                print '{} Replacement completed in: "{}"'.format(count, f)
                count += 1
            else:
                print 'ERROR in: "{}"'.format(f)
        

def main():
    walk(ndl=NEEDLE,
         rep=REPLACEMENT)


if __name__ == '__main__':
    main()