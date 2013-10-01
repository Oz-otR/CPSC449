import java.util.Map;

public class Node{
    private static long[][] penalties;
    private static long[][] tooNearPenalties;

    private int[] tasks = new int[8];
    private boolean[] assigned;

    public Node(int[] tasks, long[][] penalties, long[][] tooNearPenalties){
        this.penalties = penalties;
        this.tooNearPenalties = tooNearPenalties;
        this.tasks = tasks;
    }

    public Node(Node parent){
        for(int i = 0; i < 8; i++){
            tasks[i] = parent.getTask(i);
            if(tasks[i] != -1) assigned[tasks[i]] = true;
        }
    }

    public void setTask(int machine, int task) throws Exception{
        if(machine < 0 || machine > 7) throw new Exception("invalid machine");
        if(task < 0 || task > 7) throw new Exception("invalid task");
        if(tasks[machine] != -1) throw new Exception("machine already assigned");
        for(int i = 0; i < 8; i++){
            if(tasks[i] == task) throw new Exception("task already assigned");
        }

        assigned[task] = true;
        tasks[machine] = task;
    }
    
    public int getTask(int machine){
        return tasks[machine];
    }

    public long getPenalty(){
        long penalty = 0;
        for(int i = 0; i < 8; i++){
            if(tasks[i] != -1){
                penalty += penalties[i][tasks[i]];
                if(tasks[(i + 1) % 8] != -1){
                    penalty += tooNearPenalties[i][(i + 1) % 8];
                }
            }
        }
        return penalty;
    }

    public long getTaskCount(){
        long count = 0;
        for(int i = 0; i < 8; i++){
            if(tasks[i] != -1) count++;
        }
        return count;
    }
    
    public int[] getRemainingTasks(){
        // Count how many remaining tasks there are.
        int count = 0;
        for(int i = 0; i < 8; i++){
            if(tasks[i] == -1) count++;
        }

        // Create the result array of size count.
        int[] result = new int[count];

        // Fill the result array.
        for(int i = 0; i < 8; i++){
            if(!assigned[i]) result[--count] = i;
        }
        return result;
    }

    public int getFreeMachine(){
        int result = 0;
        while(tasks[result] != -1) result++;
        return result;
    }

    public static int getTaskNumber(char task){
        switch(task){
            case 'a':
                return 0;
            case 'b':
                return 1;
            case 'c':
                return 2;
            case 'd':
                return 3;
            case 'e':
                return 4;
            case 'f':
                return 5;
            case 'g':
                return 6;
            case 'h':
                return 7;
            default:
                return -1;
        }
    }

    public static int getTaskNumber(String task){
        task = task.toLowerCase();
        if(task == "a") return 0;
        if(task == "b") return 1;
        if(task == "c") return 2;
        if(task == "d") return 3;
        if(task == "e") return 4;
        if(task == "f") return 5;
        if(task == "g") return 6;
        if(task == "h") return 7;
        return -1;
    }
}
