/////////////////////////////////////////////////////////////////
import uvm_pkg::* ;
//`include"uvm_macros.svh"
import SPI_pkg::* ;
/////////////////////////////////////////////////////////////////



class env extends uvm_env;
  `uvm_component_utils(env)
  
 //  uvm_tlm_fifo #(seq_item) driver_fifo ;
  
   agent SPI_agent ;
   scoreboard SPI_scoreboard ;
   coverage_collector SPI_coverage_collector ;
  
  
  
  // Constructor 
    function new(string name = "env" ,uvm_component parent);
     super.new(name,parent); 
      `uvm_info(get_type_name(),"Inside constructor of Environment Class",UVM_LOW)
    endfunction : new
              
              
  
  // Build Phase 
    function void build_phase(uvm_phase phase);
     super.build_phase(phase); 
	 `uvm_info(get_type_name(),"Inside build phase of Environment Class",UVM_LOW)
      
    //  driver_fifo = new("driver_fifo",this) ; 
      SPI_agent = agent::type_id::create("SPI_agent",this);
      
      SPI_scoreboard = scoreboard::type_id::create("SPI_scoreboard",this);
      
      SPI_coverage_collector = coverage_collector::type_id::create("SPI_coverage_collector",this);
      
    endfunction :build_phase    
              
  
              
    
  // Connect Phase 
    function void connect_phase (uvm_phase phase);
      super.connect_phase(phase);
	 `uvm_info(get_type_name(),"Inside connect phase of Environment Class",UVM_LOW)
	 
	 // Connect monitor to scoreboard by analysis port 
      SPI_agent.SPI_monitor.monitor_ap.connect(SPI_scoreboard.monitor_export) ;
      
      
      
     // Connect monitor to Coverage Collector by tlm analysis port              
      SPI_agent.SPI_monitor.monitor_ap.connect(SPI_coverage_collector.analysis_export) ;
      
      
    
      
  endfunction :connect_phase
  
endclass : env