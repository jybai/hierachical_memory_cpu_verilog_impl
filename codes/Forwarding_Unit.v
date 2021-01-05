module Forwarding_Unit
(
    EXRs1_i,
    EXRs2_i,
    WBRegWrite_i,
    WBRd_i,
    MEMRegWrite_i,
    MEMRd_i,
    ForwardA_o,
    ForwardB_o
);

// Ports
input  [4:0]    EXRs1_i;
input  [4:0]    EXRs2_i;
input           WBRegWrite_i;
input  [4:0]    WBRd_i;
input           MEMRegWrite_i;
input  [4:0]    MEMRd_i;
output reg [1:0] ForwardA_o;
output reg [1:0] ForwardB_o;

always @(*) begin
    if (MEMRegWrite_i
        && (MEMRd_i != 0)
        && (MEMRd_i == EXRs1_i)) ForwardA_o <= 2'b10;
    else if (WBRegWrite_i
        && (WBRd_i != 0)
        && !(MEMRegWrite_i && (MEMRd_i != 0) && (MEMRd_i == EXRs1_i))
        && (WBRd_i == EXRs1_i)) ForwardA_o <= 2'b01;
    else
        ForwardA_o <= 2'b00;

    if (MEMRegWrite_i
        && (MEMRd_i != 0)
        && (MEMRd_i == EXRs2_i)) ForwardB_o <= 2'b10;
    else if (WBRegWrite_i
        && (WBRd_i != 0)
        && !(MEMRegWrite_i && (MEMRd_i != 0) && (MEMRd_i == EXRs2_i))
        && (WBRd_i == EXRs2_i)) ForwardB_o <= 2'b01;
    else
        ForwardB_o <= 2'b00;
end

endmodule
