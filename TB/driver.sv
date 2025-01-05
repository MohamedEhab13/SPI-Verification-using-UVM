import uvm_pkg::* ;
import SPI_pkg::* ;



class driver extends uvm_driver #(seq_item);
  `uvm_component_utils(driver)

  seq_item SPI_item ;
  virtual bfm SPI_bfm ;
  
  
 // Constructor  
  function new(string name = "driver" ,uvm_component parent);
    super.new(name,parent);
    `uvm_info(get_type_name(),"Inside constructor of driver Class",UVM_LOW)
  endfunction :new
 
  
   
 // Build Phase 
  function void build_phase(uvm_phase phase);  
  
    super.build_phase(phase);
	`uvm_info(get_type_name(),"Inside build phase of Driver Class",UVM_LOW)
   
   
    if(!(uvm_config_db #(virtual bfm)::get(this,"*","SPI_bfm",SPI_bfm))) 
   `uvm_error(get_type_name(),"failed to get virtual interface inside Driver class")
      
   
    
  endfunction :build_phase 
      
      
      
  
      
 // Run Phase 
  task run_phase (uvm_phase phase);
    
    super.run_phase(phase);

    
    
    forever begin 
      
      SPI_item = seq_item::type_id::create("SPI_item");
      
      seq_item_port.get_next_item(SPI_item) ;
      
 
      drive(SPI_item) ;
      seq_item_port.item_done() ;
      
    end
    
  endtask : run_phase 
      
      
      
 // drive task 
      task drive (seq_item SPI_item) ;
        if(SPI_item.i_Rst == 1) begin 
          SPI_bfm.i_Rst = SPI_item.i_Rst ;
          SPI_bfm.i_TX_Byte = SPI_item.i_TX_Byte ;
        end  
        
        else begin : spi_drive 
           
          SPI_item.serial_input = SPI_item.r_MISO ;
          
          wait (SPI_item.i_TX_Valid == 1) ;
          @(posedge SPI_bfm.i_Clk);
          fork 
          
            begin 
              SPI_bfm.i_Rst        = SPI_item.i_Rst        ;
              SPI_bfm.i_TX_Byte    = SPI_item.i_TX_Byte    ;
              SPI_bfm.i_TX_Valid   = SPI_item.i_TX_Valid   ; 
              SPI_bfm.serial_input = SPI_item.serial_input ;
              
              
              @(posedge SPI_bfm.i_Clk);
              SPI_bfm.i_TX_Valid = 0; 
              @(posedge SPI_bfm.o_TX_Ready);
            end 
            
            begin 
              for (int i = 7; i >= 0; i--) begin
                SPI_bfm.MISO = SPI_item.r_MISO[i] ;
                @(negedge SPI_bfm.SCLK) ;
                @(posedge SPI_bfm.i_Clk) ;
                
                
              end
            end
        
          
          join
          
          SPI_bfm.MISO = 0 ;
          
        end : spi_drive
        
      endtask : drive
 
  
endclass : driver