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
            line = in.nextLine.trim();
        }
        MTPair[] forcedAssignments = parseForcedAssignments(lines);
		
        lines = new LinkedList<String>();
        line = in.nextLine().trim();
        while(line != ""){
            lines.add(line);
            line = in.nextLine.trim();
        }
        boolean[][] forbiddenMachine = parseForbiddenMachines(lines);

        lines = new LinkedList<String>();
        line = in.nextLine().trim();
        while(line != ""){
            lines.add(line);
            line = in.nextLine.trim();
        }

		String line = in.nextLine().trim();
		while(line.toCharArray()[0] == '('){
			String[] split = line.substring(1, line.length() -1).split(",");
			int machine = Integer.parseInt(split[0]);
			char task = split[1].toCharArray()[0];
			
			line = in.nextLine().trim();
		}
	}
	
    // Return some data structure containing forced parcial assignments.
	public static MTPair[] parseForcedAssignments(LinkedList<String> in) throws IOException{
		MTPair[] result = new MTPair[in.length]; // 8 machines maximum, each can only appear once.
		int sp = 0;
		char machine;
		char task;
		MTPair constraint;
		for(String line : in){
			String[] split = line.substring(0, line.length() - 1).split(",");
			machine = split[0].charAt(0);
			task = split[1].toLowerCase().charAt(0);
			constraint = new MTPair(machine, task);
			
			// Naive search for duplicate machines or tasks.
			for(MTPair p : result){
				if(p != null && (p.machine() == machine || p.task() == task)){
					throw new IOException("partial assignment error");
				}
			}
			result[sp++] = constraint;
		}
		
		return result;
	}
	
    // Return a map ((machine, task) -> boolean) containing forbidden machines.
	public static boolean[][] parseForbiddenMachines(LinkedList<String> in){
		boolean[][] result = new boolean[8][8];
		char machine;
		char task;
		for(String line : in){
			String[] split = line.substring(0, line.length() - 1).split(",");
			machine = split[0].toLowerCase().charAt(0);
			task = Integer.parseInt(split[1].charAt(0)) - 1;
			
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
        char machine;
        char task;
        for(String line : in){
            String[] split = line.substring(0, line.lengh() - 1).split(",");
            task1 = split[0].charAt(0) - 1;
            task2 = split[1].charAt(0) - 1;
            result[task1][task2] = true;
        }

        return result;
	}
	
    // Return a 2D matrix of penalties.
	public static int[][] parseMachinePenalties(LinkedList<String> in) throws IOException{
        int[][] result = new int[8][8];

        /* Check input length. */
        if (in.length != 8) throw new IOException("machine penalty error");

		for(int i = 0; i < 8; i++){
            String[] split = in[i].split();
            
            /* Check input length. */
            if(split.length != 8) throw new IOException("machine penalty error");

            for(int j = 0; i < 8; i++){
                result[i][j] = Integer.parseInt(split[j]);
            }
        }
        return result;
	}
	
	public static int[][] parseTooNearPenalties(LinkedList<String> in){
		
	}
}
