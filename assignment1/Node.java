import java.util.Map;

public class Node{
    private int[] tasks = new int[8];
    private int[][] penalties;
    private int penalty;
    private Node parent;

    public Node(int[][] penalties){
        this.penalties = penalties;
    }

    public Node(int[][] penalties, Node parent){
        this.penalties = penalties;
        this.penalty = parent.getPenalty();
    }

    public void setTask(char machine, int task) throws Exception{
        int machineNum = getMachineNumber(machine);
        if(machineNum < 0 || machineNum > 7) throw new Exception("FAIL");
        tasks[getMachineNumber(machine)] = task;
        penalty += penalties[machineNum][task];
    }

    public int getPenalty(){
        return penalty;
    }

    public static int getMachineNumber(char machine){
        switch(machine){
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
}
