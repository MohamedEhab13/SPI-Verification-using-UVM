import uvm_pkg::* ;
import SPI_pkg::* ;




class coverage_collector extends uvm_subscriber #(seq_item) ;
  `uvm_component_utils(coverage_collector)
  
  
  logic [7:0] TX_Byte ;
  logic       Rst     ;
  
  
  covergroup TX_Byte_cg ;
    TX_Data : coverpoint TX_Byte { bins all_zeros = {0}       ;
                                   bins other     = {[1:254]} ;
                                   bins all_ones  = {255}       ;
                                   }   
  endgroup : TX_Byte_cg 
  
 
  
  
  
  covergroup Reset_cg ;
    Reset_Signal : coverpoint Rst { bins reset_on  = {1} ;
                                     bins reset_off = {0} ;
                                  }
  endgroup : Reset_cg
  
  
  
  
  
  
  
  covergroup transitions_cg ;
      reset_transition : coverpoint Rst { bins reset2on = (1 => 0) ;
                                          bins on2on    = (0 => 0) ;
                                          bins on2reset = (0 => 1) ;
                                        }
  endgroup 	: transitions_cg
  
  
  
  // Constructor 
  function new(string name = "coverage_collector" ,uvm_component parent);
     super.new(name,parent);
    `uvm_info(get_type_name(),"Inside constructor of coverage collector Class",UVM_LOW)
  
    TX_Byte_cg      = new();
    Reset_cg        = new();
    transitions_cg  = new();
      
  endfunction : new
  
  
  
 // Build Phase 
  function void build_phase(uvm_phase phase);  
    super.build_phase(phase);
  endfunction
  
  
  
  function void write (seq_item  t);
     TX_Byte = t.i_TX_Byte ;
     Rst     = t.i_Rst     ;
    
    TX_Byte_cg.sample() ;
    Reset_cg.sample() ;
    transitions_cg.sample() ;
    
  endfunction : write 
  
 
  
  
endclass : coverage_collector