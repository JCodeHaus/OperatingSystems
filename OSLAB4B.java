import java.io.*;
import java.util.Scanner;

public class OSLAB4B
{
  public static final String Completion="-2";
  public static void main(String[] var)
    {
      boolean complete = true;
      while(complete)
      {
        System.out.println("Enter file or press -2 to quit: ");
        Scanner file = new Scanner (System.in);
        String filename = file.nextLine();
        if(filename.equals(Completion))
          {
            complete= false;
           }
         else
         {
            try
              {
                new FileInputStream("/Users/yair/Desktop/" +filename);
                System.out.println("File exists " +filename+".");
               }
               catch (FileNotFoundException x)
                {
                  System.out.println("File doesn't exist. ");
                 }
           }
          }
        }
  }
          