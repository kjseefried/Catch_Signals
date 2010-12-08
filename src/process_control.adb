-------------------------------------------------------------------------------
--                                                                           --
--                               Catch_Signals                               --
--                                                                           --
--                              process_control                              --
--                                                                           --
--                                  BODY                                     --
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

with Ada.Interrupts;

package body Process_Control is

   ------------
   --  Wait  --
   ------------

   procedure Wait
   is

      use Ada.Interrupts;
      use Ada.Text_IO;
      use State_IO;

   begin

      if not Wait_Called then
         Wait_Called := True;

         Attach_Handler
           (New_Handler => Controller.Handle_SIGHUP_Change_Handler'Access,
            Interrupt   => Ada.Interrupts.Names.SIGHUP);
         --  Dynamically attach a handler to the SIGHUP interrupt.

         Put ("Wait called. Process_State is ");
         Put (Controller.Get_State);
         New_Line;

         Controller.Start;
         Controller.Check;
      end if;

   end Wait;

   ------------------
   --  Controller  --
   ------------------

   protected body Controller is

      -------------
      --  Check  --
      -------------

      entry Check when Process_State = Shutdown
      is

         use Ada.Text_IO;
         use State_IO;

      begin

         Put ("Check called. Process_State is ");
         Put (Controller.Get_State);
         New_Line;

      end Check;

      -----------------
      --  Get_State  --
      -----------------

      function Get_State return State
      is
      begin

         return Process_State;

      end Get_State;

      ------------------------------------
      --  Handle_SIGHUP_Change_Handler  --
      ------------------------------------

      procedure Handle_SIGHUP_Change_Handler
      is

         use Ada.Interrupts;
         use Ada.Text_IO;

      begin

         Put_Line ("Handle_SIGHUP_Change_Handler called.");
         Put_Line
           ("Dynamically changing handler to Handle_SIGHUP_Shutdown.");
         Put_Line ("Next SIGHUP will stop the program.");

         Attach_Handler (New_Handler => Handle_SIGHUP_Shutdown'Access,
                         Interrupt   => Ada.Interrupts.Names.SIGHUP);
         --  Dynamically assign a new handler to the SIGHUP interrupt.

      end Handle_SIGHUP_Change_Handler;

      ------------------------------
      --  Handle_SIGHUP_Shutdown  --
      ------------------------------

      procedure Handle_SIGHUP_Shutdown
      is

         use Ada.Text_IO;

      begin

         Put_Line ("Handle_SIGHUP_Shutdown called.");
         Process_State := Shutdown;

      end Handle_SIGHUP_Shutdown;

      ---------------------
      --  Handle_SIGINT  --
      ---------------------

      procedure Handle_SIGINT
      is

         use Ada.Text_IO;

      begin

         Put_Line ("Handle_SIGINT called.");
         Process_State := Shutdown;

      end Handle_SIGINT;

      ---------------------
      --  Handle_SIGPWR  --
      ---------------------

      procedure Handle_SIGPWR
      is

         use Ada.Text_IO;

      begin

         Put_Line ("Handle_SIGPWR called.");
         Process_State := Shutdown;

      end Handle_SIGPWR;

      ----------------------
      --  Handle_SIGTERM  --
      ----------------------

      procedure Handle_SIGTERM
      is

         use Ada.Text_IO;

      begin

         Put_Line ("Handle_SIGTERM called.");
         Process_State := Shutdown;

      end Handle_SIGTERM;

      -------------
      --  Start  --
      -------------

      entry Start when Process_State = Stopped
      is

         use Ada.Text_IO;
         use State_IO;

      begin

         Process_State := Running;
         Put ("Start called. Process_State is ");
         Put (Controller.Get_State);
         New_Line;

         Put_Line ("I will react on SIGHUP, SIGINT, SIGPWR and SIGTERM.");

      end Start;

   end Controller;

end Process_Control;
