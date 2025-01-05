/////////////////////////////////////////////////////////////////
import uvm_pkg::* ;
//`include"uvm_macros.svh"
import SPI_pkg::* ;
/////////////////////////////////////////////////////////////////




class agent extends uvm_agent ;
  `uvm_component_utils(agent)
  
  
  driver SPI_driver ;
  monitor SPI_monitor ;
  sequencer SPI_sequencer ;
  
  
  // Constructor  
  function new(string name = "agent" ,uvm_component parent);
    super.new(name,parent);
    `uvm_info(get_type_name(),"Inside constructor of agent Class",UVM_LOW)
  endfunction :new
  
  
  
  // Build Phase 
  function void build_phase(uvm_phase phase);  
  
    super.build_phase(phase);
	`uvm_info(get_type_name(),"Inside build phase of Driver Class",UVM_LOW)
    
    
    SPI_driver    = driver::type_id::create("SPI_driver",this);
    SPI_monitor = monitor::type_id::create("SPI_monitor",this);
    SPI_sequencer = sequencer::type_id::create("SPI_sequencer",this);
    
  endfunction : build_phase 
  
  
  
  
  
  
 // Connect Phase 
  function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
	 
	 `uvm_info(get_type_name(),"Inside connect phase of Agent Class",UVM_LOW)
	 
	 // connect driver to sequencer 
	 SPI_driver.seq_item_port.connect(SPI_sequencer.seq_item_export);
     
  endfunction :connect_phase
  
  
endclass : agent 