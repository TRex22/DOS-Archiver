// Tool to replace ANY2IMD or work alongside it to execute commands that need
// user input after certain events are displayed on the screen
// Quick 'n dirty and not properly C or CPP

#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <dos.h>
#include <bios.h>

int main() {
   // Launch IMD.COM and wait for it to complete
   system("c:\\IMD120\\IMD.COM");

   // Wait for the "Press Enter to continue" message to be displayed
   while (1) {
      if (cputs("Read disk into file") != 0) {
         printf("FOUND! \n");
         // putch(27);
         // putch(27);
         // putch(27);
         break;
      }
   }

   // https://duckduckgo.com/?q=c+character+codes&ia=answer&iax=answer
   // ESC = 27
   // ENTER = 13

   // Simulate pressing the Escape key using interrupts
   // putch(27);
   // ah = 0x01;
   // al = 0x01;
   // geninterrupt(0x16);

   // // Simulate pressing the Enter key using interrupts
   // ah = 0x01;
   // geninterrupt(0x16);

   return 0;
}
