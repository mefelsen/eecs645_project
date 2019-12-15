LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.my_package.ALL;
USE work.math_real.ALL;

ENTITY InstrMem IS
   PORT( 
      A     : IN  std_logic_vector (n_bits_address - 1 DOWNTO 0);
      rst   : IN  std_logic;
      Instr : OUT std_logic_vector (instr_mem_width - 1 DOWNTO 0)
   );
END InstrMem;

ARCHITECTURE behav OF InstrMem IS

   -- Internal signal declarations
   SIGNAL instr_mem  : instr_mem_type(0 to instr_mem_depth - 1);
   SIGNAL A_index : std_logic_vector (A'length - 1 DOWNTO 0);

BEGIN
   
   A_index <= STD_LOGIC_VECTOR((UNSIGNED(A) - UNSIGNED(text_segment_start))/4) WHEN ((TO_INTEGER((UNSIGNED(A) - UNSIGNED(text_segment_start))/4) >= 0) AND (TO_INTEGER((UNSIGNED(A) - UNSIGNED(text_segment_start))/4) < instr_mem_depth)) ELSE (OTHERS => '0');
   
   ---------------------------------------------------------------------------
   process1 : PROCESS (A_index, rst)
   ---------------------------------------------------------------------------
   BEGIN
      -- Asynchronous Reset
      IF (rst = '1') THEN
         -- Reset Actions
         instr_mem <= initial_instr_mem;
         instr_mem(0 to my_program_size - 1) <= my_program;
         Instr <= nop;
      ELSE
         Instr <= instr_mem(TO_INTEGER(UNSIGNED(A_index)));
      END IF;
   END PROCESS process1;

END behav;
