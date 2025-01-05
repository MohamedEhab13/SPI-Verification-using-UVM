/////////////////////////////////////////////////////////////////
import uvm_pkg::* ;
//`include"uvm_macros.svh"
import SPI_pkg::* ;
/////////////////////////////////////////////////////////////////



class test extends uvm_test ;
  `uvm_component_utils(test)


  env SPI_env ;

  reset_sequence  reset_seq; 
  SPI_sequence    spi_seq;



  // Constructor 
  function new(string name = "test" ,uvm_component parent);
    super.new(name,parent);
    `uvm_info(get_type_name(),"Inside constructor of Test Class",UVM_LOW)
  endfunction :new



  // Build Phase 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(),"Inside build phase of SPI Test Class",UVM_LOW)

    SPI_env = env::type_id::create("SPI_env",this);

  endfunction :build_phase 



  // Run Phase 
  task  run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_type_name(),"Inside run phase of SPI Test Class",UVM_LOW)


    phase.raise_objection(this);

    reset_seq = reset_sequence::type_id::create("reset_seq");
    reset_seq.start(SPI_env.SPI_agent.SPI_sequencer);

    #50
    repeat(10) begin 

      spi_seq = SPI_sequence::type_id::create("spi_seq");
      spi_seq.start(SPI_env.SPI_agent.SPI_sequencer);

      #150;		 

    end
    $stop ;
    phase.drop_objection(this);
    
  endtask :run_phase



endclass :test