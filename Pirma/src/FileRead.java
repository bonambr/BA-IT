import java.io.File;
import java.io.IOException; 
  
public class FileRead extends OpenFile
{ 
     static void RecursivePrint(File[] arr,int index,int level) throws IOException
     {  
         if(index == arr.length) 
             return; 
           
         if(arr[index].isFile()) 
        	OpenFile.OpenFiles(arr[index]);
         
         else if(arr[index].isDirectory()) 
             RecursivePrint(arr[index].listFiles(), 0, level + 1); 
         
         RecursivePrint(arr,++index, level); 
    } 
      
    public static void main(String[] args) throws IOException 
    { 
        // Path for project
    	
    	//C:\\Users\\...\\ReadmeBA-master 
        String maindirpath = "C:"; 
                  
        File maindir = new File(maindirpath); 
           
        if(maindir.exists() && maindir.isDirectory()) 
        { 
            File arr[] = maindir.listFiles(); 
              
            RecursivePrint(arr,0,0);  
       }  
    } 
}