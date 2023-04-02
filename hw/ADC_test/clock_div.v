module clock_div
	(
		input wire clk_in,
		input wire rst,
		output reg clk_out
	);
	
	reg [3:0] count;
	
	localparam DIVISOR = 4'd5;
	
	always@(posedge clk_in, posedge rst) begin
		if(rst == 1'b1) begin
			count <= 4'b0000;
		end
		else begin
			count <= count + 4'd1;
			
			if(count == DIVISOR-1'b1) begin
				count <= 4'b0000;
			end
			
			clk_out <= (count<DIVISOR/2)?1'b1:1'b0;
		end
	end
endmodule