public class Solver{
    public static long solve(Node n, boolean[][] forbidden, boolean[][] tooNear){
        // Set the best penalty found so far to infinity.
        long best = Integer.maxLong();

        // Check if the number of assigned tasks for n is 8.
        if(n.taskCount >= 8){
            // There are no more empty slots, get the penalty value for this configuration.
            best = n.getPenalty();
        } else {
            // There is still at least one task to assign.

            // Find a free machine.
            long m = n.nextFreeMachine();

            // Create a branch for each remaining task.
            for(long t : n.remainingTasks()){

                // Check if the task assignment is forbidden.
                if(!forbidden[m][t] && !tooNear[n.getTask(m-1)][t]){

                    // Create the new node and assign the task.
                    Node next = new Node(n);
                    next.setTask(m, t);

                    // Check if the subtree rooted at the new node
                    // has a smaller penalty than the current best.
                    if(next.getPenalty() < best){
                        long nextBest = solve(next);
                        best = nextBest < best ? nextBest : best;
                    }
                }
            }
        }
        return best;
    }
}
