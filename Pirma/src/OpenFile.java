import java.io.BufferedReader;
import java.io.BufferedWriter;

import java.io.File;

import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;


public class OpenFile{
	
	public static void OpenFiles(File path) throws IOException {
		
		FileReader fr = new FileReader(path); 
		File myObj = new File("C:\\Isvedimas.txt");
		FileWriter writer = new FileWriter(myObj, true); 
		BufferedWriter myWriter = new BufferedWriter(writer);
		ParserState currentState = ParserState.NormalContent;
		if (myObj.createNewFile()!=true) myObj.createNewFile();
		
		String str = path.toString();
		String extension = str.substring(str.lastIndexOf("\\") + 1);
		myWriter.write("\n" + extension + "------\n");

		OpenTextFile(fr, currentState, myWriter);
		myWriter.close();
	}
	
	public static void OpenTextFile(FileReader fr, ParserState currentState, BufferedWriter myWriter) throws IOException {
		
		int i;
		
		while ((i=fr.read()) != -1) 
		{
           	switch (currentState)
           	{
           		case NormalContent: switch ((char) i)
           		{
           			case '/':  currentState = ParserState.SingleLineCommentStart; break;
           				case '<':  currentState = ParserState.MultipleCommentStep2; break;
                        case '@':  currentState = ParserState.SingleLineCommentStart; break;
                        case '\'': currentState = ParserState.SingleQuote; break;
                        case '\"': currentState = ParserState.DoubleQuote; break;
                        default: break;
                }
                break;
                      
           		case MultipleCommentStep2:  switch ((char) i) 
           		{
           			case '!':  currentState = ParserState.MultipleCommentStep3; break;
                    default: currentState = ParserState.NormalContent; break;
               	}
              	break;
                    
           		case MultipleCommentStep3:  switch ((char) i) 
           		{
           			case '-':  currentState = ParserState.MultipleCommentStep4; break;
           			default: currentState = ParserState.NormalContent; break;
           		}
                break;
                        
           		case MultipleCommentStep4:  switch ((char) i) 
           		{
           			case '-':  currentState = ParserState.MultipleCommentStart; myWriter.write("<!"); break;
                    default: break;
          		}
                break;
                        
           		case SingleLineCommentStart: switch ((char) i)
           		{
           			case '\"': currentState = ParserState.DoubleQuote; break;
           			case '/': currentState = ParserState.SingleLineCommentEnd; myWriter.write("/"); break;
           			case '*': currentState = ParserState.MultipleCommentStart; myWriter.write((char) i); break;
           			default: currentState = ParserState.NormalContent; break;
                }
                break;

           		case MultipleCommentStart: switch ((char) i)
           		{
           			case '*': currentState = ParserState.StartObserved; break;
           			case '-': currentState = ParserState.DashObserved; break;                               
           			default: break;
           		}
           		break;
               
           		case DashObserved: switch ((char) i)
           		{
           			case '-': currentState = ParserState.DashObserved2; myWriter.write((char) i); break;
                 	default: currentState = ParserState.MultipleCommentStart; break;
                }
              	break;
                        
           		case DashObserved2: switch ((char) i)
                {
           			case '-': currentState = ParserState.DashObserved2; myWriter.write((char) i); break;
           			case '>': currentState = ParserState.MultipleCommentEnd; myWriter.write((char) i); break;
           			default: currentState = ParserState.MultipleCommentStart; break;
           		}
           		break;
                        
           		case StartObserved: switch ((char) i)
           		{
           			case '/': currentState = ParserState.MultipleCommentEnd; myWriter.write((char) i); break;
           			case '@': currentState = ParserState.MultipleCommentEnd; myWriter.write((char) i); break;  
           			case '*': currentState = ParserState.StartObserved; break;
           			default: currentState = ParserState.MultipleCommentStart; break;
           		}
           		break;

           		case DoubleQuote: switch ((char) i)
           		{
           			case '\"': currentState = ParserState.NormalContent; break;
           			default: break;
           		}
           		break;

           		case SingleQuote: switch ((char) i)
           		{
           			case '\'': currentState = ParserState.NormalContent; break;
           			default: break;
           		}
           		break;          		
           	}
           	
           	if(currentState == ParserState.SingleLineCommentEnd && i =='\n') 
           		myWriter.write("\n");
           	else if(currentState == ParserState.SingleLineCommentEnd && i!='\n' ) 
           		myWriter.write((char) i);
            else if(currentState == ParserState.MultipleCommentStart || currentState == ParserState.StartObserved) 
            	myWriter.write((char) i);
            else if(currentState == ParserState.SingleLineCommentEnd || currentState == ParserState.MultipleCommentEnd)   
            	currentState = ParserState.NormalContent;          
		}
	}
} 


