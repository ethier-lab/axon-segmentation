# -*- coding: utf-8 -*-
"""
Created on Thu Apr 30 22:27:21 2020

@author: Matthew

command line tool for editing all masks in a directory, remembering which is the last one which was opened
"""

#place this python file in the Preliminary Dataset folder for ease
import os, glob, numpy as np

#move to folder, change to either 'Aaron and Gabriela', 'Gabriela and Vidisha' or 'Vidisha and Aaron'
os.chdir('Aaron and Gabriela')
#load in filenames
images=glob.glob('image*')
masks=glob.glob('mask*')
masks.sort()
images.sort()
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
    command='cmd /c ' + 'itk-snap -g '+images[i]+' -s '+masks[i]
    os.system(command)
    edited = np.append(edited, i)
    np.savetxt('editedList.csv', edited, delimiter=',')
    cont = input('continue? y/n  \n')
    if cont!='y':
        break



