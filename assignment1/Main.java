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
            int[] forcedAssignments = Parser.parseForcedAssignments(lines);
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
            boolean[][] forbiddenMachine = Parser.parseForbiddenMachines(lines);
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
}
