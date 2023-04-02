module ADC_Interface
    (
        input wire clk_in,
        input wire rst,

        input wire signed [11:0] data_in,
        input wire of_in,

        output wire clk_out,
        output reg pulse_out,
		  output reg pulse2_out,
        output wire of_out
		  
		  //output reg unsigned [3:0] ones,
		  //output reg unsigned [3:0] tens,
		  //output reg       sign
    );

    assign clk_out = clk_in;

    reg signed [11:0] data_frame;
	 reg signed [11:0] max_data_frame;
    reg of_frame;

    always @(posedge clk_in, posedge rst) begin
        if(rst == 1'b1) begin
            data_frame <= 12'd0;
            of_frame <= 1'b0;
        end
        else begin
            data_frame <= data_in;
            of_frame <= of_in;
        end
    end

    assign of_out = of_frame;

    always @* begin
        if(data_frame[11] == 1'b1)
            pulse_out = 1'b0;
        else
            pulse_out = 1'b1;
				
		  /*if(data_frame > 200)
			   pulse2_out = 1'b1;
		  else
			   pulse2_out = 1'b0;*/
    end
	 
	 localparam delay = 10'd3; // Pulse ~0.4us @ 0.1us/cycle
	 localparam wait_delay = 10'd7;
	 reg [9:0] count;
	 reg [2:0] state;
	 
	 always @(posedge clk_in, posedge rst) begin
		if(rst == 1'b1) begin
			pulse2_out <= 1'b0;
			count <= 10'b0000000000;
			state <= 3'b000;
		end
		else begin
			case(state)
				3'b000: begin // START
					if(data_frame > 12'd60) begin// || data_frame < -12'sd60) begin //TODO test
						pulse2_out <= 1'b1;
						count <= 10'b0000000000;
						state <= 3'b001;
					end
				end
				
				3'b001: begin // DELAY
					count <= count + 1'b1;
					
					if(count >= delay)
						state <= 3'b010;
				end
				
				3'b010: begin // END
					pulse2_out <= 1'b0;
					state <= 3'b011;
					count <= 10'b0000000000;
				end
				
				3'b011: begin // WAIT_DELAY
					count <= count + 1'b1;
					
					if(count >= wait_delay)
						state <= 3'b100;
				end
				
				3'b100: begin // START
					if(data_frame < -12'sd150) begin// || data_frame < -12'sd60) begin //TODO test
						pulse2_out <= 1'b1;
						count <= 10'b0000000000;
						state <= 3'b101;
					end
				end
				
				3'b101: begin // DELAY
					count <= count + 1'b1;
					
					if(count >= delay)
						state <= 3'b110;
				end
				
				3'b110: begin // END
					pulse2_out <= 1'b0;
					state <= 3'b111;
					count <= 10'b0000000000;
				end
				
				3'b111: begin // WAIT_DELAY
					count <= count + 1'b1;
					
					if(count >= wait_delay)
						state <= 3'b000;
				end
				
				default: state <= 3'b000;
			endcase
		end
	 end
	 
	 /*localparam delay = 10'd1000;
	 reg [10:0] count;
	 
	 always @(posedge clk_in, posedge rst) begin
		if(rst == 1'b1) begin
			ones <= 4'b0000;
			tens <= 4'b0000;
			sign <= 1'b0;
			count <= 10'b0000000000;
			max_data_frame <= 12'd000000000000;
		end
		else begin
			count <= count + 1'b1;
			
			if(count >= delay) begin
				count <= 10'b0000000000;
				
				if(data_frame > max_data_frame) begin
					max_data_frame <= data_frame;
					
					ones <= data_frame[3:0];
					tens <= data_frame[7:4];
					
					if(data_frame < 0)
						sign <= 1'b1;
					else
						sign <= 1'b0;
				end
			end
		end
	 end*/
	 
	 
endmodule