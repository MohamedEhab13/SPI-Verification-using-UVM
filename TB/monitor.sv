import uvm_pkg::* ;
import SPI_pkg::* ;



class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)


  virtual bfm SPI_bfm;
  uvm_analysis_port #(seq_item) monitor_ap;


  seq_item monitor_item;



  // Constructor 
  function new(string name = "monitor" ,uvm_component parent);
    super.new(name,parent);
    `uvm_info(get_type_name(),"Inside constructor of Monitor Class",UVM_LOW)

  endfunction :new





  // Build Phase 
  function void build_phase(uvm_phase phase);

    if(!uvm_config_db #(virtual bfm)::get(this, "*","SPI_bfm", SPI_bfm))
      `uvm_fatal("MONITOR", "Failed to get BFM");

    monitor_ap  = new("monitor_ap",this);

  endfunction : build_phase




  // Run Phase 

  task  run_phase(uvm_phase phase);
    super.run_phase(phase);

    `uvm_info(get_type_name(),"Inside run phase of monitor Class",UVM_LOW)


    forever begin 

      monitor_item = seq_item::type_id::create("monitor_item");
      @(posedge SPI_bfm.i_Clk) ;        
      if(SPI_bfm.i_Rst == 1) begin 
        
        monitor_item.i_TX_Byte  = SPI_bfm.i_TX_Byte  ;
        monitor_item.i_TX_Valid = SPI_bfm.i_TX_Valid ;
        monitor_item.i_Rst      = SPI_bfm.i_Rst      ;
        monitor_item.o_TX_Ready = SPI_bfm.o_TX_Ready ;
        monitor_item.o_RX_Valid = SPI_bfm.o_RX_Valid ;
        monitor_item.o_RX_Byte  = SPI_bfm.o_RX_Byte  ;
        monitor_item.r_MOSI     = SPI_bfm.MOSI       ;
        monitor_item.SCLK       = SPI_bfm.SCLK       ; 
         
      end

      else begin 

        wait (SPI_bfm.i_TX_Valid == 0) ;

        for (int i = 7; i >= 0; i--) begin
          @(posedge SPI_bfm.SCLK) ;
          monitor_item.r_MOSI[i] = SPI_bfm.MOSI ;

        end          

        monitor_item.i_TX_Byte    = SPI_bfm.i_TX_Byte    ;
         monitor_item.i_TX_Valid = SPI_bfm.i_TX_Valid ;
        monitor_item.serial_input = SPI_bfm.serial_input ;
        monitor_item.o_RX_Valid   = SPI_bfm.o_RX_Valid   ;
        monitor_item.o_RX_Byte    = SPI_bfm.o_RX_Byte    ; 
        monitor_item.i_Rst        = SPI_bfm.i_Rst        ;
        monitor_item.SCLK         = SPI_bfm.SCLK         ;
      end
      
     
      monitor_ap.write(monitor_item) ;

    end

  endtask : run_phase  


endclass 