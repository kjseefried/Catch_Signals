-------------------------------------------------------------------------------
--                                                                           --
--                              Catch_Signals                                --
--                                                                           --
--                             process_control                               --
--                                                                           --
--                                  SPEC                                     --
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

with Ada.Interrupts.Names; use Ada.Interrupts.Names;
with Ada.Text_IO;

package Process_Control is

   pragma Unreserve_All_Interrupts;
   --  Make sure that GNAT does not handle any interrupts automatically.

   procedure Wait;
   --  Wait until Process_State is Shutdown.

private

   type State is (Running, Shutdown, Stopped);

   package State_IO is new Ada.Text_IO.Enumeration_IO (State);

   Wait_Called : Boolean := False;
   --  Set to True when Wait is called the first time.

   protected Controller is

      entry Check;
      --  Check if the Process_State is Shutdown, and if so, shut down the
      --  process.

      function Get_State return State;
      --  Return the current Process_State.

      procedure Handle_SIGHUP;
      procedure Handle_SIGINT;
      procedure Handle_SIGPWR;
      procedure Handle_SIGTERM;
      pragma Attach_Handler (Handle_SIGINT, SIGINT);
      pragma Attach_Handler (Handle_SIGPWR, SIGPWR);
      pragma Attach_Handler (Handle_SIGHUP, SIGHUP);
      pragma Attach_Handler (Handle_SIGTERM, SIGTERM);
      --  Handles the SIGINT, SIGPWR, SIGHUP and SIGTERM signals.

      entry Start;
      --  Set Process_State to Running.

   private

      Process_State : State := Stopped;
      --  What state the process is in.

   end Controller;

end Process_Control;
