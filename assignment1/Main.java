import java.util.ArrayList;
import java.util.LinkedList;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
<<<<<<< HEAD
import java.io.InputStreamReader;
import java.io.FileWriter;
import java.util.Dictionary;
=======
>>>>>>> origin/master
import java.util.Scanner;
import java.io.FileReader;
import java.io.FileNotFoundException;


public class Main {
<<<<<<< HEAD

	/**
	 * @param args
	 */
	public static void main(String[] args){
		FileWriter output = new FileWriter(args[2]);
		try(output.open()) catch(IOException e{
		Scanner in = new Scanner(new BufferedReader(new InputStreamReader(System.in)));
=======
	public static void main(String[] args) {
        Scanner in = null;
        try{
		    in = new Scanner(new BufferedReader(new FileReader(args[1])));
        } catch (FileNotFoundException e){
            System.out.println("file not found");
            return;
        }

>>>>>>> origin/master
        String line;

        line = rtrim(skip(in));
        if(!matches(line, "Name:")) return;
		String name = rtrim(in.nextLine()); // Get name.

        /* Skip all blank lines. */
        line = skip(in);

        if(!matches(line, "forced partial assignment:")) return;
        try{
            int[] forcedAssignments = Parser.parseForcedAssignments(getLines(in));
        } catch(IOException e){
            System.out.println(e.getMessage());
            return;
        }
		
        /* Skip all blank lines. */
        line = skip(in);
        if(!matches(line, "forbidden machine:")) return;
        try{
            boolean[][] forbiddenMachine = Parser.parseForbiddenMachines(getLines(in));
        } catch(IOException e){
            System.out.println(e.getMessage());
            return;
        }
        
        /* Skip all blank lines. */
        line = skip(in);
        if(!matches(line, "too-near tasks:")) return;
        try{
            boolean[][] tooNear = Parser.parseTooNearTasks(getLines(in));
        } catch (IOException e){
            System.out.println(e.getMessage());
            return;
        }

        /* Skip all blank lines. */
        line = skip(in);
        if(!matches(line, "machine penalties")) return;
        try{
            long[][] machinePenalties = Parser.parseMachinePenalties(getLines(in));
        } catch (IOException e){
            System.out.println(e.getMessage());
            return;
        }

        /* Skip all blank lines. */
        line = skip(in);
        if(!matches(line, "too-near penalities")) return;
        try{
            long[][] tooNearPenalties = Parser.parseTooNearPenalties(getLines(in));
        } catch (IOException e){
            System.out.println(e.getMessage());
            return;
        }
    }

    /** Check if the line matches the title. */
    private static boolean matches(String line, String match){
        if(line != match){
            System.out.println("Error while parsing input file");
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
			e.printStackTrace();
			System.out.println("File Not Found!");
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
				e.printStackTrace();
				System.out.println("Error writing to file");
			}
	}
}
