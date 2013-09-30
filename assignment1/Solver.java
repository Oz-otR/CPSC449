public class Solver{
    private static Node solve(Node n, boolean[][] forbidden, boolean[][] tooNear){
        return solve(n, null, forbidden, tooNear);
    }

    private static Node solve(Node n, Node bestNode, boolean[][] forbidden, boolean[][] tooNear){
        // Set the best penalty found so far to infinity.

        // Check if the number of assigned tasks for n is 8.
        if(n.getTaskCount() >= 8){
            // There are no more empty slots, get the penalty value for this configuration.
            bestNode = this;
        } else {
            // There is still at least one task to assign.

            // Find a free machine.
            int m = n.getFreeMachine();

            // Create a branch for each remaining task.
            for(int t : n.getRemainingTasks()){

                // Check if the task assignment is forbidden.
                if((forbidden == null || !forbidden[m][t]) && 
                   (tooNear == null || n.getTask((m-1) % 8) == -1 ||
                    n.getTask((m-1) % 8) != -1 && !tooNear[n.getTask((m-1) % 8)][t]))
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
                        Node nextBestNode = solve(next, forbidden, tooNear);
                        long nextBest = nextBestNode.getPenalty();
                        if(bestNode == null || nextBest < bestNode.getPenalty()){
                            bestNode = nextBestNode;
                        }
                    }
                }
            }
        }
        return bestNode;
    }
}
