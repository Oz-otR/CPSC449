import static org.junit.Assert.*;

import java.io.IOException;
import java.util.LinkedList;

import org.junit.Test;


public class JUnitTest {

	
	/////////////////////////////////////////////////////////////////////////////////
	//Parser tests
	@Test
	public void ParseForcedFullAssignmentTest() throws IOException {
		LinkedList<String> testResult = new LinkedList<String>();
		testResult.add("(1,a)");
		testResult.add("(2,b)");
		testResult.add("(3,c)");
		testResult.add("(4,d)");
		testResult.add("(5,e)");
		testResult.add("(6,f)");
		testResult.add("(7,g)");
		testResult.add("(8,h)");
		
        int[] expectedResult = new int[8];
        for(int i = 0; i < 8; i++){
            expectedResult[i] = i;
        }

        Parser testParser = new Parser();        
        assertEquals(Parser.parseForcedAssignments(testResult),expectedResult);
	}

	@Test
	public void ParseForcedPartialAssignmentTest() throws IOException {
		LinkedList<String> testResult = new LinkedList<String>();
		testResult.add("(1,a)");
		testResult.add("(2,b)");
		testResult.add("(3,c)");
		testResult.add("(7,g)");
		testResult.add("(8,h)");
		
        int[] expectedResult = {0,1,2,6,7};
        Parser testParser = new Parser();        
        assertEquals(Parser.parseForcedAssignments(testResult),expectedResult);
	}
	
	@Test(expected=IOException.class)
	public void InvalidForbiddenMachine() throws IOException {
		LinkedList<String> testResult = new LinkedList<String>();
		testResult.add("(a,5)");
		testResult.add("(x,l)");	   
		Parser.parseForbiddenMachines(testResult);
	}
	
	@Test
	public void ParseForbidAssignmentTest() throws IOException {
		LinkedList<String> testResult = new LinkedList<String>();
		testResult.add("(1,a)");
		testResult.add("(2,b)");
		
        boolean[][] expectedResult = new boolean[8][8];
		for (int i = 0; i<8; i++){
			for (int j = 0; j<8; j++){
				expectedResult[i][j] = false;
			}
		}
        expectedResult[0][0] = true;
        expectedResult[1][1] = true;
        
        assertArrayEquals(Parser.parseForbiddenMachines(testResult),expectedResult);
	}
	
	@Test
	public void TestParseMachinePenalty() throws IOException {
        int[][] expectedResult = new int[8][8];
		LinkedList<String> testResult = new LinkedList<String>();
		testResult.add("1 1 1 1 1 1 1 1");
		testResult.add("1 1 1 1 1 1 1 1");
		testResult.add("1 1 1 1 1 1 1 1");
		testResult.add("1 1 1 1 1 1 1 1");
		testResult.add("1 1 1 1 1 1 1 1");
		testResult.add("1 1 1 1 1 1 1 1");
		testResult.add("1 1 1 1 1 1 1 1");
		testResult.add("1 1 1 1 1 1 1 1");
		
		for (int i = 0; i<8; i++){
			for (int j = 0; j<8; j++){
				expectedResult[i][j] = 1;
			}
		}
		
       assertArrayEquals(expectedResult,Parser.parseMachinePenalties(testResult));
	}
	
	/////////////////////////////////////////////////////////////////////////////////
	//Node Tests
	
	/*
	public void GetMachineNumberTest(){
		//int testResult = Node.getMachineNumber('a');
		//int expectedResult = 0;
		
		assertEquals(testResult,expectedResult);
	}*/
	
	@Test
	public void GetTaskTest() throws Exception{
		int[] tasks = {0,1,2,3,4,5,6,7};
		long[][] penalties = new long[8][8];
		long[][] tooNearPenalties = new long[8][8];
		
		for (int i = 0; i<8; i++){
			for (int j = 0; j<8; j++){
				penalties[i][j] = 1;
				tooNearPenalties[i][j] = 1;
			}
		}
		
		Node testNode = new Node(tasks,penalties,tooNearPenalties);
		
		assertEquals(0,testNode.getTask(0));
	}

	@Test (expected=Exception.class)
	public void MachineAlreadyAssignedTest() throws Exception{
		int[] tasks = {0,1,2,3,4,5,6,7};
		long[][] penalties = new long[8][8];
		long[][] tooNearPenalties = new long[8][8];
		
		for (int i = 0; i<8; i++){
			for (int j = 0; j<8; j++){
				penalties[i][j] = 1;
				tooNearPenalties[i][j] = 1;
			}
		}
		
		Node testNode = new Node(tasks,penalties,tooNearPenalties);
		testNode.setTask(0, 0);
	}
	
	@Test
	public void FreeMachineTest(){
		int[] tasks = {0,1,2,3,4,5,6,7};
		long[][] penalties = new long[8][8];
		long[][] tooNearPenalties = new long[8][8];
		
		for (int i = 0; i<8; i++){
			for (int j = 0; j<8; j++){
				penalties[i][j] = 1;
				tooNearPenalties[i][j] = 1;
			}
		}
		
		Node testNode = new Node(tasks,penalties,tooNearPenalties);
		//testNode.setTask(0, 0);
	}
	
	//////////////////////////////////////////////////////////////////////////
	//Solver test
	/*
	@Test
	public void SetupRootTest(){
		int[] tasks = {0,1,2,3,4,5,6,7};
		long[][] penalties = new long[8][8];
		long[][] tooNearPenalties = new long[8][8];
		boolean[][] forbidden = new boolean[8][8];
		boolean[][] tooNearTask = new boolean[8][8];
		
		Node testNode = new Node(tasks,penalties,tooNearPenalties);
		try {
			assertEquals(testNode, Solver.setupRoot(tasks, forbidden, tooNearTask, penalties, tooNearPenalties));
		} catch (Exception e) {
			
			e.printStackTrace();
		}
	}
	*/
	
	/*
	@Test
	public void getPenaltyTest(){
		int testResult = Node.getMachineNumber('a');
		int expectedResult = 0;
		
		assertEquals(testResult,expectedResult);
	}*/
	
	/////////////////////////////////////////////////////////////////////////////////
	//Test examples
	@Test
	public void TestStub(){
		LinkedList<String> testResult = new LinkedList();
		testResult.add("(1,a)");
		testResult.add("(2,b)");
		
		LinkedList<String> testResult2 = new LinkedList();
		testResult2.add("(1,a)");
		testResult2.add("(2,b)");
		
		assertEquals(testResult,testResult2);
	}
	
	@Test
	public void TestArray3d(){
        boolean[][] expectedResult = new boolean[8][8];
		for (int i = 0; i<8; i++){
			for (int j = 0; j<8; j++){
				expectedResult[i][j] = false;
			}
		}
		
        boolean[][] expectedResult2 = new boolean[8][8];
		for (int i = 0; i<8; i++){
			for (int j = 0; j<8; j++){
				expectedResult[i][j] = false;
			}
		}
		assertArrayEquals(expectedResult,expectedResult2);
	}
	

}
