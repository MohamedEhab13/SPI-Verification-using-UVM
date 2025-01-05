import uvm_pkg::* ;
import SPI_pkg::* ;



class seq_item extends uvm_sequence_item ;
  `uvm_object_utils(seq_item) 

  
  ///////////// Constructor \\\\\\\\\\\\\\\
  function new (string name = "seq_item" );
    super.new(name);
   `uvm_info(get_type_name(),"Inside constructor of SPI seq item Class",UVM_HIGH)
  endfunction
 

  
  
  ////////// Signals Declerations \\\\\\\\\\
  rand logic       i_Rst      ;
  rand logic [7:0] i_TX_Byte  ;
  rand logic       i_TX_Valid ;
  rand logic [7:0] r_MISO     ;
  logic      [7:0] o_TX_Ready ;
  logic      [7:0] r_MOSI     ;
  logic      [7:0] o_RX_Byte  ;
  logic            o_RX_Valid ;
  logic            SCLK       ;
  
  logic      [7:0] serial_input ;
endclass 