module ahb_slave(
	input HCLK,
	input HRESET,
	input [31:0] HADDR,
	input HWRITE,
	input [2:0] HSIZE,
	input [2:0] HBURST,
	input [1:0] HTRANS,
	input [31:0] HWDATA,

	output reg HREADY, 
	//output HRESP,
	output reg [31:0]HRDATA
);
	parameter idle 			= 2'b00;
	parameter sample_state 	 	= 2'b01;
	parameter write_state		= 2'b10;
	parameter write_state_ready 	= 2'b11;
	
	reg[1:0] htrans_internal;
	reg hwrite_internal ;
	reg [31:0] addr_internal;
	reg[1:0] present_state,next_state;

	//PRESENT STATE LOGIC

	always@(posedge HCLK)begin
		if(HRESET)begin
			present_state <=  idle;
		end
		else begin
			present_state <= next_state;
		end
	
	end

	always @(*)begin
		case(present_state)
			idle:begin
				HREADY = 1;
				next_state = sample_state;
			end

			sample_state:begin
				htrans_internal	= HTRANS;
				hwrite_internal = HWRITE;
				addr_internal   = HADDR;
				if(htrans_internal == 2'b10|| htrans_internal == 2'b01)begin
					if (hwrite_internal)
						next_state = write_state;
				end	
			end
			write_state:begin
				HRDATA = HWDATA;
				if(htrans_internal == 2'b00) 
					next_state = idle;
			end
		endcase

			
	end



endmodule
