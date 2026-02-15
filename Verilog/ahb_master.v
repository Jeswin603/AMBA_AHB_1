module master_ahb(

//AHB INPUT SIGNALS
input CLK_MASTER,
input RESET_MASTER,
input HREADY,			//output of salve and input of master
input [31:0] HRDATA, 		//output of salve and input of master

//USER DEFINED SIGNAL 
input [31:0] data_top,  	// input to the master given by the testbench
input write_top,		//control signal for deciding write or read operation 
				//write_top = 1 WRITE / write_top = 0 READ operation
input[3:0] beat_length,		//this signal is used to describe the beat of data from the tb
input enb,			//enb  1 master will start either write or read operation 
input [31:0] addr_top,		//base address given from testbench
input wrap_enb,			//wrap_enb = 1 wrapping burst else incremental burst

//AHB OUTPUT SIGNALS	
output [31:0] HADDR,		//address bus 
output reg HWRITE,		//write control signal
output reg [2:0] HSIZE,		//used to determine the transfer size
output reg [31:0] HWDATA,	//DATA BUS

//USER DEFINED SIGNAL [FIFO]
output fifo_empty,fifo_full,
 
);

reg[1:0] present_state,next_state;
reg [31:0]addr_internal = 32'h0000_0000;
integer i = 0;
reg [3:0] count = 3'b000;
reg hburst_internal;
reg [31:0] internal_data;
reg [7:0] wrap_base;
reg [7:0] wrap_boundary

//fifo signals 
reg[3:0] wr_ptr, rd_ptr;

parameter  idle 		= 3'b000;
parameter write_state_address 	= 3'b001;
parameter read_state_address 	= 3'b010;
parameter read_state_data 	= 3'b011;  	
parameter write_state_data	= 3'b100;

assign fifo_empty = (wr_ptr == rd_ptr);
assign fifo_full = rd_ptr == (wr_ptr + 1);


endmodule
