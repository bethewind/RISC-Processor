
`include "sysbus.defs"

module alu 
#(
	BUS_DATA_WIDTH = 64
)
(
	input [BUS_DATA_WIDTH-1 : 0] dataA,
	input [BUS_DATA_WIDTH-1 : 0] dataB,  // could be immediate or register
	input [5:0] alu_control,  // for 41 ALU ops, 6 bits
	output [BUS_DATA_WIDTH-1 : 0] dataOut
);

reg [BUS_DATA_WIDTH-1 : 0] val = 0;
reg [BUS_DATA_WIDTH-1 : 0] x;

always @ (posedge clk) begin
	case(alu_control)
		6'b000001:  // addi
			val[31:0] <= dataA + dataB ;
		6'b000010:  // slti
			if($signed(dataA) < $signed(dataB)) begin
				val[31:0] <= 1;
			end else begin
				val[31:0] <= 0;
			end
		6'b000011:  // sltiu
			if(dataA < dataB) begin
				val[31:0] <= 1;
			end else begin
				val[31:0] <= 0;
			end
		6'b000100:  // xori
			val[31:0] <= dataA ^ dataB;
		6'b000101:  // ori
			val[31:0] <= dataA | dataB;
		6'b000110:  // andi
			val[31:0] <= dataA & dataB;
		6'b000111: // slli
			val[31:0] <= dataA << dataB[5:0] ;
		6'b001000: // srli
			val[31:0] <= dataA >> dataB[5:0] ;
		6'b001001: // srai
			val[31:0] <= dataA >>> dataB[5:0] ;
		6'b001100: // add
			val[31:0] <= dataA + dataB;
		6'b001101: // sub
			val[31:0] <= dataA - dataB;
		6'b001110: // sll
			val[31:0] <= dataA << dataB[4:0];
		6'b001111: // slt
			if($signed(dataA) < $signed(dataB)) begin
				val[31:0] <= 1;
			end else begin
				val[31:0] <= 0;
			end
		6'b010000: // sltu
			if(dataA < dataB) begin
				val[31:0] <= 1;
			end else begin
				val[31:0] <= 0;
			end
		6'b010001: // xor
			val[31:0] <= dataA ^ dataB;
		6'b010010:  // srl
			val[31:0] <= dataA >> dataB[4:0] ;
		6'b010011: // sra
			val[31:0] <= dataA >>> dataB[4:0] ;
		6'b010100: // or
			val[31:0] <= dataA | dataB ;
		6'b010101: // and
			val[31:0] <= dataA & dataB;
		/*********************** 32-bit instructions end ***********************/
		6'b010110: // addiw
			val[31:0] <= dataA + dataB;
		6'b010111: // slliw
			val[31:0] <= dataA << dataB[4:0];
		6'b011000: // srliw
			val[31:0] <= dataA >> dataB[4:0];
		6'b011001: // sraiw
			val[31:0] <= dataA >>> dataB[4:0];
		6'b011010: // addw
			val[31:0] <= dataA + dataB ;
		6'b011011: // subw
			val[31:0] <= dataA - dataB;
		6'b011100: //sllw
			val[31:0] <= dataA << dataB[4:0];
		6'b011101: // srlw
			val[31:0] <= dataA >> dataB[4:0];
		6'b011110: // sraw
			val[31:0] <= dataA >>> dataB[4:0];
		/************************ M - Extension start ************************************/
		6'b011111: // mul
			val[31:0] <= dataA * dataB;
		6'b100000: // mulh
			val <= $signed(dataA) * $signed(dataB) ;
		6'b100001: // mulhsu
			val <= $signed(dataA) * dataB ;
		6'b100010: // mulhu
			val <= dataA * dataB;
		6'b100011: // div
			val <= $signed(dataA[31:0]) / $signed(dataB[31:0]) ;
		6'b100100: // divu
			val <= dataA[31:0] / dataB[31:0] ;
		6'b100101: // rem
			val <= $signed(dataA[31:0]) % $signed(dataB[31:0]) ;
		6'b100110: // remu
			val <= dataA[31:0] % dataB[31:0];
		6'b100111: // mulw
			val[31:0] <= dataA[31:0] * dataB[31:0] ;
		6'b101000: // divw
			val[31:0] <= $signed(dataA[31:0]) / $signed(dataB[31:0]) ;
		6'b101001: // divuw
			val[31:0] <= dataA[31:0] / dataB[31:0] ;
		6'b101010: // remw
			val[31:0] <= $signed(dataA[31:0]) % $signed(dataB[31:0]);
		6'b101011: // remuw
			val[31:0] <= dataA[31:0] % dataB[31:0] ;
	endcase
end

always_comb begin
	if(alu_control > 6'b010101) begin
		if(alu_control < 6'b011111 || alu_control >= 6'b100111) begin
			x = {{32{val[31]}}, val[31:0]};
			dataOut = x;
		end
		else if(alu_control >= 6'b100000 && alu_control <= 6'b100010) begin
			x = {32{0}, val[63:32]};
			dataOut = x;
		end
	end
	else begin
		dataOut = val;
	end
end

// instantiate writeback stage here

writeback wb (
	.dataIn(dataOut)
);
		
		
 			
			
			
			





