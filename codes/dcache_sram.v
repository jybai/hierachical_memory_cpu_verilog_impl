module dcache_sram
(
    clk_i,
    rst_i,
    addr_i,
    tag_i,
    data_i,
    enable_i,
    write_i,
    tag_o,
    data_o,
    hit_o
);

// I/O Interface from/to controller
input              clk_i;
input              rst_i;
input    [3:0]     addr_i;
input    [24:0]    tag_i;
input    [255:0]   data_i;
input              enable_i;
input              write_i;

output   [24:0]    tag_o;
output   [255:0]   data_o;
output             hit_o;

// Memory
reg      [24:0]    tag [0:15][0:1];
reg      [255:0]   data[0:15][0:1];
reg      [15:0]    to_evict;

integer            i, j;

assign hit_0 = (tag[addr_i][0][22:0] == tag_i[22:0] && tag[addr_i][0][24] == 1);
assign hit_1 = (tag[addr_i][1][22:0] == tag_i[22:0] && tag[addr_i][1][24] == 1);
assign rd_bit = hit_0 ? 0 : (hit_1 ? 1 : to_evict[addr_i]);

// Write Data
// 1. Write hit
// 2. Read miss: Read from memory
always@(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        for (i=0;i<16;i=i+1) begin
            for (j=0;j<2;j=j+1) begin
                tag[i][j] <= 25'b0;
                data[i][j] <= 256'b0;
            end
        end
        to_evict <= 16'b0;
    end
    if (enable_i && write_i) begin
        // TODO: Handle your write of 2-way associative cache + LRU here Done
        // Write hit for j=0
        if (hit_0) begin
            tag[addr_i][0] <= tag_i;
            data[addr_i][0] <= data_i;
        end else if (hit_1) begin
        // Write hit for j=1
            tag[addr_i][1] <= tag_i;
            data[addr_i][1] <= data_i;
        end else begin
        // Miss: write to the to-be-evicted block
            tag[addr_i][rd_bit] <= tag_i;
            data[addr_i][rd_bit] <= data_i;
        end
    end
    if (enable_i) begin
        if (hit_0)
            to_evict[addr_i] <= 1;
        else if (hit_1)
            to_evict[addr_i] <= 0;
        else
            to_evict[addr_i] <= ~rd_bit;
    end
end

// Read Data
// TODO: tag_o=? data_o=? hit_o=? Done
assign tag_o = (enable_i) ? tag[addr_i][rd_bit] : 25'b0;
assign data_o = (enable_i) ? data[addr_i][rd_bit] : 256'b0;
assign hit_o = hit_0 || hit_1;

endmodule
