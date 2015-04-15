with Ada.Text_IO; use Ada.Text_IO;with Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO;
use Ada;  
with Ada.Text_IO, Ada.Calendar, Ada.Integer_Text_IO, Ada.Strings;
use Ada.Text_IO, Ada.Calendar, Ada.Integer_Text_IO, Ada.Strings;
with Lab1Ver2;  use Lab1Ver2;
procedure Lab1Ver2Use is
   OfficerNumber: Integer;

   shuttle1: Shuttle(Atlantis);  -- Compile time allocation.
   shuttle2: Shuttle(Challenger);
   shuttle3: Shuttle(Ranger);
   shuttle4: Shuttle(Columbia);
   shuttle5: Shuttle(Discovery);
   shuttle6: Shuttle(Endeavor);
   shuttle7: Shuttle(Hubble);
   shuttle8: Shuttle(Kennedy);
   shuttle9: Shuttle(Nasa);  
   shuttle10: Shuttle(MeanMachine);


begin
    put("Shuttle operations are authorized."); new_line;
    put("How many officers");
    Integer_Text_IO.Get(OfficerNumber);
    Amount(OfficerNumber);
    -- Used as a container by the mother ship to launch and recover shuttles.
end Lab1Ver2Use;
