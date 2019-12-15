LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.my_package.ALL;
USE work.math_real.ALL;

ENTITY ALU IS
   PORT( 
      A           : IN     std_logic_vector (n_bits_alu  - 1 DOWNTO 0);
      ALUControl  : IN     std_logic_vector (n_bits_of(n_functions_alu) - 1 DOWNTO 0);
      B           : IN     std_logic_vector (n_bits_alu  - 1 DOWNTO 0);
      C           : OUT    std_logic_vector (n_bits_alu  - 1 DOWNTO 0);
      zero        : OUT    std_logic;
      overflow    : OUT    std_logic
   );
END ALU;


ARCHITECTURE behav OF ALU IS

   -- Internal signal declarations
   SIGNAL ALUControl_int : natural RANGE 0 TO (n_functions_alu - 1);
   SIGNAL C_internal : std_logic_vector(n_bits_alu  - 1 DOWNTO 0);
   SIGNAL s_A, s_B, s_C : std_logic; -- Sign bits of A, B, C
   
   SIGNAL immediate : std_logic_vector (immediate_end DOWNTO immediate_start);
   SIGNAL immediate_Zero_Extended : std_logic_vector (n_bits_alu - 1 DOWNTO 0);

BEGIN
C <= C_internal;
   ALUControl_int <= TO_INTEGER(UNSIGNED(ALUControl));
   
   s_A <= A(n_bits_alu  - 1);
   s_B <= B(n_bits_alu  - 1);
   s_C <= C_internal(n_bits_alu  - 1);

   zero <= '1' when (C_internal = zeros) else '0';
   
   immediate <= B(15 downto 0);
   immediate_Zero_Extended <= "0000000000000000" & immediate;
   ---------------------------------------------------------------------------
   process1 : PROCESS (A, B, ALUControl_int, s_A, s_B, s_C)
   ---------------------------------------------------------------------------
   BEGIN
      C_internal <= zeros;
      overflow <= '0';
      CASE ALUControl_int IS
	      WHEN 0 =>
		      C_internal <= A and B;
	      WHEN 1 =>
		      C_internal <= A or B;
	      WHEN 2 =>
		      C_internal <= STD_LOGIC_VECTOR(SIGNED(A) + SIGNED(B));
		      overflow <= ((NOT s_A) AND (NOT s_B) AND (    s_C)) OR
                          ((    s_A) AND (    s_B) AND (NOT s_C)); 
	      WHEN 6 =>
		      C_internal <= STD_LOGIC_VECTOR(SIGNED(A) - SIGNED(B));
		      overflow <= ((NOT s_A) AND (    s_B) AND (    s_C)) OR
                          ((    s_A) AND (NOT s_B) AND (NOT s_C)); 
	      WHEN 7 =>
             IF (SIGNED(A) < SIGNED(B)) THEN
                C_internal(0) <= '1';
             END IF;
	      WHEN 12 =>
		      C_internal <= A nor B;
		  WHEN 13 =>
		      C_internal <= immediate_Zero_Extended OR A;
		  WHEN 15 =>
		      C_internal <= immediate & "0000000000000000";
	      WHEN others =>
		      C_internal <= zeros;
		      overflow <= '0';
      END CASE;
   END PROCESS process1;
   
END behav;