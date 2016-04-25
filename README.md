## lip tracking and eyes tracking  
![alt tag](https://github.com/yihui-he/proj2/blob/master/pic.png)
### Performance and extra points
As it is mentioned in homework, I implemented some advanced features. My snake is particle filter enhanced.  
- It can deal with sharp change, like in the middle of liptracking3.avi.  
- It can track other face features: eyes  
- For liptracking3 and liptracking4, my snake can track the full video.  
- For liptracking2, maybe my snake will lose tracking lip at frame:1493, able to track lip about 200 frames (Uncertainty is because of partical filter). However, eyes can be tracked in the full video.  

### Results
Tracking results are in avi format, already in my submission. After running the codes, they will be override by new results.  

### instuction on run the code  
To run the code, put images folders and all matlab scripts in the same folder. folder names should be liptracking2,liptracking3,liptracking4  
There are two ways to run my code.  
1. run entry.m, 3 online tracking will be done one by one.  
2. call function main.m in the way as described in homework  
main(foldername,root,startidx,endidx)   

Real time processing is shown frame by frame, but it's a bit slow. So you you can wait until the program finished, then watch the results.  
After program finished there will be a *video name*.avi for each testing sequence, for offline watching.  

