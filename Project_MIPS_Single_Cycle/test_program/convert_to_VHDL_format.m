clear all;
close all;
clc;

fid_read_prog = fopen('fibonacci_sequence_recursive_binary.txt','r');
fid_write_prog = fopen('fibonacci_sequence_recursive_binary_VHDL.txt','w');

%% ********************* Convert ".text" Segment **************************
fprintf(fid_write_prog,'(');
instructions = 0;
while 1
    tline = fgetl(fid_read_prog);
    if ~ischar(tline)
        fprintf(fid_write_prog,'\n);\n');
        break;
    else
        instructions = instructions + 1;
        if (instructions == 1)
            fprintf(fid_write_prog,'\n"%s"',tline);
        else
            fprintf(fid_write_prog,',\n"%s"',tline);
        end;
    end;
end

%% ************************************************************************
fclose(fid_read_prog);
fclose(fid_write_prog);
