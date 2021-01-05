module ID_EX
(
    start_i,
    clk_i,
    stall_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i, 
    MemWrite_i,
    ALUOp_i,
    ALUSrc_i,
    RDdata1_i,
    RDdata2_i,
    Imm_i,
    Instruction1_i, // 31-25, 14-12
    Instruction2_i, // 19-15
    Instruction3_i, // 24-20
    Instruction4_i, // 11-7
    RegWrite_o,
    MemtoReg_o,
    MemRead_o, 
    MemWrite_o,
    ALUOp_o,
    ALUSrc_o,
    RDdata1_o,
    RDdata2_o,
    Imm_o,
    Instruction1_o, // 31-25, 14-12
    EXRs1_o, // 19-15
    EXRs2_o, // 24-20
    Instruction4_o, // 11-7
);

// Ports
input           start_i;
input           clk_i;
input           stall_i;
input           RegWrite_i;
input           MemtoReg_i;
input           MemRead_i; 
input           MemWrite_i;
input   [1:0]   ALUOp_i;
input           ALUSrc_i;
input   [31:0]  RDdata1_i;
input   [31:0]  RDdata2_i;
input   [31:0]  Imm_i;
input   [9:0]   Instruction1_i;
input   [4:0]   Instruction2_i;
input   [4:0]   Instruction3_i;
input   [4:0]   Instruction4_i;
output          RegWrite_o;
output          MemtoReg_o;
output          MemRead_o; 
output          MemWrite_o;
output  [1:0]   ALUOp_o;
output          ALUSrc_o;
output  [31:0]  RDdata1_o;
output  [31:0]  RDdata2_o;
output  [31:0]  Imm_o;
output  [9:0]   Instruction1_o;
output  [4:0]   EXRs1_o;
output  [4:0]   EXRs2_o;
output  [4:0]   Instruction4_o;

// Register Files
reg           RegWrite;
reg           MemtoReg;
reg           MemRead; 
reg           MemWrite;
reg   [1:0]   ALUOp;
reg           ALUSrc;
reg   [31:0]  RDdata1;
reg   [31:0]  RDdata2;
reg   [31:0]  Imm;
reg   [9:0]   Instruction1;
reg   [4:0]   Instruction2;
reg   [4:0]   Instruction3;
reg   [4:0]   Instruction4;

// Read Data
assign RegWrite_o = RegWrite;
assign MemtoReg_o = MemtoReg;
assign MemRead_o = MemRead;
assign MemWrite_o = MemWrite;
assign ALUOp_o = ALUOp;
assign ALUSrc_o = ALUSrc;
assign RDdata1_o = RDdata1;
assign RDdata2_o = RDdata2;
assign Imm_o = Imm;
assign Instruction1_o = Instruction1;
assign EXRs1_o = Instruction2;
assign EXRs2_o = Instruction3;
assign Instruction4_o = Instruction4;

// Write Data
always @(posedge clk_i) begin
    if (!stall_i) begin
        RegWrite <= RegWrite_i;
        MemtoReg <= MemtoReg_i;
        MemRead <= MemRead_i;
        MemWrite <= MemWrite_i;
        ALUOp <= ALUOp_i;
        ALUSrc <= ALUSrc_i;
        RDdata1 <= RDdata1_i;
        RDdata2 <= RDdata2_i;
        Imm <= Imm_i;
        Instruction1 <= Instruction1_i;
        Instruction2 <= Instruction2_i;
        Instruction3 <= Instruction3_i;
        Instruction4 <= Instruction4_i;
    end
end

always @(negedge start_i) begin
    RegWrite <= 0;
    MemtoReg <= 0;
    MemRead <= 0;
    MemWrite <= 0;
    ALUOp <= 0;
    ALUSrc <= 0;
    RDdata1 <= 0;
    RDdata2 <= 0;
    Imm <= 0;
    Instruction1 <= 0;
    Instruction2 <= 0;
    Instruction3 <= 0;
    Instruction4 <= 0;
end

endmodule
