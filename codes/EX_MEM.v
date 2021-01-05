module EX_MEM
(
    start_i,
    clk_i,
    stall_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i, 
    MemWrite_i,
    ALUResult_i,
    MUX2Result_i,
    Instruction4_i, // 11-7
    RegWrite_o,
    MemtoReg_o,
    MemRead_o, 
    MemWrite_o,
    ALUResult_o,
    MUX2Result_o,
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
input   [31:0]  ALUResult_i;
input   [31:0]  MUX2Result_i;
input   [4:0]   Instruction4_i;
output          RegWrite_o;
output          MemtoReg_o;
output          MemRead_o; 
output          MemWrite_o;
output  [31:0]  ALUResult_o;
output  [31:0]  MUX2Result_o;
output  [4:0]   Instruction4_o;

// Register Files
reg             RegWrite;
reg             MemtoReg;
reg             MemRead; 
reg             MemWrite;
reg   [31:0]    ALUResult;
reg   [31:0]    MUX2Result;
reg   [4:0]     Instruction4;

// Read Data
assign RegWrite_o = RegWrite;
assign MemtoReg_o = MemtoReg;
assign MemRead_o = MemRead;
assign MemWrite_o = MemWrite;
assign ALUResult_o = ALUResult;
assign MUX2Result_o = MUX2Result;
assign Instruction4_o = Instruction4;

// Write Data
always @(posedge clk_i) begin
    if (!stall_i) begin
        RegWrite <= RegWrite_i;
        MemtoReg <= MemtoReg_i;
        MemRead <= MemRead_i;
        MemWrite <= MemWrite_i;
        ALUResult <= ALUResult_i;
        MUX2Result <= MUX2Result_i;
        Instruction4 <= Instruction4_i;
    end
end

always @(negedge start_i) begin
    RegWrite <= 0;
    MemtoReg <= 0;
    MemRead <= 0;
    MemWrite <= 0;
    ALUResult <= 0;
    MUX2Result <= 0;
    Instruction4 <= 0;
end

endmodule
