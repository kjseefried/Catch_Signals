-------------------------------------------------------------------------------
--                                                                           --
--                              Catch_Signals                                --
--                                                                           --
--                     Copyright (C) 2010, Thomas Løcke                      --
--                                                                           --
--  Catch_Signals is free software;  you can  redistribute it  and/or modify --
--  it under terms of the  GNU General Public License as published  by the   --
--  Free Software  Foundation;  either version 2,  or (at your option) any   --
--  later version.  Catch_Signals is distributed in the hope that it will be --
--  useful, but WITHOUT ANY WARRANTY;  without even the  implied warranty of --
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Gene-  --
--  ral Public License for  more details.  You should have  received  a copy --
--  of the GNU General Public License  distributed with Catch_Signals.  If   --
--  not, write to  the  Free Software Foundation,  51  Franklin  Street,     --
--  Fifth Floor, Boston, MA 02110 - 1301, USA.                               --
--                                                                           --
-------------------------------------------------------------------------------

with Ada.Text_IO;
with Process_Control;

procedure Catch_Signals
is

   use Ada.Text_IO;

begin

   Put_Line ("Lets catch some interrupts!");

   Process_Control.Wait;
   --  Wait for an interrupt here. The program is "stuck" here until the
   --  Process_State variable is set to Shutdown by one of the registered
   --  interrupt handlers.

   Put_Line ("Interrupt caught - shutting down.");

end Catch_Signals;
