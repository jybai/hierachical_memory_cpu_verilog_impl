module MUX32_4WAY
(
  data1_i,
  data2_i,
  data3_i,
  data4_i,
  select_i,
  data_o
);

input      [31:0] data1_i;
input      [31:0] data2_i;
input      [31:0] data3_i;
input      [31:0] data4_i;
input       [1:0] select_i;
output reg  [31:0] data_o;

`define DATA1 2'b00
`define DATA2 2'b01
`define DATA3 2'b10
`define DATA4 2'b11

always @ (*) begin
  case (select_i)
    `DATA1: data_o <= data1_i;
    `DATA2: data_o <= data2_i;
    `DATA3: data_o <= data3_i;
    `DATA4: data_o <= data4_i;
  endcase
end

endmodule
