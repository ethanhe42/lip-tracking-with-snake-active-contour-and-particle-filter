proj2  
### Performance  
My snake is particle filter enhanced.  
It can deal with sharp change, like in the middle of liptracking3.avi.  
For liptracking3 and liptracking4, my snake can track the full video.  
For liptracking2, maybe my snake will lose tracking at frame:1493, able to track about 200 frames (Uncertainty is because of partical filter).  
### Results
Tracking results are in avi format, already in my submission. After running the codes, they will be override by new results.  
### instuction on run the code  
To run the code, put images folders and all matlab scripts in the same folder. folder names should be liptracking2,liptracking3,liptracking4
There are two ways to run my code.
1. run entry.m, 3 online tracking will be done one by one.  
2. call function main.m as described in homework  
main(foldername,root,startidx,endidx)   

Real time processing is shown frame by frame,  
After program finished there will be a *video name*.avi,  
for offline watching.  

