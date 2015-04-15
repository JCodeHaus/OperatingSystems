import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class OSLAB4 implements Runnable
{ 
  @Override
  public void run()
  {
    long drift = 0;
    long amount =0;
    int i =1;
    try
      {
        do
        {
          amount=System.currentTimeMillis();
          Date instant= new Date();
          SimpleDateFormat instanttime= new SimpleDateFormat ("hh:mm:ss:S a");
          System.out.println("Current: " + instanttime.format(instant));
          drift = System.currentTimeMillis()- amount;
          Thread.sleep(10000 - drift);
          i++;
         }
         while(i<10000);
        }
        catch (InterruptedException x)
          {
            x.printStackTrace();
           }
        }
        public static void main(String[] arg)
          {
            (new Thread(new OSLAB4())).start();
          }
}