# -*- coding: utf-8 -*-
"""
Created on Thu Apr 30 22:27:21 2020

@author: Matthew

command line tool for editing all masks in a directory, remembering which is the last one which was opened
"""

import os, glob, numpy as np

#move to folder
os.chdir('images and masks')
#load in filenames
images=glob.glob('*image.tiff')
masks=glob.glob('*mask.png')
#editedList holds the indices which have been edited already
check=os.path.exists('editedList.csv')
if not check:
    file = open("editedList.csv", "w") 
    file.close()    
edited = np.loadtxt('editedList.csv', delimiter=',')

#find next unedited index
edited.sort()
if (len(edited)==0):
    startInd=0;
else:
    startInd=int(edited[-1]+1)    
print("\n\n\nstarting from first unedited mask, %s\n\n" % masks[startInd])

        
for i in range(startInd,len(masks),1):
    print("opening next unedited mask, name is %s\n" % masks[i])
    command='cmd /c "' + 'itk-snap -g '+images[i]+' -s '+masks[i] +'"'
    os.system(command)
    edited = np.append(edited, i)
    np.savetxt('editedList.csv', edited, delimiter=',')
#    cont = input('continue? y/n  \n')
#    if cont!='y':
#        break


