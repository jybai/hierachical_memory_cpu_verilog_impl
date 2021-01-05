module ALU_Control(
  funct_i,
  ALUOp_i,
  ALUCtrl_o
);

input          [9:0] funct_i;
input          [1:0] ALUOp_i;
output reg     [2:0] ALUCtrl_o;

`define AND 3'b000
`define XOR 3'b001
`define SLL 3'b010
`define ADD 3'b011
`define SUB 3'b100
`define MUL 3'b101
`define SRAI 3'b110

`define ALUOP_RTYPE 2'b00
`define ALUOP_IMM 2'b01

`define  FUNCT_AND 10'b0000000_111
`define  FUNCT_XOR 10'b0000000_100
`define  FUNCT_SLL 10'b0000000_001
`define  FUNCT_ADD 10'b0000000_000
`define  FUNCT_SUB 10'b0100000_000
`define  FUNCT_MUL 10'b0000001_000
`define  FUNCT_ADDI_BEQ 3'b000
`define  FUNCT_SRAI 3'b101
`define  FUNCT_LSW 3'b010

always @ (*) begin
  if (ALUOp_i == `ALUOP_RTYPE) begin
    case (funct_i)
      `FUNCT_AND: ALUCtrl_o <= `AND;
      `FUNCT_XOR: ALUCtrl_o <= `XOR;
      `FUNCT_SLL: ALUCtrl_o <= `SLL;
      `FUNCT_ADD: ALUCtrl_o <= `ADD;
      `FUNCT_SUB: ALUCtrl_o <= `SUB;
      `FUNCT_MUL: ALUCtrl_o <= `MUL;
    endcase
  end
  else if (ALUOp_i == `ALUOP_IMM) begin
    case (funct_i[2:0])
      `FUNCT_ADDI_BEQ: ALUCtrl_o <= `ADD;
      `FUNCT_LSW: ALUCtrl_o <= `ADD;
      `FUNCT_SRAI: ALUCtrl_o <= `SRAI;
    endcase
  end
end

endmodule
