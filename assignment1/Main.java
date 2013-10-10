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
    
    /** main method */
	public static void main(String[] args) {
		// Initiate input file checks
		
		// Check if correct arguments are being used
		// Check if input file is valid
        _args = args;
        if(args.length != 2){
            System.out.println("Usage: <input file> <output file>");
            return;
        }
        Scanner in = null;
        try{
		    in = new Scanner(new BufferedReader(new FileReader(args[0])));
        } catch (FileNotFoundException e){
            String s = "file not found";
			WriteToFile(s, args[1]);
            return;
        }
        
        String line;
        
        // Retrieve name of input file
        line = rtrim(skip(in));
        if(!matches(line, "Name:")) {
        	return;
        }
		String name = rtrim(in.nextLine()); // Get name.
	    
        /* Skip all blank lines. */
        line = skip(in);
        
        // Test for forced partial assignments
        // Uses parseForcedAssignments(LinkedList <String>) from Parser
        // If forced partial assignment found, write error message to output file 
        if(!matches(line, "forced partial assignment:")) {
        	return;
        }
		int[] forcedAssignments = null;
        try{
            forcedAssignments = Parser.parseForcedAssignments(getLines(in));
		    for (int m=0; m<8; m++){
		    	if (forcedAssignments[m] != -1){
			    	for (int n=0; n<8; n++){
			    		if (n!=m && forcedAssignments[n] == forcedAssignments[m]){
			    			throw new PartialAssignmentErrorException();
			    		}
			    	}
		    	}
			}
        } catch(InvalidMachineTaskException e){
        	WriteToFile(e.getMessage(), _args[1]);
        } catch(Exception e){
            WriteToFile(e.getMessage(), _args[1]);
            return;
        }
		
        /* Skip all blank lines. */
        line = skip(in);
        
        // Test for forbidden machines
        // Uses parseForbiddenMachines(LinkedList<Strings>) from Parser
        // If forbidden machine assignment found, write error message to file
        if(!matches(line, "forbidden machine:")) return;
		boolean[][] forbiddenMachine = null;
        try{
            forbiddenMachine = Parser.parseForbiddenMachines(getLines(in));
        }
        catch(InvalidMachineTaskException e){
        	WriteToFile(e.getMessage(), _args[1]);
        } catch(Exception e){
			WriteToFile(e.getMessage(), _args[1]);
            return;
        }
        
        /* Skip all blank lines. */
        line = skip(in);
        
        // Test for too-near tasks
        // Uses parseTooNearTasks(LinkedList<Strings>) from Parser
        // If too-near tasks assignments are found, write error message to file
        if(!matches(line, "too-near tasks:")) return;
		boolean[][] tooNear = null;
        try{
            tooNear = Parser.parseTooNearTasks(getLines(in));
        } catch(InvalidMachineTaskException e){
        	WriteToFile(e.getMessage(), _args[1]);
        } catch(Exception e){
        	WriteToFile(e.getMessage(), _args[1]);
            return;
        }

        /* Skip all blank lines. */
        line = skip(in);
        
        // Get machine penalties and apply penalties
        // Uses parseMachinePenalties(LinkedList<Strings>) from Parser
        // If error, write error to output file
        if(!matches(line, "machine penalties:")) {
        	return;
        }
        
		long[][] machinePenalties = null;
        try{
            machinePenalties = Parser.parseMachinePenalties(getLines(in));
        } 
        catch(InvalidPenaltyException e){
        	WriteToFile(e.getMessage(), _args[1]);
        }
        catch (MachinePenaltyException e){
        	WriteToFile(e.getMessage(), _args[1]);
        }
        catch (Exception e){
        	WriteToFile(e.getMessage(), _args[1]);
            return;
        }

        /* Skip all blank lines. */
        line = skip(in);
        
        // Get too-near penalties and apply penalties
        // Uses parseTooNearPenalties(LinkedList<Strings>) from Parser
        // If error, write error to output file
        if(!matches(line, "too-near penalities")) {
        	return;
        }
		long[][] tooNearPenalties = null;
        try{
            tooNearPenalties = Parser.parseTooNearPenalties(getLines(in));
        } 
        catch(InvalidPenaltyException e){
        	WriteToFile(e.getMessage(), _args[1]);
        }
        catch (Exception e){
        	WriteToFile(e.getMessage(), _args[1]);
            return;
        }
		
        String result;
        try{
            result = Solver.solve(forcedAssignments, forbiddenMachine, tooNear, machinePenalties, tooNearPenalties).toString();
        } catch (NoValidSolutionException e){
        	result = e.getMessage();
        } catch (Exception e){
            result = "Something went terrible wrong! " + e.getMessage();
        }
		WriteToFile(result, _args[1]);
    }

    /** Check if the line matches the title. */
    private static boolean matches(String line, String match){
        if(!line.equals(match)){
            String s = "Error while parsing input file";
			WriteToFile(s, _args[1]);
            return false;
        }
        return true;
    }
        
    /** Gets the next section of lines. */
    private static LinkedList<String> getLines(Scanner in){
        LinkedList<String> lines = new LinkedList<String>();
        String line;
        if(in.hasNext()){
        	line = rtrim(in.nextLine());
        	while(!line.equals("")){
        		lines.add(line);
        		line = in.hasNext() ? rtrim(in.nextLine()) : "";
        	}
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
            } while (in.hasNext() && line.trim().equals(""));
        }
        return line;
    }

     /** Trim whitespace from only the right side of the string. 
      *  Start from end of the string
      *  Navigate to front of string until NO whitespace found
   	  *  Return the string consisting of the remaining characters
      */
    private static String rtrim(String s){
    	
        if (s == null) {
        	return null;
        }
        int i = s.length() - 1;
        for(; i >= 0 && Character.isWhitespace(s.charAt(i)); i--);
        return s.substring(0, i + 1);
    }
    
    /** Method to read from file given a filename
     *  Put lines read into a linked list of strings
     *  Return the linked list of strings
     */
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
	
	/** Method to write to file given a filename 
	 *  If file exists, create new file
	 *  Write string to file and add newline
	 *  Close the file
	 * 	Notify user of error if unable to write to file
	 */
	public static void WriteToFile(String inputStringToFile, String fileName) {
		try {
			File file = new File(fileName);
	 
			if (!file.exists()) {
				file.createNewFile();
			}
 
			FileWriter fw = new FileWriter(file.getAbsoluteFile(),false); //false to overwrite, true to append
			BufferedWriter buffWriter = new BufferedWriter(fw);
			buffWriter.write(inputStringToFile);
			buffWriter.newLine();
			buffWriter.close();
 
			System.out.println(inputStringToFile);
			System.out.println("Done writing to file.");
	 
			} catch (IOException e) {
				System.out.println("Error writing to file");
			}
	}
}
