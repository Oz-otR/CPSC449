import java.io.IOException;
import java.util.LinkedList;

public class Parser{

    // Return some data structure containing forced parcial assignments.
    public static int[] parseForcedAssignments(LinkedList<String> in) throws IOException{
        int[] result = new int[8];
        for(int i = 0; i < 8; i++){
            result[i] = -1;
        }

        int machine;
        int task;

        for(String line : in){
            String[] split = line.substring(1, line.length() - 1).split(",");
            machine = Integer.parseInt(split[0]);
            task = Node.getTaskNumber(split[1]);
            if(machine>7 || machine<0) throw new IOException("invalid machine");
            if(task>7 || task<0) throw new IOException("invalid task");
            if(result[machine] != -1) throw new IOException("partial assignment error");

            result[machine] = task;
        }

        return result;
    }
    
    // Return a map ((machine, task) -> boolean) containing forbidden machines.
        public static boolean[][] parseForbiddenMachines(LinkedList<String> in) throws IOException{
        boolean[][] result = new boolean[8][8];
        int machine;
        int task;
        for(String line : in){
            String[] split = line.substring(0, line.length() - 1).split(",");
            machine = Integer.parseInt(split[0]);
            task = Node.getTaskNumber(split[1]);
            
            /* Catch errors. */
            if(task<0 || task>7) throw new IOException("invalid task");

            result[machine][task] = true;
        }
    	
    return result;
    }
    
    // Return some data structure containing Too-Near tasks.
    public static boolean[][] parseTooNearTasks(LinkedList<String> in) throws IOException{
        boolean[][] result = new boolean[8][8];
        int machine;
        int task;
        int task1;
        int task2;
        for(String line : in){
            String[] split = line.substring(0, line.length() - 1).split(",");
            task1 = Node.getTaskNumber(split[0]);
            task2 = Node.getTaskNumber(split[1]);
            if(task2 < 0 || task1 < 0) throw new IOException("invalid task");
            result[task1][task2] = true;
        }

        return result;
	}
	
    // Return a 2D matrix of penalties.
    public static long[][] parseMachinePenalties(LinkedList<String> in) throws IOException{
        long[][] result = new long[8][8];

        /* Check input length. */
        if (in.size() != 8) throw new IOException("machine penalty error");

        int i = 0;
        for(String line : in){
            String[] split = line.split(",");
            
            /* Check input length. */
            if(split.length != 8) throw new IOException("machine penalty error");

            for(int j = 0; j < 8; j++){
                try{
                    result[i][j] = Long.parseLong(split[j]);
                } catch (NumberFormatException e){
                    throw new IOException("invalid penalty");
                }
            }

            i++;
        }
        return result;
    }
    // Returns an 8x8 matrix of pentalties, where [x][y] is the penalty for having y run on the machine next to x
    public static long[][] parseTooNearPenalties(LinkedList<String> in) throws IOException{
        long[][] result = new long[8][8];
        int sp = 0;
        int machine;
        int task;
        int task1;
        int task2;
        long value;
        for(String line : in){
            String[] split = line.substring(0, line.length() - 1).split(",");
            try{
                task1 = Node.getTaskNumber(split[0]);
                task2 = Node.getTaskNumber(split[1]);
            } catch (NumberFormatException e){
                throw new IOException("invalid task");
            }
            if(task1 < 0 || task2 < 0) throw new IOException("invalid task");
            try{
                value = Long.parseLong(split[2]);
            } catch (NumberFormatException e){
                throw new IOException("invalid penalty");
            }

            result[task1][task2] = value;
        }

        return result;
    }
}
