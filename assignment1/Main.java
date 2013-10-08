import java.util.ArrayList;
import java.util.LinkedList;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.FileWriter;
import java.util.Dictionary;
import java.util.Scanner;
import java.io.FileReader;
import java.io.FileNotFoundException;


public class Main {
    static String[] _args;
	public static void main(String[] args) {
        _args = args;
        if(args.length != 2){
            System.out.println("Usage: <input file> <output file>");
            return;
        }
        Scanner in = null;
        try{
		    in = new Scanner(new BufferedReader(new FileReader(_args[0])));
        } catch (FileNotFoundException e){
            String s = "file not found";
			WriteToFile(s, _args[1]);
            return;
        }
        
        String line;

        line = rtrim(skip(in));
        if(!matches(line, "Name:")) return;
		String name = rtrim(in.nextLine()); // Get name.

        /* Skip all blank lines. */
        line = skip(in);

        if(!matches(line, "forced partial assignment:")) return;
		int[] forcedAssignments;
        try{
            forcedAssignments = Parser.parseForcedAssignments(getLines(in));
        } catch(IOException e){
            String s = e.getMessage();
			WriteToFile(s, _args[1]);
            return;
        }
		
        /* Skip all blank lines. */
        line = skip(in);
        if(!matches(line, "forbidden machine:")) return;
		boolean[][] forbiddenMachine;
        try{
            forbiddenMachine = Parser.parseForbiddenMachines(getLines(in));
        } catch(IOException e){
            String s = e.getMessage();
			WriteToFile(s, _args[1]);
            return;
        }
        
        /* Skip all blank lines. */
        line = skip(in);
        if(!matches(line, "too-near tasks:")) return;
		boolean[][] tooNear;
        try{
            tooNear = Parser.parseTooNearTasks(getLines(in));
        } catch (IOException e){
            String s = e.getMessage();
			WriteToFile(s, _args[1]);
            return;
        }

        /* Skip all blank lines. */
        line = skip(in);
        if(!matches(line, "machine penalties")) return;
		long[][] machinePenalties;
        try{
            machinePenalties = Parser.parseMachinePenalties(getLines(in));
        } catch (IOException e){
            String s = e.getMessage();
			WriteToFile(s, _args[1]);
            return;
        }

        /* Skip all blank lines. */
        line = skip(in);
        if(!matches(line, "too-near penalities")) return;
		long[][] tooNearPenalties;
        try{
            tooNearPenalties = Parser.parseTooNearPenalties(getLines(in));
        } catch (IOException e){
            String s = e.getMessage();
			WriteToFile(s, _args[1]);
            return;
        }
		
        String result;
        try{
            result = Solver.solve(forcedAssignments, forbiddenMachine, tooNear, machinePenalties, tooNearPenalties).toString();
        } catch (Exception e){
            result = "Something went terrible wrong!" + e.getMessage();
        }
		WriteToFile(result, _args[1]);
    }

    /** Check if the line matches the title. */
    private static boolean matches(String line, String match){
        if(line != match){
            String s = "Error while parsing input file";
			WriteToFile(s, _args[1]);
            return false;
        }
        return true;
    }
        
    /** Gets the next section of lines. */
    private static LinkedList<String> getLines(Scanner in){
        LinkedList<String> lines = new LinkedList<String>();
        if(in.hasNext()){
            do{
                lines.add(rtrim(in.nextLine()));
            } while(in.hasNext());
        }
        return lines;
    }

    /** Moves forward through the scanner until a non-empty line
     *  is found. */
    private static String skip(Scanner in){
        String line = null;
        if(in.hasNext()){
            do{
                line = in.nextLine();
            } while (in.hasNext() && line.trim() == "");
        }
        return line;
    }

    /** Trim whitespace from only the right side of the string. */
    private static String rtrim(String s){
        if (s == null) return null;
        int i = s.length() - 1;
        for(; i >= 0 && Character.isWhitespace(s.charAt(i)); i--);
        return s.substring(0, i + 1);
    }
    
	public static LinkedList<String> ReadFromFile(String readFileName){
		
		LinkedList<String> linesOfFile = new LinkedList<String>();
		Scanner fileScanner;
		try {
			//new File(System.getProperty("user.dir") + "/" + 
			fileScanner = new Scanner(new File(readFileName));
			while (fileScanner.hasNextLine()){
			    linesOfFile.add(fileScanner.nextLine().trim());
			}
			fileScanner.close();
			
		} catch (FileNotFoundException e) {
			String s = "File not found!";
			WriteToFile(s, _args[1]);
		}
		
		return linesOfFile;
	}
	
	public static void WriteToFile(String inputStringToFile, String fileName) {
		try {
			File file = new File(fileName);
	 
			if (!file.exists()) {
				file.createNewFile();
			}
 
			FileWriter fw = new FileWriter(file.getAbsoluteFile(),true); //false to overwrite, true to append
			BufferedWriter buffWriter = new BufferedWriter(fw);
			buffWriter.write(inputStringToFile);
			buffWriter.newLine();
			buffWriter.close();
 
			System.out.println("Done writing to file.");
	 
			} catch (IOException e) {
				System.out.println("Error writing to file");
			}
	}
}
