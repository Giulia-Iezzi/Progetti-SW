package Test;

import static org.junit.Assert.*;

import java.io.File;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

import org.jdom.Element;
import org.jdom.JDOMException;
import org.junit.Before;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import framework.Common;
import framework.Conf;

@RunWith(Parameterized.class)
public class TestASMCreation {
	
	public static String fileName;
	public static List<String> states;
	public static File ASM;
	
	public TestASMCreation(String fileToTest) {
	      fileName = fileToTest;
	   }
	
	@Before
	public void importArrays(){
		ASM = new File(Conf.source_dir + Conf.filesep + fileName + Conf.filesep + "ImplASM.java");
		System.out.println("Testing: " + ASM.getPath());
		File inputFile = new File(Conf.data_dir + Conf.filesep + fileName + Conf.scxml_extension);
		Element documentRoot = Common.getDocumentRoot(inputFile);
		try {
			states = Common.getStateNames(documentRoot);
		} catch (JDOMException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * Checks if the generated ASM file contains the methods corresponding to the states.
	 **/
	@Test
	public void testASMmethods() {
		Class AsmClass = ASM.getClass(); //Il getClass non va bene.
		ArrayList<Method> methodList = new ArrayList<Method>(Arrays.asList(AsmClass.getDeclaredMethods()));
		ArrayList<String> methodNames = new ArrayList<String>(methodList.size());
		for (Method m : methodList){
			methodNames.add(m.getName());
		}
		for (String s : states){
			assertTrue("Il metodo \"" + s + "\" per \'" + fileName + "\' non esiste!", methodNames.contains(s));
		}
	}

	@Parameterized.Parameters
	   public static Collection filesToTest() {
		File inputFile = new File(Conf.data_dir + Conf.filesep + "FilesToTest.txt");
		ArrayList<String[]> input = Common.read(inputFile);
		return input;
	   }
}
