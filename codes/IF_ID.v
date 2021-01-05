module IF_ID
(
    start_i,
    clk_i,
    stall_i,
    flush_i,
    pc_i,
    Instruction_i,
    pc_o,
    Instruction_o,
);

// Ports
input           start_i;
input           clk_i;
input           stall_i;
input           flush_i;
input   [31:0]  pc_i;
input   [31:0]  Instruction_i;
output  [31:0]  pc_o;
output  [31:0]  Instruction_o;

// Register Files
reg   [31:0]    pc;
reg   [31:0]    Instruction;

// Read Data
assign pc_o = pc;
assign Instruction_o = Instruction;

// Write Data
always @(posedge clk_i) begin
    if (!stall_i) begin
        pc <= pc_i;
        Instruction <= Instruction_i;
        if (flush_i) Instruction <= 0;
    end
end

always @(negedge start_i) begin
    pc <= 0;
    Instruction <= 0;
end

endmodule
