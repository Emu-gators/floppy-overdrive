module ADCTest_top
	(
	  input wire clk_in,
	  input wire rst,

	  input wire [11:0] data_in,
	  input wire of_in,

	  output wire clk_out,
	  output wire pulse_LED,
	  output wire pulse2_LED,
	  output wire pulse_pin,
	  output wire pulse2_pin,
	  output wire of_out
	  
	  //output wire [7:0] ones_led,
	  //output wire [7:0] tens_led,
	  //output wire       sign_led
	);
 
	wire clk_div;
	wire adc_out;
	wire adc2_out;
	
	wire [3:0] ones;
	wire [3:0] tens;
	wire       sign;
	 
	clock_div U_DIV(
		.clk_in(clk_in),
		.rst(rst),
		.clk_out(clk_div)
	);
	 
	ADC_Interface U_ADC(
		.clk_in(clk_div),
		.rst(rst),
		.data_in(data_in),
		.of_in(of_in),
		.clk_out(clk_out),
		.pulse_out(adc_out),
		.pulse2_out(adc2_out),
		.of_out(of_out)
		//.ones(ones),
		//.tens(tens),
		//.sign(sign)
	);
	
	/*assign sign_led= ~sign;
	
	eight_seg U_ONES(
		.num_in(ones), //.num_in(4'b0110),
		.eight_seg_out(ones_led)
	);
	
	eight_seg U_TENS(
		.num_in(tens), //.num_in(4'b0011),
		.eight_seg_out(tens_led)
	);*/
	
	assign pulse_LED = adc_out;
	assign pulse_pin = adc_out;
	
	assign pulse2_LED = adc2_out;
	assign pulse2_pin = adc2_out;

endmodule