module regfile(
    input  logic        clk,
    input  logic        we3,
    input  logic [4:0]  a1,
    input  logic [4:0]  a2,
    input  logic [4:0]  a3,
    input  logic [31:0] wd3,
    output logic [31:0] rd1,
    output logic [31:0] rd2
);

    logic [31:0] rf [0:31];

    // x0 is hardwired to zero; writes to it are ignored.
    always_ff @(posedge clk) begin
        if (we3 && (a3 != 5'd0)) begin
            rf[a3] <= wd3;
        end
    end

    // Two asynchronous (combinational) read ports.
    always_comb begin
        rd1 = (a1 == 5'd0) ? 32'b0 : rf[a1];
        rd2 = (a2 == 5'd0) ? 32'b0 : rf[a2];
    end

endmodule
