with Ada.Text_IO, Ada.Calendar, Ada.Numerics.Float_Random;
use Ada.Text_IO, Ada.Calendar, Ada.Numerics.Float_Random;
procedure Lab1Ver1COpt is
    -- definitions
    package Duration_IO is new Ada.Text_IO.Fixed_IO(duration);  use Duration_IO;
    package integerIO is new Ada.Text_IO.Integer_IO(integer); use integerIO;

    randNum: Generator;  -- used to generate 0.0 <= random numbers <1.0.
    --"Random(randNum)" generates a random number, 0.0 < random number < 1.0.
    -- Duration(Random(randNum) ) coerces the random number to the data type 
    -- required by the "delay" statement when requesting a process be put to sleep.

    type RequestType is (Permission_To_Land, Call_The_Ball, Touch_Down);
    type ShuttleNameType is (Atlantis, Challenger, Ranger, MeanMachine);
    type FLAG is (UP,DOWN);
    FLAG_1,FLAG_2:FLAG:=DOWN;
    --Flag up implies the tasks intention to enter critical section
    TURN:INTEGER range 1..2:=1;
    --Used to arbitrate between tasks if they both wish to enter their
    --respective critical sections concurrently

    package ShuttleNameIO is new Ada.Text_IO.Enumeration_IO(ShuttleNameType);
    use ShuttleNameIO;

    -- This entire procedure represents a critical resource where access must be controlled.
    procedure LandingControlOfficer( Request: in RequestType; Shuttle: in ShuttleNameType) is
    begin

       case Request is
           when Permission_To_Land =>
               delay Duration(Random(randNum) * 5.0);  --  0 <= Delay < 5.0 uniformly distributed.
               -- Make decision.
               put(Shuttle); put(" is granted permission to land."); new_line;
           when Call_The_Ball =>
               delay Duration(Random(randNum) * 5.0);
               -- Prepare gudiance system..
               put(Shuttle); put(" call the ball!"); new_line;
           when Touch_Down =>
               put(Shuttle); put(", permission is granted for final approach."); new_line;
               delay Duration(Random(randNum) * 10.0);
               -- Wait for shuttle to land.

       end case;
    end LandingControlOfficer;

    task ShuttleAtlantis;
    task body ShuttleAtlantis is
        initiateLandingSequence: duration;
        landingComplete: duration;
    begin
        for I in 1..10 loop
           delay Duration(Random(randNum) * 15.0);  --Crew boarding and perform mission.
           FLAG_1:=UP;
              while FLAG_2= UP loop
                  if TURN=2 then
                      FLAG_1:=DOWN;
                          while TURN= 2 loop
                            delay Duration(Random(randNum)*0.0);
                          end loop;
                      FLAG_1:=UP;
                  end if;
              end loop;
                          
           delay Duration(Random(randNum) * 15.0);  --Crew boarding and perform mission.
           put("Atlantis entering its critical landing section.");  new_line(2);
           initiateLandingSequence:= seconds(clock);
           LandingControlOfficer( Permission_To_Land, Atlantis );
           LandingControlOfficer( Call_The_Ball, Atlantis );
           delay Duration(Random(randNum) * 3.0); -- line up shuttle with mother ship
           LandingControlOfficer( Touch_Down, Atlantis );
           landingComplete := seconds(clock);
           put("Shuttle Atlantis docked in "); put( landingComplete - initiateLandingSequence );
           put(" seconds." ); new_line;
           put("Atlantis leavings its critical section.  Obtain new crew and start next mission."); 
           new_line(2);
           TURN:=2;
           FLAG_1 := DOWN;
        end loop;
    end ShuttleAtlantis;
    
    task ShuttleRanger;
    task body ShuttleRanger is
        initiateLandingSequence: duration;
        landingComplete: duration;
    begin
        for I in 1..10 loop
           delay Duration(Random(randNum) * 15.0);  --Crew boarding and perform mission.
           FLAG_2:=UP;
              while FLAG_1= UP loop
                  if TURN=1 then
                      FLAG_1:=DOWN;
                          while TURN= 1 loop
                            delay Duration(Random(randNum)*0.0);
                          end loop;
                      FLAG_2:=UP;
                  end if;
              end loop;

           delay Duration(Random(randNum) * 15.0);  --Crew boarding and perform mission.
           put("Ranger entering its critical landing section.");  new_line(2);
           initiateLandingSequence:= seconds(clock);
           LandingControlOfficer( Permission_To_Land, Ranger );
           LandingControlOfficer( Call_The_Ball, Ranger );
           delay Duration(Random(randNum) * 3.0); -- line up shuttle with mother ship
           LandingControlOfficer( Touch_Down, Ranger );
           landingComplete := seconds(clock);
           put("Shuttle Ranger docked in "); put( landingComplete - initiateLandingSequence );
           put(" seconds." ); new_line;
           put("Ranger leavings its critical section.  Obtain new crew and start next mission."); 
           new_line(2);
           TURN:=1;
           FLAG_2:=DOWN;
        end loop;
    end ShuttleRanger;

begin
    put("Shuttle operations are authorized."); new_line;
    -- Used as a container by the mother ship to launch and recover shuttles.
end Lab1Ver1COpt;