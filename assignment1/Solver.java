public class Solver{
  public static Node solve(int[] forced, boolean[][] forbidden, boolean[][] tooNear, long[][] penalties, long[][] tooNearPenalties) throws Exception{
    Node n = setupRoot(forced, forbidden, tooNear, penalties, tooNearPenalties);
    return solve(n,null,forbidden,tooNear);
  }
  
  private static Node solve(Node n, Node bestNode, boolean[][] forbidden, boolean[][] tooNear) throws Exception{
    // Set the best penalty found so far to infinity.
    
    // Check if the number of assigned tasks for n is 8.
    if(n.getTaskCount() >= 8){
      // There are no more empty slots, get the penalty value for this configuration.
      bestNode = n;
    } else {
      // There is still at least one task to assign.
      
      // Find a free machine.
      int m = n.getFreeMachine();
      
      // Create a branch for each remaining task.
      for(int t : n.getRemainingTasks()){
        
        // Check if the task assignment is forbidden.
    	int mPrev = m - 1 > -1 ? m - 1 : 7;
        int mNext = m + 1 < 8  ? m + 1 : 0;
        boolean isForbidden = (forbidden != null && forbidden[m][t]);
        boolean isTooNear = (tooNear != null && n.getTask(mPrev) != -1 && tooNear[n.getTask(mPrev)][t]);
        isTooNear = isTooNear || (tooNear != null && n.getTask(mNext) != -1 && tooNear[t][n.getTask(mNext)]);
        if(!isTooNear && !isForbidden)
        {
          // Create the new node and assign the task.
          Node next = new Node(n);
          
          try{
            next.setTask(m, t);
          } catch (Exception e){
            System.out.println(e.getMessage());
            return null; 
          }
          
          // Check if the subtree rooted at the new node
          // has a smaller penalty than the current best.
          if(bestNode == null || next.getPenalty() < bestNode.getPenalty()){
            Node nextBestNode = solve(next, bestNode, forbidden, tooNear);
            long nextBest = nextBestNode == null ? Long.MAX_VALUE : nextBestNode.getPenalty();
            if(bestNode == null || nextBest < bestNode.getPenalty()){
              bestNode = nextBestNode;
            }
          }
        }
      }
    }
    return bestNode;
  }

  public static Node setupRoot(int [] forced, boolean[][] forbidden, boolean[][] tooNearTask,long[][] penalties, long[][] tooNearPenalties) throws Exception{
      int[] taskArray;
      int prev_I;
      int next_I;
      int prevTask;
      int nextTask;
      int i=0;
      int tempMachine;
      int tempTask;
      boolean tooNear;
      
      taskArray=new int[8];
      while(i<8){
        taskArray[i]=-1;
        i++;
      }
      i=0;
      
      while(i<8){
        tempMachine=i;
        tempTask=-1;
        if(forced[i]!=-1){
            tempTask=forced[i];
        }
        
        //Check if Forbidden
        if(tempTask == -1){ i++; continue; }
        if(forbidden[tempMachine][tempTask]==true){
            throw new NoValidSolutionException();
        }
        
        taskArray[tempMachine]=tempTask;
        
        //Checking for too near task
        if(i==0) prev_I = 7; else prev_I = i - 1;
        if(i==7) next_I = 0; else next_I = i + 1;
        
        //Check for i-1 to i
        if(taskArray[prev_I] >=0 && taskArray[prev_I] < 8){
            prevTask=taskArray[prev_I];
            if(tooNearTask[prevTask][tempTask]){
              throw new NoValidSolutionException();
            }
        }
        
        //Check for i to 1+1
        if(taskArray[next_I]!=-1){
            nextTask=taskArray[next_I];
            if(tooNearTask[tempTask][nextTask]){
              throw new NoValidSolutionException();
            }
        }
        
        i++;
      }
      
      return new Node(taskArray, penalties, tooNearPenalties);
  }
}
