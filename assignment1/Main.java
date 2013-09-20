import java.util.LinkedList;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Dictionary;
import java.util.Scanner;
import java.util.HashMap;

public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		Scanner in = new Scanner(new BufferedReader(new InputStreamReader(System.in)));
        String line;
        LinkedList<String> lines;

        line = in.nextLine().trim();
        if(line != "Name:") System.out.println("Error while parsing input file");
		String name = in.nextLine().trim(); // Get name.
		in.nextLine(); // Skip blank line.

        line = in.nextLine();
        if(line != "forced partial assignment:") System.out.println("Error while parsing input file");

        lines = new LinkedList<String>();
        line = in.nextLine().trim();
        while(line != ""){
            lines.add(line);
            line = in.nextLine().trim();
        }
        try{
            int[][] forcedAssignments = parseForcedAssignments(lines);
        } catch(IOException e){
            System.out.println(e.getMessage());
            return;
        }
		
        lines = new LinkedList<String>();
        line = in.nextLine().trim();
        while(line != ""){
            lines.add(line);
            line = in.nextLine().trim();
        }
        try{
            boolean[][] forbiddenMachine = parseForbiddenMachines(lines);
        } catch(IOException e){
            System.out.println(e.getMessage());
            return;
        }

        lines = new LinkedList<String>();
        line = in.nextLine().trim();
        while(line != ""){
            lines.add(line);
            line = in.nextLine().trim();
        }

		line = in.nextLine().trim();
		while(line.toCharArray()[0] == '('){
			String[] split = line.substring(1, line.length() -1).split(",");
			int machine = Integer.parseInt(split[0]);
			char task = split[1].toCharArray()[0];
			
			line = in.nextLine().trim();
		}
	}
	
    // Return some data structure containing forced parcial assignments.
	public static int[][] parseForcedAssignments(LinkedList<String> in) throws IOException{
        // Initialize the result array such that each element is -1;
        int[][] result = new int[in.size()][2];
        for(int i = 0; i < result.length; i++){
            result[i][0] = -1;
            result[i][1] = -1;
        }
        
		int sp = 0;
		int machine;
		int task;

		for(String line : in){
			String[] split = line.substring(0, line.length() - 1).split(",");
			machine = Node.getMachineNumber(split[0].charAt(0));
			task = Character.getNumericValue(split[1].toLowerCase().charAt(0));
			
			// Naive search for duplicate machines or tasks.
            for(int i = 0; i < result.length; i++){
                if(result[i][0] != -1 && (result[i][0] == machine || result[i][1] == task)){
					throw new IOException("partial assignment error");
				}
			}
            result[sp][0] = machine;
            result[sp][1] = task;
            sp++;
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
	
	public static int[][] parseTooNearPenalties(LinkedList<String> in){
		return null;
	}
}
