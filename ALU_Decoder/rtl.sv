module aludec(
    input  logic       opb5,
    input  logic [2:0] funct3,
    input  logic       funct7b5,
    input  logic [1:0] ALUOp,
    output logic [2:0] ALUControl
);

    always_comb begin
        case (ALUOp)
            2'b00: ALUControl = 3'b000; // Address calculation: ADD
            2'b01: ALUControl = 3'b001; // BEQ comparison: SUBTRACT

            2'b10: begin
                case (funct3)
                    3'b000: begin
                        // SUB is R-type with instruction bit 30 set; otherwise ADD/ADDI.
                        if (opb5 && funct7b5)
                            ALUControl = 3'b001;
                        else
                            ALUControl = 3'b000;
                    end
                    3'b111: ALUControl = 3'b010; // AND / ANDI
                    3'b110: ALUControl = 3'b011; // OR / ORI
                    3'b010: ALUControl = 3'b101; // SLT / SLTI
                    default: ALUControl = 3'b000;
                endcase
            end

            default: ALUControl = 3'b000;
        endcase
    end

endmodule
