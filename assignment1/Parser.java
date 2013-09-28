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
            machine = Node.getMachineNumber(split[0].charAt(0));
            task = Character.getNumericValue(split[1].toLowerCase().charAt(0));

            if(result[machine] != -1) throw new IOException("partial assignment error");

            result[machine] = task;
        }

        return result;
    }
	
    // Return a map ((machine, task) -> boolean) containing forbidden machines.
        public static boolean[][] parseForbiddenMachines(LinkedList<String> in) throws IOException{
        boolean[][] result = new boolean[8][8];
        char machine;
        int task;
        for(String line : in){
            String[] split = line.substring(0, line.length() - 1).split(",");
            machine = split[0].toLowerCase().charAt(0);
            task = Character.getNumericValue(split[1].charAt(0)) - 1;
            
            /* Catch errors. */
            if(machine < 'a' || machine > 'h' || task < 0 || task > 7){
                throw new IOException("invalid machine/task");
            }

            result[Node.getMachineNumber(machine)][task] = true;
        }
		
    return result;
    }
	
    // Return some data structure containing Too-Near tasks.
    public static boolean[][] parseTooNearTasks(LinkedList<String> in){
        boolean[][] result = new boolean[8][8];
        int sp = 0;
        int machine;
        int task;
        int task1;
        int task2;
        for(String line : in){
            String[] split = line.substring(0, line.length() - 1).split(",");
            task1 = Character.getNumericValue(split[0].charAt(0)) - 1;
            task2 = Character.getNumericValue(split[1].charAt(0)) - 1;
            result[task1][task2] = true;
        }

        return result;
	}
	
    // Return a 2D matrix of penalties.
    public static int[][] parseMachinePenalties(LinkedList<String> in) throws IOException{
        int[][] result = new int[8][8];

        /* Check input length. */
        if (in.size() != 8) throw new IOException("machine penalty error");

        int i = 0;
        for(String line : in){
            String[] split = line.split(",");
            
            /* Check input length. */
            if(split.length != 8) throw new IOException("machine penalty error");

            for(int j = 0; j < 8; j++){
                result[i][j] = Integer.parseInt(split[j]);
            }

            i++;
        }
        return result;
    }
    // Returns an 8x8 matrix of pentalties, where [x][y] is the penalty for having y run on the machine next to x
    public static int[][] parseTooNearPenalties(LinkedList<String> in){
        int[][] result = new int[8][8];
        int sp = 0;
        int machine;
        int task;
        int task1;
        int task2;
        int value;
        for(String line : in){
            String[] split = line.substring(0, line.length() - 1).split(",");
            task1 = Character.getNumericValue(split[0].charAt(0)) - 1;
            task2 = Character.getNumericValue(split[1].charAt(0)) - 1;
            value = Character.getNumericValue(split[2].charAt(0));
            result[task1][task2] = value;
        }

        return result;
    }
}
