import java.util.LinkedList;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.Scanner;
import java.io.FileReader;
import java.io.FileNotFoundException;

public class Main {
	public static void main(String[] args) {
        Scanner in = null;
        try{
		    in = new Scanner(new BufferedReader(new FileReader(args[1])));
        } catch (FileNotFoundException e){
            System.out.println("file not found");
            return;
        }

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
}
