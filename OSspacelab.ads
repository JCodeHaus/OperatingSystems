with Ada.Text_IO, Ada.Calendar, Ada.Numerics.Float_Random , Ada.Numerics.Elementary_Functions;
use  Ada.Text_IO, Ada.Calendar, Ada.Numerics.Float_Random , Ada.Numerics.Elementary_Functions;

package OSspacelab is  
  
  package durationio is new ada.text_io.fixed_io(duration); use durationio;
  package integerio is new ada.text_io.integer_io(integer); use integerio;
  
  randnum:generator;
  
  type typemessage is(newasteroid, getasteroidinfo, probedown);
  type typeorder is(asteroidinfo, updateasteroid, getasteroid);
  type typeweapon is(phasor, photon_torpeado);
  type typeprobe is(scout,defense);
  type asteroid is
    record
      asteroidid:integer;
      asteroidmass:float;
      asteroidimpacttime:duration;
    end record;
    
    task type scoutprobe is
      entry signal;
      entry typeordernew(orders: in typeorder);
    end scoutprobe;
    type scoutprobelink is access scoutprobe;
    
    task type defenseprobe(probeid:integer;weapon:typeweapon) is
      entry signal;
      entry asteroidinfonew(currentasteroid:asteroid);
    end defenseprobe;
    type defenseprobelink is access defenseprobe;
    
    task taskforcecommand is 
      entry signal;
      entry scoutprobecommunication(newAsteroid: in asteroid);
      entry defensiveinfo(probeid: in integer;currentasteroid:out asteroid;condition:out boolean);
      entry newprobedown(probeid:in integer);
      entry asteroiddestroyed(probeid:in integer;asteroidid:in integer);
    end taskforcecommand;
end OSspacelab;