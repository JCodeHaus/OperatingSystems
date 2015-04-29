with Ada.Text_IO, Ada.Calendar, Ada.Numerics.Float_Random , Ada.Numerics.Elementary_Functions;
use  Ada.Text_IO, Ada.Calendar, Ada.Numerics.Float_Random , Ada.Numerics.Elementary_Functions;
with stack;
package body OSspacelab is

 task body taskforcecommand is
    --Prior to entering asteroid field:
    --Obtain start up information.
    --Create and launch probes.
      shielddamage:integer:=5;
      asteroidsdestroyed:integer:=0;
      availableasteroids:integer:=0;
      availableprobes:integer:=15;
      initialprobe:integer:=2+availableprobes;
      currentasteroid: asteroid;
      package asteroidstack is new stack(asteroid,15); use asteroidstack;
      encounterarray:array(1..availableprobes) of defenseprobelink;
      probing:scoutprobelink;
      begin
        --Create and launch probes.
        encounterarray(1):=new defenseprobe(1,photon_torpeado);
        encounterarray(2):=new defenseprobe(2,photon_torpeado);
        for i in 3..availableprobes loop
          encounterarray(i):=new defenseprobe(i,phasor);
        end loop;
        availableprobes:=availableprobes+2;
        probing:=new scoutprobe;
        while asteroidsdestroyed <= 55 loop
          select
            accept defensiveinfo(probeid: in integer;currentasteroid:out asteroid;condition:out boolean) do
              if availableasteroids>0 then
                pop(currentasteroid);
                availableasteroids:=availableasteroids-1;
                condition:=true;
              else
                condition:=false;
                null;
              end if;
              end defensiveinfo;
            or
              accept scoutprobecommunication(newasteroid: in asteroid) do
                if availableasteroids<15 and then availableprobes>0 then
                  push(newasteroid);
                  availableasteroids:=availableasteroids+1;
                  put("Available Asteroids ==> "); new_line;
                  put(availableasteroids); new_line;
                else
                  shielddamage:=shielddamage-1;
                  asteroidsdestroyed:=asteroidsdestroyed+1;
                  put("Shield's resistance ==> "); new_line;
                  put(shielddamage); new_line;
                end if;
              end scoutprobecommunication;
            or
              accept newprobedown(probeid:in integer) do
                put("Probe Down ==> "); new_line;
                put(probeid); new_line;
                availableprobes:=availableprobes-1;
              end newprobedown;
            or
              accept asteroiddestroyed(probeid:in integer;asteroidid:in integer) do
                put("Asteroid Destroyed ==> "); new_line;
                put(asteroidid); new_line;
                asteroidsdestroyed:=asteroidsdestroyed+1;
              end asteroiddestroyed;
            else
              null;
            end select;
            if availableprobes<=0 then
              shielddamage:=shielddamage-availableasteroids;
            end if;
            if shielddamage<=0 then
              put("Failure"); new_line;
              abort taskforcecommand;
            end if;

        end loop;
        if asteroidsdestroyed>=55 then
          put("Success");new_line;
          abort taskforcecommand;
        end if;
    end taskforcecommand;
    --Scout Probe
    task body scoutprobe is
    --Obtain start up information including probe 
    --identification and IP of Task Force Command;
      probeid:integer:=0;
      parentip:integer:=0;
      probeis:typeprobe:=scout;
      ready:boolean:=false;
      currentasteroid:asteroid;
      currentasteroidid:integer:=1;
      realtime:duration;
      variant:float;
      begin
        while currentasteroidid<=55 loop
          currentasteroid.asteroidid:=currentasteroidid;
          currentasteroidid:=currentasteroidid+1;
          --Wait random length of time exponentially distributed to detect next asteroid;
          delay duration(float(4.0)*(-log(random(randnum))+float'model_small));
           --Determine time to impact (random, step function);
          currentasteroid.asteroidimpacttime:=duration(random(randnum)*15.0);
          currentasteroid.asteroidimpacttime:=currentasteroid.asteroidimpacttime+seconds(clock);
          --Determine asteroid mass ( random, uniformly distributed);
          variant:=random(randnum);
          if variant<=0.2 then
            currentasteroid.asteroidmass:=3.0;
          elsif variant<=0.5 then
            currentasteroid.asteroidmass:=6.0;
          elsif variant<=0.7 then
            currentasteroid.asteroidmass:=9.0;
          else
            currentasteroid.asteroidmass:=11.0;
          end if;
          put("Current Asteroid ==> "); new_line;
          put(currentasteroid.asteroidid); new_line;
          put("Time til Impact ==> "); new_line;
          put(currentasteroid.asteroidimpacttime-seconds(clock)); new_line;
          put("Current Asteroid ==> "); new_line;
          put(integer(currentasteroid.asteroidmass)); new_line;
          ---Send targeting information to Tack Force Command;
          taskforcecommand.scoutprobecommunication(currentasteroid);
          
        end loop;
    end scoutprobe;
    --Defensive Probe
    task body defenseprobe is
    --Obtain start up information including probe 
    --identification, IP of Task Force Command and weapon type;
      probeis:typeprobe:=defense;
      unitamount:float;
      hitpower:float;
      rechargetime:duration;
      Timetilfailure:duration;
      intiation:duration;
      realtime:duration;
      currentasteroidid:integer:=1;
      condition:boolean:=false;
      currentasteroid:asteroid;
      begin
        if weapon=photon_torpeado then
          unitamount:=5.0;
          rechargetime:=duration(3);
        else
          unitamount:=3.0;
          rechargetime:=duration(2);
        end if;
        loop
          intiation:=seconds(clock);
          --Request message from Task Force Command and process as required;
          taskforcecommand.defensiveinfo(probeid,currentasteroid,condition);
          --If(target available)
          if condition=true then
            put("Current Asteroid ==> "); new_line;
            put(currentasteroid.asteroidid); new_line;
            put("Encountered by ==> "); new_line;
            put(probeid); new_line;
             --Request targeting information;
            hitpower:=float'ceiling(currentasteroid.asteroidmass/unitamount);
            timetilfailure:=duration((hitpower-1.0))*rechargetime;
             --If(remaining time till impact is sufficient to destroy target)
            if currentasteroid.asteroidimpacttime-seconds(clock)>timetilfailure then
             --Delay the time for required number of shots to destroy target;
              delay timetilfailure;
              --Report target destroyed with our ID;
              taskforcecommand.asteroiddestroyed(probeid,currentasteroid.asteroidid);
              --Delay any remaining time to allow weapon to recharge;
              delay rechargetime;
            else
              delay currentasteroid.asteroidimpacttime-(seconds(clock));
              taskforcecommand.newprobedown(probeid);
              taskforcecommand.asteroiddestroyed(probeid,currentasteroid.asteroidid);
              exit;
            end if;
            
          end if;
            --Rest prior to requesting target information 500 milliseconds;
            delay 5.0;
        end loop;
    end defenseprobe;
end OSspacelab;

