module Imm_Gen(
  instr_i,
  imm_o
);

input        [31:0] instr_i;
output reg   [31:0] imm_o;

`define ADDI 10'b0000010011
`define SRAI 10'b1010010011
`define   LW 10'b0100000011
`define   SW 10'b0100100011
`define  BEQ 10'b0001100011

always @ (*) begin
  case ({instr_i[14:12], instr_i[6:0]})
    `ADDI: imm_o <= {{20{instr_i[31]}}, instr_i[31:20]};
    `SRAI: imm_o <= {{27{instr_i[24]}}, instr_i[24:20]};
    `LW:   imm_o <= {{20{instr_i[31]}}, instr_i[31:20]};
    `SW:   imm_o <= {{20{instr_i[31]}}, instr_i[31:25], instr_i[11:7]};
    `BEQ:  imm_o <= {{20{instr_i[31]}}, instr_i[31], instr_i[7], instr_i[30:25], instr_i[11:8]};
    default: imm_o <= 32'b0;
  endcase
end

endmodule
