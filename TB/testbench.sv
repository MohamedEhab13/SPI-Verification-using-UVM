`timescale 1ns/1ns


`include "package.sv"
`include "interface.sv"

module top;
   import uvm_pkg::*;
   `include "uvm_macros.svh"
   import SPI_pkg::*;
  
  bit clk ;
  
  bfm SPI_bfm(.i_Clk(clk)) ;
  
  SPI_Master DUT (    
                  .i_Clk(clk),
                  .i_Rst(SPI_bfm.i_Rst),
                  .i_TX_Byte(SPI_bfm.i_TX_Byte),
			      .i_TX_Valid(SPI_bfm.i_TX_Valid),
			      .o_TX_Ready(SPI_bfm.o_TX_Ready),
	    	      .o_RX_Valid(SPI_bfm.o_RX_Valid),
			      .o_RX_Byte(SPI_bfm.o_RX_Byte),
			      .SCLK(SPI_bfm.SCLK),
			      .MISO(SPI_bfm.MISO),
                  .MOSI(SPI_bfm.MOSI)
				);
  
  
  initial begin  
    forever  #5 clk = ~clk;
  end
  
  
  initial begin 
    uvm_config_db #(virtual bfm)::set(null,"*","SPI_bfm",SPI_bfm);
    run_test("test");
  end
  




property Not_Ready ; 
  @(posedge SPI_bfm.i_Clk) disable iff(SPI_bfm.i_Rst) SPI_bfm.i_TX_Valid |=> (SPI_bfm.o_TX_Ready==0) ;
endproperty
 VR_assert: assert property (Not_Ready) ;
 VR_cover : cover property  (Not_Ready) ;
    

   
property Ready ;
  @(posedge SPI_bfm.i_Clk) disable iff(SPI_bfm.i_Rst) (SPI_bfm.i_TX_Valid==1) |-> ##34 $rose(SPI_bfm.o_TX_Ready) ;
endproperty 
 NRR_assert: assert property (Ready) ;
 NRR_cover : cover property  (Ready) ;

initial 
  begin
    // Required to dump signals to EPWave
    $dumpfile("dump.vcd");
    $dumpvars(0);
  end   
   
endmodule     
  
  
  
  
  