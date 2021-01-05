module MEM_WB
(
    start_i,
    clk_i,
    stall_i,
    RegWrite_i,
    MemtoReg_i,
    ALUResult_i,
    RDdata_i,
    Instruction4_i, // 11-7
    RegWrite_o,
    MemtoReg_o,
    ALUResult_o,
    RDdata_o,
    Instruction4_o, // 11-7
);

// Ports
input           start_i;
input           clk_i;
input           stall_i;
input           RegWrite_i;
input           MemtoReg_i;
input   [31:0]  ALUResult_i;
input   [31:0]  RDdata_i;
input   [4:0]   Instruction4_i;
output          RegWrite_o;
output          MemtoReg_o;
output  [31:0]  ALUResult_o;
output  [31:0]  RDdata_o;
output  [4:0]   Instruction4_o;

// Register Files
reg             RegWrite;
reg             MemtoReg;
reg   [31:0]    ALUResult;
reg   [31:0]    RDdata;
reg   [4:0]     Instruction4;

// Read Data
assign RegWrite_o = RegWrite;
assign MemtoReg_o = MemtoReg;
assign ALUResult_o = ALUResult;
assign RDdata_o = RDdata;
assign Instruction4_o = Instruction4;

// Write Data
always @(posedge clk_i) begin
    if (!stall_i) begin
        RegWrite <= RegWrite_i;
        MemtoReg <= MemtoReg_i;
        ALUResult <= ALUResult_i;
        RDdata <= RDdata_i;
        Instruction4 <= Instruction4_i;
    end
end

always @(negedge start_i) begin
    RegWrite <= 0;
    MemtoReg <= 0;
    ALUResult <= 0;
    RDdata <= 0;
    Instruction4 <= 0;
end

endmodule
