with Ada.Text_IO, Ada.Calendar, Ada.Numerics.Float_Random;
use Ada.Text_IO, Ada.Calendar, Ada.Numerics.Float_Random;
package body Lab1Ver2 is

    -- This entire procedure represents a critical resource where access must be controlled.
    protected type Counting_Semaphore(Start_Count:  Integer := 1) is
      entry Secure;
      procedure Release;
      procedure setOfficers(knt: in Integer);
      function Count return Integer;
    private
      Current_Count: Integer := Start_Count;
      Officer_Amount:Integer;
    end Counting_Semaphore;
    
    protected body Counting_Semaphore is
    
      entry Secure when Current_Count < Officer_Amount is
      begin
        Current_Count := Current_Count + 1;
      end Secure;
    
      procedure Release is
      begin
        if Current_Count>0 then
          Current_Count := Current_Count - 1;
        end if;
      end Release;
    
      function Count return Integer is
      begin
        return Current_Count;
      end Count;
      
      procedure setOfficers(knt: in Integer) is
      begin
        Officer_Amount:=knt;
      end setOfficers;
    end Counting_Semaphore;
    -- definitions
    randNum: Generator;  -- used to generate 0.0 <= random numbers <1.0.
    --"Random(randNum)" generates a random number, 0.0 < random number < 1.0.
    -- Duration(Random(randNum) ) coerces the random number to the data type 
    -- required by the "delay" statement when requesting a process be put to sleep.
    Signal: Counting_Semaphore;
    LandingControlOfficerName: LandingControlOfficerNameType:= Uno;


    procedure Amount(Counter: In Integer) is
    begin
      Signal.setOfficers(Counter);
    end Amount;

    procedure LandingControlOfficer( Request: in RequestType; Shuttle: in ShuttleNameType) is
      task LandingOfficer;
      task body LandingOfficer is
      begin

         case Request is
             when Permission_To_Land =>
                 delay Duration(Random(randNum) * 5.0);
                 -- Make decision.
                 put(Shuttle); put(" is granted permission to land."); new_line;
                 if LandingControlOfficerName = Uno then
                   put(LandingControlOfficerName);put(" Is the landing control officer"); new_line;
                   LandingControlOfficerName:=Dos;
                 else
                    put(LandingControlOfficerName);put(" Is the landing control officer"); new_line;
                    LandingControlOfficerName:=Uno;
                 end if;
             when Call_The_Ball =>
                 delay Duration(Random(randNum) * 5.0);
                 -- Prepare gudiance system..
                 put(Shuttle); put(" call the ball!"); new_line;
             when Touch_Down =>
                 put(Shuttle); put(", permission is granted for final approach."); new_line;
                 delay Duration(Random(randNum) * 10.0);
                 -- Wait for shuttle to land.
  
         end case;
       end LandingOfficer;
    begin
      null;

    end LandingControlOfficer;

    task body Shuttle is
        shuttle: ShuttleNameType := shuttleName;
        initiateLandingSequence: duration;
        landingComplete: duration;
    begin
        for I in 1..5 loop
           Signal.Secure;
           delay Duration(Random(randNum) * 15.0);  --Crew boarding and perform mission.
           put(shuttle); put(" entering its critical landing section.");  new_line(2);
           initiateLandingSequence:= seconds(clock);
           LandingControlOfficer( Permission_To_Land, shuttle );
           LandingControlOfficer( Call_The_Ball, shuttle );
           delay Duration(Random(randNum) * 3.0); -- line up shuttle with mother ship
           LandingControlOfficer( Touch_Down, shuttle );
           landingComplete := seconds(clock);
           put( shuttle ); put(" docked in "); put( landingComplete - initiateLandingSequence );
           put(" seconds." ); new_line;
           put( shuttle ); put(" leavings its critical section.  Obtain new crew and start next mission.");
           new_line(2);
           Signal.Release;
        end loop;
    end Shuttle;
end Lab1Ver2;