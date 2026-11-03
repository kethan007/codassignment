module maindec(
    input  logic [6:0] op,
    output logic [1:0] ResultSrc,
    output logic       MemWrite,
    output logic       Branch,
    output logic       ALUSrc,
    output logic       RegWrite,
    output logic       Jump,
    output logic [1:0] ImmSrc,
    output logic [1:0] ALUOp
);

    always_comb begin
        // Safe defaults for unsupported opcodes and unused control signals.
        ResultSrc = 2'b00;
        MemWrite  = 1'b0;
        Branch    = 1'b0;
        ALUSrc    = 1'b0;
        RegWrite  = 1'b0;
        Jump      = 1'b0;
        ImmSrc    = 2'b00;
        ALUOp     = 2'b00;

        case (op)
            7'b0110011: begin // R-type register-register ALU instructions
                ResultSrc = 2'b00;
                RegWrite  = 1'b1;
                ALUSrc    = 1'b0;
                ALUOp     = 2'b10;
            end

            7'b0010011: begin // I-type arithmetic/logical instructions
                ResultSrc = 2'b00;
                RegWrite  = 1'b1;
                ALUSrc    = 1'b1;
                ImmSrc    = 2'b00;
                ALUOp     = 2'b10;
            end

            7'b0000011: begin // LW
                ResultSrc = 2'b01;
                RegWrite  = 1'b1;
                ALUSrc    = 1'b1;
                ImmSrc    = 2'b00;
                ALUOp     = 2'b00;
            end

            7'b0100011: begin // SW
                MemWrite = 1'b1;
                ALUSrc   = 1'b1;
                ImmSrc   = 2'b01;
                ALUOp    = 2'b00;
            end

            7'b1100011: begin // BEQ only
                Branch = 1'b1;
                ALUSrc = 1'b0;
                ImmSrc = 2'b10;
                ALUOp  = 2'b01;
            end

            7'b1101111: begin // JAL only
                ResultSrc = 2'b10;
                RegWrite  = 1'b1;
                Jump      = 1'b1;
                ImmSrc    = 2'b11;
            end

            default: begin
                // Leave all controls inactive for unsupported instructions.
            end
        endcase
    end

endmodule
