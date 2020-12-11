// Generator : SpinalHDL v1.4.0    git head : ecb5a80b713566f417ea3ea061f9969e73770a7f
// Date      : 11/12/2020, 16:40:40
// Component : VexRiscv


`define Src2CtrlEnum_defaultEncoding_type [1:0]
`define Src2CtrlEnum_defaultEncoding_RS 2'b00
`define Src2CtrlEnum_defaultEncoding_IMI 2'b01
`define Src2CtrlEnum_defaultEncoding_IMS 2'b10
`define Src2CtrlEnum_defaultEncoding_PC 2'b11

`define AluBitwiseCtrlEnum_defaultEncoding_type [1:0]
`define AluBitwiseCtrlEnum_defaultEncoding_XOR_1 2'b00
`define AluBitwiseCtrlEnum_defaultEncoding_OR_1 2'b01
`define AluBitwiseCtrlEnum_defaultEncoding_AND_1 2'b10

`define Src1CtrlEnum_defaultEncoding_type [1:0]
`define Src1CtrlEnum_defaultEncoding_RS 2'b00
`define Src1CtrlEnum_defaultEncoding_IMU 2'b01
`define Src1CtrlEnum_defaultEncoding_PC_INCREMENT 2'b10
`define Src1CtrlEnum_defaultEncoding_URS1 2'b11

`define ShiftCtrlEnum_defaultEncoding_type [1:0]
`define ShiftCtrlEnum_defaultEncoding_DISABLE_1 2'b00
`define ShiftCtrlEnum_defaultEncoding_SLL_1 2'b01
`define ShiftCtrlEnum_defaultEncoding_SRL_1 2'b10
`define ShiftCtrlEnum_defaultEncoding_SRA_1 2'b11

`define AluCtrlEnum_defaultEncoding_type [1:0]
`define AluCtrlEnum_defaultEncoding_ADD_SUB 2'b00
`define AluCtrlEnum_defaultEncoding_SLT_SLTU 2'b01
`define AluCtrlEnum_defaultEncoding_BITWISE 2'b10

`define EnvCtrlEnum_defaultEncoding_type [1:0]
`define EnvCtrlEnum_defaultEncoding_NONE 2'b00
`define EnvCtrlEnum_defaultEncoding_XRET 2'b01
`define EnvCtrlEnum_defaultEncoding_WFI 2'b10
`define EnvCtrlEnum_defaultEncoding_ECALL 2'b11

`define BranchCtrlEnum_defaultEncoding_type [1:0]
`define BranchCtrlEnum_defaultEncoding_INC 2'b00
`define BranchCtrlEnum_defaultEncoding_B 2'b01
`define BranchCtrlEnum_defaultEncoding_JAL 2'b10
`define BranchCtrlEnum_defaultEncoding_JALR 2'b11


module InstructionCache (
  input               io_flush,
  input               io_cpu_prefetch_isValid,
  output reg          io_cpu_prefetch_haltIt,
  input      [31:0]   io_cpu_prefetch_pc,
  input               io_cpu_fetch_isValid,
  input               io_cpu_fetch_isStuck,
  input               io_cpu_fetch_isRemoved,
  input      [31:0]   io_cpu_fetch_pc,
  output     [31:0]   io_cpu_fetch_data,
  output              io_cpu_fetch_mmuBus_cmd_isValid,
  output     [31:0]   io_cpu_fetch_mmuBus_cmd_virtualAddress,
  output              io_cpu_fetch_mmuBus_cmd_bypassTranslation,
  input      [31:0]   io_cpu_fetch_mmuBus_rsp_physicalAddress,
  input               io_cpu_fetch_mmuBus_rsp_isIoAccess,
  input               io_cpu_fetch_mmuBus_rsp_allowRead,
  input               io_cpu_fetch_mmuBus_rsp_allowWrite,
  input               io_cpu_fetch_mmuBus_rsp_allowExecute,
  input               io_cpu_fetch_mmuBus_rsp_exception,
  input               io_cpu_fetch_mmuBus_rsp_refilling,
  output              io_cpu_fetch_mmuBus_end,
  input               io_cpu_fetch_mmuBus_busy,
  output     [31:0]   io_cpu_fetch_physicalAddress,
  output              io_cpu_fetch_haltIt,
  input               io_cpu_decode_isValid,
  input               io_cpu_decode_isStuck,
  input      [31:0]   io_cpu_decode_pc,
  output     [31:0]   io_cpu_decode_physicalAddress,
  output     [31:0]   io_cpu_decode_data,
  output              io_cpu_decode_cacheMiss,
  output              io_cpu_decode_error,
  output              io_cpu_decode_mmuRefilling,
  output              io_cpu_decode_mmuException,
  input               io_cpu_decode_isUser,
  input               io_cpu_fill_valid,
  input      [31:0]   io_cpu_fill_payload,
  output              io_mem_cmd_valid,
  input               io_mem_cmd_ready,
  output     [31:0]   io_mem_cmd_payload_address,
  output     [2:0]    io_mem_cmd_payload_size,
  input               io_mem_rsp_valid,
  input      [31:0]   io_mem_rsp_payload_data,
  input               io_mem_rsp_payload_error,
  input               clk,
  input               reset 
);
  reg        [21:0]   _zz_10_;
  reg        [31:0]   _zz_11_;
  wire                _zz_12_;
  wire                _zz_13_;
  wire       [0:0]    _zz_14_;
  wire       [0:0]    _zz_15_;
  wire       [21:0]   _zz_16_;
  reg                 _zz_1_;
  reg                 _zz_2_;
  reg                 lineLoader_fire;
  reg                 lineLoader_valid;
  (* syn_keep , keep *) reg        [31:0]   lineLoader_address /* synthesis syn_keep = 1 */ ;
  reg                 lineLoader_hadError;
  reg                 lineLoader_flushPending;
  reg        [7:0]    lineLoader_flushCounter;
  reg                 _zz_3_;
  reg                 lineLoader_cmdSent;
  reg                 lineLoader_wayToAllocate_willIncrement;
  wire                lineLoader_wayToAllocate_willClear;
  wire                lineLoader_wayToAllocate_willOverflowIfInc;
  wire                lineLoader_wayToAllocate_willOverflow;
  (* syn_keep , keep *) reg        [2:0]    lineLoader_wordIndex /* synthesis syn_keep = 1 */ ;
  wire                lineLoader_write_tag_0_valid;
  wire       [6:0]    lineLoader_write_tag_0_payload_address;
  wire                lineLoader_write_tag_0_payload_data_valid;
  wire                lineLoader_write_tag_0_payload_data_error;
  wire       [19:0]   lineLoader_write_tag_0_payload_data_address;
  wire                lineLoader_write_data_0_valid;
  wire       [9:0]    lineLoader_write_data_0_payload_address;
  wire       [31:0]   lineLoader_write_data_0_payload_data;
  wire                _zz_4_;
  wire       [6:0]    _zz_5_;
  wire                _zz_6_;
  wire                fetchStage_read_waysValues_0_tag_valid;
  wire                fetchStage_read_waysValues_0_tag_error;
  wire       [19:0]   fetchStage_read_waysValues_0_tag_address;
  wire       [21:0]   _zz_7_;
  wire       [9:0]    _zz_8_;
  wire                _zz_9_;
  wire       [31:0]   fetchStage_read_waysValues_0_data;
  wire                fetchStage_hit_hits_0;
  wire                fetchStage_hit_valid;
  wire                fetchStage_hit_error;
  wire       [31:0]   fetchStage_hit_data;
  wire       [31:0]   fetchStage_hit_word;
  reg        [31:0]   io_cpu_fetch_data_regNextWhen;
  reg        [31:0]   decodeStage_mmuRsp_physicalAddress;
  reg                 decodeStage_mmuRsp_isIoAccess;
  reg                 decodeStage_mmuRsp_allowRead;
  reg                 decodeStage_mmuRsp_allowWrite;
  reg                 decodeStage_mmuRsp_allowExecute;
  reg                 decodeStage_mmuRsp_exception;
  reg                 decodeStage_mmuRsp_refilling;
  reg                 decodeStage_hit_valid;
  reg                 decodeStage_hit_error;
  (* ram_style = "block" *) reg [21:0] ways_0_tags [0:127];
  (* ram_style = "block" *) reg [31:0] ways_0_datas [0:1023];

  assign _zz_12_ = (! lineLoader_flushCounter[7]);
  assign _zz_13_ = (lineLoader_flushPending && (! (lineLoader_valid || io_cpu_fetch_isValid)));
  assign _zz_14_ = _zz_7_[0 : 0];
  assign _zz_15_ = _zz_7_[1 : 1];
  assign _zz_16_ = {lineLoader_write_tag_0_payload_data_address,{lineLoader_write_tag_0_payload_data_error,lineLoader_write_tag_0_payload_data_valid}};
  always @ (posedge clk) begin
    if(_zz_2_) begin
      ways_0_tags[lineLoader_write_tag_0_payload_address] <= _zz_16_;
    end
  end

  always @ (posedge clk) begin
    if(_zz_6_) begin
      _zz_10_ <= ways_0_tags[_zz_5_];
    end
  end

  always @ (posedge clk) begin
    if(_zz_1_) begin
      ways_0_datas[lineLoader_write_data_0_payload_address] <= lineLoader_write_data_0_payload_data;
    end
  end

  always @ (posedge clk) begin
    if(_zz_9_) begin
      _zz_11_ <= ways_0_datas[_zz_8_];
    end
  end

  always @ (*) begin
    _zz_1_ = 1'b0;
    if(lineLoader_write_data_0_valid)begin
      _zz_1_ = 1'b1;
    end
  end

  always @ (*) begin
    _zz_2_ = 1'b0;
    if(lineLoader_write_tag_0_valid)begin
      _zz_2_ = 1'b1;
    end
  end

  assign io_cpu_fetch_haltIt = io_cpu_fetch_mmuBus_busy;
  always @ (*) begin
    lineLoader_fire = 1'b0;
    if(io_mem_rsp_valid)begin
      if((lineLoader_wordIndex == (3'b111)))begin
        lineLoader_fire = 1'b1;
      end
    end
  end

  always @ (*) begin
    io_cpu_prefetch_haltIt = (lineLoader_valid || lineLoader_flushPending);
    if(_zz_12_)begin
      io_cpu_prefetch_haltIt = 1'b1;
    end
    if((! _zz_3_))begin
      io_cpu_prefetch_haltIt = 1'b1;
    end
    if(io_flush)begin
      io_cpu_prefetch_haltIt = 1'b1;
    end
  end

  assign io_mem_cmd_valid = (lineLoader_valid && (! lineLoader_cmdSent));
  assign io_mem_cmd_payload_address = {lineLoader_address[31 : 5],5'h0};
  assign io_mem_cmd_payload_size = (3'b101);
  always @ (*) begin
    lineLoader_wayToAllocate_willIncrement = 1'b0;
    if((! lineLoader_valid))begin
      lineLoader_wayToAllocate_willIncrement = 1'b1;
    end
  end

  assign lineLoader_wayToAllocate_willClear = 1'b0;
  assign lineLoader_wayToAllocate_willOverflowIfInc = 1'b1;
  assign lineLoader_wayToAllocate_willOverflow = (lineLoader_wayToAllocate_willOverflowIfInc && lineLoader_wayToAllocate_willIncrement);
  assign _zz_4_ = 1'b1;
  assign lineLoader_write_tag_0_valid = ((_zz_4_ && lineLoader_fire) || (! lineLoader_flushCounter[7]));
  assign lineLoader_write_tag_0_payload_address = (lineLoader_flushCounter[7] ? lineLoader_address[11 : 5] : lineLoader_flushCounter[6 : 0]);
  assign lineLoader_write_tag_0_payload_data_valid = lineLoader_flushCounter[7];
  assign lineLoader_write_tag_0_payload_data_error = (lineLoader_hadError || io_mem_rsp_payload_error);
  assign lineLoader_write_tag_0_payload_data_address = lineLoader_address[31 : 12];
  assign lineLoader_write_data_0_valid = (io_mem_rsp_valid && _zz_4_);
  assign lineLoader_write_data_0_payload_address = {lineLoader_address[11 : 5],lineLoader_wordIndex};
  assign lineLoader_write_data_0_payload_data = io_mem_rsp_payload_data;
  assign _zz_5_ = io_cpu_prefetch_pc[11 : 5];
  assign _zz_6_ = (! io_cpu_fetch_isStuck);
  assign _zz_7_ = _zz_10_;
  assign fetchStage_read_waysValues_0_tag_valid = _zz_14_[0];
  assign fetchStage_read_waysValues_0_tag_error = _zz_15_[0];
  assign fetchStage_read_waysValues_0_tag_address = _zz_7_[21 : 2];
  assign _zz_8_ = io_cpu_prefetch_pc[11 : 2];
  assign _zz_9_ = (! io_cpu_fetch_isStuck);
  assign fetchStage_read_waysValues_0_data = _zz_11_;
  assign fetchStage_hit_hits_0 = (fetchStage_read_waysValues_0_tag_valid && (fetchStage_read_waysValues_0_tag_address == io_cpu_fetch_mmuBus_rsp_physicalAddress[31 : 12]));
  assign fetchStage_hit_valid = (fetchStage_hit_hits_0 != (1'b0));
  assign fetchStage_hit_error = fetchStage_read_waysValues_0_tag_error;
  assign fetchStage_hit_data = fetchStage_read_waysValues_0_data;
  assign fetchStage_hit_word = fetchStage_hit_data;
  assign io_cpu_fetch_data = fetchStage_hit_word;
  assign io_cpu_decode_data = io_cpu_fetch_data_regNextWhen;
  assign io_cpu_fetch_mmuBus_cmd_isValid = io_cpu_fetch_isValid;
  assign io_cpu_fetch_mmuBus_cmd_virtualAddress = io_cpu_fetch_pc;
  assign io_cpu_fetch_mmuBus_cmd_bypassTranslation = 1'b0;
  assign io_cpu_fetch_mmuBus_end = ((! io_cpu_fetch_isStuck) || io_cpu_fetch_isRemoved);
  assign io_cpu_fetch_physicalAddress = io_cpu_fetch_mmuBus_rsp_physicalAddress;
  assign io_cpu_decode_cacheMiss = (! decodeStage_hit_valid);
  assign io_cpu_decode_error = decodeStage_hit_error;
  assign io_cpu_decode_mmuRefilling = decodeStage_mmuRsp_refilling;
  assign io_cpu_decode_mmuException = ((! decodeStage_mmuRsp_refilling) && (decodeStage_mmuRsp_exception || (! decodeStage_mmuRsp_allowExecute)));
  assign io_cpu_decode_physicalAddress = decodeStage_mmuRsp_physicalAddress;
  always @ (posedge clk) begin
    if(reset) begin
      lineLoader_valid <= 1'b0;
      lineLoader_hadError <= 1'b0;
      lineLoader_flushPending <= 1'b1;
      lineLoader_cmdSent <= 1'b0;
      lineLoader_wordIndex <= (3'b000);
    end else begin
      if(lineLoader_fire)begin
        lineLoader_valid <= 1'b0;
      end
      if(lineLoader_fire)begin
        lineLoader_hadError <= 1'b0;
      end
      if(io_cpu_fill_valid)begin
        lineLoader_valid <= 1'b1;
      end
      if(io_flush)begin
        lineLoader_flushPending <= 1'b1;
      end
      if(_zz_13_)begin
        lineLoader_flushPending <= 1'b0;
      end
      if((io_mem_cmd_valid && io_mem_cmd_ready))begin
        lineLoader_cmdSent <= 1'b1;
      end
      if(lineLoader_fire)begin
        lineLoader_cmdSent <= 1'b0;
      end
      if(io_mem_rsp_valid)begin
        lineLoader_wordIndex <= (lineLoader_wordIndex + (3'b001));
        if(io_mem_rsp_payload_error)begin
          lineLoader_hadError <= 1'b1;
        end
      end
    end
  end

  always @ (posedge clk) begin
    if(io_cpu_fill_valid)begin
      lineLoader_address <= io_cpu_fill_payload;
    end
    if(_zz_12_)begin
      lineLoader_flushCounter <= (lineLoader_flushCounter + 8'h01);
    end
    _zz_3_ <= lineLoader_flushCounter[7];
    if(_zz_13_)begin
      lineLoader_flushCounter <= 8'h0;
    end
    if((! io_cpu_decode_isStuck))begin
      io_cpu_fetch_data_regNextWhen <= io_cpu_fetch_data;
    end
    if((! io_cpu_decode_isStuck))begin
      decodeStage_mmuRsp_physicalAddress <= io_cpu_fetch_mmuBus_rsp_physicalAddress;
      decodeStage_mmuRsp_isIoAccess <= io_cpu_fetch_mmuBus_rsp_isIoAccess;
      decodeStage_mmuRsp_allowRead <= io_cpu_fetch_mmuBus_rsp_allowRead;
      decodeStage_mmuRsp_allowWrite <= io_cpu_fetch_mmuBus_rsp_allowWrite;
      decodeStage_mmuRsp_allowExecute <= io_cpu_fetch_mmuBus_rsp_allowExecute;
      decodeStage_mmuRsp_exception <= io_cpu_fetch_mmuBus_rsp_exception;
      decodeStage_mmuRsp_refilling <= io_cpu_fetch_mmuBus_rsp_refilling;
    end
    if((! io_cpu_decode_isStuck))begin
      decodeStage_hit_valid <= fetchStage_hit_valid;
    end
    if((! io_cpu_decode_isStuck))begin
      decodeStage_hit_error <= fetchStage_hit_error;
    end
  end


endmodule

module DataCache (
  input               io_cpu_execute_isValid,
  input      [31:0]   io_cpu_execute_address,
  input               io_cpu_execute_args_wr,
  input      [31:0]   io_cpu_execute_args_data,
  input      [1:0]    io_cpu_execute_args_size,
  input               io_cpu_memory_isValid,
  input               io_cpu_memory_isStuck,
  input               io_cpu_memory_isRemoved,
  output              io_cpu_memory_isWrite,
  input      [31:0]   io_cpu_memory_address,
  output              io_cpu_memory_mmuBus_cmd_isValid,
  output     [31:0]   io_cpu_memory_mmuBus_cmd_virtualAddress,
  output              io_cpu_memory_mmuBus_cmd_bypassTranslation,
  input      [31:0]   io_cpu_memory_mmuBus_rsp_physicalAddress,
  input               io_cpu_memory_mmuBus_rsp_isIoAccess,
  input               io_cpu_memory_mmuBus_rsp_allowRead,
  input               io_cpu_memory_mmuBus_rsp_allowWrite,
  input               io_cpu_memory_mmuBus_rsp_allowExecute,
  input               io_cpu_memory_mmuBus_rsp_exception,
  input               io_cpu_memory_mmuBus_rsp_refilling,
  output              io_cpu_memory_mmuBus_end,
  input               io_cpu_memory_mmuBus_busy,
  input               io_cpu_writeBack_isValid,
  input               io_cpu_writeBack_isStuck,
  input               io_cpu_writeBack_isUser,
  output reg          io_cpu_writeBack_haltIt,
  output              io_cpu_writeBack_isWrite,
  output reg [31:0]   io_cpu_writeBack_data,
  input      [31:0]   io_cpu_writeBack_address,
  output              io_cpu_writeBack_mmuException,
  output              io_cpu_writeBack_unalignedAccess,
  output reg          io_cpu_writeBack_accessError,
  output reg          io_cpu_redo,
  input               io_cpu_flush_valid,
  output reg          io_cpu_flush_ready,
  output reg          io_mem_cmd_valid,
  input               io_mem_cmd_ready,
  output reg          io_mem_cmd_payload_wr,
  output reg [31:0]   io_mem_cmd_payload_address,
  output     [31:0]   io_mem_cmd_payload_data,
  output     [3:0]    io_mem_cmd_payload_mask,
  output reg [2:0]    io_mem_cmd_payload_length,
  output reg          io_mem_cmd_payload_last,
  input               io_mem_rsp_valid,
  input      [31:0]   io_mem_rsp_payload_data,
  input               io_mem_rsp_payload_error,
  input               clk,
  input               reset 
);
  reg        [21:0]   _zz_10_;
  reg        [31:0]   _zz_11_;
  wire                _zz_12_;
  wire                _zz_13_;
  wire                _zz_14_;
  wire                _zz_15_;
  wire                _zz_16_;
  wire       [0:0]    _zz_17_;
  wire       [0:0]    _zz_18_;
  wire       [0:0]    _zz_19_;
  wire       [2:0]    _zz_20_;
  wire       [1:0]    _zz_21_;
  wire       [21:0]   _zz_22_;
  reg                 _zz_1_;
  reg                 _zz_2_;
  wire                haltCpu;
  reg                 tagsReadCmd_valid;
  reg        [6:0]    tagsReadCmd_payload;
  reg                 tagsWriteCmd_valid;
  reg        [0:0]    tagsWriteCmd_payload_way;
  reg        [6:0]    tagsWriteCmd_payload_address;
  reg                 tagsWriteCmd_payload_data_valid;
  reg                 tagsWriteCmd_payload_data_error;
  reg        [19:0]   tagsWriteCmd_payload_data_address;
  reg                 tagsWriteLastCmd_valid;
  reg        [0:0]    tagsWriteLastCmd_payload_way;
  reg        [6:0]    tagsWriteLastCmd_payload_address;
  reg                 tagsWriteLastCmd_payload_data_valid;
  reg                 tagsWriteLastCmd_payload_data_error;
  reg        [19:0]   tagsWriteLastCmd_payload_data_address;
  reg                 dataReadCmd_valid;
  reg        [9:0]    dataReadCmd_payload;
  reg                 dataWriteCmd_valid;
  reg        [0:0]    dataWriteCmd_payload_way;
  reg        [9:0]    dataWriteCmd_payload_address;
  reg        [31:0]   dataWriteCmd_payload_data;
  reg        [3:0]    dataWriteCmd_payload_mask;
  wire                _zz_3_;
  wire                ways_0_tagsReadRsp_valid;
  wire                ways_0_tagsReadRsp_error;
  wire       [19:0]   ways_0_tagsReadRsp_address;
  wire       [21:0]   _zz_4_;
  wire                _zz_5_;
  wire       [31:0]   ways_0_dataReadRsp;
  reg        [3:0]    _zz_6_;
  wire       [3:0]    stage0_mask;
  wire       [0:0]    stage0_colisions;
  reg                 stageA_request_wr;
  reg        [31:0]   stageA_request_data;
  reg        [1:0]    stageA_request_size;
  reg        [3:0]    stageA_mask;
  wire                stageA_wayHits_0;
  reg        [0:0]    stage0_colisions_regNextWhen;
  wire       [0:0]    _zz_7_;
  wire       [0:0]    stageA_colisions;
  reg                 stageB_request_wr;
  reg        [31:0]   stageB_request_data;
  reg        [1:0]    stageB_request_size;
  reg                 stageB_mmuRspFreeze;
  reg        [31:0]   stageB_mmuRsp_physicalAddress;
  reg                 stageB_mmuRsp_isIoAccess;
  reg                 stageB_mmuRsp_allowRead;
  reg                 stageB_mmuRsp_allowWrite;
  reg                 stageB_mmuRsp_allowExecute;
  reg                 stageB_mmuRsp_exception;
  reg                 stageB_mmuRsp_refilling;
  reg                 stageB_tagsReadRsp_0_valid;
  reg                 stageB_tagsReadRsp_0_error;
  reg        [19:0]   stageB_tagsReadRsp_0_address;
  reg        [31:0]   stageB_dataReadRsp_0;
  wire       [0:0]    _zz_8_;
  reg        [0:0]    stageB_waysHits;
  wire                stageB_waysHit;
  wire       [31:0]   stageB_dataMux;
  reg        [3:0]    stageB_mask;
  reg        [0:0]    stageB_colisions;
  reg                 stageB_loaderValid;
  reg                 stageB_flusher_valid;
  reg                 stageB_flusher_start;
  wire       [31:0]   stageB_requestDataBypass;
  wire                stageB_isAmo;
  reg                 stageB_memCmdSent;
  wire       [0:0]    _zz_9_;
  reg                 loader_valid;
  reg                 loader_counter_willIncrement;
  wire                loader_counter_willClear;
  reg        [2:0]    loader_counter_valueNext;
  reg        [2:0]    loader_counter_value;
  wire                loader_counter_willOverflowIfInc;
  wire                loader_counter_willOverflow;
  reg        [0:0]    loader_waysAllocator;
  reg                 loader_error;
  (* ram_style = "block" *) reg [21:0] ways_0_tags [0:127];
  (* ram_style = "block" *) reg [7:0] ways_0_data_symbol0 [0:1023];
  (* ram_style = "block" *) reg [7:0] ways_0_data_symbol1 [0:1023];
  (* ram_style = "block" *) reg [7:0] ways_0_data_symbol2 [0:1023];
  (* ram_style = "block" *) reg [7:0] ways_0_data_symbol3 [0:1023];
  reg [7:0] _zz_23_;
  reg [7:0] _zz_24_;
  reg [7:0] _zz_25_;
  reg [7:0] _zz_26_;

  assign _zz_12_ = (io_cpu_execute_isValid && (! io_cpu_memory_isStuck));
  assign _zz_13_ = (((stageB_mmuRsp_refilling || io_cpu_writeBack_accessError) || io_cpu_writeBack_mmuException) || io_cpu_writeBack_unalignedAccess);
  assign _zz_14_ = (stageB_waysHit || (stageB_request_wr && (! stageB_isAmo)));
  assign _zz_15_ = (loader_valid && io_mem_rsp_valid);
  assign _zz_16_ = (stageB_mmuRsp_physicalAddress[11 : 5] != 7'h7f);
  assign _zz_17_ = _zz_4_[0 : 0];
  assign _zz_18_ = _zz_4_[1 : 1];
  assign _zz_19_ = loader_counter_willIncrement;
  assign _zz_20_ = {2'd0, _zz_19_};
  assign _zz_21_ = {loader_waysAllocator,loader_waysAllocator[0]};
  assign _zz_22_ = {tagsWriteCmd_payload_data_address,{tagsWriteCmd_payload_data_error,tagsWriteCmd_payload_data_valid}};
  always @ (posedge clk) begin
    if(_zz_3_) begin
      _zz_10_ <= ways_0_tags[tagsReadCmd_payload];
    end
  end

  always @ (posedge clk) begin
    if(_zz_2_) begin
      ways_0_tags[tagsWriteCmd_payload_address] <= _zz_22_;
    end
  end

  always @ (*) begin
    _zz_11_ = {_zz_26_, _zz_25_, _zz_24_, _zz_23_};
  end
  always @ (posedge clk) begin
    if(_zz_5_) begin
      _zz_23_ <= ways_0_data_symbol0[dataReadCmd_payload];
      _zz_24_ <= ways_0_data_symbol1[dataReadCmd_payload];
      _zz_25_ <= ways_0_data_symbol2[dataReadCmd_payload];
      _zz_26_ <= ways_0_data_symbol3[dataReadCmd_payload];
    end
  end

  always @ (posedge clk) begin
    if(dataWriteCmd_payload_mask[0] && _zz_1_) begin
      ways_0_data_symbol0[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[7 : 0];
    end
    if(dataWriteCmd_payload_mask[1] && _zz_1_) begin
      ways_0_data_symbol1[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[15 : 8];
    end
    if(dataWriteCmd_payload_mask[2] && _zz_1_) begin
      ways_0_data_symbol2[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[23 : 16];
    end
    if(dataWriteCmd_payload_mask[3] && _zz_1_) begin
      ways_0_data_symbol3[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[31 : 24];
    end
  end

  always @ (*) begin
    _zz_1_ = 1'b0;
    if((dataWriteCmd_valid && dataWriteCmd_payload_way[0]))begin
      _zz_1_ = 1'b1;
    end
  end

  always @ (*) begin
    _zz_2_ = 1'b0;
    if((tagsWriteCmd_valid && tagsWriteCmd_payload_way[0]))begin
      _zz_2_ = 1'b1;
    end
  end

  assign haltCpu = 1'b0;
  assign _zz_3_ = (tagsReadCmd_valid && (! io_cpu_memory_isStuck));
  assign _zz_4_ = _zz_10_;
  assign ways_0_tagsReadRsp_valid = _zz_17_[0];
  assign ways_0_tagsReadRsp_error = _zz_18_[0];
  assign ways_0_tagsReadRsp_address = _zz_4_[21 : 2];
  assign _zz_5_ = (dataReadCmd_valid && (! io_cpu_memory_isStuck));
  assign ways_0_dataReadRsp = _zz_11_;
  always @ (*) begin
    tagsReadCmd_valid = 1'b0;
    if(_zz_12_)begin
      tagsReadCmd_valid = 1'b1;
    end
  end

  always @ (*) begin
    tagsReadCmd_payload = 7'h0;
    if(_zz_12_)begin
      tagsReadCmd_payload = io_cpu_execute_address[11 : 5];
    end
  end

  always @ (*) begin
    dataReadCmd_valid = 1'b0;
    if(_zz_12_)begin
      dataReadCmd_valid = 1'b1;
    end
  end

  always @ (*) begin
    dataReadCmd_payload = 10'h0;
    if(_zz_12_)begin
      dataReadCmd_payload = io_cpu_execute_address[11 : 2];
    end
  end

  always @ (*) begin
    tagsWriteCmd_valid = 1'b0;
    if(stageB_flusher_valid)begin
      tagsWriteCmd_valid = stageB_flusher_valid;
    end
    if(_zz_13_)begin
      tagsWriteCmd_valid = 1'b0;
    end
    if(loader_counter_willOverflow)begin
      tagsWriteCmd_valid = 1'b1;
    end
  end

  always @ (*) begin
    tagsWriteCmd_payload_way = (1'bx);
    if(stageB_flusher_valid)begin
      tagsWriteCmd_payload_way = (1'b1);
    end
    if(loader_counter_willOverflow)begin
      tagsWriteCmd_payload_way = loader_waysAllocator;
    end
  end

  always @ (*) begin
    tagsWriteCmd_payload_address = 7'h0;
    if(stageB_flusher_valid)begin
      tagsWriteCmd_payload_address = stageB_mmuRsp_physicalAddress[11 : 5];
    end
    if(loader_counter_willOverflow)begin
      tagsWriteCmd_payload_address = stageB_mmuRsp_physicalAddress[11 : 5];
    end
  end

  always @ (*) begin
    tagsWriteCmd_payload_data_valid = 1'bx;
    if(stageB_flusher_valid)begin
      tagsWriteCmd_payload_data_valid = 1'b0;
    end
    if(loader_counter_willOverflow)begin
      tagsWriteCmd_payload_data_valid = 1'b1;
    end
  end

  always @ (*) begin
    tagsWriteCmd_payload_data_error = 1'bx;
    if(loader_counter_willOverflow)begin
      tagsWriteCmd_payload_data_error = (loader_error || io_mem_rsp_payload_error);
    end
  end

  always @ (*) begin
    tagsWriteCmd_payload_data_address = 20'h0;
    if(loader_counter_willOverflow)begin
      tagsWriteCmd_payload_data_address = stageB_mmuRsp_physicalAddress[31 : 12];
    end
  end

  always @ (*) begin
    dataWriteCmd_valid = 1'b0;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(_zz_14_)begin
          if((stageB_request_wr && stageB_waysHit))begin
            dataWriteCmd_valid = 1'b1;
          end
        end
      end
    end
    if(_zz_13_)begin
      dataWriteCmd_valid = 1'b0;
    end
    if(_zz_15_)begin
      dataWriteCmd_valid = 1'b1;
    end
  end

  always @ (*) begin
    dataWriteCmd_payload_way = (1'bx);
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(_zz_14_)begin
          dataWriteCmd_payload_way = stageB_waysHits;
        end
      end
    end
    if(_zz_15_)begin
      dataWriteCmd_payload_way = loader_waysAllocator;
    end
  end

  always @ (*) begin
    dataWriteCmd_payload_address = 10'h0;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(_zz_14_)begin
          dataWriteCmd_payload_address = stageB_mmuRsp_physicalAddress[11 : 2];
        end
      end
    end
    if(_zz_15_)begin
      dataWriteCmd_payload_address = {stageB_mmuRsp_physicalAddress[11 : 5],loader_counter_value};
    end
  end

  always @ (*) begin
    dataWriteCmd_payload_data = 32'h0;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(_zz_14_)begin
          dataWriteCmd_payload_data = stageB_requestDataBypass;
        end
      end
    end
    if(_zz_15_)begin
      dataWriteCmd_payload_data = io_mem_rsp_payload_data;
    end
  end

  always @ (*) begin
    dataWriteCmd_payload_mask = (4'bxxxx);
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(_zz_14_)begin
          dataWriteCmd_payload_mask = stageB_mask;
        end
      end
    end
    if(_zz_15_)begin
      dataWriteCmd_payload_mask = (4'b1111);
    end
  end

  always @ (*) begin
    case(io_cpu_execute_args_size)
      2'b00 : begin
        _zz_6_ = (4'b0001);
      end
      2'b01 : begin
        _zz_6_ = (4'b0011);
      end
      default : begin
        _zz_6_ = (4'b1111);
      end
    endcase
  end

  assign stage0_mask = (_zz_6_ <<< io_cpu_execute_address[1 : 0]);
  assign stage0_colisions[0] = (((dataWriteCmd_valid && dataWriteCmd_payload_way[0]) && (dataWriteCmd_payload_address == io_cpu_execute_address[11 : 2])) && ((stage0_mask & dataWriteCmd_payload_mask) != (4'b0000)));
  assign io_cpu_memory_mmuBus_cmd_isValid = io_cpu_memory_isValid;
  assign io_cpu_memory_mmuBus_cmd_virtualAddress = io_cpu_memory_address;
  assign io_cpu_memory_mmuBus_cmd_bypassTranslation = 1'b0;
  assign io_cpu_memory_mmuBus_end = ((! io_cpu_memory_isStuck) || io_cpu_memory_isRemoved);
  assign io_cpu_memory_isWrite = stageA_request_wr;
  assign stageA_wayHits_0 = ((io_cpu_memory_mmuBus_rsp_physicalAddress[31 : 12] == ways_0_tagsReadRsp_address) && ways_0_tagsReadRsp_valid);
  assign _zz_7_[0] = (((dataWriteCmd_valid && dataWriteCmd_payload_way[0]) && (dataWriteCmd_payload_address == io_cpu_memory_address[11 : 2])) && ((stageA_mask & dataWriteCmd_payload_mask) != (4'b0000)));
  assign stageA_colisions = (stage0_colisions_regNextWhen | _zz_7_);
  always @ (*) begin
    stageB_mmuRspFreeze = 1'b0;
    if((stageB_loaderValid || loader_valid))begin
      stageB_mmuRspFreeze = 1'b1;
    end
  end

  assign _zz_8_[0] = stageA_wayHits_0;
  assign stageB_waysHit = (stageB_waysHits != (1'b0));
  assign stageB_dataMux = stageB_dataReadRsp_0;
  always @ (*) begin
    stageB_loaderValid = 1'b0;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(! _zz_14_) begin
          if(io_mem_cmd_ready)begin
            stageB_loaderValid = 1'b1;
          end
        end
      end
    end
    if(_zz_13_)begin
      stageB_loaderValid = 1'b0;
    end
  end

  always @ (*) begin
    io_cpu_writeBack_haltIt = io_cpu_writeBack_isValid;
    if(stageB_flusher_valid)begin
      io_cpu_writeBack_haltIt = 1'b1;
    end
    if(io_cpu_writeBack_isValid)begin
      if(stageB_mmuRsp_isIoAccess)begin
        if((stageB_request_wr ? io_mem_cmd_ready : io_mem_rsp_valid))begin
          io_cpu_writeBack_haltIt = 1'b0;
        end
      end else begin
        if(_zz_14_)begin
          if(((! stageB_request_wr) || io_mem_cmd_ready))begin
            io_cpu_writeBack_haltIt = 1'b0;
          end
        end
      end
    end
    if(_zz_13_)begin
      io_cpu_writeBack_haltIt = 1'b0;
    end
  end

  always @ (*) begin
    io_cpu_flush_ready = 1'b0;
    if(stageB_flusher_start)begin
      io_cpu_flush_ready = 1'b1;
    end
  end

  assign stageB_requestDataBypass = stageB_request_data;
  assign stageB_isAmo = 1'b0;
  always @ (*) begin
    io_cpu_redo = 1'b0;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(_zz_14_)begin
          if((((! stageB_request_wr) || stageB_isAmo) && ((stageB_colisions & stageB_waysHits) != (1'b0))))begin
            io_cpu_redo = 1'b1;
          end
        end
      end
    end
    if((io_cpu_writeBack_isValid && stageB_mmuRsp_refilling))begin
      io_cpu_redo = 1'b1;
    end
    if(loader_valid)begin
      io_cpu_redo = 1'b1;
    end
  end

  always @ (*) begin
    io_cpu_writeBack_accessError = 1'b0;
    if(stageB_mmuRsp_isIoAccess)begin
      io_cpu_writeBack_accessError = (io_mem_rsp_valid && io_mem_rsp_payload_error);
    end else begin
      io_cpu_writeBack_accessError = ((stageB_waysHits & _zz_9_) != (1'b0));
    end
  end

  assign io_cpu_writeBack_mmuException = (io_cpu_writeBack_isValid && ((stageB_mmuRsp_exception || ((! stageB_mmuRsp_allowWrite) && stageB_request_wr)) || ((! stageB_mmuRsp_allowRead) && ((! stageB_request_wr) || stageB_isAmo))));
  assign io_cpu_writeBack_unalignedAccess = (io_cpu_writeBack_isValid && (((stageB_request_size == (2'b10)) && (stageB_mmuRsp_physicalAddress[1 : 0] != (2'b00))) || ((stageB_request_size == (2'b01)) && (stageB_mmuRsp_physicalAddress[0 : 0] != (1'b0)))));
  assign io_cpu_writeBack_isWrite = stageB_request_wr;
  always @ (*) begin
    io_mem_cmd_valid = 1'b0;
    if(io_cpu_writeBack_isValid)begin
      if(stageB_mmuRsp_isIoAccess)begin
        io_mem_cmd_valid = (! stageB_memCmdSent);
      end else begin
        if(_zz_14_)begin
          if(stageB_request_wr)begin
            io_mem_cmd_valid = 1'b1;
          end
        end else begin
          if((! stageB_memCmdSent))begin
            io_mem_cmd_valid = 1'b1;
          end
        end
      end
    end
    if(_zz_13_)begin
      io_mem_cmd_valid = 1'b0;
    end
  end

  always @ (*) begin
    io_mem_cmd_payload_address = 32'h0;
    if(io_cpu_writeBack_isValid)begin
      if(stageB_mmuRsp_isIoAccess)begin
        io_mem_cmd_payload_address = {stageB_mmuRsp_physicalAddress[31 : 2],(2'b00)};
      end else begin
        if(_zz_14_)begin
          io_mem_cmd_payload_address = {stageB_mmuRsp_physicalAddress[31 : 2],(2'b00)};
        end else begin
          io_mem_cmd_payload_address = {stageB_mmuRsp_physicalAddress[31 : 5],5'h0};
        end
      end
    end
  end

  always @ (*) begin
    io_mem_cmd_payload_length = (3'bxxx);
    if(io_cpu_writeBack_isValid)begin
      if(stageB_mmuRsp_isIoAccess)begin
        io_mem_cmd_payload_length = (3'b000);
      end else begin
        if(_zz_14_)begin
          io_mem_cmd_payload_length = (3'b000);
        end else begin
          io_mem_cmd_payload_length = (3'b111);
        end
      end
    end
  end

  always @ (*) begin
    io_mem_cmd_payload_last = 1'bx;
    if(io_cpu_writeBack_isValid)begin
      if(stageB_mmuRsp_isIoAccess)begin
        io_mem_cmd_payload_last = 1'b1;
      end else begin
        if(_zz_14_)begin
          io_mem_cmd_payload_last = 1'b1;
        end else begin
          io_mem_cmd_payload_last = 1'b1;
        end
      end
    end
  end

  always @ (*) begin
    io_mem_cmd_payload_wr = stageB_request_wr;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(! _zz_14_) begin
          io_mem_cmd_payload_wr = 1'b0;
        end
      end
    end
  end

  assign io_mem_cmd_payload_mask = stageB_mask;
  assign io_mem_cmd_payload_data = stageB_requestDataBypass;
  always @ (*) begin
    if(stageB_mmuRsp_isIoAccess)begin
      io_cpu_writeBack_data = io_mem_rsp_payload_data;
    end else begin
      io_cpu_writeBack_data = stageB_dataMux;
    end
  end

  assign _zz_9_[0] = stageB_tagsReadRsp_0_error;
  always @ (*) begin
    loader_counter_willIncrement = 1'b0;
    if(_zz_15_)begin
      loader_counter_willIncrement = 1'b1;
    end
  end

  assign loader_counter_willClear = 1'b0;
  assign loader_counter_willOverflowIfInc = (loader_counter_value == (3'b111));
  assign loader_counter_willOverflow = (loader_counter_willOverflowIfInc && loader_counter_willIncrement);
  always @ (*) begin
    loader_counter_valueNext = (loader_counter_value + _zz_20_);
    if(loader_counter_willClear)begin
      loader_counter_valueNext = (3'b000);
    end
  end

  always @ (posedge clk) begin
    tagsWriteLastCmd_valid <= tagsWriteCmd_valid;
    tagsWriteLastCmd_payload_way <= tagsWriteCmd_payload_way;
    tagsWriteLastCmd_payload_address <= tagsWriteCmd_payload_address;
    tagsWriteLastCmd_payload_data_valid <= tagsWriteCmd_payload_data_valid;
    tagsWriteLastCmd_payload_data_error <= tagsWriteCmd_payload_data_error;
    tagsWriteLastCmd_payload_data_address <= tagsWriteCmd_payload_data_address;
    if((! io_cpu_memory_isStuck))begin
      stageA_request_wr <= io_cpu_execute_args_wr;
      stageA_request_data <= io_cpu_execute_args_data;
      stageA_request_size <= io_cpu_execute_args_size;
    end
    if((! io_cpu_memory_isStuck))begin
      stageA_mask <= stage0_mask;
    end
    if((! io_cpu_memory_isStuck))begin
      stage0_colisions_regNextWhen <= stage0_colisions;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_request_wr <= stageA_request_wr;
      stageB_request_data <= stageA_request_data;
      stageB_request_size <= stageA_request_size;
    end
    if(((! io_cpu_writeBack_isStuck) && (! stageB_mmuRspFreeze)))begin
      stageB_mmuRsp_physicalAddress <= io_cpu_memory_mmuBus_rsp_physicalAddress;
      stageB_mmuRsp_isIoAccess <= io_cpu_memory_mmuBus_rsp_isIoAccess;
      stageB_mmuRsp_allowRead <= io_cpu_memory_mmuBus_rsp_allowRead;
      stageB_mmuRsp_allowWrite <= io_cpu_memory_mmuBus_rsp_allowWrite;
      stageB_mmuRsp_allowExecute <= io_cpu_memory_mmuBus_rsp_allowExecute;
      stageB_mmuRsp_exception <= io_cpu_memory_mmuBus_rsp_exception;
      stageB_mmuRsp_refilling <= io_cpu_memory_mmuBus_rsp_refilling;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_tagsReadRsp_0_valid <= ways_0_tagsReadRsp_valid;
      stageB_tagsReadRsp_0_error <= ways_0_tagsReadRsp_error;
      stageB_tagsReadRsp_0_address <= ways_0_tagsReadRsp_address;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_dataReadRsp_0 <= ways_0_dataReadRsp;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_waysHits <= _zz_8_;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_mask <= stageA_mask;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_colisions <= stageA_colisions;
    end
    if(stageB_flusher_valid)begin
      if(_zz_16_)begin
        stageB_mmuRsp_physicalAddress[11 : 5] <= (stageB_mmuRsp_physicalAddress[11 : 5] + 7'h01);
      end
    end
    if(stageB_flusher_start)begin
      stageB_mmuRsp_physicalAddress[11 : 5] <= 7'h0;
    end
    `ifndef SYNTHESIS
      `ifdef FORMAL
        assert((! ((io_cpu_writeBack_isValid && (! io_cpu_writeBack_haltIt)) && io_cpu_writeBack_isStuck)))
      `else
        if(!(! ((io_cpu_writeBack_isValid && (! io_cpu_writeBack_haltIt)) && io_cpu_writeBack_isStuck))) begin
          $display("FAILURE writeBack stuck by another plugin is not allowed");
          $finish;
        end
      `endif
    `endif
  end

  always @ (posedge clk) begin
    if(reset) begin
      stageB_flusher_valid <= 1'b0;
      stageB_flusher_start <= 1'b1;
      stageB_memCmdSent <= 1'b0;
      loader_valid <= 1'b0;
      loader_counter_value <= (3'b000);
      loader_waysAllocator <= (1'b1);
      loader_error <= 1'b0;
    end else begin
      if(stageB_flusher_valid)begin
        if(! _zz_16_) begin
          stageB_flusher_valid <= 1'b0;
        end
      end
      stageB_flusher_start <= ((((((! stageB_flusher_start) && io_cpu_flush_valid) && (! io_cpu_execute_isValid)) && (! io_cpu_memory_isValid)) && (! io_cpu_writeBack_isValid)) && (! io_cpu_redo));
      if(stageB_flusher_start)begin
        stageB_flusher_valid <= 1'b1;
      end
      if(io_mem_cmd_ready)begin
        stageB_memCmdSent <= 1'b1;
      end
      if((! io_cpu_writeBack_isStuck))begin
        stageB_memCmdSent <= 1'b0;
      end
      if(stageB_loaderValid)begin
        loader_valid <= 1'b1;
      end
      loader_counter_value <= loader_counter_valueNext;
      if(_zz_15_)begin
        loader_error <= (loader_error || io_mem_rsp_payload_error);
      end
      if(loader_counter_willOverflow)begin
        loader_valid <= 1'b0;
        loader_error <= 1'b0;
      end
      if((! loader_valid))begin
        loader_waysAllocator <= _zz_21_[0:0];
      end
    end
  end


endmodule

module VexRiscv (
  input      [31:0]   externalResetVector,
  input               timerInterrupt,
  input               softwareInterrupt,
  input      [31:0]   externalInterruptArray,
  output reg          iBusWishbone_CYC,
  output reg          iBusWishbone_STB,
  input               iBusWishbone_ACK,
  output              iBusWishbone_WE,
  output     [29:0]   iBusWishbone_ADR,
  input      [31:0]   iBusWishbone_DAT_MISO,
  output     [31:0]   iBusWishbone_DAT_MOSI,
  output     [3:0]    iBusWishbone_SEL,
  input               iBusWishbone_ERR,
  output     [1:0]    iBusWishbone_BTE,
  output     [2:0]    iBusWishbone_CTI,
  output              dBusWishbone_CYC,
  output              dBusWishbone_STB,
  input               dBusWishbone_ACK,
  output              dBusWishbone_WE,
  output     [29:0]   dBusWishbone_ADR,
  input      [31:0]   dBusWishbone_DAT_MISO,
  output     [31:0]   dBusWishbone_DAT_MOSI,
  output     [3:0]    dBusWishbone_SEL,
  input               dBusWishbone_ERR,
  output     [1:0]    dBusWishbone_BTE,
  output     [2:0]    dBusWishbone_CTI,
  input               clk,
  input               reset 
);
  wire                _zz_561_;
  wire                _zz_562_;
  wire                _zz_563_;
  wire                _zz_564_;
  wire                _zz_565_;
  wire                _zz_566_;
  wire                _zz_567_;
  reg                 _zz_568_;
  wire                _zz_569_;
  wire       [31:0]   _zz_570_;
  wire                _zz_571_;
  wire       [31:0]   _zz_572_;
  reg                 _zz_573_;
  wire                _zz_574_;
  wire                _zz_575_;
  wire       [31:0]   _zz_576_;
  wire                _zz_577_;
  wire                _zz_578_;
  reg        [31:0]   _zz_579_;
  reg        [31:0]   _zz_580_;
  reg        [31:0]   _zz_581_;
  reg                 _zz_582_;
  reg                 _zz_583_;
  reg                 _zz_584_;
  reg                 _zz_585_;
  reg                 _zz_586_;
  reg                 _zz_587_;
  wire                IBusCachedPlugin_cache_io_cpu_prefetch_haltIt;
  wire       [31:0]   IBusCachedPlugin_cache_io_cpu_fetch_data;
  wire       [31:0]   IBusCachedPlugin_cache_io_cpu_fetch_physicalAddress;
  wire                IBusCachedPlugin_cache_io_cpu_fetch_haltIt;
  wire                IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_isValid;
  wire       [31:0]   IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_virtualAddress;
  wire                IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_bypassTranslation;
  wire                IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_end;
  wire                IBusCachedPlugin_cache_io_cpu_decode_error;
  wire                IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling;
  wire                IBusCachedPlugin_cache_io_cpu_decode_mmuException;
  wire       [31:0]   IBusCachedPlugin_cache_io_cpu_decode_data;
  wire                IBusCachedPlugin_cache_io_cpu_decode_cacheMiss;
  wire       [31:0]   IBusCachedPlugin_cache_io_cpu_decode_physicalAddress;
  wire                IBusCachedPlugin_cache_io_mem_cmd_valid;
  wire       [31:0]   IBusCachedPlugin_cache_io_mem_cmd_payload_address;
  wire       [2:0]    IBusCachedPlugin_cache_io_mem_cmd_payload_size;
  wire                dataCache_1__io_cpu_memory_isWrite;
  wire                dataCache_1__io_cpu_memory_mmuBus_cmd_isValid;
  wire       [31:0]   dataCache_1__io_cpu_memory_mmuBus_cmd_virtualAddress;
  wire                dataCache_1__io_cpu_memory_mmuBus_cmd_bypassTranslation;
  wire                dataCache_1__io_cpu_memory_mmuBus_end;
  wire                dataCache_1__io_cpu_writeBack_haltIt;
  wire       [31:0]   dataCache_1__io_cpu_writeBack_data;
  wire                dataCache_1__io_cpu_writeBack_mmuException;
  wire                dataCache_1__io_cpu_writeBack_unalignedAccess;
  wire                dataCache_1__io_cpu_writeBack_accessError;
  wire                dataCache_1__io_cpu_writeBack_isWrite;
  wire                dataCache_1__io_cpu_flush_ready;
  wire                dataCache_1__io_cpu_redo;
  wire                dataCache_1__io_mem_cmd_valid;
  wire                dataCache_1__io_mem_cmd_payload_wr;
  wire       [31:0]   dataCache_1__io_mem_cmd_payload_address;
  wire       [31:0]   dataCache_1__io_mem_cmd_payload_data;
  wire       [3:0]    dataCache_1__io_mem_cmd_payload_mask;
  wire       [2:0]    dataCache_1__io_mem_cmd_payload_length;
  wire                dataCache_1__io_mem_cmd_payload_last;
  wire                _zz_588_;
  wire                _zz_589_;
  wire                _zz_590_;
  wire                _zz_591_;
  wire                _zz_592_;
  wire                _zz_593_;
  wire                _zz_594_;
  wire                _zz_595_;
  wire                _zz_596_;
  wire                _zz_597_;
  wire                _zz_598_;
  wire                _zz_599_;
  wire                _zz_600_;
  wire                _zz_601_;
  wire       [1:0]    _zz_602_;
  wire                _zz_603_;
  wire                _zz_604_;
  wire                _zz_605_;
  wire                _zz_606_;
  wire                _zz_607_;
  wire                _zz_608_;
  wire                _zz_609_;
  wire                _zz_610_;
  wire                _zz_611_;
  wire                _zz_612_;
  wire                _zz_613_;
  wire                _zz_614_;
  wire       [1:0]    _zz_615_;
  wire                _zz_616_;
  wire                _zz_617_;
  wire                _zz_618_;
  wire                _zz_619_;
  wire                _zz_620_;
  wire                _zz_621_;
  wire                _zz_622_;
  wire                _zz_623_;
  wire                _zz_624_;
  wire                _zz_625_;
  wire                _zz_626_;
  wire                _zz_627_;
  wire                _zz_628_;
  wire                _zz_629_;
  wire                _zz_630_;
  wire                _zz_631_;
  wire                _zz_632_;
  wire                _zz_633_;
  wire                _zz_634_;
  wire                _zz_635_;
  wire                _zz_636_;
  wire                _zz_637_;
  wire                _zz_638_;
  wire                _zz_639_;
  wire       [1:0]    _zz_640_;
  wire                _zz_641_;
  wire       [1:0]    _zz_642_;
  wire       [0:0]    _zz_643_;
  wire       [51:0]   _zz_644_;
  wire       [51:0]   _zz_645_;
  wire       [51:0]   _zz_646_;
  wire       [32:0]   _zz_647_;
  wire       [51:0]   _zz_648_;
  wire       [49:0]   _zz_649_;
  wire       [51:0]   _zz_650_;
  wire       [49:0]   _zz_651_;
  wire       [51:0]   _zz_652_;
  wire       [0:0]    _zz_653_;
  wire       [0:0]    _zz_654_;
  wire       [32:0]   _zz_655_;
  wire       [31:0]   _zz_656_;
  wire       [32:0]   _zz_657_;
  wire       [0:0]    _zz_658_;
  wire       [0:0]    _zz_659_;
  wire       [0:0]    _zz_660_;
  wire       [0:0]    _zz_661_;
  wire       [0:0]    _zz_662_;
  wire       [0:0]    _zz_663_;
  wire       [0:0]    _zz_664_;
  wire       [0:0]    _zz_665_;
  wire       [0:0]    _zz_666_;
  wire       [0:0]    _zz_667_;
  wire       [0:0]    _zz_668_;
  wire       [0:0]    _zz_669_;
  wire       [0:0]    _zz_670_;
  wire       [0:0]    _zz_671_;
  wire       [3:0]    _zz_672_;
  wire       [2:0]    _zz_673_;
  wire       [31:0]   _zz_674_;
  wire       [11:0]   _zz_675_;
  wire       [31:0]   _zz_676_;
  wire       [19:0]   _zz_677_;
  wire       [11:0]   _zz_678_;
  wire       [31:0]   _zz_679_;
  wire       [31:0]   _zz_680_;
  wire       [19:0]   _zz_681_;
  wire       [11:0]   _zz_682_;
  wire       [2:0]    _zz_683_;
  wire       [2:0]    _zz_684_;
  wire       [31:0]   _zz_685_;
  wire       [31:0]   _zz_686_;
  wire       [31:0]   _zz_687_;
  wire       [31:0]   _zz_688_;
  wire       [31:0]   _zz_689_;
  wire       [31:0]   _zz_690_;
  wire       [31:0]   _zz_691_;
  wire       [31:0]   _zz_692_;
  wire       [31:0]   _zz_693_;
  wire       [31:0]   _zz_694_;
  wire       [31:0]   _zz_695_;
  wire       [31:0]   _zz_696_;
  wire       [31:0]   _zz_697_;
  wire       [31:0]   _zz_698_;
  wire       [31:0]   _zz_699_;
  wire       [31:0]   _zz_700_;
  wire       [31:0]   _zz_701_;
  wire       [31:0]   _zz_702_;
  wire       [31:0]   _zz_703_;
  wire       [31:0]   _zz_704_;
  wire       [31:0]   _zz_705_;
  wire       [31:0]   _zz_706_;
  wire       [31:0]   _zz_707_;
  wire       [31:0]   _zz_708_;
  wire       [31:0]   _zz_709_;
  wire       [31:0]   _zz_710_;
  wire       [31:0]   _zz_711_;
  wire       [31:0]   _zz_712_;
  wire       [31:0]   _zz_713_;
  wire       [31:0]   _zz_714_;
  wire       [31:0]   _zz_715_;
  wire       [31:0]   _zz_716_;
  wire       [31:0]   _zz_717_;
  wire       [31:0]   _zz_718_;
  wire       [31:0]   _zz_719_;
  wire       [31:0]   _zz_720_;
  wire       [31:0]   _zz_721_;
  wire       [31:0]   _zz_722_;
  wire       [31:0]   _zz_723_;
  wire       [31:0]   _zz_724_;
  wire       [31:0]   _zz_725_;
  wire       [31:0]   _zz_726_;
  wire       [31:0]   _zz_727_;
  wire       [31:0]   _zz_728_;
  wire       [31:0]   _zz_729_;
  wire       [31:0]   _zz_730_;
  wire       [31:0]   _zz_731_;
  wire       [31:0]   _zz_732_;
  wire       [15:0]   _zz_733_;
  wire       [15:0]   _zz_734_;
  wire       [15:0]   _zz_735_;
  wire       [15:0]   _zz_736_;
  wire       [15:0]   _zz_737_;
  wire       [15:0]   _zz_738_;
  wire       [0:0]    _zz_739_;
  wire       [2:0]    _zz_740_;
  wire       [4:0]    _zz_741_;
  wire       [11:0]   _zz_742_;
  wire       [11:0]   _zz_743_;
  wire       [31:0]   _zz_744_;
  wire       [31:0]   _zz_745_;
  wire       [31:0]   _zz_746_;
  wire       [31:0]   _zz_747_;
  wire       [31:0]   _zz_748_;
  wire       [31:0]   _zz_749_;
  wire       [31:0]   _zz_750_;
  wire       [11:0]   _zz_751_;
  wire       [19:0]   _zz_752_;
  wire       [11:0]   _zz_753_;
  wire       [31:0]   _zz_754_;
  wire       [31:0]   _zz_755_;
  wire       [31:0]   _zz_756_;
  wire       [11:0]   _zz_757_;
  wire       [19:0]   _zz_758_;
  wire       [11:0]   _zz_759_;
  wire       [2:0]    _zz_760_;
  wire       [1:0]    _zz_761_;
  wire       [1:0]    _zz_762_;
  wire       [65:0]   _zz_763_;
  wire       [65:0]   _zz_764_;
  wire       [31:0]   _zz_765_;
  wire       [31:0]   _zz_766_;
  wire       [0:0]    _zz_767_;
  wire       [5:0]    _zz_768_;
  wire       [32:0]   _zz_769_;
  wire       [31:0]   _zz_770_;
  wire       [31:0]   _zz_771_;
  wire       [32:0]   _zz_772_;
  wire       [32:0]   _zz_773_;
  wire       [32:0]   _zz_774_;
  wire       [32:0]   _zz_775_;
  wire       [0:0]    _zz_776_;
  wire       [32:0]   _zz_777_;
  wire       [0:0]    _zz_778_;
  wire       [32:0]   _zz_779_;
  wire       [0:0]    _zz_780_;
  wire       [31:0]   _zz_781_;
  wire       [0:0]    _zz_782_;
  wire       [0:0]    _zz_783_;
  wire       [0:0]    _zz_784_;
  wire       [0:0]    _zz_785_;
  wire       [0:0]    _zz_786_;
  wire       [0:0]    _zz_787_;
  wire       [0:0]    _zz_788_;
  wire       [0:0]    _zz_789_;
  wire       [0:0]    _zz_790_;
  wire       [0:0]    _zz_791_;
  wire       [0:0]    _zz_792_;
  wire       [0:0]    _zz_793_;
  wire       [0:0]    _zz_794_;
  wire       [0:0]    _zz_795_;
  wire       [0:0]    _zz_796_;
  wire       [0:0]    _zz_797_;
  wire       [0:0]    _zz_798_;
  wire       [0:0]    _zz_799_;
  wire       [0:0]    _zz_800_;
  wire       [0:0]    _zz_801_;
  wire       [0:0]    _zz_802_;
  wire       [0:0]    _zz_803_;
  wire       [0:0]    _zz_804_;
  wire       [0:0]    _zz_805_;
  wire       [0:0]    _zz_806_;
  wire       [0:0]    _zz_807_;
  wire       [0:0]    _zz_808_;
  wire       [0:0]    _zz_809_;
  wire       [0:0]    _zz_810_;
  wire       [0:0]    _zz_811_;
  wire       [0:0]    _zz_812_;
  wire       [0:0]    _zz_813_;
  wire       [0:0]    _zz_814_;
  wire       [0:0]    _zz_815_;
  wire       [0:0]    _zz_816_;
  wire       [0:0]    _zz_817_;
  wire       [0:0]    _zz_818_;
  wire       [0:0]    _zz_819_;
  wire       [0:0]    _zz_820_;
  wire       [0:0]    _zz_821_;
  wire       [0:0]    _zz_822_;
  wire       [0:0]    _zz_823_;
  wire       [0:0]    _zz_824_;
  wire       [0:0]    _zz_825_;
  wire       [0:0]    _zz_826_;
  wire       [0:0]    _zz_827_;
  wire       [0:0]    _zz_828_;
  wire       [0:0]    _zz_829_;
  wire       [0:0]    _zz_830_;
  wire       [0:0]    _zz_831_;
  wire       [0:0]    _zz_832_;
  wire       [0:0]    _zz_833_;
  wire       [0:0]    _zz_834_;
  wire       [0:0]    _zz_835_;
  wire       [0:0]    _zz_836_;
  wire       [0:0]    _zz_837_;
  wire       [0:0]    _zz_838_;
  wire       [0:0]    _zz_839_;
  wire       [0:0]    _zz_840_;
  wire       [0:0]    _zz_841_;
  wire       [0:0]    _zz_842_;
  wire       [0:0]    _zz_843_;
  wire       [0:0]    _zz_844_;
  wire       [0:0]    _zz_845_;
  wire       [0:0]    _zz_846_;
  wire       [0:0]    _zz_847_;
  wire       [0:0]    _zz_848_;
  wire       [0:0]    _zz_849_;
  wire       [0:0]    _zz_850_;
  wire       [0:0]    _zz_851_;
  wire       [0:0]    _zz_852_;
  wire       [26:0]   _zz_853_;
  wire                _zz_854_;
  wire                _zz_855_;
  wire       [1:0]    _zz_856_;
  wire       [3:0]    _zz_857_;
  wire       [3:0]    _zz_858_;
  wire       [3:0]    _zz_859_;
  wire       [3:0]    _zz_860_;
  wire       [3:0]    _zz_861_;
  wire       [3:0]    _zz_862_;
  wire       [31:0]   _zz_863_;
  wire       [31:0]   _zz_864_;
  wire       [31:0]   _zz_865_;
  wire                _zz_866_;
  wire       [0:0]    _zz_867_;
  wire       [13:0]   _zz_868_;
  wire       [31:0]   _zz_869_;
  wire       [31:0]   _zz_870_;
  wire       [31:0]   _zz_871_;
  wire                _zz_872_;
  wire       [0:0]    _zz_873_;
  wire       [7:0]    _zz_874_;
  wire       [31:0]   _zz_875_;
  wire       [31:0]   _zz_876_;
  wire       [31:0]   _zz_877_;
  wire                _zz_878_;
  wire       [0:0]    _zz_879_;
  wire       [1:0]    _zz_880_;
  wire                _zz_881_;
  wire                _zz_882_;
  wire                _zz_883_;
  wire       [0:0]    _zz_884_;
  wire       [4:0]    _zz_885_;
  wire       [0:0]    _zz_886_;
  wire       [4:0]    _zz_887_;
  wire       [0:0]    _zz_888_;
  wire       [4:0]    _zz_889_;
  wire       [0:0]    _zz_890_;
  wire       [4:0]    _zz_891_;
  wire       [0:0]    _zz_892_;
  wire       [4:0]    _zz_893_;
  wire       [0:0]    _zz_894_;
  wire       [4:0]    _zz_895_;
  wire       [31:0]   _zz_896_;
  wire       [31:0]   _zz_897_;
  wire       [31:0]   _zz_898_;
  wire       [31:0]   _zz_899_;
  wire                _zz_900_;
  wire       [4:0]    _zz_901_;
  wire       [4:0]    _zz_902_;
  wire                _zz_903_;
  wire       [0:0]    _zz_904_;
  wire       [25:0]   _zz_905_;
  wire       [31:0]   _zz_906_;
  wire       [31:0]   _zz_907_;
  wire       [0:0]    _zz_908_;
  wire       [1:0]    _zz_909_;
  wire       [0:0]    _zz_910_;
  wire       [3:0]    _zz_911_;
  wire       [0:0]    _zz_912_;
  wire       [1:0]    _zz_913_;
  wire       [0:0]    _zz_914_;
  wire       [0:0]    _zz_915_;
  wire                _zz_916_;
  wire       [0:0]    _zz_917_;
  wire       [22:0]   _zz_918_;
  wire       [31:0]   _zz_919_;
  wire       [31:0]   _zz_920_;
  wire                _zz_921_;
  wire                _zz_922_;
  wire       [31:0]   _zz_923_;
  wire       [31:0]   _zz_924_;
  wire                _zz_925_;
  wire       [0:0]    _zz_926_;
  wire       [1:0]    _zz_927_;
  wire       [31:0]   _zz_928_;
  wire       [31:0]   _zz_929_;
  wire                _zz_930_;
  wire                _zz_931_;
  wire       [31:0]   _zz_932_;
  wire       [31:0]   _zz_933_;
  wire                _zz_934_;
  wire       [0:0]    _zz_935_;
  wire       [0:0]    _zz_936_;
  wire                _zz_937_;
  wire       [0:0]    _zz_938_;
  wire       [20:0]   _zz_939_;
  wire       [31:0]   _zz_940_;
  wire       [31:0]   _zz_941_;
  wire       [31:0]   _zz_942_;
  wire       [31:0]   _zz_943_;
  wire       [31:0]   _zz_944_;
  wire                _zz_945_;
  wire                _zz_946_;
  wire       [31:0]   _zz_947_;
  wire       [31:0]   _zz_948_;
  wire       [31:0]   _zz_949_;
  wire       [31:0]   _zz_950_;
  wire       [31:0]   _zz_951_;
  wire                _zz_952_;
  wire       [4:0]    _zz_953_;
  wire       [4:0]    _zz_954_;
  wire                _zz_955_;
  wire       [0:0]    _zz_956_;
  wire       [18:0]   _zz_957_;
  wire       [31:0]   _zz_958_;
  wire       [31:0]   _zz_959_;
  wire                _zz_960_;
  wire       [0:0]    _zz_961_;
  wire       [1:0]    _zz_962_;
  wire                _zz_963_;
  wire                _zz_964_;
  wire       [0:0]    _zz_965_;
  wire       [1:0]    _zz_966_;
  wire       [3:0]    _zz_967_;
  wire       [3:0]    _zz_968_;
  wire                _zz_969_;
  wire       [0:0]    _zz_970_;
  wire       [15:0]   _zz_971_;
  wire       [31:0]   _zz_972_;
  wire       [31:0]   _zz_973_;
  wire       [31:0]   _zz_974_;
  wire                _zz_975_;
  wire                _zz_976_;
  wire       [31:0]   _zz_977_;
  wire       [31:0]   _zz_978_;
  wire       [31:0]   _zz_979_;
  wire       [31:0]   _zz_980_;
  wire                _zz_981_;
  wire                _zz_982_;
  wire                _zz_983_;
  wire       [0:0]    _zz_984_;
  wire       [1:0]    _zz_985_;
  wire                _zz_986_;
  wire       [0:0]    _zz_987_;
  wire       [0:0]    _zz_988_;
  wire                _zz_989_;
  wire       [0:0]    _zz_990_;
  wire       [13:0]   _zz_991_;
  wire       [31:0]   _zz_992_;
  wire       [31:0]   _zz_993_;
  wire       [31:0]   _zz_994_;
  wire       [31:0]   _zz_995_;
  wire       [31:0]   _zz_996_;
  wire       [31:0]   _zz_997_;
  wire       [31:0]   _zz_998_;
  wire                _zz_999_;
  wire                _zz_1000_;
  wire       [31:0]   _zz_1001_;
  wire       [31:0]   _zz_1002_;
  wire       [31:0]   _zz_1003_;
  wire                _zz_1004_;
  wire       [4:0]    _zz_1005_;
  wire       [4:0]    _zz_1006_;
  wire                _zz_1007_;
  wire       [0:0]    _zz_1008_;
  wire       [11:0]   _zz_1009_;
  wire                _zz_1010_;
  wire       [0:0]    _zz_1011_;
  wire       [1:0]    _zz_1012_;
  wire                _zz_1013_;
  wire                _zz_1014_;
  wire                _zz_1015_;
  wire       [0:0]    _zz_1016_;
  wire       [0:0]    _zz_1017_;
  wire                _zz_1018_;
  wire       [0:0]    _zz_1019_;
  wire       [8:0]    _zz_1020_;
  wire       [31:0]   _zz_1021_;
  wire       [31:0]   _zz_1022_;
  wire       [31:0]   _zz_1023_;
  wire                _zz_1024_;
  wire                _zz_1025_;
  wire       [31:0]   _zz_1026_;
  wire       [31:0]   _zz_1027_;
  wire       [31:0]   _zz_1028_;
  wire       [0:0]    _zz_1029_;
  wire       [0:0]    _zz_1030_;
  wire       [0:0]    _zz_1031_;
  wire       [0:0]    _zz_1032_;
  wire                _zz_1033_;
  wire       [0:0]    _zz_1034_;
  wire       [6:0]    _zz_1035_;
  wire       [31:0]   _zz_1036_;
  wire       [31:0]   _zz_1037_;
  wire       [31:0]   _zz_1038_;
  wire       [31:0]   _zz_1039_;
  wire       [31:0]   _zz_1040_;
  wire                _zz_1041_;
  wire       [1:0]    _zz_1042_;
  wire       [1:0]    _zz_1043_;
  wire                _zz_1044_;
  wire       [0:0]    _zz_1045_;
  wire       [3:0]    _zz_1046_;
  wire       [31:0]   _zz_1047_;
  wire       [31:0]   _zz_1048_;
  wire       [31:0]   _zz_1049_;
  wire       [31:0]   _zz_1050_;
  wire       [31:0]   _zz_1051_;
  wire       [0:0]    _zz_1052_;
  wire       [0:0]    _zz_1053_;
  wire       [1:0]    _zz_1054_;
  wire       [1:0]    _zz_1055_;
  wire                _zz_1056_;
  wire                _zz_1057_;
  wire                _zz_1058_;
  wire                _zz_1059_;
  wire                _zz_1060_;
  wire       [31:0]   _zz_1061_;
  wire       [31:0]   _zz_1062_;
  wire       [31:0]   _zz_1063_;
  wire       [31:0]   _zz_1064_;
  wire       [31:0]   _zz_1065_;
  wire       [31:0]   _zz_1066_;
  wire       [31:0]   _zz_1067_;
  wire       [31:0]   _zz_1068_;
  wire       [31:0]   _zz_1069_;
  wire       [31:0]   _zz_1070_;
  wire       [31:0]   _zz_1071_;
  wire       [31:0]   _zz_1072_;
  wire       [31:0]   _zz_1073_;
  wire       [31:0]   _zz_1074_;
  wire       [31:0]   _zz_1075_;
  wire       [31:0]   _zz_1076_;
  wire       [31:0]   _zz_1077_;
  wire                decode_CSR_READ_OPCODE;
  wire       [31:0]   execute_REGFILE_WRITE_DATA;
  wire                execute_BRANCH_DO;
  wire                decode_IS_DIV;
  wire       `Src2CtrlEnum_defaultEncoding_type decode_SRC2_CTRL;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_1_;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_2_;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_3_;
  wire       [51:0]   memory_MUL_LOW;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type decode_ALU_BITWISE_CTRL;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_4_;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_5_;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_6_;
  wire                memory_MEMORY_WR;
  wire                decode_MEMORY_WR;
  wire       [33:0]   execute_MUL_LH;
  wire       [31:0]   execute_MUL_LL;
  wire                decode_CSR_WRITE_OPCODE;
  wire                decode_SRC2_FORCE_ZERO;
  wire       `Src1CtrlEnum_defaultEncoding_type decode_SRC1_CTRL;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_7_;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_8_;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_9_;
  wire                decode_IS_CSR;
  wire       [31:0]   execute_SHIFT_RIGHT;
  wire       [31:0]   writeBack_FORMAL_PC_NEXT;
  wire       [31:0]   memory_FORMAL_PC_NEXT;
  wire       [31:0]   execute_FORMAL_PC_NEXT;
  wire       [31:0]   decode_FORMAL_PC_NEXT;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_10_;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_11_;
  wire       `ShiftCtrlEnum_defaultEncoding_type decode_SHIFT_CTRL;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_12_;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_13_;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_14_;
  wire                decode_SRC_LESS_UNSIGNED;
  wire                execute_BYPASSABLE_MEMORY_STAGE;
  wire                decode_BYPASSABLE_MEMORY_STAGE;
  wire       [31:0]   execute_BRANCH_CALC;
  wire                decode_PREDICTION_HAD_BRANCHED2;
  wire       [1:0]    memory_MEMORY_ADDRESS_LOW;
  wire       [1:0]    execute_MEMORY_ADDRESS_LOW;
  wire       [33:0]   execute_MUL_HL;
  wire                decode_BYPASSABLE_EXECUTE_STAGE;
  wire       `AluCtrlEnum_defaultEncoding_type decode_ALU_CTRL;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_15_;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_16_;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_17_;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_18_;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_19_;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_20_;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_21_;
  wire       `EnvCtrlEnum_defaultEncoding_type decode_ENV_CTRL;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_22_;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_23_;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_24_;
  wire                decode_IS_RS1_SIGNED;
  wire                memory_IS_MUL;
  wire                execute_IS_MUL;
  wire                decode_IS_MUL;
  wire       [33:0]   memory_MUL_HH;
  wire       [33:0]   execute_MUL_HH;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_25_;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_26_;
  wire       [31:0]   memory_PC;
  wire                decode_MEMORY_MANAGMENT;
  wire                decode_IS_RS2_SIGNED;
  wire                execute_IS_RS1_SIGNED;
  wire                execute_IS_DIV;
  wire                execute_IS_RS2_SIGNED;
  wire                memory_IS_DIV;
  wire                writeBack_IS_MUL;
  wire       [33:0]   writeBack_MUL_HH;
  wire       [51:0]   writeBack_MUL_LOW;
  wire       [33:0]   memory_MUL_HL;
  wire       [33:0]   memory_MUL_LH;
  wire       [31:0]   memory_MUL_LL;
  wire                execute_CSR_READ_OPCODE;
  wire                execute_CSR_WRITE_OPCODE;
  wire                execute_IS_CSR;
  wire       `EnvCtrlEnum_defaultEncoding_type memory_ENV_CTRL;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_27_;
  wire       `EnvCtrlEnum_defaultEncoding_type execute_ENV_CTRL;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_28_;
  wire       `EnvCtrlEnum_defaultEncoding_type writeBack_ENV_CTRL;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_29_;
  wire       [31:0]   memory_BRANCH_CALC;
  wire                memory_BRANCH_DO;
  wire       [31:0]   execute_PC;
  wire                execute_PREDICTION_HAD_BRANCHED2;
  (* syn_keep , keep *) wire       [31:0]   execute_RS1 /* synthesis syn_keep = 1 */ ;
  wire                execute_BRANCH_COND_RESULT;
  wire       `BranchCtrlEnum_defaultEncoding_type execute_BRANCH_CTRL;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_30_;
  wire                decode_RS2_USE;
  wire                decode_RS1_USE;
  reg        [31:0]   _zz_31_;
  wire                execute_REGFILE_WRITE_VALID;
  wire                execute_BYPASSABLE_EXECUTE_STAGE;
  wire                memory_REGFILE_WRITE_VALID;
  wire       [31:0]   memory_INSTRUCTION;
  wire                memory_BYPASSABLE_MEMORY_STAGE;
  wire                writeBack_REGFILE_WRITE_VALID;
  reg        [31:0]   decode_RS2;
  reg        [31:0]   decode_RS1;
  wire       [31:0]   memory_SHIFT_RIGHT;
  reg        [31:0]   _zz_32_;
  wire       `ShiftCtrlEnum_defaultEncoding_type memory_SHIFT_CTRL;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_33_;
  wire       `ShiftCtrlEnum_defaultEncoding_type execute_SHIFT_CTRL;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_34_;
  wire                execute_SRC_LESS_UNSIGNED;
  wire                execute_SRC2_FORCE_ZERO;
  wire                execute_SRC_USE_SUB_LESS;
  wire       [31:0]   _zz_35_;
  wire       `Src2CtrlEnum_defaultEncoding_type execute_SRC2_CTRL;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_36_;
  wire       `Src1CtrlEnum_defaultEncoding_type execute_SRC1_CTRL;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_37_;
  wire                decode_SRC_USE_SUB_LESS;
  wire                decode_SRC_ADD_ZERO;
  wire       [31:0]   execute_SRC_ADD_SUB;
  wire                execute_SRC_LESS;
  wire       `AluCtrlEnum_defaultEncoding_type execute_ALU_CTRL;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_38_;
  wire       [31:0]   execute_SRC2;
  wire       [31:0]   execute_SRC1;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type execute_ALU_BITWISE_CTRL;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_39_;
  wire       [31:0]   _zz_40_;
  wire                _zz_41_;
  reg                 _zz_42_;
  wire       [31:0]   decode_INSTRUCTION_ANTICIPATED;
  reg                 decode_REGFILE_WRITE_VALID;
  wire                decode_LEGAL_INSTRUCTION;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_43_;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_44_;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_45_;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_46_;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_47_;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_48_;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_49_;
  reg        [4:0]    _zz_50_;
  reg        [4:0]    _zz_50__14;
  reg        [4:0]    _zz_50__13;
  reg        [4:0]    _zz_50__12;
  reg        [4:0]    _zz_50__11;
  reg        [4:0]    _zz_50__10;
  reg        [4:0]    _zz_50__9;
  reg        [4:0]    _zz_50__8;
  reg        [4:0]    _zz_50__7;
  reg        [4:0]    _zz_50__6;
  reg        [4:0]    _zz_50__5;
  reg        [4:0]    _zz_50__4;
  reg        [4:0]    _zz_50__3;
  reg        [4:0]    _zz_50__2;
  reg        [4:0]    _zz_50__1;
  reg        [4:0]    _zz_50__0;
  reg        [4:0]    _zz_51_;
  reg        [4:0]    _zz_51__14;
  reg        [4:0]    _zz_51__13;
  reg        [4:0]    _zz_51__12;
  reg        [4:0]    _zz_51__11;
  reg        [4:0]    _zz_51__10;
  reg        [4:0]    _zz_51__9;
  reg        [4:0]    _zz_51__8;
  reg        [4:0]    _zz_51__7;
  reg        [4:0]    _zz_51__6;
  reg        [4:0]    _zz_51__5;
  reg        [4:0]    _zz_51__4;
  reg        [4:0]    _zz_51__3;
  reg        [4:0]    _zz_51__2;
  reg        [4:0]    _zz_51__1;
  reg        [4:0]    _zz_51__0;
  reg        [31:0]   _zz_52_;
  wire       [1:0]    writeBack_MEMORY_ADDRESS_LOW;
  wire                writeBack_MEMORY_WR;
  wire       [31:0]   writeBack_REGFILE_WRITE_DATA;
  wire                writeBack_MEMORY_ENABLE;
  wire       [31:0]   memory_REGFILE_WRITE_DATA;
  wire                memory_MEMORY_ENABLE;
  wire                execute_MEMORY_MANAGMENT;
  (* syn_keep , keep *) wire       [31:0]   execute_RS2 /* synthesis syn_keep = 1 */ ;
  wire                execute_MEMORY_WR;
  wire       [31:0]   execute_SRC_ADD;
  wire                execute_MEMORY_ENABLE;
  wire       [31:0]   execute_INSTRUCTION;
  wire                decode_MEMORY_ENABLE;
  wire                decode_FLUSH_ALL;
  reg                 _zz_53_;
  reg                 _zz_53__2;
  reg                 _zz_53__1;
  reg                 _zz_53__0;
  wire       `BranchCtrlEnum_defaultEncoding_type decode_BRANCH_CTRL;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_54_;
  wire       [31:0]   decode_INSTRUCTION;
  reg        [31:0]   _zz_55_;
  reg        [31:0]   _zz_56_;
  wire       [31:0]   decode_PC;
  wire       [31:0]   writeBack_PC;
  wire       [31:0]   writeBack_INSTRUCTION;
  reg                 decode_arbitration_haltItself;
  reg                 decode_arbitration_haltByOther;
  reg                 decode_arbitration_removeIt;
  wire                decode_arbitration_flushIt;
  reg                 decode_arbitration_flushNext;
  wire                decode_arbitration_isValid;
  wire                decode_arbitration_isStuck;
  wire                decode_arbitration_isStuckByOthers;
  wire                decode_arbitration_isFlushed;
  wire                decode_arbitration_isMoving;
  wire                decode_arbitration_isFiring;
  reg                 execute_arbitration_haltItself;
  wire                execute_arbitration_haltByOther;
  reg                 execute_arbitration_removeIt;
  wire                execute_arbitration_flushIt;
  reg                 execute_arbitration_flushNext;
  reg                 execute_arbitration_isValid;
  wire                execute_arbitration_isStuck;
  wire                execute_arbitration_isStuckByOthers;
  wire                execute_arbitration_isFlushed;
  wire                execute_arbitration_isMoving;
  wire                execute_arbitration_isFiring;
  reg                 memory_arbitration_haltItself;
  wire                memory_arbitration_haltByOther;
  reg                 memory_arbitration_removeIt;
  wire                memory_arbitration_flushIt;
  reg                 memory_arbitration_flushNext;
  reg                 memory_arbitration_isValid;
  wire                memory_arbitration_isStuck;
  wire                memory_arbitration_isStuckByOthers;
  wire                memory_arbitration_isFlushed;
  wire                memory_arbitration_isMoving;
  wire                memory_arbitration_isFiring;
  reg                 writeBack_arbitration_haltItself;
  wire                writeBack_arbitration_haltByOther;
  reg                 writeBack_arbitration_removeIt;
  reg                 writeBack_arbitration_flushIt;
  reg                 writeBack_arbitration_flushNext;
  reg                 writeBack_arbitration_isValid;
  wire                writeBack_arbitration_isStuck;
  wire                writeBack_arbitration_isStuckByOthers;
  wire                writeBack_arbitration_isFlushed;
  wire                writeBack_arbitration_isMoving;
  wire                writeBack_arbitration_isFiring;
  wire       [31:0]   lastStageInstruction /* verilator public */ ;
  wire       [31:0]   lastStagePc /* verilator public */ ;
  wire                lastStageIsValid /* verilator public */ ;
  wire                lastStageIsFiring /* verilator public */ ;
  reg                 IBusCachedPlugin_fetcherHalt;
  reg                 IBusCachedPlugin_incomingInstruction;
  wire                IBusCachedPlugin_predictionJumpInterface_valid;
  (* syn_keep , keep *) wire       [31:0]   IBusCachedPlugin_predictionJumpInterface_payload /* synthesis syn_keep = 1 */ ;
  reg                 IBusCachedPlugin_decodePrediction_cmd_hadBranch;
  wire                IBusCachedPlugin_decodePrediction_rsp_wasWrong;
  wire                IBusCachedPlugin_pcValids_0;
  wire                IBusCachedPlugin_pcValids_1;
  wire                IBusCachedPlugin_pcValids_2;
  wire                IBusCachedPlugin_pcValids_3;
  reg                 IBusCachedPlugin_decodeExceptionPort_valid;
  reg        [3:0]    IBusCachedPlugin_decodeExceptionPort_payload_code;
  wire       [31:0]   IBusCachedPlugin_decodeExceptionPort_payload_badAddr;
  wire                IBusCachedPlugin_mmuBus_cmd_isValid;
  wire       [31:0]   IBusCachedPlugin_mmuBus_cmd_virtualAddress;
  wire                IBusCachedPlugin_mmuBus_cmd_bypassTranslation;
  wire       [31:0]   IBusCachedPlugin_mmuBus_rsp_physicalAddress;
  wire                IBusCachedPlugin_mmuBus_rsp_isIoAccess;
  reg                 IBusCachedPlugin_mmuBus_rsp_allowRead;
  reg                 IBusCachedPlugin_mmuBus_rsp_allowWrite;
  reg                 IBusCachedPlugin_mmuBus_rsp_allowExecute;
  wire                IBusCachedPlugin_mmuBus_rsp_exception;
  wire                IBusCachedPlugin_mmuBus_rsp_refilling;
  wire                IBusCachedPlugin_mmuBus_end;
  wire                IBusCachedPlugin_mmuBus_busy;
  wire                DBusCachedPlugin_mmuBus_cmd_isValid;
  wire       [31:0]   DBusCachedPlugin_mmuBus_cmd_virtualAddress;
  wire                DBusCachedPlugin_mmuBus_cmd_bypassTranslation;
  wire       [31:0]   DBusCachedPlugin_mmuBus_rsp_physicalAddress;
  wire                DBusCachedPlugin_mmuBus_rsp_isIoAccess;
  reg                 DBusCachedPlugin_mmuBus_rsp_allowRead;
  reg                 DBusCachedPlugin_mmuBus_rsp_allowWrite;
  reg                 DBusCachedPlugin_mmuBus_rsp_allowExecute;
  wire                DBusCachedPlugin_mmuBus_rsp_exception;
  wire                DBusCachedPlugin_mmuBus_rsp_refilling;
  wire                DBusCachedPlugin_mmuBus_end;
  wire                DBusCachedPlugin_mmuBus_busy;
  reg                 DBusCachedPlugin_redoBranch_valid;
  wire       [31:0]   DBusCachedPlugin_redoBranch_payload;
  reg                 DBusCachedPlugin_exceptionBus_valid;
  reg        [3:0]    DBusCachedPlugin_exceptionBus_payload_code;
  wire       [31:0]   DBusCachedPlugin_exceptionBus_payload_badAddr;
  wire                decodeExceptionPort_valid;
  wire       [3:0]    decodeExceptionPort_payload_code;
  wire       [31:0]   decodeExceptionPort_payload_badAddr;
  wire                BranchPlugin_jumpInterface_valid;
  wire       [31:0]   BranchPlugin_jumpInterface_payload;
  wire                BranchPlugin_branchExceptionPort_valid;
  wire       [3:0]    BranchPlugin_branchExceptionPort_payload_code;
  wire       [31:0]   BranchPlugin_branchExceptionPort_payload_badAddr;
  reg                 CsrPlugin_inWfi /* verilator public */ ;
  wire                CsrPlugin_thirdPartyWake;
  reg                 CsrPlugin_jumpInterface_valid;
  reg        [31:0]   CsrPlugin_jumpInterface_payload;
  wire                CsrPlugin_exceptionPendings_0;
  wire                CsrPlugin_exceptionPendings_1;
  wire                CsrPlugin_exceptionPendings_2;
  wire                CsrPlugin_exceptionPendings_3;
  wire                externalInterrupt;
  wire                contextSwitching;
  reg        [1:0]    CsrPlugin_privilege;
  wire                CsrPlugin_forceMachineWire;
  reg                 CsrPlugin_selfException_valid;
  reg        [3:0]    CsrPlugin_selfException_payload_code;
  wire       [31:0]   CsrPlugin_selfException_payload_badAddr;
  wire                CsrPlugin_allowInterrupts;
  wire                CsrPlugin_allowException;
  wire                IBusCachedPlugin_externalFlush;
  wire                IBusCachedPlugin_jump_pcLoad_valid;
  wire       [31:0]   IBusCachedPlugin_jump_pcLoad_payload;
  wire       [3:0]    _zz_57_;
  wire       [3:0]    _zz_58_;
  wire                _zz_59_;
  wire                _zz_60_;
  wire                _zz_61_;
  wire                IBusCachedPlugin_fetchPc_output_valid;
  wire                IBusCachedPlugin_fetchPc_output_ready;
  wire       [31:0]   IBusCachedPlugin_fetchPc_output_payload;
  reg        [31:0]   IBusCachedPlugin_fetchPc_pcReg /* verilator public */ ;
  reg                 IBusCachedPlugin_fetchPc_correction;
  reg                 IBusCachedPlugin_fetchPc_correctionReg;
  wire                IBusCachedPlugin_fetchPc_corrected;
  reg                 IBusCachedPlugin_fetchPc_pcRegPropagate;
  reg                 IBusCachedPlugin_fetchPc_booted;
  reg                 IBusCachedPlugin_fetchPc_inc;
  reg        [31:0]   IBusCachedPlugin_fetchPc_pc;
  wire                IBusCachedPlugin_fetchPc_redo_valid;
  wire       [31:0]   IBusCachedPlugin_fetchPc_redo_payload;
  reg                 IBusCachedPlugin_fetchPc_flushed;
  reg                 IBusCachedPlugin_iBusRsp_redoFetch;
  wire                IBusCachedPlugin_iBusRsp_stages_0_input_valid;
  wire                IBusCachedPlugin_iBusRsp_stages_0_input_ready;
  wire       [31:0]   IBusCachedPlugin_iBusRsp_stages_0_input_payload;
  wire                IBusCachedPlugin_iBusRsp_stages_0_output_valid;
  wire                IBusCachedPlugin_iBusRsp_stages_0_output_ready;
  wire       [31:0]   IBusCachedPlugin_iBusRsp_stages_0_output_payload;
  reg                 IBusCachedPlugin_iBusRsp_stages_0_halt;
  wire                IBusCachedPlugin_iBusRsp_stages_1_input_valid;
  wire                IBusCachedPlugin_iBusRsp_stages_1_input_ready;
  wire       [31:0]   IBusCachedPlugin_iBusRsp_stages_1_input_payload;
  wire                IBusCachedPlugin_iBusRsp_stages_1_output_valid;
  wire                IBusCachedPlugin_iBusRsp_stages_1_output_ready;
  wire       [31:0]   IBusCachedPlugin_iBusRsp_stages_1_output_payload;
  reg                 IBusCachedPlugin_iBusRsp_stages_1_halt;
  wire                IBusCachedPlugin_iBusRsp_stages_2_input_valid;
  wire                IBusCachedPlugin_iBusRsp_stages_2_input_ready;
  wire       [31:0]   IBusCachedPlugin_iBusRsp_stages_2_input_payload;
  wire                IBusCachedPlugin_iBusRsp_stages_2_output_valid;
  wire                IBusCachedPlugin_iBusRsp_stages_2_output_ready;
  wire       [31:0]   IBusCachedPlugin_iBusRsp_stages_2_output_payload;
  reg                 IBusCachedPlugin_iBusRsp_stages_2_halt;
  wire                _zz_62_;
  wire                _zz_63_;
  wire                _zz_64_;
  wire                IBusCachedPlugin_iBusRsp_flush;
  wire                _zz_65_;
  wire                _zz_66_;
  reg                 _zz_67_;
  wire                _zz_68_;
  reg                 _zz_69_;
  reg        [31:0]   _zz_70_;
  reg                 IBusCachedPlugin_iBusRsp_readyForError;
  wire                IBusCachedPlugin_iBusRsp_output_valid;
  wire                IBusCachedPlugin_iBusRsp_output_ready;
  wire       [31:0]   IBusCachedPlugin_iBusRsp_output_payload_pc;
  wire                IBusCachedPlugin_iBusRsp_output_payload_rsp_error;
  wire       [31:0]   IBusCachedPlugin_iBusRsp_output_payload_rsp_inst;
  wire                IBusCachedPlugin_iBusRsp_output_payload_isRvc;
  reg                 IBusCachedPlugin_injector_nextPcCalc_valids_0;
  reg                 IBusCachedPlugin_injector_nextPcCalc_valids_1;
  reg                 IBusCachedPlugin_injector_nextPcCalc_valids_2;
  reg                 IBusCachedPlugin_injector_nextPcCalc_valids_3;
  reg                 IBusCachedPlugin_injector_nextPcCalc_valids_4;
  wire                _zz_71_;
  reg        [18:0]   _zz_72_;
  wire                _zz_73_;
  reg        [10:0]   _zz_74_;
  wire                _zz_75_;
  reg        [18:0]   _zz_76_;
  reg                 _zz_77_;
  wire                _zz_78_;
  reg        [10:0]   _zz_79_;
  wire                _zz_80_;
  reg        [18:0]   _zz_81_;
  wire                iBus_cmd_valid;
  wire                iBus_cmd_ready;
  reg        [31:0]   iBus_cmd_payload_address;
  wire       [2:0]    iBus_cmd_payload_size;
  wire                iBus_rsp_valid;
  wire       [31:0]   iBus_rsp_payload_data;
  wire                iBus_rsp_payload_error;
  wire       [31:0]   _zz_82_;
  reg        [31:0]   IBusCachedPlugin_rspCounter;
  wire                IBusCachedPlugin_s0_tightlyCoupledHit;
  reg                 IBusCachedPlugin_s1_tightlyCoupledHit;
  reg                 IBusCachedPlugin_s2_tightlyCoupledHit;
  wire                IBusCachedPlugin_rsp_iBusRspOutputHalt;
  wire                IBusCachedPlugin_rsp_issueDetected;
  reg                 IBusCachedPlugin_rsp_redoFetch;
  wire                dBus_cmd_valid;
  wire                dBus_cmd_ready;
  wire                dBus_cmd_payload_wr;
  wire       [31:0]   dBus_cmd_payload_address;
  wire       [31:0]   dBus_cmd_payload_data;
  wire       [3:0]    dBus_cmd_payload_mask;
  wire       [2:0]    dBus_cmd_payload_length;
  wire                dBus_cmd_payload_last;
  wire                dBus_rsp_valid;
  wire       [31:0]   dBus_rsp_payload_data;
  wire                dBus_rsp_payload_error;
  wire                dataCache_1__io_mem_cmd_s2mPipe_valid;
  wire                dataCache_1__io_mem_cmd_s2mPipe_ready;
  wire                dataCache_1__io_mem_cmd_s2mPipe_payload_wr;
  wire       [31:0]   dataCache_1__io_mem_cmd_s2mPipe_payload_address;
  wire       [31:0]   dataCache_1__io_mem_cmd_s2mPipe_payload_data;
  wire       [3:0]    dataCache_1__io_mem_cmd_s2mPipe_payload_mask;
  wire       [2:0]    dataCache_1__io_mem_cmd_s2mPipe_payload_length;
  wire                dataCache_1__io_mem_cmd_s2mPipe_payload_last;
  reg                 dataCache_1__io_mem_cmd_s2mPipe_rValid;
  reg                 dataCache_1__io_mem_cmd_s2mPipe_rData_wr;
  reg        [31:0]   dataCache_1__io_mem_cmd_s2mPipe_rData_address;
  reg        [31:0]   dataCache_1__io_mem_cmd_s2mPipe_rData_data;
  reg        [3:0]    dataCache_1__io_mem_cmd_s2mPipe_rData_mask;
  reg        [2:0]    dataCache_1__io_mem_cmd_s2mPipe_rData_length;
  reg                 dataCache_1__io_mem_cmd_s2mPipe_rData_last;
  wire                dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_valid;
  wire                dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_ready;
  wire                dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_wr;
  wire       [31:0]   dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_address;
  wire       [31:0]   dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_data;
  wire       [3:0]    dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_mask;
  wire       [2:0]    dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_length;
  wire                dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_last;
  reg                 dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rValid;
  reg                 dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_wr;
  reg        [31:0]   dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_address;
  reg        [31:0]   dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_data;
  reg        [3:0]    dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_mask;
  reg        [2:0]    dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_length;
  reg                 dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_last;
  wire       [31:0]   _zz_83_;
  reg        [31:0]   DBusCachedPlugin_rspCounter;
  wire       [1:0]    execute_DBusCachedPlugin_size;
  reg        [31:0]   _zz_84_;
  reg        [31:0]   writeBack_DBusCachedPlugin_rspShifted;
  wire                _zz_85_;
  reg        [31:0]   _zz_86_;
  wire                _zz_87_;
  reg        [31:0]   _zz_88_;
  reg        [31:0]   writeBack_DBusCachedPlugin_rspFormated;
  reg                 _zz_89_;
  reg                 _zz_90_;
  reg                 _zz_91_;
  reg                 _zz_92_;
  reg        [1:0]    _zz_93_;
  reg        [31:0]   _zz_94_;
  reg                 _zz_95_;
  reg                 _zz_96_;
  reg                 _zz_97_;
  reg                 _zz_98_;
  reg                 _zz_99_;
  reg        [31:0]   _zz_100_;
  reg        [31:0]   _zz_101_;
  wire       [31:0]   _zz_102_;
  wire       [31:0]   _zz_103_;
  wire       [31:0]   _zz_104_;
  reg                 _zz_105_;
  reg                 _zz_106_;
  reg                 _zz_107_;
  reg                 _zz_108_;
  reg        [1:0]    _zz_109_;
  reg        [31:0]   _zz_110_;
  reg                 _zz_111_;
  reg                 _zz_112_;
  reg                 _zz_113_;
  reg                 _zz_114_;
  reg                 _zz_115_;
  reg        [31:0]   _zz_116_;
  reg        [31:0]   _zz_117_;
  wire       [31:0]   _zz_118_;
  wire       [31:0]   _zz_119_;
  wire       [31:0]   _zz_120_;
  reg                 _zz_121_;
  reg                 _zz_122_;
  reg                 _zz_123_;
  reg                 _zz_124_;
  reg        [1:0]    _zz_125_;
  reg        [31:0]   _zz_126_;
  reg                 _zz_127_;
  reg                 _zz_128_;
  reg                 _zz_129_;
  reg                 _zz_130_;
  reg                 _zz_131_;
  reg        [31:0]   _zz_132_;
  reg        [31:0]   _zz_133_;
  wire       [31:0]   _zz_134_;
  wire       [31:0]   _zz_135_;
  wire       [31:0]   _zz_136_;
  reg                 _zz_137_;
  reg                 _zz_138_;
  reg                 _zz_139_;
  reg                 _zz_140_;
  reg        [1:0]    _zz_141_;
  reg        [31:0]   _zz_142_;
  reg                 _zz_143_;
  reg                 _zz_144_;
  reg                 _zz_145_;
  reg                 _zz_146_;
  reg                 _zz_147_;
  reg        [31:0]   _zz_148_;
  reg        [31:0]   _zz_149_;
  wire       [31:0]   _zz_150_;
  wire       [31:0]   _zz_151_;
  wire       [31:0]   _zz_152_;
  reg                 _zz_153_;
  reg                 _zz_154_;
  reg                 _zz_155_;
  reg                 _zz_156_;
  reg        [1:0]    _zz_157_;
  reg        [31:0]   _zz_158_;
  reg                 _zz_159_;
  reg                 _zz_160_;
  reg                 _zz_161_;
  reg                 _zz_162_;
  reg                 _zz_163_;
  reg        [31:0]   _zz_164_;
  reg        [31:0]   _zz_165_;
  wire       [31:0]   _zz_166_;
  wire       [31:0]   _zz_167_;
  wire       [31:0]   _zz_168_;
  reg                 _zz_169_;
  reg                 _zz_170_;
  reg                 _zz_171_;
  reg                 _zz_172_;
  reg        [1:0]    _zz_173_;
  reg        [31:0]   _zz_174_;
  reg                 _zz_175_;
  reg                 _zz_176_;
  reg                 _zz_177_;
  reg                 _zz_178_;
  reg                 _zz_179_;
  reg        [31:0]   _zz_180_;
  reg        [31:0]   _zz_181_;
  wire       [31:0]   _zz_182_;
  wire       [31:0]   _zz_183_;
  wire       [31:0]   _zz_184_;
  reg                 _zz_185_;
  reg                 _zz_186_;
  reg                 _zz_187_;
  reg                 _zz_188_;
  reg        [1:0]    _zz_189_;
  reg        [31:0]   _zz_190_;
  reg                 _zz_191_;
  reg                 _zz_192_;
  reg                 _zz_193_;
  reg                 _zz_194_;
  reg                 _zz_195_;
  reg        [31:0]   _zz_196_;
  reg        [31:0]   _zz_197_;
  wire       [31:0]   _zz_198_;
  wire       [31:0]   _zz_199_;
  wire       [31:0]   _zz_200_;
  reg                 _zz_201_;
  reg                 _zz_202_;
  reg                 _zz_203_;
  reg                 _zz_204_;
  reg        [1:0]    _zz_205_;
  reg        [31:0]   _zz_206_;
  reg                 _zz_207_;
  reg                 _zz_208_;
  reg                 _zz_209_;
  reg                 _zz_210_;
  reg                 _zz_211_;
  reg        [31:0]   _zz_212_;
  reg        [31:0]   _zz_213_;
  wire       [31:0]   _zz_214_;
  wire       [31:0]   _zz_215_;
  wire       [31:0]   _zz_216_;
  reg                 _zz_217_;
  reg                 _zz_218_;
  reg                 _zz_219_;
  reg                 _zz_220_;
  reg        [1:0]    _zz_221_;
  reg        [31:0]   _zz_222_;
  reg                 _zz_223_;
  reg                 _zz_224_;
  reg                 _zz_225_;
  reg                 _zz_226_;
  reg                 _zz_227_;
  reg        [31:0]   _zz_228_;
  reg        [31:0]   _zz_229_;
  wire       [31:0]   _zz_230_;
  wire       [31:0]   _zz_231_;
  wire       [31:0]   _zz_232_;
  reg                 _zz_233_;
  reg                 _zz_234_;
  reg                 _zz_235_;
  reg                 _zz_236_;
  reg        [1:0]    _zz_237_;
  reg        [31:0]   _zz_238_;
  reg                 _zz_239_;
  reg                 _zz_240_;
  reg                 _zz_241_;
  reg                 _zz_242_;
  reg                 _zz_243_;
  reg        [31:0]   _zz_244_;
  reg        [31:0]   _zz_245_;
  wire       [31:0]   _zz_246_;
  wire       [31:0]   _zz_247_;
  wire       [31:0]   _zz_248_;
  reg                 _zz_249_;
  reg                 _zz_250_;
  reg                 _zz_251_;
  reg                 _zz_252_;
  reg        [1:0]    _zz_253_;
  reg        [31:0]   _zz_254_;
  reg                 _zz_255_;
  reg                 _zz_256_;
  reg                 _zz_257_;
  reg                 _zz_258_;
  reg                 _zz_259_;
  reg        [31:0]   _zz_260_;
  reg        [31:0]   _zz_261_;
  wire       [31:0]   _zz_262_;
  wire       [31:0]   _zz_263_;
  wire       [31:0]   _zz_264_;
  reg                 _zz_265_;
  reg                 _zz_266_;
  reg                 _zz_267_;
  reg                 _zz_268_;
  reg        [1:0]    _zz_269_;
  reg        [31:0]   _zz_270_;
  reg                 _zz_271_;
  reg                 _zz_272_;
  reg                 _zz_273_;
  reg                 _zz_274_;
  reg                 _zz_275_;
  reg        [31:0]   _zz_276_;
  reg        [31:0]   _zz_277_;
  wire       [31:0]   _zz_278_;
  wire       [31:0]   _zz_279_;
  wire       [31:0]   _zz_280_;
  reg                 _zz_281_;
  reg                 _zz_282_;
  reg                 _zz_283_;
  reg                 _zz_284_;
  reg        [1:0]    _zz_285_;
  reg        [31:0]   _zz_286_;
  reg                 _zz_287_;
  reg                 _zz_288_;
  reg                 _zz_289_;
  reg                 _zz_290_;
  reg                 _zz_291_;
  reg        [31:0]   _zz_292_;
  reg        [31:0]   _zz_293_;
  wire       [31:0]   _zz_294_;
  wire       [31:0]   _zz_295_;
  wire       [31:0]   _zz_296_;
  reg                 _zz_297_;
  reg                 _zz_298_;
  reg                 _zz_299_;
  reg                 _zz_300_;
  reg        [1:0]    _zz_301_;
  reg        [31:0]   _zz_302_;
  reg                 _zz_303_;
  reg                 _zz_304_;
  reg                 _zz_305_;
  reg                 _zz_306_;
  reg                 _zz_307_;
  reg        [31:0]   _zz_308_;
  reg        [31:0]   _zz_309_;
  wire       [31:0]   _zz_310_;
  wire       [31:0]   _zz_311_;
  wire       [31:0]   _zz_312_;
  reg                 _zz_313_;
  reg                 _zz_314_;
  reg                 _zz_315_;
  reg                 _zz_316_;
  reg        [1:0]    _zz_317_;
  reg        [31:0]   _zz_318_;
  reg                 _zz_319_;
  reg                 _zz_320_;
  reg                 _zz_321_;
  reg                 _zz_322_;
  reg                 _zz_323_;
  reg        [31:0]   _zz_324_;
  reg        [31:0]   _zz_325_;
  wire       [31:0]   _zz_326_;
  wire       [31:0]   _zz_327_;
  wire       [31:0]   _zz_328_;
  reg                 _zz_329_;
  reg                 _zz_330_;
  reg                 _zz_331_;
  reg                 _zz_332_;
  reg        [1:0]    _zz_333_;
  reg        [31:0]   _zz_334_;
  reg                 _zz_335_;
  reg                 _zz_336_;
  reg                 _zz_337_;
  reg                 _zz_338_;
  reg                 _zz_339_;
  reg        [31:0]   _zz_340_;
  reg        [31:0]   _zz_341_;
  wire       [31:0]   _zz_342_;
  wire       [31:0]   _zz_343_;
  wire       [31:0]   _zz_344_;
  wire                PmpPlugin_ports_0_hits_0;
  wire                PmpPlugin_ports_0_hits_1;
  wire                PmpPlugin_ports_0_hits_2;
  wire                PmpPlugin_ports_0_hits_3;
  wire                PmpPlugin_ports_0_hits_4;
  wire                PmpPlugin_ports_0_hits_5;
  wire                PmpPlugin_ports_0_hits_6;
  wire                PmpPlugin_ports_0_hits_7;
  wire                PmpPlugin_ports_0_hits_8;
  wire                PmpPlugin_ports_0_hits_9;
  wire                PmpPlugin_ports_0_hits_10;
  wire                PmpPlugin_ports_0_hits_11;
  wire                PmpPlugin_ports_0_hits_12;
  wire                PmpPlugin_ports_0_hits_13;
  wire                PmpPlugin_ports_0_hits_14;
  wire                PmpPlugin_ports_0_hits_15;
  wire       [15:0]   _zz_345_;
  wire       [15:0]   _zz_346_;
  wire                _zz_347_;
  wire                _zz_348_;
  wire                _zz_349_;
  wire                _zz_350_;
  wire                _zz_351_;
  wire                _zz_352_;
  wire                _zz_353_;
  wire                _zz_354_;
  wire                _zz_355_;
  wire                _zz_356_;
  wire                _zz_357_;
  wire                _zz_358_;
  wire                _zz_359_;
  wire                _zz_360_;
  wire                _zz_361_;
  wire       [15:0]   _zz_362_;
  wire       [15:0]   _zz_363_;
  wire                _zz_364_;
  wire                _zz_365_;
  wire                _zz_366_;
  wire                _zz_367_;
  wire                _zz_368_;
  wire                _zz_369_;
  wire                _zz_370_;
  wire                _zz_371_;
  wire                _zz_372_;
  wire                _zz_373_;
  wire                _zz_374_;
  wire                _zz_375_;
  wire                _zz_376_;
  wire                _zz_377_;
  wire                _zz_378_;
  wire       [15:0]   _zz_379_;
  wire       [15:0]   _zz_380_;
  wire                _zz_381_;
  wire                _zz_382_;
  wire                _zz_383_;
  wire                _zz_384_;
  wire                _zz_385_;
  wire                _zz_386_;
  wire                _zz_387_;
  wire                _zz_388_;
  wire                _zz_389_;
  wire                _zz_390_;
  wire                _zz_391_;
  wire                _zz_392_;
  wire                _zz_393_;
  wire                _zz_394_;
  wire                _zz_395_;
  wire                PmpPlugin_ports_1_hits_0;
  wire                PmpPlugin_ports_1_hits_1;
  wire                PmpPlugin_ports_1_hits_2;
  wire                PmpPlugin_ports_1_hits_3;
  wire                PmpPlugin_ports_1_hits_4;
  wire                PmpPlugin_ports_1_hits_5;
  wire                PmpPlugin_ports_1_hits_6;
  wire                PmpPlugin_ports_1_hits_7;
  wire                PmpPlugin_ports_1_hits_8;
  wire                PmpPlugin_ports_1_hits_9;
  wire                PmpPlugin_ports_1_hits_10;
  wire                PmpPlugin_ports_1_hits_11;
  wire                PmpPlugin_ports_1_hits_12;
  wire                PmpPlugin_ports_1_hits_13;
  wire                PmpPlugin_ports_1_hits_14;
  wire                PmpPlugin_ports_1_hits_15;
  wire       [15:0]   _zz_396_;
  wire       [15:0]   _zz_397_;
  wire                _zz_398_;
  wire                _zz_399_;
  wire                _zz_400_;
  wire                _zz_401_;
  wire                _zz_402_;
  wire                _zz_403_;
  wire                _zz_404_;
  wire                _zz_405_;
  wire                _zz_406_;
  wire                _zz_407_;
  wire                _zz_408_;
  wire                _zz_409_;
  wire                _zz_410_;
  wire                _zz_411_;
  wire                _zz_412_;
  wire       [15:0]   _zz_413_;
  wire       [15:0]   _zz_414_;
  wire                _zz_415_;
  wire                _zz_416_;
  wire                _zz_417_;
  wire                _zz_418_;
  wire                _zz_419_;
  wire                _zz_420_;
  wire                _zz_421_;
  wire                _zz_422_;
  wire                _zz_423_;
  wire                _zz_424_;
  wire                _zz_425_;
  wire                _zz_426_;
  wire                _zz_427_;
  wire                _zz_428_;
  wire                _zz_429_;
  wire       [15:0]   _zz_430_;
  wire       [15:0]   _zz_431_;
  wire                _zz_432_;
  wire                _zz_433_;
  wire                _zz_434_;
  wire                _zz_435_;
  wire                _zz_436_;
  wire                _zz_437_;
  wire                _zz_438_;
  wire                _zz_439_;
  wire                _zz_440_;
  wire                _zz_441_;
  wire                _zz_442_;
  wire                _zz_443_;
  wire                _zz_444_;
  wire                _zz_445_;
  wire                _zz_446_;
  wire       [31:0]   _zz_447_;
  wire                _zz_448_;
  wire                _zz_449_;
  wire                _zz_450_;
  wire                _zz_451_;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_452_;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_453_;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_454_;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_455_;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_456_;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_457_;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_458_;
  wire       [4:0]    decode_RegFilePlugin_regFileReadAddress1;
  wire       [4:0]    decode_RegFilePlugin_regFileReadAddress2;
  wire       [31:0]   decode_RegFilePlugin_rs1Data;
  wire       [31:0]   decode_RegFilePlugin_rs2Data;
  reg                 lastStageRegFileWrite_valid /* verilator public */ ;
  wire       [4:0]    lastStageRegFileWrite_payload_address /* verilator public */ ;
  wire       [31:0]   lastStageRegFileWrite_payload_data /* verilator public */ ;
  reg                 _zz_459_;
  reg        [31:0]   execute_IntAluPlugin_bitwise;
  reg        [31:0]   _zz_460_;
  reg        [31:0]   _zz_461_;
  wire                _zz_462_;
  reg        [19:0]   _zz_463_;
  wire                _zz_464_;
  reg        [19:0]   _zz_465_;
  reg        [31:0]   _zz_466_;
  reg        [31:0]   execute_SrcPlugin_addSub;
  wire                execute_SrcPlugin_less;
  wire       [4:0]    execute_FullBarrelShifterPlugin_amplitude;
  reg        [31:0]   _zz_467_;
  wire       [31:0]   execute_FullBarrelShifterPlugin_reversed;
  reg        [31:0]   _zz_468_;
  reg                 _zz_469_;
  reg                 _zz_470_;
  reg                 _zz_471_;
  reg        [4:0]    _zz_472_;
  reg        [31:0]   _zz_473_;
  wire                _zz_474_;
  wire                _zz_475_;
  wire                _zz_476_;
  wire                _zz_477_;
  wire                _zz_478_;
  wire                _zz_479_;
  wire                execute_BranchPlugin_eq;
  wire       [2:0]    _zz_480_;
  reg                 _zz_481_;
  reg                 _zz_482_;
  wire                _zz_483_;
  reg        [19:0]   _zz_484_;
  wire                _zz_485_;
  reg        [10:0]   _zz_486_;
  wire                _zz_487_;
  reg        [18:0]   _zz_488_;
  reg                 _zz_489_;
  wire                execute_BranchPlugin_missAlignedTarget;
  reg        [31:0]   execute_BranchPlugin_branch_src1;
  reg        [31:0]   execute_BranchPlugin_branch_src2;
  wire                _zz_490_;
  reg        [19:0]   _zz_491_;
  wire                _zz_492_;
  reg        [10:0]   _zz_493_;
  wire                _zz_494_;
  reg        [18:0]   _zz_495_;
  wire       [31:0]   execute_BranchPlugin_branchAdder;
  reg        [1:0]    _zz_496_;
  reg        [1:0]    CsrPlugin_misa_base;
  reg        [25:0]   CsrPlugin_misa_extensions;
  reg        [1:0]    CsrPlugin_mtvec_mode;
  reg        [29:0]   CsrPlugin_mtvec_base;
  reg        [31:0]   CsrPlugin_mepc;
  reg                 CsrPlugin_mstatus_MIE;
  reg                 CsrPlugin_mstatus_MPIE;
  reg        [1:0]    CsrPlugin_mstatus_MPP;
  reg                 CsrPlugin_mip_MEIP;
  reg                 CsrPlugin_mip_MTIP;
  reg                 CsrPlugin_mip_MSIP;
  reg                 CsrPlugin_mie_MEIE;
  reg                 CsrPlugin_mie_MTIE;
  reg                 CsrPlugin_mie_MSIE;
  reg        [31:0]   CsrPlugin_mscratch;
  reg                 CsrPlugin_mcause_interrupt;
  reg        [3:0]    CsrPlugin_mcause_exceptionCode;
  reg        [31:0]   CsrPlugin_mtval;
  reg        [63:0]   CsrPlugin_mcycle = 64'b0000000000000000000000000000000000000000000000000000000000000000;
  reg        [63:0]   CsrPlugin_minstret = 64'b0000000000000000000000000000000000000000000000000000000000000000;
  wire                _zz_497_;
  wire                _zz_498_;
  wire                _zz_499_;
  reg                 CsrPlugin_exceptionPortCtrl_exceptionValids_decode;
  reg                 CsrPlugin_exceptionPortCtrl_exceptionValids_execute;
  reg                 CsrPlugin_exceptionPortCtrl_exceptionValids_memory;
  reg                 CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack;
  reg                 CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode;
  reg                 CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute;
  reg                 CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory;
  reg                 CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack;
  reg        [3:0]    CsrPlugin_exceptionPortCtrl_exceptionContext_code;
  reg        [31:0]   CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr;
  wire       [1:0]    CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped;
  wire       [1:0]    CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege;
  wire       [1:0]    _zz_500_;
  wire                _zz_501_;
  reg                 CsrPlugin_interrupt_valid;
  reg        [3:0]    CsrPlugin_interrupt_code /* verilator public */ ;
  reg        [1:0]    CsrPlugin_interrupt_targetPrivilege;
  wire                CsrPlugin_exception;
  reg                 CsrPlugin_lastStageWasWfi;
  reg                 CsrPlugin_pipelineLiberator_pcValids_0;
  reg                 CsrPlugin_pipelineLiberator_pcValids_1;
  reg                 CsrPlugin_pipelineLiberator_pcValids_2;
  wire                CsrPlugin_pipelineLiberator_active;
  reg                 CsrPlugin_pipelineLiberator_done;
  wire                CsrPlugin_interruptJump /* verilator public */ ;
  reg                 CsrPlugin_hadException;
  reg        [1:0]    CsrPlugin_targetPrivilege;
  reg        [3:0]    CsrPlugin_trapCause;
  reg        [1:0]    CsrPlugin_xtvec_mode;
  reg        [29:0]   CsrPlugin_xtvec_base;
  reg                 execute_CsrPlugin_wfiWake;
  wire                execute_CsrPlugin_blockedBySideEffects;
  reg                 execute_CsrPlugin_illegalAccess;
  reg                 execute_CsrPlugin_illegalInstruction;
  wire       [31:0]   execute_CsrPlugin_readData;
  reg                 execute_CsrPlugin_writeInstruction;
  reg                 execute_CsrPlugin_readInstruction;
  wire                execute_CsrPlugin_writeEnable;
  wire                execute_CsrPlugin_readEnable;
  wire       [31:0]   execute_CsrPlugin_readToWriteData;
  reg        [31:0]   execute_CsrPlugin_writeData;
  wire       [11:0]   execute_CsrPlugin_csrAddress;
  reg                 execute_MulPlugin_aSigned;
  reg                 execute_MulPlugin_bSigned;
  wire       [31:0]   execute_MulPlugin_a;
  wire       [31:0]   execute_MulPlugin_b;
  wire       [15:0]   execute_MulPlugin_aULow;
  wire       [15:0]   execute_MulPlugin_bULow;
  wire       [16:0]   execute_MulPlugin_aSLow;
  wire       [16:0]   execute_MulPlugin_bSLow;
  wire       [16:0]   execute_MulPlugin_aHigh;
  wire       [16:0]   execute_MulPlugin_bHigh;
  wire       [65:0]   writeBack_MulPlugin_result;
  reg        [32:0]   memory_DivPlugin_rs1;
  reg        [31:0]   memory_DivPlugin_rs2;
  reg        [64:0]   memory_DivPlugin_accumulator;
  wire                memory_DivPlugin_frontendOk;
  reg                 memory_DivPlugin_div_needRevert;
  reg                 memory_DivPlugin_div_counter_willIncrement;
  reg                 memory_DivPlugin_div_counter_willClear;
  reg        [5:0]    memory_DivPlugin_div_counter_valueNext;
  reg        [5:0]    memory_DivPlugin_div_counter_value;
  wire                memory_DivPlugin_div_counter_willOverflowIfInc;
  wire                memory_DivPlugin_div_counter_willOverflow;
  reg                 memory_DivPlugin_div_done;
  reg        [31:0]   memory_DivPlugin_div_result;
  wire       [31:0]   _zz_502_;
  wire       [32:0]   memory_DivPlugin_div_stage_0_remainderShifted;
  wire       [32:0]   memory_DivPlugin_div_stage_0_remainderMinusDenominator;
  wire       [31:0]   memory_DivPlugin_div_stage_0_outRemainder;
  wire       [31:0]   memory_DivPlugin_div_stage_0_outNumerator;
  wire       [31:0]   _zz_503_;
  wire                _zz_504_;
  wire                _zz_505_;
  reg        [32:0]   _zz_506_;
  reg        [31:0]   externalInterruptArray_regNext;
  reg        [31:0]   _zz_507_;
  wire       [31:0]   _zz_508_;
  reg                 decode_to_execute_IS_RS2_SIGNED;
  reg                 decode_to_execute_MEMORY_MANAGMENT;
  reg        [31:0]   decode_to_execute_PC;
  reg        [31:0]   execute_to_memory_PC;
  reg        [31:0]   memory_to_writeBack_PC;
  reg        `BranchCtrlEnum_defaultEncoding_type decode_to_execute_BRANCH_CTRL;
  reg                 decode_to_execute_REGFILE_WRITE_VALID;
  reg                 execute_to_memory_REGFILE_WRITE_VALID;
  reg                 memory_to_writeBack_REGFILE_WRITE_VALID;
  reg        [31:0]   decode_to_execute_INSTRUCTION;
  reg        [31:0]   execute_to_memory_INSTRUCTION;
  reg        [31:0]   memory_to_writeBack_INSTRUCTION;
  reg        [33:0]   execute_to_memory_MUL_HH;
  reg        [33:0]   memory_to_writeBack_MUL_HH;
  reg                 decode_to_execute_IS_MUL;
  reg                 execute_to_memory_IS_MUL;
  reg                 memory_to_writeBack_IS_MUL;
  reg                 decode_to_execute_IS_RS1_SIGNED;
  reg        `EnvCtrlEnum_defaultEncoding_type decode_to_execute_ENV_CTRL;
  reg        `EnvCtrlEnum_defaultEncoding_type execute_to_memory_ENV_CTRL;
  reg        `EnvCtrlEnum_defaultEncoding_type memory_to_writeBack_ENV_CTRL;
  reg        `AluCtrlEnum_defaultEncoding_type decode_to_execute_ALU_CTRL;
  reg                 decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  reg        [33:0]   execute_to_memory_MUL_HL;
  reg        [1:0]    execute_to_memory_MEMORY_ADDRESS_LOW;
  reg        [1:0]    memory_to_writeBack_MEMORY_ADDRESS_LOW;
  reg                 decode_to_execute_PREDICTION_HAD_BRANCHED2;
  reg        [31:0]   execute_to_memory_BRANCH_CALC;
  reg                 decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  reg                 execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  reg                 decode_to_execute_SRC_LESS_UNSIGNED;
  reg        `ShiftCtrlEnum_defaultEncoding_type decode_to_execute_SHIFT_CTRL;
  reg        `ShiftCtrlEnum_defaultEncoding_type execute_to_memory_SHIFT_CTRL;
  reg        [31:0]   decode_to_execute_RS1;
  reg        [31:0]   decode_to_execute_FORMAL_PC_NEXT;
  reg        [31:0]   execute_to_memory_FORMAL_PC_NEXT;
  reg        [31:0]   memory_to_writeBack_FORMAL_PC_NEXT;
  reg        [31:0]   execute_to_memory_SHIFT_RIGHT;
  reg                 decode_to_execute_IS_CSR;
  reg        [31:0]   decode_to_execute_RS2;
  reg        `Src1CtrlEnum_defaultEncoding_type decode_to_execute_SRC1_CTRL;
  reg                 decode_to_execute_SRC2_FORCE_ZERO;
  reg                 decode_to_execute_MEMORY_ENABLE;
  reg                 execute_to_memory_MEMORY_ENABLE;
  reg                 memory_to_writeBack_MEMORY_ENABLE;
  reg                 decode_to_execute_CSR_WRITE_OPCODE;
  reg        [31:0]   execute_to_memory_MUL_LL;
  reg        [33:0]   execute_to_memory_MUL_LH;
  reg                 decode_to_execute_MEMORY_WR;
  reg                 execute_to_memory_MEMORY_WR;
  reg                 memory_to_writeBack_MEMORY_WR;
  reg        `AluBitwiseCtrlEnum_defaultEncoding_type decode_to_execute_ALU_BITWISE_CTRL;
  reg        [51:0]   memory_to_writeBack_MUL_LOW;
  reg        `Src2CtrlEnum_defaultEncoding_type decode_to_execute_SRC2_CTRL;
  reg                 decode_to_execute_IS_DIV;
  reg                 execute_to_memory_IS_DIV;
  reg                 execute_to_memory_BRANCH_DO;
  reg        [31:0]   execute_to_memory_REGFILE_WRITE_DATA;
  reg        [31:0]   memory_to_writeBack_REGFILE_WRITE_DATA;
  reg                 decode_to_execute_SRC_USE_SUB_LESS;
  reg                 decode_to_execute_CSR_READ_OPCODE;
  reg                 execute_CsrPlugin_csr_3264;
  reg                 execute_CsrPlugin_csr_944;
  reg                 execute_CsrPlugin_csr_945;
  reg                 execute_CsrPlugin_csr_946;
  reg                 execute_CsrPlugin_csr_947;
  reg                 execute_CsrPlugin_csr_948;
  reg                 execute_CsrPlugin_csr_949;
  reg                 execute_CsrPlugin_csr_950;
  reg                 execute_CsrPlugin_csr_951;
  reg                 execute_CsrPlugin_csr_952;
  reg                 execute_CsrPlugin_csr_953;
  reg                 execute_CsrPlugin_csr_954;
  reg                 execute_CsrPlugin_csr_955;
  reg                 execute_CsrPlugin_csr_956;
  reg                 execute_CsrPlugin_csr_957;
  reg                 execute_CsrPlugin_csr_958;
  reg                 execute_CsrPlugin_csr_959;
  reg                 execute_CsrPlugin_csr_928;
  reg                 execute_CsrPlugin_csr_929;
  reg                 execute_CsrPlugin_csr_930;
  reg                 execute_CsrPlugin_csr_931;
  reg                 execute_CsrPlugin_csr_3857;
  reg                 execute_CsrPlugin_csr_3858;
  reg                 execute_CsrPlugin_csr_3859;
  reg                 execute_CsrPlugin_csr_3860;
  reg                 execute_CsrPlugin_csr_769;
  reg                 execute_CsrPlugin_csr_768;
  reg                 execute_CsrPlugin_csr_836;
  reg                 execute_CsrPlugin_csr_772;
  reg                 execute_CsrPlugin_csr_773;
  reg                 execute_CsrPlugin_csr_833;
  reg                 execute_CsrPlugin_csr_832;
  reg                 execute_CsrPlugin_csr_834;
  reg                 execute_CsrPlugin_csr_835;
  reg                 execute_CsrPlugin_csr_2816;
  reg                 execute_CsrPlugin_csr_2944;
  reg                 execute_CsrPlugin_csr_2818;
  reg                 execute_CsrPlugin_csr_2946;
  reg                 execute_CsrPlugin_csr_3072;
  reg                 execute_CsrPlugin_csr_3200;
  reg                 execute_CsrPlugin_csr_3074;
  reg                 execute_CsrPlugin_csr_3202;
  reg                 execute_CsrPlugin_csr_3008;
  reg                 execute_CsrPlugin_csr_4032;
  reg        [31:0]   _zz_509_;
  reg        [31:0]   _zz_510_;
  reg        [31:0]   _zz_511_;
  reg        [31:0]   _zz_512_;
  reg        [31:0]   _zz_513_;
  reg        [31:0]   _zz_514_;
  reg        [31:0]   _zz_515_;
  reg        [31:0]   _zz_516_;
  reg        [31:0]   _zz_517_;
  reg        [31:0]   _zz_518_;
  reg        [31:0]   _zz_519_;
  reg        [31:0]   _zz_520_;
  reg        [31:0]   _zz_521_;
  reg        [31:0]   _zz_522_;
  reg        [31:0]   _zz_523_;
  reg        [31:0]   _zz_524_;
  reg        [31:0]   _zz_525_;
  reg        [31:0]   _zz_526_;
  reg        [31:0]   _zz_527_;
  reg        [31:0]   _zz_528_;
  reg        [31:0]   _zz_529_;
  reg        [31:0]   _zz_530_;
  reg        [31:0]   _zz_531_;
  reg        [31:0]   _zz_532_;
  reg        [31:0]   _zz_533_;
  reg        [31:0]   _zz_534_;
  reg        [31:0]   _zz_535_;
  reg        [31:0]   _zz_536_;
  reg        [31:0]   _zz_537_;
  reg        [31:0]   _zz_538_;
  reg        [31:0]   _zz_539_;
  reg        [31:0]   _zz_540_;
  reg        [31:0]   _zz_541_;
  reg        [31:0]   _zz_542_;
  reg        [31:0]   _zz_543_;
  reg        [31:0]   _zz_544_;
  reg        [31:0]   _zz_545_;
  reg        [31:0]   _zz_546_;
  reg        [31:0]   _zz_547_;
  reg        [31:0]   _zz_548_;
  reg        [31:0]   _zz_549_;
  reg        [31:0]   _zz_550_;
  reg        [31:0]   _zz_551_;
  reg        [2:0]    _zz_552_;
  reg                 _zz_553_;
  reg        [31:0]   iBusWishbone_DAT_MISO_regNext;
  reg        [2:0]    _zz_554_;
  wire                _zz_555_;
  wire                _zz_556_;
  wire                _zz_557_;
  wire                _zz_558_;
  wire                _zz_559_;
  reg                 _zz_560_;
  reg        [31:0]   dBusWishbone_DAT_MISO_regNext;
  `ifndef SYNTHESIS
  reg [23:0] decode_SRC2_CTRL_string;
  reg [23:0] _zz_1__string;
  reg [23:0] _zz_2__string;
  reg [23:0] _zz_3__string;
  reg [39:0] decode_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_4__string;
  reg [39:0] _zz_5__string;
  reg [39:0] _zz_6__string;
  reg [95:0] decode_SRC1_CTRL_string;
  reg [95:0] _zz_7__string;
  reg [95:0] _zz_8__string;
  reg [95:0] _zz_9__string;
  reg [71:0] _zz_10__string;
  reg [71:0] _zz_11__string;
  reg [71:0] decode_SHIFT_CTRL_string;
  reg [71:0] _zz_12__string;
  reg [71:0] _zz_13__string;
  reg [71:0] _zz_14__string;
  reg [63:0] decode_ALU_CTRL_string;
  reg [63:0] _zz_15__string;
  reg [63:0] _zz_16__string;
  reg [63:0] _zz_17__string;
  reg [39:0] _zz_18__string;
  reg [39:0] _zz_19__string;
  reg [39:0] _zz_20__string;
  reg [39:0] _zz_21__string;
  reg [39:0] decode_ENV_CTRL_string;
  reg [39:0] _zz_22__string;
  reg [39:0] _zz_23__string;
  reg [39:0] _zz_24__string;
  reg [31:0] _zz_25__string;
  reg [31:0] _zz_26__string;
  reg [39:0] memory_ENV_CTRL_string;
  reg [39:0] _zz_27__string;
  reg [39:0] execute_ENV_CTRL_string;
  reg [39:0] _zz_28__string;
  reg [39:0] writeBack_ENV_CTRL_string;
  reg [39:0] _zz_29__string;
  reg [31:0] execute_BRANCH_CTRL_string;
  reg [31:0] _zz_30__string;
  reg [71:0] memory_SHIFT_CTRL_string;
  reg [71:0] _zz_33__string;
  reg [71:0] execute_SHIFT_CTRL_string;
  reg [71:0] _zz_34__string;
  reg [23:0] execute_SRC2_CTRL_string;
  reg [23:0] _zz_36__string;
  reg [95:0] execute_SRC1_CTRL_string;
  reg [95:0] _zz_37__string;
  reg [63:0] execute_ALU_CTRL_string;
  reg [63:0] _zz_38__string;
  reg [39:0] execute_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_39__string;
  reg [31:0] _zz_43__string;
  reg [39:0] _zz_44__string;
  reg [39:0] _zz_45__string;
  reg [71:0] _zz_46__string;
  reg [63:0] _zz_47__string;
  reg [23:0] _zz_48__string;
  reg [95:0] _zz_49__string;
  reg [31:0] decode_BRANCH_CTRL_string;
  reg [31:0] _zz_54__string;
  reg [95:0] _zz_452__string;
  reg [23:0] _zz_453__string;
  reg [63:0] _zz_454__string;
  reg [71:0] _zz_455__string;
  reg [39:0] _zz_456__string;
  reg [39:0] _zz_457__string;
  reg [31:0] _zz_458__string;
  reg [31:0] decode_to_execute_BRANCH_CTRL_string;
  reg [39:0] decode_to_execute_ENV_CTRL_string;
  reg [39:0] execute_to_memory_ENV_CTRL_string;
  reg [39:0] memory_to_writeBack_ENV_CTRL_string;
  reg [63:0] decode_to_execute_ALU_CTRL_string;
  reg [71:0] decode_to_execute_SHIFT_CTRL_string;
  reg [71:0] execute_to_memory_SHIFT_CTRL_string;
  reg [95:0] decode_to_execute_SRC1_CTRL_string;
  reg [39:0] decode_to_execute_ALU_BITWISE_CTRL_string;
  reg [23:0] decode_to_execute_SRC2_CTRL_string;
  `endif

  (* ram_style = "block" *) reg [31:0] RegFilePlugin_regFile [0:31] /* verilator public */ ;

  assign _zz_588_ = (execute_arbitration_isValid && execute_IS_CSR);
  assign _zz_589_ = (writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID);
  assign _zz_590_ = 1'b1;
  assign _zz_591_ = (memory_arbitration_isValid && memory_REGFILE_WRITE_VALID);
  assign _zz_592_ = (execute_arbitration_isValid && execute_REGFILE_WRITE_VALID);
  assign _zz_593_ = (memory_arbitration_isValid && memory_IS_DIV);
  assign _zz_594_ = ((_zz_565_ && IBusCachedPlugin_cache_io_cpu_decode_error) && (! _zz_53__2));
  assign _zz_595_ = ((_zz_565_ && IBusCachedPlugin_cache_io_cpu_decode_cacheMiss) && (! _zz_53__1));
  assign _zz_596_ = ((_zz_565_ && IBusCachedPlugin_cache_io_cpu_decode_mmuException) && (! _zz_53__0));
  assign _zz_597_ = ((_zz_565_ && IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling) && (! IBusCachedPlugin_rsp_issueDetected));
  assign _zz_598_ = ({decodeExceptionPort_valid,IBusCachedPlugin_decodeExceptionPort_valid} != (2'b00));
  assign _zz_599_ = (execute_arbitration_isValid && (execute_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_WFI));
  assign _zz_600_ = (CsrPlugin_hadException || CsrPlugin_interruptJump);
  assign _zz_601_ = (writeBack_arbitration_isValid && (writeBack_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET));
  assign _zz_602_ = writeBack_INSTRUCTION[29 : 28];
  assign _zz_603_ = (writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE);
  assign _zz_604_ = (_zz_51_ == 5'h0);
  assign _zz_605_ = (_zz_50_ == 5'h0);
  assign _zz_606_ = (writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID);
  assign _zz_607_ = (1'b0 || (! 1'b1));
  assign _zz_608_ = (memory_arbitration_isValid && memory_REGFILE_WRITE_VALID);
  assign _zz_609_ = (1'b0 || (! memory_BYPASSABLE_MEMORY_STAGE));
  assign _zz_610_ = (execute_arbitration_isValid && execute_REGFILE_WRITE_VALID);
  assign _zz_611_ = (1'b0 || (! execute_BYPASSABLE_EXECUTE_STAGE));
  assign _zz_612_ = (CsrPlugin_privilege < execute_CsrPlugin_csrAddress[9 : 8]);
  assign _zz_613_ = (execute_CsrPlugin_illegalAccess || execute_CsrPlugin_illegalInstruction);
  assign _zz_614_ = (execute_arbitration_isValid && (execute_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_ECALL));
  assign _zz_615_ = execute_INSTRUCTION[13 : 12];
  assign _zz_616_ = (memory_DivPlugin_frontendOk && (! memory_DivPlugin_div_done));
  assign _zz_617_ = (! memory_arbitration_isStuck);
  assign _zz_618_ = (iBus_cmd_valid || (_zz_552_ != (3'b000)));
  assign _zz_619_ = (_zz_578_ && (! dataCache_1__io_mem_cmd_s2mPipe_ready));
  assign _zz_620_ = (! _zz_98_);
  assign _zz_621_ = (! _zz_114_);
  assign _zz_622_ = (! _zz_130_);
  assign _zz_623_ = (! _zz_146_);
  assign _zz_624_ = (! _zz_162_);
  assign _zz_625_ = (! _zz_178_);
  assign _zz_626_ = (! _zz_194_);
  assign _zz_627_ = (! _zz_210_);
  assign _zz_628_ = (! _zz_226_);
  assign _zz_629_ = (! _zz_242_);
  assign _zz_630_ = (! _zz_258_);
  assign _zz_631_ = (! _zz_274_);
  assign _zz_632_ = (! _zz_290_);
  assign _zz_633_ = (! _zz_306_);
  assign _zz_634_ = (! _zz_322_);
  assign _zz_635_ = (! _zz_338_);
  assign _zz_636_ = (CsrPlugin_mstatus_MIE || (CsrPlugin_privilege < (2'b11)));
  assign _zz_637_ = ((_zz_497_ && 1'b1) && (! 1'b0));
  assign _zz_638_ = ((_zz_498_ && 1'b1) && (! 1'b0));
  assign _zz_639_ = ((_zz_499_ && 1'b1) && (! 1'b0));
  assign _zz_640_ = writeBack_INSTRUCTION[13 : 12];
  assign _zz_641_ = execute_INSTRUCTION[13];
  assign _zz_642_ = writeBack_INSTRUCTION[13 : 12];
  assign _zz_643_ = _zz_447_[17 : 17];
  assign _zz_644_ = ($signed(_zz_645_) + $signed(_zz_650_));
  assign _zz_645_ = ($signed(_zz_646_) + $signed(_zz_648_));
  assign _zz_646_ = 52'h0;
  assign _zz_647_ = {1'b0,memory_MUL_LL};
  assign _zz_648_ = {{19{_zz_647_[32]}}, _zz_647_};
  assign _zz_649_ = ({16'd0,memory_MUL_LH} <<< 16);
  assign _zz_650_ = {{2{_zz_649_[49]}}, _zz_649_};
  assign _zz_651_ = ({16'd0,memory_MUL_HL} <<< 16);
  assign _zz_652_ = {{2{_zz_651_[49]}}, _zz_651_};
  assign _zz_653_ = _zz_447_[12 : 12];
  assign _zz_654_ = _zz_447_[13 : 13];
  assign _zz_655_ = ($signed(_zz_657_) >>> execute_FullBarrelShifterPlugin_amplitude);
  assign _zz_656_ = _zz_655_[31 : 0];
  assign _zz_657_ = {((execute_SHIFT_CTRL == `ShiftCtrlEnum_defaultEncoding_SRA_1) && execute_FullBarrelShifterPlugin_reversed[31]),execute_FullBarrelShifterPlugin_reversed};
  assign _zz_658_ = _zz_447_[10 : 10];
  assign _zz_659_ = _zz_447_[28 : 28];
  assign _zz_660_ = _zz_447_[14 : 14];
  assign _zz_661_ = _zz_447_[1 : 1];
  assign _zz_662_ = _zz_447_[16 : 16];
  assign _zz_663_ = _zz_447_[9 : 9];
  assign _zz_664_ = _zz_447_[11 : 11];
  assign _zz_665_ = _zz_447_[0 : 0];
  assign _zz_666_ = _zz_447_[18 : 18];
  assign _zz_667_ = _zz_447_[26 : 26];
  assign _zz_668_ = _zz_447_[29 : 29];
  assign _zz_669_ = _zz_447_[27 : 27];
  assign _zz_670_ = _zz_447_[15 : 15];
  assign _zz_671_ = _zz_447_[4 : 4];
  assign _zz_672_ = (_zz_57_ - (4'b0001));
  assign _zz_673_ = {IBusCachedPlugin_fetchPc_inc,(2'b00)};
  assign _zz_674_ = {29'd0, _zz_673_};
  assign _zz_675_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_676_ = {{_zz_72_,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_677_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]};
  assign _zz_678_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_679_ = {{_zz_74_,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]}},1'b0};
  assign _zz_680_ = {{_zz_76_,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_681_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]};
  assign _zz_682_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_683_ = (writeBack_MEMORY_WR ? (3'b111) : (3'b101));
  assign _zz_684_ = (writeBack_MEMORY_WR ? (3'b110) : (3'b100));
  assign _zz_685_ = (_zz_94_ + 32'h00000001);
  assign _zz_686_ = (_zz_687_ <<< 3);
  assign _zz_687_ = (_zz_103_ + 32'h00000001);
  assign _zz_688_ = (_zz_110_ + 32'h00000001);
  assign _zz_689_ = (_zz_690_ <<< 3);
  assign _zz_690_ = (_zz_119_ + 32'h00000001);
  assign _zz_691_ = (_zz_126_ + 32'h00000001);
  assign _zz_692_ = (_zz_693_ <<< 3);
  assign _zz_693_ = (_zz_135_ + 32'h00000001);
  assign _zz_694_ = (_zz_142_ + 32'h00000001);
  assign _zz_695_ = (_zz_696_ <<< 3);
  assign _zz_696_ = (_zz_151_ + 32'h00000001);
  assign _zz_697_ = (_zz_158_ + 32'h00000001);
  assign _zz_698_ = (_zz_699_ <<< 3);
  assign _zz_699_ = (_zz_167_ + 32'h00000001);
  assign _zz_700_ = (_zz_174_ + 32'h00000001);
  assign _zz_701_ = (_zz_702_ <<< 3);
  assign _zz_702_ = (_zz_183_ + 32'h00000001);
  assign _zz_703_ = (_zz_190_ + 32'h00000001);
  assign _zz_704_ = (_zz_705_ <<< 3);
  assign _zz_705_ = (_zz_199_ + 32'h00000001);
  assign _zz_706_ = (_zz_206_ + 32'h00000001);
  assign _zz_707_ = (_zz_708_ <<< 3);
  assign _zz_708_ = (_zz_215_ + 32'h00000001);
  assign _zz_709_ = (_zz_222_ + 32'h00000001);
  assign _zz_710_ = (_zz_711_ <<< 3);
  assign _zz_711_ = (_zz_231_ + 32'h00000001);
  assign _zz_712_ = (_zz_238_ + 32'h00000001);
  assign _zz_713_ = (_zz_714_ <<< 3);
  assign _zz_714_ = (_zz_247_ + 32'h00000001);
  assign _zz_715_ = (_zz_254_ + 32'h00000001);
  assign _zz_716_ = (_zz_717_ <<< 3);
  assign _zz_717_ = (_zz_263_ + 32'h00000001);
  assign _zz_718_ = (_zz_270_ + 32'h00000001);
  assign _zz_719_ = (_zz_720_ <<< 3);
  assign _zz_720_ = (_zz_279_ + 32'h00000001);
  assign _zz_721_ = (_zz_286_ + 32'h00000001);
  assign _zz_722_ = (_zz_723_ <<< 3);
  assign _zz_723_ = (_zz_295_ + 32'h00000001);
  assign _zz_724_ = (_zz_302_ + 32'h00000001);
  assign _zz_725_ = (_zz_726_ <<< 3);
  assign _zz_726_ = (_zz_311_ + 32'h00000001);
  assign _zz_727_ = (_zz_318_ + 32'h00000001);
  assign _zz_728_ = (_zz_729_ <<< 3);
  assign _zz_729_ = (_zz_327_ + 32'h00000001);
  assign _zz_730_ = (_zz_334_ + 32'h00000001);
  assign _zz_731_ = (_zz_732_ <<< 3);
  assign _zz_732_ = (_zz_343_ + 32'h00000001);
  assign _zz_733_ = (_zz_345_ - 16'h0001);
  assign _zz_734_ = (_zz_362_ - 16'h0001);
  assign _zz_735_ = (_zz_379_ - 16'h0001);
  assign _zz_736_ = (_zz_396_ - 16'h0001);
  assign _zz_737_ = (_zz_413_ - 16'h0001);
  assign _zz_738_ = (_zz_430_ - 16'h0001);
  assign _zz_739_ = execute_SRC_LESS;
  assign _zz_740_ = (3'b100);
  assign _zz_741_ = execute_INSTRUCTION[19 : 15];
  assign _zz_742_ = execute_INSTRUCTION[31 : 20];
  assign _zz_743_ = {execute_INSTRUCTION[31 : 25],execute_INSTRUCTION[11 : 7]};
  assign _zz_744_ = ($signed(_zz_745_) + $signed(_zz_748_));
  assign _zz_745_ = ($signed(_zz_746_) + $signed(_zz_747_));
  assign _zz_746_ = execute_SRC1;
  assign _zz_747_ = (execute_SRC_USE_SUB_LESS ? (~ execute_SRC2) : execute_SRC2);
  assign _zz_748_ = (execute_SRC_USE_SUB_LESS ? _zz_749_ : _zz_750_);
  assign _zz_749_ = 32'h00000001;
  assign _zz_750_ = 32'h0;
  assign _zz_751_ = execute_INSTRUCTION[31 : 20];
  assign _zz_752_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]};
  assign _zz_753_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]};
  assign _zz_754_ = {_zz_484_,execute_INSTRUCTION[31 : 20]};
  assign _zz_755_ = {{_zz_486_,{{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]}},1'b0};
  assign _zz_756_ = {{_zz_488_,{{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_757_ = execute_INSTRUCTION[31 : 20];
  assign _zz_758_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]};
  assign _zz_759_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]};
  assign _zz_760_ = (3'b100);
  assign _zz_761_ = (_zz_500_ & (~ _zz_762_));
  assign _zz_762_ = (_zz_500_ - (2'b01));
  assign _zz_763_ = {{14{writeBack_MUL_LOW[51]}}, writeBack_MUL_LOW};
  assign _zz_764_ = ({32'd0,writeBack_MUL_HH} <<< 32);
  assign _zz_765_ = writeBack_MUL_LOW[31 : 0];
  assign _zz_766_ = writeBack_MulPlugin_result[63 : 32];
  assign _zz_767_ = memory_DivPlugin_div_counter_willIncrement;
  assign _zz_768_ = {5'd0, _zz_767_};
  assign _zz_769_ = {1'd0, memory_DivPlugin_rs2};
  assign _zz_770_ = memory_DivPlugin_div_stage_0_remainderMinusDenominator[31:0];
  assign _zz_771_ = memory_DivPlugin_div_stage_0_remainderShifted[31:0];
  assign _zz_772_ = {_zz_502_,(! memory_DivPlugin_div_stage_0_remainderMinusDenominator[32])};
  assign _zz_773_ = _zz_774_;
  assign _zz_774_ = _zz_775_;
  assign _zz_775_ = ({1'b0,(memory_DivPlugin_div_needRevert ? (~ _zz_503_) : _zz_503_)} + _zz_777_);
  assign _zz_776_ = memory_DivPlugin_div_needRevert;
  assign _zz_777_ = {32'd0, _zz_776_};
  assign _zz_778_ = _zz_505_;
  assign _zz_779_ = {32'd0, _zz_778_};
  assign _zz_780_ = _zz_504_;
  assign _zz_781_ = {31'd0, _zz_780_};
  assign _zz_782_ = execute_CsrPlugin_writeData[31 : 31];
  assign _zz_783_ = execute_CsrPlugin_writeData[23 : 23];
  assign _zz_784_ = execute_CsrPlugin_writeData[15 : 15];
  assign _zz_785_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_786_ = execute_CsrPlugin_writeData[26 : 26];
  assign _zz_787_ = execute_CsrPlugin_writeData[25 : 25];
  assign _zz_788_ = execute_CsrPlugin_writeData[24 : 24];
  assign _zz_789_ = execute_CsrPlugin_writeData[18 : 18];
  assign _zz_790_ = execute_CsrPlugin_writeData[17 : 17];
  assign _zz_791_ = execute_CsrPlugin_writeData[16 : 16];
  assign _zz_792_ = execute_CsrPlugin_writeData[10 : 10];
  assign _zz_793_ = execute_CsrPlugin_writeData[9 : 9];
  assign _zz_794_ = execute_CsrPlugin_writeData[8 : 8];
  assign _zz_795_ = execute_CsrPlugin_writeData[2 : 2];
  assign _zz_796_ = execute_CsrPlugin_writeData[1 : 1];
  assign _zz_797_ = execute_CsrPlugin_writeData[0 : 0];
  assign _zz_798_ = execute_CsrPlugin_writeData[31 : 31];
  assign _zz_799_ = execute_CsrPlugin_writeData[23 : 23];
  assign _zz_800_ = execute_CsrPlugin_writeData[15 : 15];
  assign _zz_801_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_802_ = execute_CsrPlugin_writeData[26 : 26];
  assign _zz_803_ = execute_CsrPlugin_writeData[25 : 25];
  assign _zz_804_ = execute_CsrPlugin_writeData[24 : 24];
  assign _zz_805_ = execute_CsrPlugin_writeData[18 : 18];
  assign _zz_806_ = execute_CsrPlugin_writeData[17 : 17];
  assign _zz_807_ = execute_CsrPlugin_writeData[16 : 16];
  assign _zz_808_ = execute_CsrPlugin_writeData[10 : 10];
  assign _zz_809_ = execute_CsrPlugin_writeData[9 : 9];
  assign _zz_810_ = execute_CsrPlugin_writeData[8 : 8];
  assign _zz_811_ = execute_CsrPlugin_writeData[2 : 2];
  assign _zz_812_ = execute_CsrPlugin_writeData[1 : 1];
  assign _zz_813_ = execute_CsrPlugin_writeData[0 : 0];
  assign _zz_814_ = execute_CsrPlugin_writeData[31 : 31];
  assign _zz_815_ = execute_CsrPlugin_writeData[23 : 23];
  assign _zz_816_ = execute_CsrPlugin_writeData[15 : 15];
  assign _zz_817_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_818_ = execute_CsrPlugin_writeData[26 : 26];
  assign _zz_819_ = execute_CsrPlugin_writeData[25 : 25];
  assign _zz_820_ = execute_CsrPlugin_writeData[24 : 24];
  assign _zz_821_ = execute_CsrPlugin_writeData[18 : 18];
  assign _zz_822_ = execute_CsrPlugin_writeData[17 : 17];
  assign _zz_823_ = execute_CsrPlugin_writeData[16 : 16];
  assign _zz_824_ = execute_CsrPlugin_writeData[10 : 10];
  assign _zz_825_ = execute_CsrPlugin_writeData[9 : 9];
  assign _zz_826_ = execute_CsrPlugin_writeData[8 : 8];
  assign _zz_827_ = execute_CsrPlugin_writeData[2 : 2];
  assign _zz_828_ = execute_CsrPlugin_writeData[1 : 1];
  assign _zz_829_ = execute_CsrPlugin_writeData[0 : 0];
  assign _zz_830_ = execute_CsrPlugin_writeData[31 : 31];
  assign _zz_831_ = execute_CsrPlugin_writeData[23 : 23];
  assign _zz_832_ = execute_CsrPlugin_writeData[15 : 15];
  assign _zz_833_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_834_ = execute_CsrPlugin_writeData[26 : 26];
  assign _zz_835_ = execute_CsrPlugin_writeData[25 : 25];
  assign _zz_836_ = execute_CsrPlugin_writeData[24 : 24];
  assign _zz_837_ = execute_CsrPlugin_writeData[18 : 18];
  assign _zz_838_ = execute_CsrPlugin_writeData[17 : 17];
  assign _zz_839_ = execute_CsrPlugin_writeData[16 : 16];
  assign _zz_840_ = execute_CsrPlugin_writeData[10 : 10];
  assign _zz_841_ = execute_CsrPlugin_writeData[9 : 9];
  assign _zz_842_ = execute_CsrPlugin_writeData[8 : 8];
  assign _zz_843_ = execute_CsrPlugin_writeData[2 : 2];
  assign _zz_844_ = execute_CsrPlugin_writeData[1 : 1];
  assign _zz_845_ = execute_CsrPlugin_writeData[0 : 0];
  assign _zz_846_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_847_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_848_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_849_ = execute_CsrPlugin_writeData[11 : 11];
  assign _zz_850_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_851_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_852_ = execute_CsrPlugin_writeData[31 : 31];
  assign _zz_853_ = (iBus_cmd_payload_address >>> 5);
  assign _zz_854_ = 1'b1;
  assign _zz_855_ = 1'b1;
  assign _zz_856_ = {_zz_61_,_zz_60_};
  assign _zz_857_ = {_zz_361_,{_zz_360_,{_zz_359_,_zz_358_}}};
  assign _zz_858_ = {_zz_378_,{_zz_377_,{_zz_376_,_zz_375_}}};
  assign _zz_859_ = {_zz_395_,{_zz_394_,{_zz_393_,_zz_392_}}};
  assign _zz_860_ = {_zz_412_,{_zz_411_,{_zz_410_,_zz_409_}}};
  assign _zz_861_ = {_zz_429_,{_zz_428_,{_zz_427_,_zz_426_}}};
  assign _zz_862_ = {_zz_446_,{_zz_445_,{_zz_444_,_zz_443_}}};
  assign _zz_863_ = 32'h0000107f;
  assign _zz_864_ = (decode_INSTRUCTION & 32'h0000207f);
  assign _zz_865_ = 32'h00002073;
  assign _zz_866_ = ((decode_INSTRUCTION & 32'h0000407f) == 32'h00004063);
  assign _zz_867_ = ((decode_INSTRUCTION & 32'h0000207f) == 32'h00002013);
  assign _zz_868_ = {((decode_INSTRUCTION & 32'h0000603f) == 32'h00000023),{((decode_INSTRUCTION & 32'h0000207f) == 32'h00000003),{((decode_INSTRUCTION & _zz_869_) == 32'h00000003),{(_zz_870_ == _zz_871_),{_zz_872_,{_zz_873_,_zz_874_}}}}}};
  assign _zz_869_ = 32'h0000505f;
  assign _zz_870_ = (decode_INSTRUCTION & 32'h0000707b);
  assign _zz_871_ = 32'h00000063;
  assign _zz_872_ = ((decode_INSTRUCTION & 32'h0000607f) == 32'h0000000f);
  assign _zz_873_ = ((decode_INSTRUCTION & 32'hfc00007f) == 32'h00000033);
  assign _zz_874_ = {((decode_INSTRUCTION & 32'h01f0707f) == 32'h0000500f),{((decode_INSTRUCTION & 32'hbc00707f) == 32'h00005013),{((decode_INSTRUCTION & _zz_875_) == 32'h00001013),{(_zz_876_ == _zz_877_),{_zz_878_,{_zz_879_,_zz_880_}}}}}};
  assign _zz_875_ = 32'hfc00307f;
  assign _zz_876_ = (decode_INSTRUCTION & 32'hbe00707f);
  assign _zz_877_ = 32'h00005033;
  assign _zz_878_ = ((decode_INSTRUCTION & 32'hbe00707f) == 32'h00000033);
  assign _zz_879_ = ((decode_INSTRUCTION & 32'hdfffffff) == 32'h10200073);
  assign _zz_880_ = {((decode_INSTRUCTION & 32'hffffffff) == 32'h10500073),((decode_INSTRUCTION & 32'hffffffff) == 32'h00000073)};
  assign _zz_881_ = decode_INSTRUCTION[31];
  assign _zz_882_ = decode_INSTRUCTION[31];
  assign _zz_883_ = decode_INSTRUCTION[7];
  assign _zz_884_ = PmpPlugin_ports_0_hits_5;
  assign _zz_885_ = {PmpPlugin_ports_0_hits_4,{PmpPlugin_ports_0_hits_3,{PmpPlugin_ports_0_hits_2,{PmpPlugin_ports_0_hits_1,PmpPlugin_ports_0_hits_0}}}};
  assign _zz_886_ = PmpPlugin_ports_0_hits_5;
  assign _zz_887_ = {PmpPlugin_ports_0_hits_4,{PmpPlugin_ports_0_hits_3,{PmpPlugin_ports_0_hits_2,{PmpPlugin_ports_0_hits_1,PmpPlugin_ports_0_hits_0}}}};
  assign _zz_888_ = PmpPlugin_ports_0_hits_5;
  assign _zz_889_ = {PmpPlugin_ports_0_hits_4,{PmpPlugin_ports_0_hits_3,{PmpPlugin_ports_0_hits_2,{PmpPlugin_ports_0_hits_1,PmpPlugin_ports_0_hits_0}}}};
  assign _zz_890_ = PmpPlugin_ports_1_hits_5;
  assign _zz_891_ = {PmpPlugin_ports_1_hits_4,{PmpPlugin_ports_1_hits_3,{PmpPlugin_ports_1_hits_2,{PmpPlugin_ports_1_hits_1,PmpPlugin_ports_1_hits_0}}}};
  assign _zz_892_ = PmpPlugin_ports_1_hits_5;
  assign _zz_893_ = {PmpPlugin_ports_1_hits_4,{PmpPlugin_ports_1_hits_3,{PmpPlugin_ports_1_hits_2,{PmpPlugin_ports_1_hits_1,PmpPlugin_ports_1_hits_0}}}};
  assign _zz_894_ = PmpPlugin_ports_1_hits_5;
  assign _zz_895_ = {PmpPlugin_ports_1_hits_4,{PmpPlugin_ports_1_hits_3,{PmpPlugin_ports_1_hits_2,{PmpPlugin_ports_1_hits_1,PmpPlugin_ports_1_hits_0}}}};
  assign _zz_896_ = (decode_INSTRUCTION & 32'h0000001c);
  assign _zz_897_ = 32'h00000004;
  assign _zz_898_ = (decode_INSTRUCTION & 32'h00000058);
  assign _zz_899_ = 32'h00000040;
  assign _zz_900_ = ((decode_INSTRUCTION & 32'h00000064) == 32'h00000024);
  assign _zz_901_ = {(_zz_906_ == _zz_907_),{_zz_450_,{_zz_908_,_zz_909_}}};
  assign _zz_902_ = 5'h0;
  assign _zz_903_ = ({_zz_451_,{_zz_910_,_zz_911_}} != 6'h0);
  assign _zz_904_ = ({_zz_912_,_zz_913_} != (3'b000));
  assign _zz_905_ = {(_zz_914_ != _zz_915_),{_zz_916_,{_zz_917_,_zz_918_}}};
  assign _zz_906_ = (decode_INSTRUCTION & 32'h00000040);
  assign _zz_907_ = 32'h00000040;
  assign _zz_908_ = (_zz_919_ == _zz_920_);
  assign _zz_909_ = {_zz_921_,_zz_922_};
  assign _zz_910_ = (_zz_923_ == _zz_924_);
  assign _zz_911_ = {_zz_925_,{_zz_926_,_zz_927_}};
  assign _zz_912_ = (_zz_928_ == _zz_929_);
  assign _zz_913_ = {_zz_930_,_zz_931_};
  assign _zz_914_ = (_zz_932_ == _zz_933_);
  assign _zz_915_ = (1'b0);
  assign _zz_916_ = (_zz_934_ != (1'b0));
  assign _zz_917_ = (_zz_935_ != _zz_936_);
  assign _zz_918_ = {_zz_937_,{_zz_938_,_zz_939_}};
  assign _zz_919_ = (decode_INSTRUCTION & 32'h00004020);
  assign _zz_920_ = 32'h00004020;
  assign _zz_921_ = ((decode_INSTRUCTION & _zz_940_) == 32'h00000010);
  assign _zz_922_ = ((decode_INSTRUCTION & _zz_941_) == 32'h00000020);
  assign _zz_923_ = (decode_INSTRUCTION & 32'h00001010);
  assign _zz_924_ = 32'h00001010;
  assign _zz_925_ = ((decode_INSTRUCTION & _zz_942_) == 32'h00002010);
  assign _zz_926_ = (_zz_943_ == _zz_944_);
  assign _zz_927_ = {_zz_945_,_zz_946_};
  assign _zz_928_ = (decode_INSTRUCTION & 32'h00000044);
  assign _zz_929_ = 32'h00000040;
  assign _zz_930_ = ((decode_INSTRUCTION & _zz_947_) == 32'h00002010);
  assign _zz_931_ = ((decode_INSTRUCTION & _zz_948_) == 32'h40000030);
  assign _zz_932_ = (decode_INSTRUCTION & 32'h00203050);
  assign _zz_933_ = 32'h00000050;
  assign _zz_934_ = ((decode_INSTRUCTION & _zz_949_) == 32'h00000050);
  assign _zz_935_ = (_zz_950_ == _zz_951_);
  assign _zz_936_ = (1'b0);
  assign _zz_937_ = (_zz_952_ != (1'b0));
  assign _zz_938_ = (_zz_953_ != _zz_954_);
  assign _zz_939_ = {_zz_955_,{_zz_956_,_zz_957_}};
  assign _zz_940_ = 32'h00000030;
  assign _zz_941_ = 32'h02000020;
  assign _zz_942_ = 32'h00002010;
  assign _zz_943_ = (decode_INSTRUCTION & 32'h00000050);
  assign _zz_944_ = 32'h00000010;
  assign _zz_945_ = ((decode_INSTRUCTION & 32'h0000000c) == 32'h00000004);
  assign _zz_946_ = ((decode_INSTRUCTION & 32'h00000028) == 32'h0);
  assign _zz_947_ = 32'h00002014;
  assign _zz_948_ = 32'h40000034;
  assign _zz_949_ = 32'h00403050;
  assign _zz_950_ = (decode_INSTRUCTION & 32'h00001000);
  assign _zz_951_ = 32'h00001000;
  assign _zz_952_ = ((decode_INSTRUCTION & 32'h00003000) == 32'h00002000);
  assign _zz_953_ = {(_zz_958_ == _zz_959_),{_zz_960_,{_zz_961_,_zz_962_}}};
  assign _zz_954_ = 5'h0;
  assign _zz_955_ = ({_zz_963_,_zz_964_} != (2'b00));
  assign _zz_956_ = ({_zz_965_,_zz_966_} != (3'b000));
  assign _zz_957_ = {(_zz_967_ != _zz_968_),{_zz_969_,{_zz_970_,_zz_971_}}};
  assign _zz_958_ = (decode_INSTRUCTION & 32'h00002040);
  assign _zz_959_ = 32'h00002040;
  assign _zz_960_ = ((decode_INSTRUCTION & _zz_972_) == 32'h00001040);
  assign _zz_961_ = (_zz_973_ == _zz_974_);
  assign _zz_962_ = {_zz_975_,_zz_976_};
  assign _zz_963_ = ((decode_INSTRUCTION & _zz_977_) == 32'h00005010);
  assign _zz_964_ = ((decode_INSTRUCTION & _zz_978_) == 32'h00005020);
  assign _zz_965_ = (_zz_979_ == _zz_980_);
  assign _zz_966_ = {_zz_981_,_zz_982_};
  assign _zz_967_ = {_zz_983_,{_zz_984_,_zz_985_}};
  assign _zz_968_ = (4'b0000);
  assign _zz_969_ = (_zz_986_ != (1'b0));
  assign _zz_970_ = (_zz_987_ != _zz_988_);
  assign _zz_971_ = {_zz_989_,{_zz_990_,_zz_991_}};
  assign _zz_972_ = 32'h00001040;
  assign _zz_973_ = (decode_INSTRUCTION & 32'h00000050);
  assign _zz_974_ = 32'h00000040;
  assign _zz_975_ = ((decode_INSTRUCTION & _zz_992_) == 32'h00000040);
  assign _zz_976_ = ((decode_INSTRUCTION & _zz_993_) == 32'h0);
  assign _zz_977_ = 32'h00007034;
  assign _zz_978_ = 32'h02007064;
  assign _zz_979_ = (decode_INSTRUCTION & 32'h40003054);
  assign _zz_980_ = 32'h40001010;
  assign _zz_981_ = ((decode_INSTRUCTION & _zz_994_) == 32'h00001010);
  assign _zz_982_ = ((decode_INSTRUCTION & _zz_995_) == 32'h00001010);
  assign _zz_983_ = ((decode_INSTRUCTION & _zz_996_) == 32'h0);
  assign _zz_984_ = (_zz_997_ == _zz_998_);
  assign _zz_985_ = {_zz_999_,_zz_1000_};
  assign _zz_986_ = ((decode_INSTRUCTION & _zz_1001_) == 32'h02004020);
  assign _zz_987_ = (_zz_1002_ == _zz_1003_);
  assign _zz_988_ = (1'b0);
  assign _zz_989_ = (_zz_1004_ != (1'b0));
  assign _zz_990_ = (_zz_1005_ != _zz_1006_);
  assign _zz_991_ = {_zz_1007_,{_zz_1008_,_zz_1009_}};
  assign _zz_992_ = 32'h00400040;
  assign _zz_993_ = 32'h00000038;
  assign _zz_994_ = 32'h00007034;
  assign _zz_995_ = 32'h02007054;
  assign _zz_996_ = 32'h00000044;
  assign _zz_997_ = (decode_INSTRUCTION & 32'h00000018);
  assign _zz_998_ = 32'h0;
  assign _zz_999_ = ((decode_INSTRUCTION & 32'h00006004) == 32'h00002000);
  assign _zz_1000_ = ((decode_INSTRUCTION & 32'h00005004) == 32'h00001000);
  assign _zz_1001_ = 32'h02004064;
  assign _zz_1002_ = (decode_INSTRUCTION & 32'h02004074);
  assign _zz_1003_ = 32'h02000030;
  assign _zz_1004_ = ((decode_INSTRUCTION & 32'h00000058) == 32'h0);
  assign _zz_1005_ = {_zz_450_,{_zz_1010_,{_zz_1011_,_zz_1012_}}};
  assign _zz_1006_ = 5'h0;
  assign _zz_1007_ = ({_zz_1013_,_zz_1014_} != (2'b00));
  assign _zz_1008_ = (_zz_1015_ != (1'b0));
  assign _zz_1009_ = {(_zz_1016_ != _zz_1017_),{_zz_1018_,{_zz_1019_,_zz_1020_}}};
  assign _zz_1010_ = ((decode_INSTRUCTION & _zz_1021_) == 32'h00002010);
  assign _zz_1011_ = (_zz_1022_ == _zz_1023_);
  assign _zz_1012_ = {_zz_1024_,_zz_1025_};
  assign _zz_1013_ = ((decode_INSTRUCTION & _zz_1026_) == 32'h00001050);
  assign _zz_1014_ = ((decode_INSTRUCTION & _zz_1027_) == 32'h00002050);
  assign _zz_1015_ = ((decode_INSTRUCTION & _zz_1028_) == 32'h00000020);
  assign _zz_1016_ = _zz_448_;
  assign _zz_1017_ = (1'b0);
  assign _zz_1018_ = ({_zz_1029_,_zz_1030_} != (2'b00));
  assign _zz_1019_ = (_zz_1031_ != _zz_1032_);
  assign _zz_1020_ = {_zz_1033_,{_zz_1034_,_zz_1035_}};
  assign _zz_1021_ = 32'h00002030;
  assign _zz_1022_ = (decode_INSTRUCTION & 32'h00001030);
  assign _zz_1023_ = 32'h00000010;
  assign _zz_1024_ = ((decode_INSTRUCTION & 32'h02002060) == 32'h00002020);
  assign _zz_1025_ = ((decode_INSTRUCTION & 32'h02003020) == 32'h00000020);
  assign _zz_1026_ = 32'h00001050;
  assign _zz_1027_ = 32'h00002050;
  assign _zz_1028_ = 32'h00000020;
  assign _zz_1029_ = ((decode_INSTRUCTION & _zz_1036_) == 32'h00002000);
  assign _zz_1030_ = ((decode_INSTRUCTION & _zz_1037_) == 32'h00001000);
  assign _zz_1031_ = ((decode_INSTRUCTION & _zz_1038_) == 32'h00004008);
  assign _zz_1032_ = (1'b0);
  assign _zz_1033_ = ((_zz_1039_ == _zz_1040_) != (1'b0));
  assign _zz_1034_ = (_zz_1041_ != (1'b0));
  assign _zz_1035_ = {(_zz_1042_ != _zz_1043_),{_zz_1044_,{_zz_1045_,_zz_1046_}}};
  assign _zz_1036_ = 32'h00002010;
  assign _zz_1037_ = 32'h00005000;
  assign _zz_1038_ = 32'h00004048;
  assign _zz_1039_ = (decode_INSTRUCTION & 32'h00004014);
  assign _zz_1040_ = 32'h00004010;
  assign _zz_1041_ = ((decode_INSTRUCTION & 32'h00006014) == 32'h00002010);
  assign _zz_1042_ = {_zz_450_,((decode_INSTRUCTION & _zz_1047_) == 32'h00000020)};
  assign _zz_1043_ = (2'b00);
  assign _zz_1044_ = ({_zz_450_,(_zz_1048_ == _zz_1049_)} != (2'b00));
  assign _zz_1045_ = ((_zz_1050_ == _zz_1051_) != (1'b0));
  assign _zz_1046_ = {({_zz_1052_,_zz_1053_} != (2'b00)),{(_zz_1054_ != _zz_1055_),{_zz_1056_,_zz_1057_}}};
  assign _zz_1047_ = 32'h00000070;
  assign _zz_1048_ = (decode_INSTRUCTION & 32'h00000020);
  assign _zz_1049_ = 32'h0;
  assign _zz_1050_ = (decode_INSTRUCTION & 32'h00005048);
  assign _zz_1051_ = 32'h00001008;
  assign _zz_1052_ = ((decode_INSTRUCTION & 32'h00000014) == 32'h00000004);
  assign _zz_1053_ = _zz_449_;
  assign _zz_1054_ = {((decode_INSTRUCTION & 32'h00000044) == 32'h00000004),_zz_449_};
  assign _zz_1055_ = (2'b00);
  assign _zz_1056_ = (_zz_448_ != (1'b0));
  assign _zz_1057_ = ({((decode_INSTRUCTION & 32'h00000034) == 32'h00000020),((decode_INSTRUCTION & 32'h00000064) == 32'h00000020)} != (2'b00));
  assign _zz_1058_ = execute_INSTRUCTION[31];
  assign _zz_1059_ = execute_INSTRUCTION[31];
  assign _zz_1060_ = execute_INSTRUCTION[7];
  assign _zz_1061_ = (_zz_509_ | _zz_510_);
  assign _zz_1062_ = (_zz_511_ | _zz_512_);
  assign _zz_1063_ = (_zz_513_ | _zz_514_);
  assign _zz_1064_ = (_zz_515_ | _zz_516_);
  assign _zz_1065_ = (_zz_517_ | _zz_518_);
  assign _zz_1066_ = (_zz_519_ | _zz_520_);
  assign _zz_1067_ = (_zz_521_ | _zz_522_);
  assign _zz_1068_ = (_zz_523_ | _zz_524_);
  assign _zz_1069_ = (_zz_525_ | _zz_526_);
  assign _zz_1070_ = (_zz_527_ | _zz_528_);
  assign _zz_1071_ = (_zz_529_ | _zz_530_);
  assign _zz_1072_ = (_zz_531_ | _zz_532_);
  assign _zz_1073_ = (_zz_1077_ | _zz_533_);
  assign _zz_1074_ = (_zz_534_ | _zz_535_);
  assign _zz_1075_ = (_zz_536_ | _zz_537_);
  assign _zz_1076_ = (_zz_538_ | _zz_539_);
  assign _zz_1077_ = 32'h0;
  always @ (posedge clk) begin
    if(_zz_854_) begin
      _zz_579_ <= RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress1];
    end
  end

  always @ (posedge clk) begin
    if(_zz_855_) begin
      _zz_580_ <= RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress2];
    end
  end

  always @ (posedge clk) begin
    if(_zz_42_) begin
      RegFilePlugin_regFile[lastStageRegFileWrite_payload_address] <= lastStageRegFileWrite_payload_data;
    end
  end

  InstructionCache IBusCachedPlugin_cache ( 
    .io_flush                                     (_zz_561_                                                             ), //i
    .io_cpu_prefetch_isValid                      (_zz_562_                                                             ), //i
    .io_cpu_prefetch_haltIt                       (IBusCachedPlugin_cache_io_cpu_prefetch_haltIt                        ), //o
    .io_cpu_prefetch_pc                           (IBusCachedPlugin_iBusRsp_stages_0_input_payload[31:0]                ), //i
    .io_cpu_fetch_isValid                         (_zz_563_                                                             ), //i
    .io_cpu_fetch_isStuck                         (_zz_564_                                                             ), //i
    .io_cpu_fetch_isRemoved                       (IBusCachedPlugin_externalFlush                                       ), //i
    .io_cpu_fetch_pc                              (IBusCachedPlugin_iBusRsp_stages_1_input_payload[31:0]                ), //i
    .io_cpu_fetch_data                            (IBusCachedPlugin_cache_io_cpu_fetch_data[31:0]                       ), //o
    .io_cpu_fetch_mmuBus_cmd_isValid              (IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_isValid               ), //o
    .io_cpu_fetch_mmuBus_cmd_virtualAddress       (IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_virtualAddress[31:0]  ), //o
    .io_cpu_fetch_mmuBus_cmd_bypassTranslation    (IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_bypassTranslation     ), //o
    .io_cpu_fetch_mmuBus_rsp_physicalAddress      (IBusCachedPlugin_mmuBus_rsp_physicalAddress[31:0]                    ), //i
    .io_cpu_fetch_mmuBus_rsp_isIoAccess           (IBusCachedPlugin_mmuBus_rsp_isIoAccess                               ), //i
    .io_cpu_fetch_mmuBus_rsp_allowRead            (IBusCachedPlugin_mmuBus_rsp_allowRead                                ), //i
    .io_cpu_fetch_mmuBus_rsp_allowWrite           (IBusCachedPlugin_mmuBus_rsp_allowWrite                               ), //i
    .io_cpu_fetch_mmuBus_rsp_allowExecute         (IBusCachedPlugin_mmuBus_rsp_allowExecute                             ), //i
    .io_cpu_fetch_mmuBus_rsp_exception            (IBusCachedPlugin_mmuBus_rsp_exception                                ), //i
    .io_cpu_fetch_mmuBus_rsp_refilling            (IBusCachedPlugin_mmuBus_rsp_refilling                                ), //i
    .io_cpu_fetch_mmuBus_end                      (IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_end                       ), //o
    .io_cpu_fetch_mmuBus_busy                     (IBusCachedPlugin_mmuBus_busy                                         ), //i
    .io_cpu_fetch_physicalAddress                 (IBusCachedPlugin_cache_io_cpu_fetch_physicalAddress[31:0]            ), //o
    .io_cpu_fetch_haltIt                          (IBusCachedPlugin_cache_io_cpu_fetch_haltIt                           ), //o
    .io_cpu_decode_isValid                        (_zz_565_                                                             ), //i
    .io_cpu_decode_isStuck                        (_zz_566_                                                             ), //i
    .io_cpu_decode_pc                             (IBusCachedPlugin_iBusRsp_stages_2_input_payload[31:0]                ), //i
    .io_cpu_decode_physicalAddress                (IBusCachedPlugin_cache_io_cpu_decode_physicalAddress[31:0]           ), //o
    .io_cpu_decode_data                           (IBusCachedPlugin_cache_io_cpu_decode_data[31:0]                      ), //o
    .io_cpu_decode_cacheMiss                      (IBusCachedPlugin_cache_io_cpu_decode_cacheMiss                       ), //o
    .io_cpu_decode_error                          (IBusCachedPlugin_cache_io_cpu_decode_error                           ), //o
    .io_cpu_decode_mmuRefilling                   (IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling                    ), //o
    .io_cpu_decode_mmuException                   (IBusCachedPlugin_cache_io_cpu_decode_mmuException                    ), //o
    .io_cpu_decode_isUser                         (_zz_567_                                                             ), //i
    .io_cpu_fill_valid                            (_zz_568_                                                             ), //i
    .io_cpu_fill_payload                          (IBusCachedPlugin_cache_io_cpu_decode_physicalAddress[31:0]           ), //i
    .io_mem_cmd_valid                             (IBusCachedPlugin_cache_io_mem_cmd_valid                              ), //o
    .io_mem_cmd_ready                             (iBus_cmd_ready                                                       ), //i
    .io_mem_cmd_payload_address                   (IBusCachedPlugin_cache_io_mem_cmd_payload_address[31:0]              ), //o
    .io_mem_cmd_payload_size                      (IBusCachedPlugin_cache_io_mem_cmd_payload_size[2:0]                  ), //o
    .io_mem_rsp_valid                             (iBus_rsp_valid                                                       ), //i
    .io_mem_rsp_payload_data                      (iBus_rsp_payload_data[31:0]                                          ), //i
    .io_mem_rsp_payload_error                     (iBus_rsp_payload_error                                               ), //i
    .clk                                          (clk                                                                  ), //i
    .reset                                        (reset                                                                )  //i
  );
  DataCache dataCache_1_ ( 
    .io_cpu_execute_isValid                        (_zz_569_                                                    ), //i
    .io_cpu_execute_address                        (_zz_570_[31:0]                                              ), //i
    .io_cpu_execute_args_wr                        (execute_MEMORY_WR                                           ), //i
    .io_cpu_execute_args_data                      (_zz_84_[31:0]                                               ), //i
    .io_cpu_execute_args_size                      (execute_DBusCachedPlugin_size[1:0]                          ), //i
    .io_cpu_memory_isValid                         (_zz_571_                                                    ), //i
    .io_cpu_memory_isStuck                         (memory_arbitration_isStuck                                  ), //i
    .io_cpu_memory_isRemoved                       (memory_arbitration_removeIt                                 ), //i
    .io_cpu_memory_isWrite                         (dataCache_1__io_cpu_memory_isWrite                          ), //o
    .io_cpu_memory_address                         (_zz_572_[31:0]                                              ), //i
    .io_cpu_memory_mmuBus_cmd_isValid              (dataCache_1__io_cpu_memory_mmuBus_cmd_isValid               ), //o
    .io_cpu_memory_mmuBus_cmd_virtualAddress       (dataCache_1__io_cpu_memory_mmuBus_cmd_virtualAddress[31:0]  ), //o
    .io_cpu_memory_mmuBus_cmd_bypassTranslation    (dataCache_1__io_cpu_memory_mmuBus_cmd_bypassTranslation     ), //o
    .io_cpu_memory_mmuBus_rsp_physicalAddress      (DBusCachedPlugin_mmuBus_rsp_physicalAddress[31:0]           ), //i
    .io_cpu_memory_mmuBus_rsp_isIoAccess           (_zz_573_                                                    ), //i
    .io_cpu_memory_mmuBus_rsp_allowRead            (DBusCachedPlugin_mmuBus_rsp_allowRead                       ), //i
    .io_cpu_memory_mmuBus_rsp_allowWrite           (DBusCachedPlugin_mmuBus_rsp_allowWrite                      ), //i
    .io_cpu_memory_mmuBus_rsp_allowExecute         (DBusCachedPlugin_mmuBus_rsp_allowExecute                    ), //i
    .io_cpu_memory_mmuBus_rsp_exception            (DBusCachedPlugin_mmuBus_rsp_exception                       ), //i
    .io_cpu_memory_mmuBus_rsp_refilling            (DBusCachedPlugin_mmuBus_rsp_refilling                       ), //i
    .io_cpu_memory_mmuBus_end                      (dataCache_1__io_cpu_memory_mmuBus_end                       ), //o
    .io_cpu_memory_mmuBus_busy                     (DBusCachedPlugin_mmuBus_busy                                ), //i
    .io_cpu_writeBack_isValid                      (_zz_574_                                                    ), //i
    .io_cpu_writeBack_isStuck                      (writeBack_arbitration_isStuck                               ), //i
    .io_cpu_writeBack_isUser                       (_zz_575_                                                    ), //i
    .io_cpu_writeBack_haltIt                       (dataCache_1__io_cpu_writeBack_haltIt                        ), //o
    .io_cpu_writeBack_isWrite                      (dataCache_1__io_cpu_writeBack_isWrite                       ), //o
    .io_cpu_writeBack_data                         (dataCache_1__io_cpu_writeBack_data[31:0]                    ), //o
    .io_cpu_writeBack_address                      (_zz_576_[31:0]                                              ), //i
    .io_cpu_writeBack_mmuException                 (dataCache_1__io_cpu_writeBack_mmuException                  ), //o
    .io_cpu_writeBack_unalignedAccess              (dataCache_1__io_cpu_writeBack_unalignedAccess               ), //o
    .io_cpu_writeBack_accessError                  (dataCache_1__io_cpu_writeBack_accessError                   ), //o
    .io_cpu_redo                                   (dataCache_1__io_cpu_redo                                    ), //o
    .io_cpu_flush_valid                            (_zz_577_                                                    ), //i
    .io_cpu_flush_ready                            (dataCache_1__io_cpu_flush_ready                             ), //o
    .io_mem_cmd_valid                              (dataCache_1__io_mem_cmd_valid                               ), //o
    .io_mem_cmd_ready                              (_zz_578_                                                    ), //i
    .io_mem_cmd_payload_wr                         (dataCache_1__io_mem_cmd_payload_wr                          ), //o
    .io_mem_cmd_payload_address                    (dataCache_1__io_mem_cmd_payload_address[31:0]               ), //o
    .io_mem_cmd_payload_data                       (dataCache_1__io_mem_cmd_payload_data[31:0]                  ), //o
    .io_mem_cmd_payload_mask                       (dataCache_1__io_mem_cmd_payload_mask[3:0]                   ), //o
    .io_mem_cmd_payload_length                     (dataCache_1__io_mem_cmd_payload_length[2:0]                 ), //o
    .io_mem_cmd_payload_last                       (dataCache_1__io_mem_cmd_payload_last                        ), //o
    .io_mem_rsp_valid                              (dBus_rsp_valid                                              ), //i
    .io_mem_rsp_payload_data                       (dBus_rsp_payload_data[31:0]                                 ), //i
    .io_mem_rsp_payload_error                      (dBus_rsp_payload_error                                      ), //i
    .clk                                           (clk                                                         ), //i
    .reset                                         (reset                                                       )  //i
  );
  always @(*) begin
    case(_zz_856_)
      2'b00 : begin
        _zz_581_ = DBusCachedPlugin_redoBranch_payload;
      end
      2'b01 : begin
        _zz_581_ = CsrPlugin_jumpInterface_payload;
      end
      2'b10 : begin
        _zz_581_ = BranchPlugin_jumpInterface_payload;
      end
      default : begin
        _zz_581_ = IBusCachedPlugin_predictionJumpInterface_payload;
      end
    endcase
  end

  always @(*) begin
    case(_zz_857_)
      4'b0000 : begin
        _zz_582_ = _zz_95_;
      end
      4'b0001 : begin
        _zz_582_ = _zz_111_;
      end
      4'b0010 : begin
        _zz_582_ = _zz_127_;
      end
      4'b0011 : begin
        _zz_582_ = _zz_143_;
      end
      4'b0100 : begin
        _zz_582_ = _zz_159_;
      end
      4'b0101 : begin
        _zz_582_ = _zz_175_;
      end
      4'b0110 : begin
        _zz_582_ = _zz_191_;
      end
      4'b0111 : begin
        _zz_582_ = _zz_207_;
      end
      4'b1000 : begin
        _zz_582_ = _zz_223_;
      end
      4'b1001 : begin
        _zz_582_ = _zz_239_;
      end
      4'b1010 : begin
        _zz_582_ = _zz_255_;
      end
      4'b1011 : begin
        _zz_582_ = _zz_271_;
      end
      4'b1100 : begin
        _zz_582_ = _zz_287_;
      end
      4'b1101 : begin
        _zz_582_ = _zz_303_;
      end
      4'b1110 : begin
        _zz_582_ = _zz_319_;
      end
      default : begin
        _zz_582_ = _zz_335_;
      end
    endcase
  end

  always @(*) begin
    case(_zz_858_)
      4'b0000 : begin
        _zz_583_ = _zz_96_;
      end
      4'b0001 : begin
        _zz_583_ = _zz_112_;
      end
      4'b0010 : begin
        _zz_583_ = _zz_128_;
      end
      4'b0011 : begin
        _zz_583_ = _zz_144_;
      end
      4'b0100 : begin
        _zz_583_ = _zz_160_;
      end
      4'b0101 : begin
        _zz_583_ = _zz_176_;
      end
      4'b0110 : begin
        _zz_583_ = _zz_192_;
      end
      4'b0111 : begin
        _zz_583_ = _zz_208_;
      end
      4'b1000 : begin
        _zz_583_ = _zz_224_;
      end
      4'b1001 : begin
        _zz_583_ = _zz_240_;
      end
      4'b1010 : begin
        _zz_583_ = _zz_256_;
      end
      4'b1011 : begin
        _zz_583_ = _zz_272_;
      end
      4'b1100 : begin
        _zz_583_ = _zz_288_;
      end
      4'b1101 : begin
        _zz_583_ = _zz_304_;
      end
      4'b1110 : begin
        _zz_583_ = _zz_320_;
      end
      default : begin
        _zz_583_ = _zz_336_;
      end
    endcase
  end

  always @(*) begin
    case(_zz_859_)
      4'b0000 : begin
        _zz_584_ = _zz_97_;
      end
      4'b0001 : begin
        _zz_584_ = _zz_113_;
      end
      4'b0010 : begin
        _zz_584_ = _zz_129_;
      end
      4'b0011 : begin
        _zz_584_ = _zz_145_;
      end
      4'b0100 : begin
        _zz_584_ = _zz_161_;
      end
      4'b0101 : begin
        _zz_584_ = _zz_177_;
      end
      4'b0110 : begin
        _zz_584_ = _zz_193_;
      end
      4'b0111 : begin
        _zz_584_ = _zz_209_;
      end
      4'b1000 : begin
        _zz_584_ = _zz_225_;
      end
      4'b1001 : begin
        _zz_584_ = _zz_241_;
      end
      4'b1010 : begin
        _zz_584_ = _zz_257_;
      end
      4'b1011 : begin
        _zz_584_ = _zz_273_;
      end
      4'b1100 : begin
        _zz_584_ = _zz_289_;
      end
      4'b1101 : begin
        _zz_584_ = _zz_305_;
      end
      4'b1110 : begin
        _zz_584_ = _zz_321_;
      end
      default : begin
        _zz_584_ = _zz_337_;
      end
    endcase
  end

  always @(*) begin
    case(_zz_860_)
      4'b0000 : begin
        _zz_585_ = _zz_95_;
      end
      4'b0001 : begin
        _zz_585_ = _zz_111_;
      end
      4'b0010 : begin
        _zz_585_ = _zz_127_;
      end
      4'b0011 : begin
        _zz_585_ = _zz_143_;
      end
      4'b0100 : begin
        _zz_585_ = _zz_159_;
      end
      4'b0101 : begin
        _zz_585_ = _zz_175_;
      end
      4'b0110 : begin
        _zz_585_ = _zz_191_;
      end
      4'b0111 : begin
        _zz_585_ = _zz_207_;
      end
      4'b1000 : begin
        _zz_585_ = _zz_223_;
      end
      4'b1001 : begin
        _zz_585_ = _zz_239_;
      end
      4'b1010 : begin
        _zz_585_ = _zz_255_;
      end
      4'b1011 : begin
        _zz_585_ = _zz_271_;
      end
      4'b1100 : begin
        _zz_585_ = _zz_287_;
      end
      4'b1101 : begin
        _zz_585_ = _zz_303_;
      end
      4'b1110 : begin
        _zz_585_ = _zz_319_;
      end
      default : begin
        _zz_585_ = _zz_335_;
      end
    endcase
  end

  always @(*) begin
    case(_zz_861_)
      4'b0000 : begin
        _zz_586_ = _zz_96_;
      end
      4'b0001 : begin
        _zz_586_ = _zz_112_;
      end
      4'b0010 : begin
        _zz_586_ = _zz_128_;
      end
      4'b0011 : begin
        _zz_586_ = _zz_144_;
      end
      4'b0100 : begin
        _zz_586_ = _zz_160_;
      end
      4'b0101 : begin
        _zz_586_ = _zz_176_;
      end
      4'b0110 : begin
        _zz_586_ = _zz_192_;
      end
      4'b0111 : begin
        _zz_586_ = _zz_208_;
      end
      4'b1000 : begin
        _zz_586_ = _zz_224_;
      end
      4'b1001 : begin
        _zz_586_ = _zz_240_;
      end
      4'b1010 : begin
        _zz_586_ = _zz_256_;
      end
      4'b1011 : begin
        _zz_586_ = _zz_272_;
      end
      4'b1100 : begin
        _zz_586_ = _zz_288_;
      end
      4'b1101 : begin
        _zz_586_ = _zz_304_;
      end
      4'b1110 : begin
        _zz_586_ = _zz_320_;
      end
      default : begin
        _zz_586_ = _zz_336_;
      end
    endcase
  end

  always @(*) begin
    case(_zz_862_)
      4'b0000 : begin
        _zz_587_ = _zz_97_;
      end
      4'b0001 : begin
        _zz_587_ = _zz_113_;
      end
      4'b0010 : begin
        _zz_587_ = _zz_129_;
      end
      4'b0011 : begin
        _zz_587_ = _zz_145_;
      end
      4'b0100 : begin
        _zz_587_ = _zz_161_;
      end
      4'b0101 : begin
        _zz_587_ = _zz_177_;
      end
      4'b0110 : begin
        _zz_587_ = _zz_193_;
      end
      4'b0111 : begin
        _zz_587_ = _zz_209_;
      end
      4'b1000 : begin
        _zz_587_ = _zz_225_;
      end
      4'b1001 : begin
        _zz_587_ = _zz_241_;
      end
      4'b1010 : begin
        _zz_587_ = _zz_257_;
      end
      4'b1011 : begin
        _zz_587_ = _zz_273_;
      end
      4'b1100 : begin
        _zz_587_ = _zz_289_;
      end
      4'b1101 : begin
        _zz_587_ = _zz_305_;
      end
      4'b1110 : begin
        _zz_587_ = _zz_321_;
      end
      default : begin
        _zz_587_ = _zz_337_;
      end
    endcase
  end

  `ifndef SYNTHESIS
  always @(*) begin
    case(decode_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : decode_SRC2_CTRL_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : decode_SRC2_CTRL_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : decode_SRC2_CTRL_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : decode_SRC2_CTRL_string = "PC ";
      default : decode_SRC2_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_1_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_1__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_1__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_1__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_1__string = "PC ";
      default : _zz_1__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_2_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_2__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_2__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_2__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_2__string = "PC ";
      default : _zz_2__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_3_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_3__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_3__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_3__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_3__string = "PC ";
      default : _zz_3__string = "???";
    endcase
  end
  always @(*) begin
    case(decode_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : decode_ALU_BITWISE_CTRL_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : decode_ALU_BITWISE_CTRL_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : decode_ALU_BITWISE_CTRL_string = "AND_1";
      default : decode_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_4_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_4__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_4__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_4__string = "AND_1";
      default : _zz_4__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_5_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_5__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_5__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_5__string = "AND_1";
      default : _zz_5__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_6_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_6__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_6__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_6__string = "AND_1";
      default : _zz_6__string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : decode_SRC1_CTRL_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : decode_SRC1_CTRL_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : decode_SRC1_CTRL_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : decode_SRC1_CTRL_string = "URS1        ";
      default : decode_SRC1_CTRL_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_7_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_7__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_7__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_7__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_7__string = "URS1        ";
      default : _zz_7__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_8_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_8__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_8__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_8__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_8__string = "URS1        ";
      default : _zz_8__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_9_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_9__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_9__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_9__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_9__string = "URS1        ";
      default : _zz_9__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_10_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_10__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_10__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_10__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_10__string = "SRA_1    ";
      default : _zz_10__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_11_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_11__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_11__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_11__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_11__string = "SRA_1    ";
      default : _zz_11__string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : decode_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : decode_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : decode_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : decode_SHIFT_CTRL_string = "SRA_1    ";
      default : decode_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_12_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_12__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_12__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_12__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_12__string = "SRA_1    ";
      default : _zz_12__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_13_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_13__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_13__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_13__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_13__string = "SRA_1    ";
      default : _zz_13__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_14_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_14__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_14__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_14__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_14__string = "SRA_1    ";
      default : _zz_14__string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : decode_ALU_CTRL_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : decode_ALU_CTRL_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : decode_ALU_CTRL_string = "BITWISE ";
      default : decode_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_15_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_15__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_15__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_15__string = "BITWISE ";
      default : _zz_15__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_16_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_16__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_16__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_16__string = "BITWISE ";
      default : _zz_16__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_17_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_17__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_17__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_17__string = "BITWISE ";
      default : _zz_17__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_18_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_18__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_18__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_18__string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_18__string = "ECALL";
      default : _zz_18__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_19_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_19__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_19__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_19__string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_19__string = "ECALL";
      default : _zz_19__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_20_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_20__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_20__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_20__string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_20__string = "ECALL";
      default : _zz_20__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_21_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_21__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_21__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_21__string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_21__string = "ECALL";
      default : _zz_21__string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : decode_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : decode_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : decode_ENV_CTRL_string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : decode_ENV_CTRL_string = "ECALL";
      default : decode_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_22_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_22__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_22__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_22__string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_22__string = "ECALL";
      default : _zz_22__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_23_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_23__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_23__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_23__string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_23__string = "ECALL";
      default : _zz_23__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_24_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_24__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_24__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_24__string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_24__string = "ECALL";
      default : _zz_24__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_25_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_25__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_25__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_25__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_25__string = "JALR";
      default : _zz_25__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_26_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_26__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_26__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_26__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_26__string = "JALR";
      default : _zz_26__string = "????";
    endcase
  end
  always @(*) begin
    case(memory_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : memory_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : memory_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : memory_ENV_CTRL_string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : memory_ENV_CTRL_string = "ECALL";
      default : memory_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_27_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_27__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_27__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_27__string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_27__string = "ECALL";
      default : _zz_27__string = "?????";
    endcase
  end
  always @(*) begin
    case(execute_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : execute_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : execute_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : execute_ENV_CTRL_string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : execute_ENV_CTRL_string = "ECALL";
      default : execute_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_28_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_28__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_28__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_28__string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_28__string = "ECALL";
      default : _zz_28__string = "?????";
    endcase
  end
  always @(*) begin
    case(writeBack_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : writeBack_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : writeBack_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : writeBack_ENV_CTRL_string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : writeBack_ENV_CTRL_string = "ECALL";
      default : writeBack_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_29_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_29__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_29__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_29__string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_29__string = "ECALL";
      default : _zz_29__string = "?????";
    endcase
  end
  always @(*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : execute_BRANCH_CTRL_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : execute_BRANCH_CTRL_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : execute_BRANCH_CTRL_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : execute_BRANCH_CTRL_string = "JALR";
      default : execute_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_30_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_30__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_30__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_30__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_30__string = "JALR";
      default : _zz_30__string = "????";
    endcase
  end
  always @(*) begin
    case(memory_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : memory_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : memory_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : memory_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : memory_SHIFT_CTRL_string = "SRA_1    ";
      default : memory_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_33_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_33__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_33__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_33__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_33__string = "SRA_1    ";
      default : _zz_33__string = "?????????";
    endcase
  end
  always @(*) begin
    case(execute_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : execute_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : execute_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : execute_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : execute_SHIFT_CTRL_string = "SRA_1    ";
      default : execute_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_34_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_34__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_34__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_34__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_34__string = "SRA_1    ";
      default : _zz_34__string = "?????????";
    endcase
  end
  always @(*) begin
    case(execute_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : execute_SRC2_CTRL_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : execute_SRC2_CTRL_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : execute_SRC2_CTRL_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : execute_SRC2_CTRL_string = "PC ";
      default : execute_SRC2_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_36_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_36__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_36__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_36__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_36__string = "PC ";
      default : _zz_36__string = "???";
    endcase
  end
  always @(*) begin
    case(execute_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : execute_SRC1_CTRL_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : execute_SRC1_CTRL_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : execute_SRC1_CTRL_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : execute_SRC1_CTRL_string = "URS1        ";
      default : execute_SRC1_CTRL_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_37_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_37__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_37__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_37__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_37__string = "URS1        ";
      default : _zz_37__string = "????????????";
    endcase
  end
  always @(*) begin
    case(execute_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : execute_ALU_CTRL_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : execute_ALU_CTRL_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : execute_ALU_CTRL_string = "BITWISE ";
      default : execute_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_38_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_38__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_38__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_38__string = "BITWISE ";
      default : _zz_38__string = "????????";
    endcase
  end
  always @(*) begin
    case(execute_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : execute_ALU_BITWISE_CTRL_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : execute_ALU_BITWISE_CTRL_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : execute_ALU_BITWISE_CTRL_string = "AND_1";
      default : execute_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_39_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_39__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_39__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_39__string = "AND_1";
      default : _zz_39__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_43_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_43__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_43__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_43__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_43__string = "JALR";
      default : _zz_43__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_44_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_44__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_44__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_44__string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_44__string = "ECALL";
      default : _zz_44__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_45_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_45__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_45__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_45__string = "AND_1";
      default : _zz_45__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_46_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_46__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_46__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_46__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_46__string = "SRA_1    ";
      default : _zz_46__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_47_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_47__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_47__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_47__string = "BITWISE ";
      default : _zz_47__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_48_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_48__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_48__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_48__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_48__string = "PC ";
      default : _zz_48__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_49_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_49__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_49__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_49__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_49__string = "URS1        ";
      default : _zz_49__string = "????????????";
    endcase
  end
  always @(*) begin
    case(decode_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : decode_BRANCH_CTRL_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : decode_BRANCH_CTRL_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : decode_BRANCH_CTRL_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : decode_BRANCH_CTRL_string = "JALR";
      default : decode_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_54_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_54__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_54__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_54__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_54__string = "JALR";
      default : _zz_54__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_452_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_452__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_452__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_452__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_452__string = "URS1        ";
      default : _zz_452__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_453_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_453__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_453__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_453__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_453__string = "PC ";
      default : _zz_453__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_454_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_454__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_454__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_454__string = "BITWISE ";
      default : _zz_454__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_455_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_455__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_455__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_455__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_455__string = "SRA_1    ";
      default : _zz_455__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_456_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_456__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_456__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_456__string = "AND_1";
      default : _zz_456__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_457_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_457__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_457__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_457__string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_457__string = "ECALL";
      default : _zz_457__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_458_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_458__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_458__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_458__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_458__string = "JALR";
      default : _zz_458__string = "????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : decode_to_execute_BRANCH_CTRL_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : decode_to_execute_BRANCH_CTRL_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : decode_to_execute_BRANCH_CTRL_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : decode_to_execute_BRANCH_CTRL_string = "JALR";
      default : decode_to_execute_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : decode_to_execute_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : decode_to_execute_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : decode_to_execute_ENV_CTRL_string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : decode_to_execute_ENV_CTRL_string = "ECALL";
      default : decode_to_execute_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(execute_to_memory_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : execute_to_memory_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : execute_to_memory_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : execute_to_memory_ENV_CTRL_string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : execute_to_memory_ENV_CTRL_string = "ECALL";
      default : execute_to_memory_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(memory_to_writeBack_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : memory_to_writeBack_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : memory_to_writeBack_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_WFI : memory_to_writeBack_ENV_CTRL_string = "WFI  ";
      `EnvCtrlEnum_defaultEncoding_ECALL : memory_to_writeBack_ENV_CTRL_string = "ECALL";
      default : memory_to_writeBack_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : decode_to_execute_ALU_CTRL_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : decode_to_execute_ALU_CTRL_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : decode_to_execute_ALU_CTRL_string = "BITWISE ";
      default : decode_to_execute_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : decode_to_execute_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : decode_to_execute_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : decode_to_execute_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : decode_to_execute_SHIFT_CTRL_string = "SRA_1    ";
      default : decode_to_execute_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(execute_to_memory_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : execute_to_memory_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : execute_to_memory_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : execute_to_memory_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : execute_to_memory_SHIFT_CTRL_string = "SRA_1    ";
      default : execute_to_memory_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : decode_to_execute_SRC1_CTRL_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : decode_to_execute_SRC1_CTRL_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : decode_to_execute_SRC1_CTRL_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : decode_to_execute_SRC1_CTRL_string = "URS1        ";
      default : decode_to_execute_SRC1_CTRL_string = "????????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : decode_to_execute_ALU_BITWISE_CTRL_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : decode_to_execute_ALU_BITWISE_CTRL_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : decode_to_execute_ALU_BITWISE_CTRL_string = "AND_1";
      default : decode_to_execute_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : decode_to_execute_SRC2_CTRL_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : decode_to_execute_SRC2_CTRL_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : decode_to_execute_SRC2_CTRL_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : decode_to_execute_SRC2_CTRL_string = "PC ";
      default : decode_to_execute_SRC2_CTRL_string = "???";
    endcase
  end
  `endif

  assign decode_CSR_READ_OPCODE = (decode_INSTRUCTION[13 : 7] != 7'h20);
  assign execute_REGFILE_WRITE_DATA = _zz_460_;
  assign execute_BRANCH_DO = ((execute_PREDICTION_HAD_BRANCHED2 != execute_BRANCH_COND_RESULT) || execute_BranchPlugin_missAlignedTarget);
  assign decode_IS_DIV = _zz_643_[0];
  assign decode_SRC2_CTRL = _zz_1_;
  assign _zz_2_ = _zz_3_;
  assign memory_MUL_LOW = ($signed(_zz_644_) + $signed(_zz_652_));
  assign decode_ALU_BITWISE_CTRL = _zz_4_;
  assign _zz_5_ = _zz_6_;
  assign memory_MEMORY_WR = execute_to_memory_MEMORY_WR;
  assign decode_MEMORY_WR = _zz_653_[0];
  assign execute_MUL_LH = ($signed(execute_MulPlugin_aSLow) * $signed(execute_MulPlugin_bHigh));
  assign execute_MUL_LL = (execute_MulPlugin_aULow * execute_MulPlugin_bULow);
  assign decode_CSR_WRITE_OPCODE = (! (((decode_INSTRUCTION[14 : 13] == (2'b01)) && (decode_INSTRUCTION[19 : 15] == 5'h0)) || ((decode_INSTRUCTION[14 : 13] == (2'b11)) && (decode_INSTRUCTION[19 : 15] == 5'h0))));
  assign decode_SRC2_FORCE_ZERO = (decode_SRC_ADD_ZERO && (! decode_SRC_USE_SUB_LESS));
  assign decode_SRC1_CTRL = _zz_7_;
  assign _zz_8_ = _zz_9_;
  assign decode_IS_CSR = _zz_654_[0];
  assign execute_SHIFT_RIGHT = _zz_656_;
  assign writeBack_FORMAL_PC_NEXT = memory_to_writeBack_FORMAL_PC_NEXT;
  assign memory_FORMAL_PC_NEXT = execute_to_memory_FORMAL_PC_NEXT;
  assign execute_FORMAL_PC_NEXT = decode_to_execute_FORMAL_PC_NEXT;
  assign decode_FORMAL_PC_NEXT = (decode_PC + 32'h00000004);
  assign _zz_10_ = _zz_11_;
  assign decode_SHIFT_CTRL = _zz_12_;
  assign _zz_13_ = _zz_14_;
  assign decode_SRC_LESS_UNSIGNED = _zz_658_[0];
  assign execute_BYPASSABLE_MEMORY_STAGE = decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  assign decode_BYPASSABLE_MEMORY_STAGE = _zz_659_[0];
  assign execute_BRANCH_CALC = {execute_BranchPlugin_branchAdder[31 : 1],(1'b0)};
  assign decode_PREDICTION_HAD_BRANCHED2 = IBusCachedPlugin_decodePrediction_cmd_hadBranch;
  assign memory_MEMORY_ADDRESS_LOW = execute_to_memory_MEMORY_ADDRESS_LOW;
  assign execute_MEMORY_ADDRESS_LOW = _zz_570_[1 : 0];
  assign execute_MUL_HL = ($signed(execute_MulPlugin_aHigh) * $signed(execute_MulPlugin_bSLow));
  assign decode_BYPASSABLE_EXECUTE_STAGE = _zz_660_[0];
  assign decode_ALU_CTRL = _zz_15_;
  assign _zz_16_ = _zz_17_;
  assign _zz_18_ = _zz_19_;
  assign _zz_20_ = _zz_21_;
  assign decode_ENV_CTRL = _zz_22_;
  assign _zz_23_ = _zz_24_;
  assign decode_IS_RS1_SIGNED = _zz_661_[0];
  assign memory_IS_MUL = execute_to_memory_IS_MUL;
  assign execute_IS_MUL = decode_to_execute_IS_MUL;
  assign decode_IS_MUL = _zz_662_[0];
  assign memory_MUL_HH = execute_to_memory_MUL_HH;
  assign execute_MUL_HH = ($signed(execute_MulPlugin_aHigh) * $signed(execute_MulPlugin_bHigh));
  assign _zz_25_ = _zz_26_;
  assign memory_PC = execute_to_memory_PC;
  assign decode_MEMORY_MANAGMENT = _zz_663_[0];
  assign decode_IS_RS2_SIGNED = _zz_664_[0];
  assign execute_IS_RS1_SIGNED = decode_to_execute_IS_RS1_SIGNED;
  assign execute_IS_DIV = decode_to_execute_IS_DIV;
  assign execute_IS_RS2_SIGNED = decode_to_execute_IS_RS2_SIGNED;
  assign memory_IS_DIV = execute_to_memory_IS_DIV;
  assign writeBack_IS_MUL = memory_to_writeBack_IS_MUL;
  assign writeBack_MUL_HH = memory_to_writeBack_MUL_HH;
  assign writeBack_MUL_LOW = memory_to_writeBack_MUL_LOW;
  assign memory_MUL_HL = execute_to_memory_MUL_HL;
  assign memory_MUL_LH = execute_to_memory_MUL_LH;
  assign memory_MUL_LL = execute_to_memory_MUL_LL;
  assign execute_CSR_READ_OPCODE = decode_to_execute_CSR_READ_OPCODE;
  assign execute_CSR_WRITE_OPCODE = decode_to_execute_CSR_WRITE_OPCODE;
  assign execute_IS_CSR = decode_to_execute_IS_CSR;
  assign memory_ENV_CTRL = _zz_27_;
  assign execute_ENV_CTRL = _zz_28_;
  assign writeBack_ENV_CTRL = _zz_29_;
  assign memory_BRANCH_CALC = execute_to_memory_BRANCH_CALC;
  assign memory_BRANCH_DO = execute_to_memory_BRANCH_DO;
  assign execute_PC = decode_to_execute_PC;
  assign execute_PREDICTION_HAD_BRANCHED2 = decode_to_execute_PREDICTION_HAD_BRANCHED2;
  assign execute_RS1 = decode_to_execute_RS1;
  assign execute_BRANCH_COND_RESULT = _zz_482_;
  assign execute_BRANCH_CTRL = _zz_30_;
  assign decode_RS2_USE = _zz_665_[0];
  assign decode_RS1_USE = _zz_666_[0];
  always @ (*) begin
    _zz_31_ = execute_REGFILE_WRITE_DATA;
    if(_zz_588_)begin
      _zz_31_ = execute_CsrPlugin_readData;
    end
  end

  assign execute_REGFILE_WRITE_VALID = decode_to_execute_REGFILE_WRITE_VALID;
  assign execute_BYPASSABLE_EXECUTE_STAGE = decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  assign memory_REGFILE_WRITE_VALID = execute_to_memory_REGFILE_WRITE_VALID;
  assign memory_INSTRUCTION = execute_to_memory_INSTRUCTION;
  assign memory_BYPASSABLE_MEMORY_STAGE = execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  assign writeBack_REGFILE_WRITE_VALID = memory_to_writeBack_REGFILE_WRITE_VALID;
  always @ (*) begin
    decode_RS2 = decode_RegFilePlugin_rs2Data;
    if(_zz_471_)begin
      if((_zz_472_ == decode_INSTRUCTION[24 : 20]))begin
        decode_RS2 = _zz_473_;
      end
    end
    if(_zz_589_)begin
      if(_zz_590_)begin
        if(_zz_475_)begin
          decode_RS2 = _zz_52_;
        end
      end
    end
    if(_zz_591_)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_477_)begin
          decode_RS2 = _zz_32_;
        end
      end
    end
    if(_zz_592_)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_479_)begin
          decode_RS2 = _zz_31_;
        end
      end
    end
  end

  always @ (*) begin
    decode_RS1 = decode_RegFilePlugin_rs1Data;
    if(_zz_471_)begin
      if((_zz_472_ == decode_INSTRUCTION[19 : 15]))begin
        decode_RS1 = _zz_473_;
      end
    end
    if(_zz_589_)begin
      if(_zz_590_)begin
        if(_zz_474_)begin
          decode_RS1 = _zz_52_;
        end
      end
    end
    if(_zz_591_)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_476_)begin
          decode_RS1 = _zz_32_;
        end
      end
    end
    if(_zz_592_)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_478_)begin
          decode_RS1 = _zz_31_;
        end
      end
    end
  end

  assign memory_SHIFT_RIGHT = execute_to_memory_SHIFT_RIGHT;
  always @ (*) begin
    _zz_32_ = memory_REGFILE_WRITE_DATA;
    if(memory_arbitration_isValid)begin
      case(memory_SHIFT_CTRL)
        `ShiftCtrlEnum_defaultEncoding_SLL_1 : begin
          _zz_32_ = _zz_468_;
        end
        `ShiftCtrlEnum_defaultEncoding_SRL_1, `ShiftCtrlEnum_defaultEncoding_SRA_1 : begin
          _zz_32_ = memory_SHIFT_RIGHT;
        end
        default : begin
        end
      endcase
    end
    if(_zz_593_)begin
      _zz_32_ = memory_DivPlugin_div_result;
    end
  end

  assign memory_SHIFT_CTRL = _zz_33_;
  assign execute_SHIFT_CTRL = _zz_34_;
  assign execute_SRC_LESS_UNSIGNED = decode_to_execute_SRC_LESS_UNSIGNED;
  assign execute_SRC2_FORCE_ZERO = decode_to_execute_SRC2_FORCE_ZERO;
  assign execute_SRC_USE_SUB_LESS = decode_to_execute_SRC_USE_SUB_LESS;
  assign _zz_35_ = execute_PC;
  assign execute_SRC2_CTRL = _zz_36_;
  assign execute_SRC1_CTRL = _zz_37_;
  assign decode_SRC_USE_SUB_LESS = _zz_667_[0];
  assign decode_SRC_ADD_ZERO = _zz_668_[0];
  assign execute_SRC_ADD_SUB = execute_SrcPlugin_addSub;
  assign execute_SRC_LESS = execute_SrcPlugin_less;
  assign execute_ALU_CTRL = _zz_38_;
  assign execute_SRC2 = _zz_466_;
  assign execute_SRC1 = _zz_461_;
  assign execute_ALU_BITWISE_CTRL = _zz_39_;
  assign _zz_40_ = writeBack_INSTRUCTION;
  assign _zz_41_ = writeBack_REGFILE_WRITE_VALID;
  always @ (*) begin
    _zz_42_ = 1'b0;
    if(lastStageRegFileWrite_valid)begin
      _zz_42_ = 1'b1;
    end
  end

  assign decode_INSTRUCTION_ANTICIPATED = (decode_arbitration_isStuck ? decode_INSTRUCTION : IBusCachedPlugin_cache_io_cpu_fetch_data);
  always @ (*) begin
    decode_REGFILE_WRITE_VALID = _zz_669_[0];
    if((decode_INSTRUCTION[11 : 7] == 5'h0))begin
      decode_REGFILE_WRITE_VALID = 1'b0;
    end
  end

  assign decode_LEGAL_INSTRUCTION = ({((decode_INSTRUCTION & 32'h0000005f) == 32'h00000017),{((decode_INSTRUCTION & 32'h0000007f) == 32'h0000006f),{((decode_INSTRUCTION & 32'h0000106f) == 32'h00000003),{((decode_INSTRUCTION & _zz_863_) == 32'h00001073),{(_zz_864_ == _zz_865_),{_zz_866_,{_zz_867_,_zz_868_}}}}}}} != 21'h0);
  always @ (*) begin
    _zz_50_ = _zz_50__14;
    if(PmpPlugin_ports_1_hits_15)begin
      _zz_50_ = (_zz_50__14 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__14 = _zz_50__13;
    if(PmpPlugin_ports_1_hits_14)begin
      _zz_50__14 = (_zz_50__13 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__13 = _zz_50__12;
    if(PmpPlugin_ports_1_hits_13)begin
      _zz_50__13 = (_zz_50__12 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__12 = _zz_50__11;
    if(PmpPlugin_ports_1_hits_12)begin
      _zz_50__12 = (_zz_50__11 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__11 = _zz_50__10;
    if(PmpPlugin_ports_1_hits_11)begin
      _zz_50__11 = (_zz_50__10 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__10 = _zz_50__9;
    if(PmpPlugin_ports_1_hits_10)begin
      _zz_50__10 = (_zz_50__9 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__9 = _zz_50__8;
    if(PmpPlugin_ports_1_hits_9)begin
      _zz_50__9 = (_zz_50__8 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__8 = _zz_50__7;
    if(PmpPlugin_ports_1_hits_8)begin
      _zz_50__8 = (_zz_50__7 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__7 = _zz_50__6;
    if(PmpPlugin_ports_1_hits_7)begin
      _zz_50__7 = (_zz_50__6 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__6 = _zz_50__5;
    if(PmpPlugin_ports_1_hits_6)begin
      _zz_50__6 = (_zz_50__5 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__5 = _zz_50__4;
    if(PmpPlugin_ports_1_hits_5)begin
      _zz_50__5 = (_zz_50__4 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__4 = _zz_50__3;
    if(PmpPlugin_ports_1_hits_4)begin
      _zz_50__4 = (_zz_50__3 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__3 = _zz_50__2;
    if(PmpPlugin_ports_1_hits_3)begin
      _zz_50__3 = (_zz_50__2 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__2 = _zz_50__1;
    if(PmpPlugin_ports_1_hits_2)begin
      _zz_50__2 = (_zz_50__1 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__1 = _zz_50__0;
    if(PmpPlugin_ports_1_hits_1)begin
      _zz_50__1 = (_zz_50__0 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_50__0 = 5'h0;
    if(PmpPlugin_ports_1_hits_0)begin
      _zz_50__0 = (5'h0 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51_ = _zz_51__14;
    if(PmpPlugin_ports_0_hits_15)begin
      _zz_51_ = (_zz_51__14 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__14 = _zz_51__13;
    if(PmpPlugin_ports_0_hits_14)begin
      _zz_51__14 = (_zz_51__13 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__13 = _zz_51__12;
    if(PmpPlugin_ports_0_hits_13)begin
      _zz_51__13 = (_zz_51__12 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__12 = _zz_51__11;
    if(PmpPlugin_ports_0_hits_12)begin
      _zz_51__12 = (_zz_51__11 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__11 = _zz_51__10;
    if(PmpPlugin_ports_0_hits_11)begin
      _zz_51__11 = (_zz_51__10 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__10 = _zz_51__9;
    if(PmpPlugin_ports_0_hits_10)begin
      _zz_51__10 = (_zz_51__9 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__9 = _zz_51__8;
    if(PmpPlugin_ports_0_hits_9)begin
      _zz_51__9 = (_zz_51__8 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__8 = _zz_51__7;
    if(PmpPlugin_ports_0_hits_8)begin
      _zz_51__8 = (_zz_51__7 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__7 = _zz_51__6;
    if(PmpPlugin_ports_0_hits_7)begin
      _zz_51__7 = (_zz_51__6 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__6 = _zz_51__5;
    if(PmpPlugin_ports_0_hits_6)begin
      _zz_51__6 = (_zz_51__5 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__5 = _zz_51__4;
    if(PmpPlugin_ports_0_hits_5)begin
      _zz_51__5 = (_zz_51__4 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__4 = _zz_51__3;
    if(PmpPlugin_ports_0_hits_4)begin
      _zz_51__4 = (_zz_51__3 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__3 = _zz_51__2;
    if(PmpPlugin_ports_0_hits_3)begin
      _zz_51__3 = (_zz_51__2 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__2 = _zz_51__1;
    if(PmpPlugin_ports_0_hits_2)begin
      _zz_51__2 = (_zz_51__1 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__1 = _zz_51__0;
    if(PmpPlugin_ports_0_hits_1)begin
      _zz_51__1 = (_zz_51__0 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_51__0 = 5'h0;
    if(PmpPlugin_ports_0_hits_0)begin
      _zz_51__0 = (5'h0 + 5'h01);
    end
  end

  always @ (*) begin
    _zz_52_ = writeBack_REGFILE_WRITE_DATA;
    if((writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE))begin
      _zz_52_ = writeBack_DBusCachedPlugin_rspFormated;
    end
    if((writeBack_arbitration_isValid && writeBack_IS_MUL))begin
      case(_zz_642_)
        2'b00 : begin
          _zz_52_ = _zz_765_;
        end
        default : begin
          _zz_52_ = _zz_766_;
        end
      endcase
    end
  end

  assign writeBack_MEMORY_ADDRESS_LOW = memory_to_writeBack_MEMORY_ADDRESS_LOW;
  assign writeBack_MEMORY_WR = memory_to_writeBack_MEMORY_WR;
  assign writeBack_REGFILE_WRITE_DATA = memory_to_writeBack_REGFILE_WRITE_DATA;
  assign writeBack_MEMORY_ENABLE = memory_to_writeBack_MEMORY_ENABLE;
  assign memory_REGFILE_WRITE_DATA = execute_to_memory_REGFILE_WRITE_DATA;
  assign memory_MEMORY_ENABLE = execute_to_memory_MEMORY_ENABLE;
  assign execute_MEMORY_MANAGMENT = decode_to_execute_MEMORY_MANAGMENT;
  assign execute_RS2 = decode_to_execute_RS2;
  assign execute_MEMORY_WR = decode_to_execute_MEMORY_WR;
  assign execute_SRC_ADD = execute_SrcPlugin_addSub;
  assign execute_MEMORY_ENABLE = decode_to_execute_MEMORY_ENABLE;
  assign execute_INSTRUCTION = decode_to_execute_INSTRUCTION;
  assign decode_MEMORY_ENABLE = _zz_670_[0];
  assign decode_FLUSH_ALL = _zz_671_[0];
  always @ (*) begin
    _zz_53_ = _zz_53__2;
    if(_zz_594_)begin
      _zz_53_ = 1'b1;
    end
  end

  always @ (*) begin
    _zz_53__2 = _zz_53__1;
    if(_zz_595_)begin
      _zz_53__2 = 1'b1;
    end
  end

  always @ (*) begin
    _zz_53__1 = _zz_53__0;
    if(_zz_596_)begin
      _zz_53__1 = 1'b1;
    end
  end

  always @ (*) begin
    _zz_53__0 = IBusCachedPlugin_rsp_issueDetected;
    if(_zz_597_)begin
      _zz_53__0 = 1'b1;
    end
  end

  assign decode_BRANCH_CTRL = _zz_54_;
  assign decode_INSTRUCTION = IBusCachedPlugin_iBusRsp_output_payload_rsp_inst;
  always @ (*) begin
    _zz_55_ = memory_FORMAL_PC_NEXT;
    if(BranchPlugin_jumpInterface_valid)begin
      _zz_55_ = BranchPlugin_jumpInterface_payload;
    end
  end

  always @ (*) begin
    _zz_56_ = decode_FORMAL_PC_NEXT;
    if(IBusCachedPlugin_predictionJumpInterface_valid)begin
      _zz_56_ = IBusCachedPlugin_predictionJumpInterface_payload;
    end
  end

  assign decode_PC = IBusCachedPlugin_iBusRsp_output_payload_pc;
  assign writeBack_PC = memory_to_writeBack_PC;
  assign writeBack_INSTRUCTION = memory_to_writeBack_INSTRUCTION;
  always @ (*) begin
    decode_arbitration_haltItself = 1'b0;
    if(((DBusCachedPlugin_mmuBus_busy && decode_arbitration_isValid) && decode_MEMORY_ENABLE))begin
      decode_arbitration_haltItself = 1'b1;
    end
  end

  always @ (*) begin
    decode_arbitration_haltByOther = 1'b0;
    if((decode_arbitration_isValid && (_zz_469_ || _zz_470_)))begin
      decode_arbitration_haltByOther = 1'b1;
    end
    if(CsrPlugin_pipelineLiberator_active)begin
      decode_arbitration_haltByOther = 1'b1;
    end
    if(({(writeBack_arbitration_isValid && (writeBack_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET)),{(memory_arbitration_isValid && (memory_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET)),(execute_arbitration_isValid && (execute_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET))}} != (3'b000)))begin
      decode_arbitration_haltByOther = 1'b1;
    end
  end

  always @ (*) begin
    decode_arbitration_removeIt = 1'b0;
    if(_zz_598_)begin
      decode_arbitration_removeIt = 1'b1;
    end
    if(decode_arbitration_isFlushed)begin
      decode_arbitration_removeIt = 1'b1;
    end
  end

  assign decode_arbitration_flushIt = 1'b0;
  always @ (*) begin
    decode_arbitration_flushNext = 1'b0;
    if(IBusCachedPlugin_predictionJumpInterface_valid)begin
      decode_arbitration_flushNext = 1'b1;
    end
    if(_zz_598_)begin
      decode_arbitration_flushNext = 1'b1;
    end
  end

  always @ (*) begin
    execute_arbitration_haltItself = 1'b0;
    if((_zz_577_ && (! dataCache_1__io_cpu_flush_ready)))begin
      execute_arbitration_haltItself = 1'b1;
    end
    if(((dataCache_1__io_cpu_redo && execute_arbitration_isValid) && execute_MEMORY_ENABLE))begin
      execute_arbitration_haltItself = 1'b1;
    end
    if(_zz_599_)begin
      if((! execute_CsrPlugin_wfiWake))begin
        execute_arbitration_haltItself = 1'b1;
      end
    end
    if(_zz_588_)begin
      if(execute_CsrPlugin_blockedBySideEffects)begin
        execute_arbitration_haltItself = 1'b1;
      end
    end
  end

  assign execute_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    execute_arbitration_removeIt = 1'b0;
    if(CsrPlugin_selfException_valid)begin
      execute_arbitration_removeIt = 1'b1;
    end
    if(execute_arbitration_isFlushed)begin
      execute_arbitration_removeIt = 1'b1;
    end
  end

  assign execute_arbitration_flushIt = 1'b0;
  always @ (*) begin
    execute_arbitration_flushNext = 1'b0;
    if(CsrPlugin_selfException_valid)begin
      execute_arbitration_flushNext = 1'b1;
    end
  end

  always @ (*) begin
    memory_arbitration_haltItself = 1'b0;
    if(_zz_593_)begin
      if(((! memory_DivPlugin_frontendOk) || (! memory_DivPlugin_div_done)))begin
        memory_arbitration_haltItself = 1'b1;
      end
    end
  end

  assign memory_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    memory_arbitration_removeIt = 1'b0;
    if(BranchPlugin_branchExceptionPort_valid)begin
      memory_arbitration_removeIt = 1'b1;
    end
    if(memory_arbitration_isFlushed)begin
      memory_arbitration_removeIt = 1'b1;
    end
  end

  assign memory_arbitration_flushIt = 1'b0;
  always @ (*) begin
    memory_arbitration_flushNext = 1'b0;
    if(BranchPlugin_jumpInterface_valid)begin
      memory_arbitration_flushNext = 1'b1;
    end
    if(BranchPlugin_branchExceptionPort_valid)begin
      memory_arbitration_flushNext = 1'b1;
    end
  end

  always @ (*) begin
    writeBack_arbitration_haltItself = 1'b0;
    if(dataCache_1__io_cpu_writeBack_haltIt)begin
      writeBack_arbitration_haltItself = 1'b1;
    end
  end

  assign writeBack_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    writeBack_arbitration_removeIt = 1'b0;
    if(DBusCachedPlugin_exceptionBus_valid)begin
      writeBack_arbitration_removeIt = 1'b1;
    end
    if(writeBack_arbitration_isFlushed)begin
      writeBack_arbitration_removeIt = 1'b1;
    end
  end

  always @ (*) begin
    writeBack_arbitration_flushIt = 1'b0;
    if(DBusCachedPlugin_redoBranch_valid)begin
      writeBack_arbitration_flushIt = 1'b1;
    end
  end

  always @ (*) begin
    writeBack_arbitration_flushNext = 1'b0;
    if(DBusCachedPlugin_redoBranch_valid)begin
      writeBack_arbitration_flushNext = 1'b1;
    end
    if(DBusCachedPlugin_exceptionBus_valid)begin
      writeBack_arbitration_flushNext = 1'b1;
    end
    if(_zz_600_)begin
      writeBack_arbitration_flushNext = 1'b1;
    end
    if(_zz_601_)begin
      writeBack_arbitration_flushNext = 1'b1;
    end
  end

  assign lastStageInstruction = writeBack_INSTRUCTION;
  assign lastStagePc = writeBack_PC;
  assign lastStageIsValid = writeBack_arbitration_isValid;
  assign lastStageIsFiring = writeBack_arbitration_isFiring;
  always @ (*) begin
    IBusCachedPlugin_fetcherHalt = 1'b0;
    if(({CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack,{CsrPlugin_exceptionPortCtrl_exceptionValids_memory,{CsrPlugin_exceptionPortCtrl_exceptionValids_execute,CsrPlugin_exceptionPortCtrl_exceptionValids_decode}}} != (4'b0000)))begin
      IBusCachedPlugin_fetcherHalt = 1'b1;
    end
    if(_zz_600_)begin
      IBusCachedPlugin_fetcherHalt = 1'b1;
    end
    if(_zz_601_)begin
      IBusCachedPlugin_fetcherHalt = 1'b1;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_incomingInstruction = 1'b0;
    if((IBusCachedPlugin_iBusRsp_stages_1_input_valid || IBusCachedPlugin_iBusRsp_stages_2_input_valid))begin
      IBusCachedPlugin_incomingInstruction = 1'b1;
    end
  end

  always @ (*) begin
    CsrPlugin_inWfi = 1'b0;
    if(_zz_599_)begin
      CsrPlugin_inWfi = 1'b1;
    end
  end

  assign CsrPlugin_thirdPartyWake = 1'b0;
  always @ (*) begin
    CsrPlugin_jumpInterface_valid = 1'b0;
    if(_zz_600_)begin
      CsrPlugin_jumpInterface_valid = 1'b1;
    end
    if(_zz_601_)begin
      CsrPlugin_jumpInterface_valid = 1'b1;
    end
  end

  always @ (*) begin
    CsrPlugin_jumpInterface_payload = 32'h0;
    if(_zz_600_)begin
      CsrPlugin_jumpInterface_payload = {CsrPlugin_xtvec_base,(2'b00)};
    end
    if(_zz_601_)begin
      case(_zz_602_)
        2'b11 : begin
          CsrPlugin_jumpInterface_payload = CsrPlugin_mepc;
        end
        default : begin
        end
      endcase
    end
  end

  assign CsrPlugin_forceMachineWire = 1'b0;
  assign CsrPlugin_allowInterrupts = 1'b1;
  assign CsrPlugin_allowException = 1'b1;
  assign IBusCachedPlugin_externalFlush = ({writeBack_arbitration_flushNext,{memory_arbitration_flushNext,{execute_arbitration_flushNext,decode_arbitration_flushNext}}} != (4'b0000));
  assign IBusCachedPlugin_jump_pcLoad_valid = ({CsrPlugin_jumpInterface_valid,{BranchPlugin_jumpInterface_valid,{DBusCachedPlugin_redoBranch_valid,IBusCachedPlugin_predictionJumpInterface_valid}}} != (4'b0000));
  assign _zz_57_ = {IBusCachedPlugin_predictionJumpInterface_valid,{BranchPlugin_jumpInterface_valid,{CsrPlugin_jumpInterface_valid,DBusCachedPlugin_redoBranch_valid}}};
  assign _zz_58_ = (_zz_57_ & (~ _zz_672_));
  assign _zz_59_ = _zz_58_[3];
  assign _zz_60_ = (_zz_58_[1] || _zz_59_);
  assign _zz_61_ = (_zz_58_[2] || _zz_59_);
  assign IBusCachedPlugin_jump_pcLoad_payload = _zz_581_;
  always @ (*) begin
    IBusCachedPlugin_fetchPc_correction = 1'b0;
    if(IBusCachedPlugin_fetchPc_redo_valid)begin
      IBusCachedPlugin_fetchPc_correction = 1'b1;
    end
    if(IBusCachedPlugin_jump_pcLoad_valid)begin
      IBusCachedPlugin_fetchPc_correction = 1'b1;
    end
  end

  assign IBusCachedPlugin_fetchPc_corrected = (IBusCachedPlugin_fetchPc_correction || IBusCachedPlugin_fetchPc_correctionReg);
  always @ (*) begin
    IBusCachedPlugin_fetchPc_pcRegPropagate = 1'b0;
    if(IBusCachedPlugin_iBusRsp_stages_1_input_ready)begin
      IBusCachedPlugin_fetchPc_pcRegPropagate = 1'b1;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_fetchPc_pc = (IBusCachedPlugin_fetchPc_pcReg + _zz_674_);
    if(IBusCachedPlugin_fetchPc_redo_valid)begin
      IBusCachedPlugin_fetchPc_pc = IBusCachedPlugin_fetchPc_redo_payload;
    end
    if(IBusCachedPlugin_jump_pcLoad_valid)begin
      IBusCachedPlugin_fetchPc_pc = IBusCachedPlugin_jump_pcLoad_payload;
    end
    IBusCachedPlugin_fetchPc_pc[0] = 1'b0;
    IBusCachedPlugin_fetchPc_pc[1] = 1'b0;
  end

  always @ (*) begin
    IBusCachedPlugin_fetchPc_flushed = 1'b0;
    if(IBusCachedPlugin_fetchPc_redo_valid)begin
      IBusCachedPlugin_fetchPc_flushed = 1'b1;
    end
    if(IBusCachedPlugin_jump_pcLoad_valid)begin
      IBusCachedPlugin_fetchPc_flushed = 1'b1;
    end
  end

  assign IBusCachedPlugin_fetchPc_output_valid = ((! IBusCachedPlugin_fetcherHalt) && IBusCachedPlugin_fetchPc_booted);
  assign IBusCachedPlugin_fetchPc_output_payload = IBusCachedPlugin_fetchPc_pc;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_redoFetch = 1'b0;
    if(IBusCachedPlugin_rsp_redoFetch)begin
      IBusCachedPlugin_iBusRsp_redoFetch = 1'b1;
    end
  end

  assign IBusCachedPlugin_iBusRsp_stages_0_input_valid = IBusCachedPlugin_fetchPc_output_valid;
  assign IBusCachedPlugin_fetchPc_output_ready = IBusCachedPlugin_iBusRsp_stages_0_input_ready;
  assign IBusCachedPlugin_iBusRsp_stages_0_input_payload = IBusCachedPlugin_fetchPc_output_payload;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_stages_0_halt = 1'b0;
    if(IBusCachedPlugin_cache_io_cpu_prefetch_haltIt)begin
      IBusCachedPlugin_iBusRsp_stages_0_halt = 1'b1;
    end
  end

  assign _zz_62_ = (! IBusCachedPlugin_iBusRsp_stages_0_halt);
  assign IBusCachedPlugin_iBusRsp_stages_0_input_ready = (IBusCachedPlugin_iBusRsp_stages_0_output_ready && _zz_62_);
  assign IBusCachedPlugin_iBusRsp_stages_0_output_valid = (IBusCachedPlugin_iBusRsp_stages_0_input_valid && _zz_62_);
  assign IBusCachedPlugin_iBusRsp_stages_0_output_payload = IBusCachedPlugin_iBusRsp_stages_0_input_payload;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_stages_1_halt = 1'b0;
    if(IBusCachedPlugin_cache_io_cpu_fetch_haltIt)begin
      IBusCachedPlugin_iBusRsp_stages_1_halt = 1'b1;
    end
  end

  assign _zz_63_ = (! IBusCachedPlugin_iBusRsp_stages_1_halt);
  assign IBusCachedPlugin_iBusRsp_stages_1_input_ready = (IBusCachedPlugin_iBusRsp_stages_1_output_ready && _zz_63_);
  assign IBusCachedPlugin_iBusRsp_stages_1_output_valid = (IBusCachedPlugin_iBusRsp_stages_1_input_valid && _zz_63_);
  assign IBusCachedPlugin_iBusRsp_stages_1_output_payload = IBusCachedPlugin_iBusRsp_stages_1_input_payload;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_stages_2_halt = 1'b0;
    if((_zz_53_ || IBusCachedPlugin_rsp_iBusRspOutputHalt))begin
      IBusCachedPlugin_iBusRsp_stages_2_halt = 1'b1;
    end
  end

  assign _zz_64_ = (! IBusCachedPlugin_iBusRsp_stages_2_halt);
  assign IBusCachedPlugin_iBusRsp_stages_2_input_ready = (IBusCachedPlugin_iBusRsp_stages_2_output_ready && _zz_64_);
  assign IBusCachedPlugin_iBusRsp_stages_2_output_valid = (IBusCachedPlugin_iBusRsp_stages_2_input_valid && _zz_64_);
  assign IBusCachedPlugin_iBusRsp_stages_2_output_payload = IBusCachedPlugin_iBusRsp_stages_2_input_payload;
  assign IBusCachedPlugin_fetchPc_redo_valid = IBusCachedPlugin_iBusRsp_redoFetch;
  assign IBusCachedPlugin_fetchPc_redo_payload = IBusCachedPlugin_iBusRsp_stages_2_input_payload;
  assign IBusCachedPlugin_iBusRsp_flush = ((decode_arbitration_removeIt || (decode_arbitration_flushNext && (! decode_arbitration_isStuck))) || IBusCachedPlugin_iBusRsp_redoFetch);
  assign IBusCachedPlugin_iBusRsp_stages_0_output_ready = _zz_65_;
  assign _zz_65_ = ((1'b0 && (! _zz_66_)) || IBusCachedPlugin_iBusRsp_stages_1_input_ready);
  assign _zz_66_ = _zz_67_;
  assign IBusCachedPlugin_iBusRsp_stages_1_input_valid = _zz_66_;
  assign IBusCachedPlugin_iBusRsp_stages_1_input_payload = IBusCachedPlugin_fetchPc_pcReg;
  assign IBusCachedPlugin_iBusRsp_stages_1_output_ready = ((1'b0 && (! _zz_68_)) || IBusCachedPlugin_iBusRsp_stages_2_input_ready);
  assign _zz_68_ = _zz_69_;
  assign IBusCachedPlugin_iBusRsp_stages_2_input_valid = _zz_68_;
  assign IBusCachedPlugin_iBusRsp_stages_2_input_payload = _zz_70_;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_readyForError = 1'b1;
    if((! IBusCachedPlugin_pcValids_0))begin
      IBusCachedPlugin_iBusRsp_readyForError = 1'b0;
    end
  end

  assign IBusCachedPlugin_pcValids_0 = IBusCachedPlugin_injector_nextPcCalc_valids_1;
  assign IBusCachedPlugin_pcValids_1 = IBusCachedPlugin_injector_nextPcCalc_valids_2;
  assign IBusCachedPlugin_pcValids_2 = IBusCachedPlugin_injector_nextPcCalc_valids_3;
  assign IBusCachedPlugin_pcValids_3 = IBusCachedPlugin_injector_nextPcCalc_valids_4;
  assign IBusCachedPlugin_iBusRsp_output_ready = (! decode_arbitration_isStuck);
  assign decode_arbitration_isValid = IBusCachedPlugin_iBusRsp_output_valid;
  assign _zz_71_ = _zz_675_[11];
  always @ (*) begin
    _zz_72_[18] = _zz_71_;
    _zz_72_[17] = _zz_71_;
    _zz_72_[16] = _zz_71_;
    _zz_72_[15] = _zz_71_;
    _zz_72_[14] = _zz_71_;
    _zz_72_[13] = _zz_71_;
    _zz_72_[12] = _zz_71_;
    _zz_72_[11] = _zz_71_;
    _zz_72_[10] = _zz_71_;
    _zz_72_[9] = _zz_71_;
    _zz_72_[8] = _zz_71_;
    _zz_72_[7] = _zz_71_;
    _zz_72_[6] = _zz_71_;
    _zz_72_[5] = _zz_71_;
    _zz_72_[4] = _zz_71_;
    _zz_72_[3] = _zz_71_;
    _zz_72_[2] = _zz_71_;
    _zz_72_[1] = _zz_71_;
    _zz_72_[0] = _zz_71_;
  end

  always @ (*) begin
    IBusCachedPlugin_decodePrediction_cmd_hadBranch = ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) || ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_B) && _zz_676_[31]));
    if(_zz_77_)begin
      IBusCachedPlugin_decodePrediction_cmd_hadBranch = 1'b0;
    end
  end

  assign _zz_73_ = _zz_677_[19];
  always @ (*) begin
    _zz_74_[10] = _zz_73_;
    _zz_74_[9] = _zz_73_;
    _zz_74_[8] = _zz_73_;
    _zz_74_[7] = _zz_73_;
    _zz_74_[6] = _zz_73_;
    _zz_74_[5] = _zz_73_;
    _zz_74_[4] = _zz_73_;
    _zz_74_[3] = _zz_73_;
    _zz_74_[2] = _zz_73_;
    _zz_74_[1] = _zz_73_;
    _zz_74_[0] = _zz_73_;
  end

  assign _zz_75_ = _zz_678_[11];
  always @ (*) begin
    _zz_76_[18] = _zz_75_;
    _zz_76_[17] = _zz_75_;
    _zz_76_[16] = _zz_75_;
    _zz_76_[15] = _zz_75_;
    _zz_76_[14] = _zz_75_;
    _zz_76_[13] = _zz_75_;
    _zz_76_[12] = _zz_75_;
    _zz_76_[11] = _zz_75_;
    _zz_76_[10] = _zz_75_;
    _zz_76_[9] = _zz_75_;
    _zz_76_[8] = _zz_75_;
    _zz_76_[7] = _zz_75_;
    _zz_76_[6] = _zz_75_;
    _zz_76_[5] = _zz_75_;
    _zz_76_[4] = _zz_75_;
    _zz_76_[3] = _zz_75_;
    _zz_76_[2] = _zz_75_;
    _zz_76_[1] = _zz_75_;
    _zz_76_[0] = _zz_75_;
  end

  always @ (*) begin
    case(decode_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_77_ = _zz_679_[1];
      end
      default : begin
        _zz_77_ = _zz_680_[1];
      end
    endcase
  end

  assign IBusCachedPlugin_predictionJumpInterface_valid = (decode_arbitration_isValid && IBusCachedPlugin_decodePrediction_cmd_hadBranch);
  assign _zz_78_ = _zz_681_[19];
  always @ (*) begin
    _zz_79_[10] = _zz_78_;
    _zz_79_[9] = _zz_78_;
    _zz_79_[8] = _zz_78_;
    _zz_79_[7] = _zz_78_;
    _zz_79_[6] = _zz_78_;
    _zz_79_[5] = _zz_78_;
    _zz_79_[4] = _zz_78_;
    _zz_79_[3] = _zz_78_;
    _zz_79_[2] = _zz_78_;
    _zz_79_[1] = _zz_78_;
    _zz_79_[0] = _zz_78_;
  end

  assign _zz_80_ = _zz_682_[11];
  always @ (*) begin
    _zz_81_[18] = _zz_80_;
    _zz_81_[17] = _zz_80_;
    _zz_81_[16] = _zz_80_;
    _zz_81_[15] = _zz_80_;
    _zz_81_[14] = _zz_80_;
    _zz_81_[13] = _zz_80_;
    _zz_81_[12] = _zz_80_;
    _zz_81_[11] = _zz_80_;
    _zz_81_[10] = _zz_80_;
    _zz_81_[9] = _zz_80_;
    _zz_81_[8] = _zz_80_;
    _zz_81_[7] = _zz_80_;
    _zz_81_[6] = _zz_80_;
    _zz_81_[5] = _zz_80_;
    _zz_81_[4] = _zz_80_;
    _zz_81_[3] = _zz_80_;
    _zz_81_[2] = _zz_80_;
    _zz_81_[1] = _zz_80_;
    _zz_81_[0] = _zz_80_;
  end

  assign IBusCachedPlugin_predictionJumpInterface_payload = (decode_PC + ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) ? {{_zz_79_,{{{_zz_881_,decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]}},1'b0} : {{_zz_81_,{{{_zz_882_,_zz_883_},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0}));
  assign iBus_cmd_valid = IBusCachedPlugin_cache_io_mem_cmd_valid;
  always @ (*) begin
    iBus_cmd_payload_address = IBusCachedPlugin_cache_io_mem_cmd_payload_address;
    iBus_cmd_payload_address = IBusCachedPlugin_cache_io_mem_cmd_payload_address;
  end

  assign iBus_cmd_payload_size = IBusCachedPlugin_cache_io_mem_cmd_payload_size;
  assign IBusCachedPlugin_s0_tightlyCoupledHit = 1'b0;
  assign _zz_562_ = (IBusCachedPlugin_iBusRsp_stages_0_input_valid && (! IBusCachedPlugin_s0_tightlyCoupledHit));
  assign _zz_563_ = (IBusCachedPlugin_iBusRsp_stages_1_input_valid && (! IBusCachedPlugin_s1_tightlyCoupledHit));
  assign _zz_564_ = (! IBusCachedPlugin_iBusRsp_stages_1_input_ready);
  assign _zz_565_ = (IBusCachedPlugin_iBusRsp_stages_2_input_valid && (! IBusCachedPlugin_s2_tightlyCoupledHit));
  assign _zz_566_ = (! IBusCachedPlugin_iBusRsp_stages_2_input_ready);
  assign _zz_567_ = (CsrPlugin_privilege == (2'b00));
  assign IBusCachedPlugin_rsp_iBusRspOutputHalt = 1'b0;
  assign IBusCachedPlugin_rsp_issueDetected = 1'b0;
  always @ (*) begin
    IBusCachedPlugin_rsp_redoFetch = 1'b0;
    if(_zz_597_)begin
      IBusCachedPlugin_rsp_redoFetch = 1'b1;
    end
    if(_zz_595_)begin
      IBusCachedPlugin_rsp_redoFetch = 1'b1;
    end
  end

  always @ (*) begin
    _zz_568_ = (IBusCachedPlugin_rsp_redoFetch && (! IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling));
    if(_zz_595_)begin
      _zz_568_ = 1'b1;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_decodeExceptionPort_valid = 1'b0;
    if(_zz_596_)begin
      IBusCachedPlugin_decodeExceptionPort_valid = IBusCachedPlugin_iBusRsp_readyForError;
    end
    if(_zz_594_)begin
      IBusCachedPlugin_decodeExceptionPort_valid = IBusCachedPlugin_iBusRsp_readyForError;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_decodeExceptionPort_payload_code = (4'bxxxx);
    if(_zz_596_)begin
      IBusCachedPlugin_decodeExceptionPort_payload_code = (4'b1100);
    end
    if(_zz_594_)begin
      IBusCachedPlugin_decodeExceptionPort_payload_code = (4'b0001);
    end
  end

  assign IBusCachedPlugin_decodeExceptionPort_payload_badAddr = {IBusCachedPlugin_iBusRsp_stages_2_input_payload[31 : 2],(2'b00)};
  assign IBusCachedPlugin_iBusRsp_output_valid = IBusCachedPlugin_iBusRsp_stages_2_output_valid;
  assign IBusCachedPlugin_iBusRsp_stages_2_output_ready = IBusCachedPlugin_iBusRsp_output_ready;
  assign IBusCachedPlugin_iBusRsp_output_payload_rsp_inst = IBusCachedPlugin_cache_io_cpu_decode_data;
  assign IBusCachedPlugin_iBusRsp_output_payload_pc = IBusCachedPlugin_iBusRsp_stages_2_output_payload;
  assign IBusCachedPlugin_mmuBus_cmd_isValid = IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_isValid;
  assign IBusCachedPlugin_mmuBus_cmd_virtualAddress = IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_virtualAddress;
  assign IBusCachedPlugin_mmuBus_cmd_bypassTranslation = IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_bypassTranslation;
  assign IBusCachedPlugin_mmuBus_end = IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_end;
  assign _zz_561_ = (decode_arbitration_isValid && decode_FLUSH_ALL);
  assign dataCache_1__io_mem_cmd_s2mPipe_valid = (dataCache_1__io_mem_cmd_valid || dataCache_1__io_mem_cmd_s2mPipe_rValid);
  assign _zz_578_ = (! dataCache_1__io_mem_cmd_s2mPipe_rValid);
  assign dataCache_1__io_mem_cmd_s2mPipe_payload_wr = (dataCache_1__io_mem_cmd_s2mPipe_rValid ? dataCache_1__io_mem_cmd_s2mPipe_rData_wr : dataCache_1__io_mem_cmd_payload_wr);
  assign dataCache_1__io_mem_cmd_s2mPipe_payload_address = (dataCache_1__io_mem_cmd_s2mPipe_rValid ? dataCache_1__io_mem_cmd_s2mPipe_rData_address : dataCache_1__io_mem_cmd_payload_address);
  assign dataCache_1__io_mem_cmd_s2mPipe_payload_data = (dataCache_1__io_mem_cmd_s2mPipe_rValid ? dataCache_1__io_mem_cmd_s2mPipe_rData_data : dataCache_1__io_mem_cmd_payload_data);
  assign dataCache_1__io_mem_cmd_s2mPipe_payload_mask = (dataCache_1__io_mem_cmd_s2mPipe_rValid ? dataCache_1__io_mem_cmd_s2mPipe_rData_mask : dataCache_1__io_mem_cmd_payload_mask);
  assign dataCache_1__io_mem_cmd_s2mPipe_payload_length = (dataCache_1__io_mem_cmd_s2mPipe_rValid ? dataCache_1__io_mem_cmd_s2mPipe_rData_length : dataCache_1__io_mem_cmd_payload_length);
  assign dataCache_1__io_mem_cmd_s2mPipe_payload_last = (dataCache_1__io_mem_cmd_s2mPipe_rValid ? dataCache_1__io_mem_cmd_s2mPipe_rData_last : dataCache_1__io_mem_cmd_payload_last);
  assign dataCache_1__io_mem_cmd_s2mPipe_ready = ((1'b1 && (! dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_valid)) || dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_ready);
  assign dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_valid = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rValid;
  assign dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_wr = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_wr;
  assign dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_address = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_address;
  assign dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_data = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_data;
  assign dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_mask = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_mask;
  assign dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_length = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_length;
  assign dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_last = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_last;
  assign dBus_cmd_valid = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_valid;
  assign dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_ready = dBus_cmd_ready;
  assign dBus_cmd_payload_wr = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_wr;
  assign dBus_cmd_payload_address = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_address;
  assign dBus_cmd_payload_data = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_data;
  assign dBus_cmd_payload_mask = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_mask;
  assign dBus_cmd_payload_length = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_length;
  assign dBus_cmd_payload_last = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_last;
  assign execute_DBusCachedPlugin_size = execute_INSTRUCTION[13 : 12];
  assign _zz_569_ = (execute_arbitration_isValid && execute_MEMORY_ENABLE);
  assign _zz_570_ = execute_SRC_ADD;
  always @ (*) begin
    case(execute_DBusCachedPlugin_size)
      2'b00 : begin
        _zz_84_ = {{{execute_RS2[7 : 0],execute_RS2[7 : 0]},execute_RS2[7 : 0]},execute_RS2[7 : 0]};
      end
      2'b01 : begin
        _zz_84_ = {execute_RS2[15 : 0],execute_RS2[15 : 0]};
      end
      default : begin
        _zz_84_ = execute_RS2[31 : 0];
      end
    endcase
  end

  assign _zz_577_ = (execute_arbitration_isValid && execute_MEMORY_MANAGMENT);
  assign _zz_571_ = (memory_arbitration_isValid && memory_MEMORY_ENABLE);
  assign _zz_572_ = memory_REGFILE_WRITE_DATA;
  assign DBusCachedPlugin_mmuBus_cmd_isValid = dataCache_1__io_cpu_memory_mmuBus_cmd_isValid;
  assign DBusCachedPlugin_mmuBus_cmd_virtualAddress = dataCache_1__io_cpu_memory_mmuBus_cmd_virtualAddress;
  assign DBusCachedPlugin_mmuBus_cmd_bypassTranslation = dataCache_1__io_cpu_memory_mmuBus_cmd_bypassTranslation;
  always @ (*) begin
    _zz_573_ = DBusCachedPlugin_mmuBus_rsp_isIoAccess;
    if((1'b0 && (! dataCache_1__io_cpu_memory_isWrite)))begin
      _zz_573_ = 1'b1;
    end
  end

  assign DBusCachedPlugin_mmuBus_end = dataCache_1__io_cpu_memory_mmuBus_end;
  assign _zz_574_ = (writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE);
  assign _zz_575_ = (CsrPlugin_privilege == (2'b00));
  assign _zz_576_ = writeBack_REGFILE_WRITE_DATA;
  always @ (*) begin
    DBusCachedPlugin_redoBranch_valid = 1'b0;
    if(_zz_603_)begin
      if(dataCache_1__io_cpu_redo)begin
        DBusCachedPlugin_redoBranch_valid = 1'b1;
      end
    end
  end

  assign DBusCachedPlugin_redoBranch_payload = writeBack_PC;
  always @ (*) begin
    DBusCachedPlugin_exceptionBus_valid = 1'b0;
    if(_zz_603_)begin
      if(dataCache_1__io_cpu_writeBack_accessError)begin
        DBusCachedPlugin_exceptionBus_valid = 1'b1;
      end
      if(dataCache_1__io_cpu_writeBack_unalignedAccess)begin
        DBusCachedPlugin_exceptionBus_valid = 1'b1;
      end
      if(dataCache_1__io_cpu_writeBack_mmuException)begin
        DBusCachedPlugin_exceptionBus_valid = 1'b1;
      end
      if(dataCache_1__io_cpu_redo)begin
        DBusCachedPlugin_exceptionBus_valid = 1'b0;
      end
    end
  end

  assign DBusCachedPlugin_exceptionBus_payload_badAddr = writeBack_REGFILE_WRITE_DATA;
  always @ (*) begin
    DBusCachedPlugin_exceptionBus_payload_code = (4'bxxxx);
    if(_zz_603_)begin
      if(dataCache_1__io_cpu_writeBack_accessError)begin
        DBusCachedPlugin_exceptionBus_payload_code = {1'd0, _zz_683_};
      end
      if(dataCache_1__io_cpu_writeBack_unalignedAccess)begin
        DBusCachedPlugin_exceptionBus_payload_code = {1'd0, _zz_684_};
      end
      if(dataCache_1__io_cpu_writeBack_mmuException)begin
        DBusCachedPlugin_exceptionBus_payload_code = (writeBack_MEMORY_WR ? (4'b1111) : (4'b1101));
      end
    end
  end

  always @ (*) begin
    writeBack_DBusCachedPlugin_rspShifted = dataCache_1__io_cpu_writeBack_data;
    case(writeBack_MEMORY_ADDRESS_LOW)
      2'b01 : begin
        writeBack_DBusCachedPlugin_rspShifted[7 : 0] = dataCache_1__io_cpu_writeBack_data[15 : 8];
      end
      2'b10 : begin
        writeBack_DBusCachedPlugin_rspShifted[15 : 0] = dataCache_1__io_cpu_writeBack_data[31 : 16];
      end
      2'b11 : begin
        writeBack_DBusCachedPlugin_rspShifted[7 : 0] = dataCache_1__io_cpu_writeBack_data[31 : 24];
      end
      default : begin
      end
    endcase
  end

  assign _zz_85_ = (writeBack_DBusCachedPlugin_rspShifted[7] && (! writeBack_INSTRUCTION[14]));
  always @ (*) begin
    _zz_86_[31] = _zz_85_;
    _zz_86_[30] = _zz_85_;
    _zz_86_[29] = _zz_85_;
    _zz_86_[28] = _zz_85_;
    _zz_86_[27] = _zz_85_;
    _zz_86_[26] = _zz_85_;
    _zz_86_[25] = _zz_85_;
    _zz_86_[24] = _zz_85_;
    _zz_86_[23] = _zz_85_;
    _zz_86_[22] = _zz_85_;
    _zz_86_[21] = _zz_85_;
    _zz_86_[20] = _zz_85_;
    _zz_86_[19] = _zz_85_;
    _zz_86_[18] = _zz_85_;
    _zz_86_[17] = _zz_85_;
    _zz_86_[16] = _zz_85_;
    _zz_86_[15] = _zz_85_;
    _zz_86_[14] = _zz_85_;
    _zz_86_[13] = _zz_85_;
    _zz_86_[12] = _zz_85_;
    _zz_86_[11] = _zz_85_;
    _zz_86_[10] = _zz_85_;
    _zz_86_[9] = _zz_85_;
    _zz_86_[8] = _zz_85_;
    _zz_86_[7 : 0] = writeBack_DBusCachedPlugin_rspShifted[7 : 0];
  end

  assign _zz_87_ = (writeBack_DBusCachedPlugin_rspShifted[15] && (! writeBack_INSTRUCTION[14]));
  always @ (*) begin
    _zz_88_[31] = _zz_87_;
    _zz_88_[30] = _zz_87_;
    _zz_88_[29] = _zz_87_;
    _zz_88_[28] = _zz_87_;
    _zz_88_[27] = _zz_87_;
    _zz_88_[26] = _zz_87_;
    _zz_88_[25] = _zz_87_;
    _zz_88_[24] = _zz_87_;
    _zz_88_[23] = _zz_87_;
    _zz_88_[22] = _zz_87_;
    _zz_88_[21] = _zz_87_;
    _zz_88_[20] = _zz_87_;
    _zz_88_[19] = _zz_87_;
    _zz_88_[18] = _zz_87_;
    _zz_88_[17] = _zz_87_;
    _zz_88_[16] = _zz_87_;
    _zz_88_[15 : 0] = writeBack_DBusCachedPlugin_rspShifted[15 : 0];
  end

  always @ (*) begin
    case(_zz_640_)
      2'b00 : begin
        writeBack_DBusCachedPlugin_rspFormated = _zz_86_;
      end
      2'b01 : begin
        writeBack_DBusCachedPlugin_rspFormated = _zz_88_;
      end
      default : begin
        writeBack_DBusCachedPlugin_rspFormated = writeBack_DBusCachedPlugin_rspShifted;
      end
    endcase
  end

  assign _zz_102_ = (_zz_94_ <<< 2);
  assign _zz_103_ = (_zz_94_ & (~ _zz_685_));
  assign _zz_104_ = ((_zz_94_ & (~ _zz_103_)) <<< 2);
  assign _zz_118_ = (_zz_110_ <<< 2);
  assign _zz_119_ = (_zz_110_ & (~ _zz_688_));
  assign _zz_120_ = ((_zz_110_ & (~ _zz_119_)) <<< 2);
  assign _zz_134_ = (_zz_126_ <<< 2);
  assign _zz_135_ = (_zz_126_ & (~ _zz_691_));
  assign _zz_136_ = ((_zz_126_ & (~ _zz_135_)) <<< 2);
  assign _zz_150_ = (_zz_142_ <<< 2);
  assign _zz_151_ = (_zz_142_ & (~ _zz_694_));
  assign _zz_152_ = ((_zz_142_ & (~ _zz_151_)) <<< 2);
  assign _zz_166_ = (_zz_158_ <<< 2);
  assign _zz_167_ = (_zz_158_ & (~ _zz_697_));
  assign _zz_168_ = ((_zz_158_ & (~ _zz_167_)) <<< 2);
  assign _zz_182_ = (_zz_174_ <<< 2);
  assign _zz_183_ = (_zz_174_ & (~ _zz_700_));
  assign _zz_184_ = ((_zz_174_ & (~ _zz_183_)) <<< 2);
  assign _zz_198_ = (_zz_190_ <<< 2);
  assign _zz_199_ = (_zz_190_ & (~ _zz_703_));
  assign _zz_200_ = ((_zz_190_ & (~ _zz_199_)) <<< 2);
  assign _zz_214_ = (_zz_206_ <<< 2);
  assign _zz_215_ = (_zz_206_ & (~ _zz_706_));
  assign _zz_216_ = ((_zz_206_ & (~ _zz_215_)) <<< 2);
  assign _zz_230_ = (_zz_222_ <<< 2);
  assign _zz_231_ = (_zz_222_ & (~ _zz_709_));
  assign _zz_232_ = ((_zz_222_ & (~ _zz_231_)) <<< 2);
  assign _zz_246_ = (_zz_238_ <<< 2);
  assign _zz_247_ = (_zz_238_ & (~ _zz_712_));
  assign _zz_248_ = ((_zz_238_ & (~ _zz_247_)) <<< 2);
  assign _zz_262_ = (_zz_254_ <<< 2);
  assign _zz_263_ = (_zz_254_ & (~ _zz_715_));
  assign _zz_264_ = ((_zz_254_ & (~ _zz_263_)) <<< 2);
  assign _zz_278_ = (_zz_270_ <<< 2);
  assign _zz_279_ = (_zz_270_ & (~ _zz_718_));
  assign _zz_280_ = ((_zz_270_ & (~ _zz_279_)) <<< 2);
  assign _zz_294_ = (_zz_286_ <<< 2);
  assign _zz_295_ = (_zz_286_ & (~ _zz_721_));
  assign _zz_296_ = ((_zz_286_ & (~ _zz_295_)) <<< 2);
  assign _zz_310_ = (_zz_302_ <<< 2);
  assign _zz_311_ = (_zz_302_ & (~ _zz_724_));
  assign _zz_312_ = ((_zz_302_ & (~ _zz_311_)) <<< 2);
  assign _zz_326_ = (_zz_318_ <<< 2);
  assign _zz_327_ = (_zz_318_ & (~ _zz_727_));
  assign _zz_328_ = ((_zz_318_ & (~ _zz_327_)) <<< 2);
  assign _zz_342_ = (_zz_334_ <<< 2);
  assign _zz_343_ = (_zz_334_ & (~ _zz_730_));
  assign _zz_344_ = ((_zz_334_ & (~ _zz_343_)) <<< 2);
  assign IBusCachedPlugin_mmuBus_rsp_physicalAddress = IBusCachedPlugin_mmuBus_cmd_virtualAddress;
  assign PmpPlugin_ports_0_hits_0 = (((_zz_99_ && (_zz_100_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_101_)) && (_zz_98_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_1 = (((_zz_115_ && (_zz_116_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_117_)) && (_zz_114_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_2 = (((_zz_131_ && (_zz_132_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_133_)) && (_zz_130_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_3 = (((_zz_147_ && (_zz_148_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_149_)) && (_zz_146_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_4 = (((_zz_163_ && (_zz_164_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_165_)) && (_zz_162_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_5 = (((_zz_179_ && (_zz_180_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_181_)) && (_zz_178_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_6 = (((_zz_195_ && (_zz_196_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_197_)) && (_zz_194_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_7 = (((_zz_211_ && (_zz_212_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_213_)) && (_zz_210_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_8 = (((_zz_227_ && (_zz_228_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_229_)) && (_zz_226_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_9 = (((_zz_243_ && (_zz_244_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_245_)) && (_zz_242_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_10 = (((_zz_259_ && (_zz_260_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_261_)) && (_zz_258_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_11 = (((_zz_275_ && (_zz_276_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_277_)) && (_zz_274_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_12 = (((_zz_291_ && (_zz_292_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_293_)) && (_zz_290_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_13 = (((_zz_307_ && (_zz_308_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_309_)) && (_zz_306_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_14 = (((_zz_323_ && (_zz_324_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_325_)) && (_zz_322_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_0_hits_15 = (((_zz_339_ && (_zz_340_ <= IBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (IBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_341_)) && (_zz_338_ || (! (CsrPlugin_privilege == (2'b11)))));
  always @ (*) begin
    if(_zz_604_)begin
      IBusCachedPlugin_mmuBus_rsp_allowRead = (CsrPlugin_privilege == (2'b11));
    end else begin
      IBusCachedPlugin_mmuBus_rsp_allowRead = _zz_582_;
    end
  end

  always @ (*) begin
    if(_zz_604_)begin
      IBusCachedPlugin_mmuBus_rsp_allowWrite = (CsrPlugin_privilege == (2'b11));
    end else begin
      IBusCachedPlugin_mmuBus_rsp_allowWrite = _zz_583_;
    end
  end

  always @ (*) begin
    if(_zz_604_)begin
      IBusCachedPlugin_mmuBus_rsp_allowExecute = (CsrPlugin_privilege == (2'b11));
    end else begin
      IBusCachedPlugin_mmuBus_rsp_allowExecute = _zz_584_;
    end
  end

  assign _zz_345_ = {PmpPlugin_ports_0_hits_15,{PmpPlugin_ports_0_hits_14,{PmpPlugin_ports_0_hits_13,{PmpPlugin_ports_0_hits_12,{PmpPlugin_ports_0_hits_11,{PmpPlugin_ports_0_hits_10,{PmpPlugin_ports_0_hits_9,{PmpPlugin_ports_0_hits_8,{PmpPlugin_ports_0_hits_7,{PmpPlugin_ports_0_hits_6,{_zz_884_,_zz_885_}}}}}}}}}}};
  assign _zz_346_ = (_zz_345_ & (~ _zz_733_));
  assign _zz_347_ = _zz_346_[3];
  assign _zz_348_ = _zz_346_[5];
  assign _zz_349_ = _zz_346_[6];
  assign _zz_350_ = _zz_346_[7];
  assign _zz_351_ = _zz_346_[9];
  assign _zz_352_ = _zz_346_[10];
  assign _zz_353_ = _zz_346_[11];
  assign _zz_354_ = _zz_346_[12];
  assign _zz_355_ = _zz_346_[13];
  assign _zz_356_ = _zz_346_[14];
  assign _zz_357_ = _zz_346_[15];
  assign _zz_358_ = (((((((_zz_346_[1] || _zz_347_) || _zz_348_) || _zz_350_) || _zz_351_) || _zz_353_) || _zz_355_) || _zz_357_);
  assign _zz_359_ = (((((((_zz_346_[2] || _zz_347_) || _zz_349_) || _zz_350_) || _zz_352_) || _zz_353_) || _zz_356_) || _zz_357_);
  assign _zz_360_ = (((((((_zz_346_[4] || _zz_348_) || _zz_349_) || _zz_350_) || _zz_354_) || _zz_355_) || _zz_356_) || _zz_357_);
  assign _zz_361_ = (((((((_zz_346_[8] || _zz_351_) || _zz_352_) || _zz_353_) || _zz_354_) || _zz_355_) || _zz_356_) || _zz_357_);
  assign _zz_362_ = {PmpPlugin_ports_0_hits_15,{PmpPlugin_ports_0_hits_14,{PmpPlugin_ports_0_hits_13,{PmpPlugin_ports_0_hits_12,{PmpPlugin_ports_0_hits_11,{PmpPlugin_ports_0_hits_10,{PmpPlugin_ports_0_hits_9,{PmpPlugin_ports_0_hits_8,{PmpPlugin_ports_0_hits_7,{PmpPlugin_ports_0_hits_6,{_zz_886_,_zz_887_}}}}}}}}}}};
  assign _zz_363_ = (_zz_362_ & (~ _zz_734_));
  assign _zz_364_ = _zz_363_[3];
  assign _zz_365_ = _zz_363_[5];
  assign _zz_366_ = _zz_363_[6];
  assign _zz_367_ = _zz_363_[7];
  assign _zz_368_ = _zz_363_[9];
  assign _zz_369_ = _zz_363_[10];
  assign _zz_370_ = _zz_363_[11];
  assign _zz_371_ = _zz_363_[12];
  assign _zz_372_ = _zz_363_[13];
  assign _zz_373_ = _zz_363_[14];
  assign _zz_374_ = _zz_363_[15];
  assign _zz_375_ = (((((((_zz_363_[1] || _zz_364_) || _zz_365_) || _zz_367_) || _zz_368_) || _zz_370_) || _zz_372_) || _zz_374_);
  assign _zz_376_ = (((((((_zz_363_[2] || _zz_364_) || _zz_366_) || _zz_367_) || _zz_369_) || _zz_370_) || _zz_373_) || _zz_374_);
  assign _zz_377_ = (((((((_zz_363_[4] || _zz_365_) || _zz_366_) || _zz_367_) || _zz_371_) || _zz_372_) || _zz_373_) || _zz_374_);
  assign _zz_378_ = (((((((_zz_363_[8] || _zz_368_) || _zz_369_) || _zz_370_) || _zz_371_) || _zz_372_) || _zz_373_) || _zz_374_);
  assign _zz_379_ = {PmpPlugin_ports_0_hits_15,{PmpPlugin_ports_0_hits_14,{PmpPlugin_ports_0_hits_13,{PmpPlugin_ports_0_hits_12,{PmpPlugin_ports_0_hits_11,{PmpPlugin_ports_0_hits_10,{PmpPlugin_ports_0_hits_9,{PmpPlugin_ports_0_hits_8,{PmpPlugin_ports_0_hits_7,{PmpPlugin_ports_0_hits_6,{_zz_888_,_zz_889_}}}}}}}}}}};
  assign _zz_380_ = (_zz_379_ & (~ _zz_735_));
  assign _zz_381_ = _zz_380_[3];
  assign _zz_382_ = _zz_380_[5];
  assign _zz_383_ = _zz_380_[6];
  assign _zz_384_ = _zz_380_[7];
  assign _zz_385_ = _zz_380_[9];
  assign _zz_386_ = _zz_380_[10];
  assign _zz_387_ = _zz_380_[11];
  assign _zz_388_ = _zz_380_[12];
  assign _zz_389_ = _zz_380_[13];
  assign _zz_390_ = _zz_380_[14];
  assign _zz_391_ = _zz_380_[15];
  assign _zz_392_ = (((((((_zz_380_[1] || _zz_381_) || _zz_382_) || _zz_384_) || _zz_385_) || _zz_387_) || _zz_389_) || _zz_391_);
  assign _zz_393_ = (((((((_zz_380_[2] || _zz_381_) || _zz_383_) || _zz_384_) || _zz_386_) || _zz_387_) || _zz_390_) || _zz_391_);
  assign _zz_394_ = (((((((_zz_380_[4] || _zz_382_) || _zz_383_) || _zz_384_) || _zz_388_) || _zz_389_) || _zz_390_) || _zz_391_);
  assign _zz_395_ = (((((((_zz_380_[8] || _zz_385_) || _zz_386_) || _zz_387_) || _zz_388_) || _zz_389_) || _zz_390_) || _zz_391_);
  assign IBusCachedPlugin_mmuBus_rsp_isIoAccess = IBusCachedPlugin_mmuBus_rsp_physicalAddress[31];
  assign IBusCachedPlugin_mmuBus_rsp_exception = 1'b0;
  assign IBusCachedPlugin_mmuBus_rsp_refilling = 1'b0;
  assign IBusCachedPlugin_mmuBus_busy = 1'b0;
  assign DBusCachedPlugin_mmuBus_rsp_physicalAddress = DBusCachedPlugin_mmuBus_cmd_virtualAddress;
  assign PmpPlugin_ports_1_hits_0 = (((_zz_99_ && (_zz_100_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_101_)) && (_zz_98_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_1 = (((_zz_115_ && (_zz_116_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_117_)) && (_zz_114_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_2 = (((_zz_131_ && (_zz_132_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_133_)) && (_zz_130_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_3 = (((_zz_147_ && (_zz_148_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_149_)) && (_zz_146_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_4 = (((_zz_163_ && (_zz_164_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_165_)) && (_zz_162_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_5 = (((_zz_179_ && (_zz_180_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_181_)) && (_zz_178_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_6 = (((_zz_195_ && (_zz_196_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_197_)) && (_zz_194_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_7 = (((_zz_211_ && (_zz_212_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_213_)) && (_zz_210_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_8 = (((_zz_227_ && (_zz_228_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_229_)) && (_zz_226_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_9 = (((_zz_243_ && (_zz_244_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_245_)) && (_zz_242_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_10 = (((_zz_259_ && (_zz_260_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_261_)) && (_zz_258_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_11 = (((_zz_275_ && (_zz_276_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_277_)) && (_zz_274_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_12 = (((_zz_291_ && (_zz_292_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_293_)) && (_zz_290_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_13 = (((_zz_307_ && (_zz_308_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_309_)) && (_zz_306_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_14 = (((_zz_323_ && (_zz_324_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_325_)) && (_zz_322_ || (! (CsrPlugin_privilege == (2'b11)))));
  assign PmpPlugin_ports_1_hits_15 = (((_zz_339_ && (_zz_340_ <= DBusCachedPlugin_mmuBus_cmd_virtualAddress)) && (DBusCachedPlugin_mmuBus_cmd_virtualAddress < _zz_341_)) && (_zz_338_ || (! (CsrPlugin_privilege == (2'b11)))));
  always @ (*) begin
    if(_zz_605_)begin
      DBusCachedPlugin_mmuBus_rsp_allowRead = (CsrPlugin_privilege == (2'b11));
    end else begin
      DBusCachedPlugin_mmuBus_rsp_allowRead = _zz_585_;
    end
  end

  always @ (*) begin
    if(_zz_605_)begin
      DBusCachedPlugin_mmuBus_rsp_allowWrite = (CsrPlugin_privilege == (2'b11));
    end else begin
      DBusCachedPlugin_mmuBus_rsp_allowWrite = _zz_586_;
    end
  end

  always @ (*) begin
    if(_zz_605_)begin
      DBusCachedPlugin_mmuBus_rsp_allowExecute = (CsrPlugin_privilege == (2'b11));
    end else begin
      DBusCachedPlugin_mmuBus_rsp_allowExecute = _zz_587_;
    end
  end

  assign _zz_396_ = {PmpPlugin_ports_1_hits_15,{PmpPlugin_ports_1_hits_14,{PmpPlugin_ports_1_hits_13,{PmpPlugin_ports_1_hits_12,{PmpPlugin_ports_1_hits_11,{PmpPlugin_ports_1_hits_10,{PmpPlugin_ports_1_hits_9,{PmpPlugin_ports_1_hits_8,{PmpPlugin_ports_1_hits_7,{PmpPlugin_ports_1_hits_6,{_zz_890_,_zz_891_}}}}}}}}}}};
  assign _zz_397_ = (_zz_396_ & (~ _zz_736_));
  assign _zz_398_ = _zz_397_[3];
  assign _zz_399_ = _zz_397_[5];
  assign _zz_400_ = _zz_397_[6];
  assign _zz_401_ = _zz_397_[7];
  assign _zz_402_ = _zz_397_[9];
  assign _zz_403_ = _zz_397_[10];
  assign _zz_404_ = _zz_397_[11];
  assign _zz_405_ = _zz_397_[12];
  assign _zz_406_ = _zz_397_[13];
  assign _zz_407_ = _zz_397_[14];
  assign _zz_408_ = _zz_397_[15];
  assign _zz_409_ = (((((((_zz_397_[1] || _zz_398_) || _zz_399_) || _zz_401_) || _zz_402_) || _zz_404_) || _zz_406_) || _zz_408_);
  assign _zz_410_ = (((((((_zz_397_[2] || _zz_398_) || _zz_400_) || _zz_401_) || _zz_403_) || _zz_404_) || _zz_407_) || _zz_408_);
  assign _zz_411_ = (((((((_zz_397_[4] || _zz_399_) || _zz_400_) || _zz_401_) || _zz_405_) || _zz_406_) || _zz_407_) || _zz_408_);
  assign _zz_412_ = (((((((_zz_397_[8] || _zz_402_) || _zz_403_) || _zz_404_) || _zz_405_) || _zz_406_) || _zz_407_) || _zz_408_);
  assign _zz_413_ = {PmpPlugin_ports_1_hits_15,{PmpPlugin_ports_1_hits_14,{PmpPlugin_ports_1_hits_13,{PmpPlugin_ports_1_hits_12,{PmpPlugin_ports_1_hits_11,{PmpPlugin_ports_1_hits_10,{PmpPlugin_ports_1_hits_9,{PmpPlugin_ports_1_hits_8,{PmpPlugin_ports_1_hits_7,{PmpPlugin_ports_1_hits_6,{_zz_892_,_zz_893_}}}}}}}}}}};
  assign _zz_414_ = (_zz_413_ & (~ _zz_737_));
  assign _zz_415_ = _zz_414_[3];
  assign _zz_416_ = _zz_414_[5];
  assign _zz_417_ = _zz_414_[6];
  assign _zz_418_ = _zz_414_[7];
  assign _zz_419_ = _zz_414_[9];
  assign _zz_420_ = _zz_414_[10];
  assign _zz_421_ = _zz_414_[11];
  assign _zz_422_ = _zz_414_[12];
  assign _zz_423_ = _zz_414_[13];
  assign _zz_424_ = _zz_414_[14];
  assign _zz_425_ = _zz_414_[15];
  assign _zz_426_ = (((((((_zz_414_[1] || _zz_415_) || _zz_416_) || _zz_418_) || _zz_419_) || _zz_421_) || _zz_423_) || _zz_425_);
  assign _zz_427_ = (((((((_zz_414_[2] || _zz_415_) || _zz_417_) || _zz_418_) || _zz_420_) || _zz_421_) || _zz_424_) || _zz_425_);
  assign _zz_428_ = (((((((_zz_414_[4] || _zz_416_) || _zz_417_) || _zz_418_) || _zz_422_) || _zz_423_) || _zz_424_) || _zz_425_);
  assign _zz_429_ = (((((((_zz_414_[8] || _zz_419_) || _zz_420_) || _zz_421_) || _zz_422_) || _zz_423_) || _zz_424_) || _zz_425_);
  assign _zz_430_ = {PmpPlugin_ports_1_hits_15,{PmpPlugin_ports_1_hits_14,{PmpPlugin_ports_1_hits_13,{PmpPlugin_ports_1_hits_12,{PmpPlugin_ports_1_hits_11,{PmpPlugin_ports_1_hits_10,{PmpPlugin_ports_1_hits_9,{PmpPlugin_ports_1_hits_8,{PmpPlugin_ports_1_hits_7,{PmpPlugin_ports_1_hits_6,{_zz_894_,_zz_895_}}}}}}}}}}};
  assign _zz_431_ = (_zz_430_ & (~ _zz_738_));
  assign _zz_432_ = _zz_431_[3];
  assign _zz_433_ = _zz_431_[5];
  assign _zz_434_ = _zz_431_[6];
  assign _zz_435_ = _zz_431_[7];
  assign _zz_436_ = _zz_431_[9];
  assign _zz_437_ = _zz_431_[10];
  assign _zz_438_ = _zz_431_[11];
  assign _zz_439_ = _zz_431_[12];
  assign _zz_440_ = _zz_431_[13];
  assign _zz_441_ = _zz_431_[14];
  assign _zz_442_ = _zz_431_[15];
  assign _zz_443_ = (((((((_zz_431_[1] || _zz_432_) || _zz_433_) || _zz_435_) || _zz_436_) || _zz_438_) || _zz_440_) || _zz_442_);
  assign _zz_444_ = (((((((_zz_431_[2] || _zz_432_) || _zz_434_) || _zz_435_) || _zz_437_) || _zz_438_) || _zz_441_) || _zz_442_);
  assign _zz_445_ = (((((((_zz_431_[4] || _zz_433_) || _zz_434_) || _zz_435_) || _zz_439_) || _zz_440_) || _zz_441_) || _zz_442_);
  assign _zz_446_ = (((((((_zz_431_[8] || _zz_436_) || _zz_437_) || _zz_438_) || _zz_439_) || _zz_440_) || _zz_441_) || _zz_442_);
  assign DBusCachedPlugin_mmuBus_rsp_isIoAccess = DBusCachedPlugin_mmuBus_rsp_physicalAddress[31];
  assign DBusCachedPlugin_mmuBus_rsp_exception = 1'b0;
  assign DBusCachedPlugin_mmuBus_rsp_refilling = 1'b0;
  assign DBusCachedPlugin_mmuBus_busy = 1'b0;
  assign _zz_448_ = ((decode_INSTRUCTION & 32'h00001000) == 32'h0);
  assign _zz_449_ = ((decode_INSTRUCTION & 32'h00004050) == 32'h00004050);
  assign _zz_450_ = ((decode_INSTRUCTION & 32'h00000004) == 32'h00000004);
  assign _zz_451_ = ((decode_INSTRUCTION & 32'h00000048) == 32'h00000048);
  assign _zz_447_ = {({_zz_451_,(_zz_896_ == _zz_897_)} != (2'b00)),{((_zz_898_ == _zz_899_) != (1'b0)),{(_zz_900_ != (1'b0)),{(_zz_901_ != _zz_902_),{_zz_903_,{_zz_904_,_zz_905_}}}}}};
  assign _zz_452_ = _zz_447_[3 : 2];
  assign _zz_49_ = _zz_452_;
  assign _zz_453_ = _zz_447_[6 : 5];
  assign _zz_48_ = _zz_453_;
  assign _zz_454_ = _zz_447_[8 : 7];
  assign _zz_47_ = _zz_454_;
  assign _zz_455_ = _zz_447_[20 : 19];
  assign _zz_46_ = _zz_455_;
  assign _zz_456_ = _zz_447_[23 : 22];
  assign _zz_45_ = _zz_456_;
  assign _zz_457_ = _zz_447_[25 : 24];
  assign _zz_44_ = _zz_457_;
  assign _zz_458_ = _zz_447_[31 : 30];
  assign _zz_43_ = _zz_458_;
  assign decodeExceptionPort_valid = (decode_arbitration_isValid && (! decode_LEGAL_INSTRUCTION));
  assign decodeExceptionPort_payload_code = (4'b0010);
  assign decodeExceptionPort_payload_badAddr = decode_INSTRUCTION;
  assign decode_RegFilePlugin_regFileReadAddress1 = decode_INSTRUCTION_ANTICIPATED[19 : 15];
  assign decode_RegFilePlugin_regFileReadAddress2 = decode_INSTRUCTION_ANTICIPATED[24 : 20];
  assign decode_RegFilePlugin_rs1Data = _zz_579_;
  assign decode_RegFilePlugin_rs2Data = _zz_580_;
  always @ (*) begin
    lastStageRegFileWrite_valid = (_zz_41_ && writeBack_arbitration_isFiring);
    if(_zz_459_)begin
      lastStageRegFileWrite_valid = 1'b1;
    end
  end

  assign lastStageRegFileWrite_payload_address = _zz_40_[11 : 7];
  assign lastStageRegFileWrite_payload_data = _zz_52_;
  always @ (*) begin
    case(execute_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 & execute_SRC2);
      end
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 | execute_SRC2);
      end
      default : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 ^ execute_SRC2);
      end
    endcase
  end

  always @ (*) begin
    case(execute_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_BITWISE : begin
        _zz_460_ = execute_IntAluPlugin_bitwise;
      end
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : begin
        _zz_460_ = {31'd0, _zz_739_};
      end
      default : begin
        _zz_460_ = execute_SRC_ADD_SUB;
      end
    endcase
  end

  always @ (*) begin
    case(execute_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : begin
        _zz_461_ = execute_RS1;
      end
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : begin
        _zz_461_ = {29'd0, _zz_740_};
      end
      `Src1CtrlEnum_defaultEncoding_IMU : begin
        _zz_461_ = {execute_INSTRUCTION[31 : 12],12'h0};
      end
      default : begin
        _zz_461_ = {27'd0, _zz_741_};
      end
    endcase
  end

  assign _zz_462_ = _zz_742_[11];
  always @ (*) begin
    _zz_463_[19] = _zz_462_;
    _zz_463_[18] = _zz_462_;
    _zz_463_[17] = _zz_462_;
    _zz_463_[16] = _zz_462_;
    _zz_463_[15] = _zz_462_;
    _zz_463_[14] = _zz_462_;
    _zz_463_[13] = _zz_462_;
    _zz_463_[12] = _zz_462_;
    _zz_463_[11] = _zz_462_;
    _zz_463_[10] = _zz_462_;
    _zz_463_[9] = _zz_462_;
    _zz_463_[8] = _zz_462_;
    _zz_463_[7] = _zz_462_;
    _zz_463_[6] = _zz_462_;
    _zz_463_[5] = _zz_462_;
    _zz_463_[4] = _zz_462_;
    _zz_463_[3] = _zz_462_;
    _zz_463_[2] = _zz_462_;
    _zz_463_[1] = _zz_462_;
    _zz_463_[0] = _zz_462_;
  end

  assign _zz_464_ = _zz_743_[11];
  always @ (*) begin
    _zz_465_[19] = _zz_464_;
    _zz_465_[18] = _zz_464_;
    _zz_465_[17] = _zz_464_;
    _zz_465_[16] = _zz_464_;
    _zz_465_[15] = _zz_464_;
    _zz_465_[14] = _zz_464_;
    _zz_465_[13] = _zz_464_;
    _zz_465_[12] = _zz_464_;
    _zz_465_[11] = _zz_464_;
    _zz_465_[10] = _zz_464_;
    _zz_465_[9] = _zz_464_;
    _zz_465_[8] = _zz_464_;
    _zz_465_[7] = _zz_464_;
    _zz_465_[6] = _zz_464_;
    _zz_465_[5] = _zz_464_;
    _zz_465_[4] = _zz_464_;
    _zz_465_[3] = _zz_464_;
    _zz_465_[2] = _zz_464_;
    _zz_465_[1] = _zz_464_;
    _zz_465_[0] = _zz_464_;
  end

  always @ (*) begin
    case(execute_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : begin
        _zz_466_ = execute_RS2;
      end
      `Src2CtrlEnum_defaultEncoding_IMI : begin
        _zz_466_ = {_zz_463_,execute_INSTRUCTION[31 : 20]};
      end
      `Src2CtrlEnum_defaultEncoding_IMS : begin
        _zz_466_ = {_zz_465_,{execute_INSTRUCTION[31 : 25],execute_INSTRUCTION[11 : 7]}};
      end
      default : begin
        _zz_466_ = _zz_35_;
      end
    endcase
  end

  always @ (*) begin
    execute_SrcPlugin_addSub = _zz_744_;
    if(execute_SRC2_FORCE_ZERO)begin
      execute_SrcPlugin_addSub = execute_SRC1;
    end
  end

  assign execute_SrcPlugin_less = ((execute_SRC1[31] == execute_SRC2[31]) ? execute_SrcPlugin_addSub[31] : (execute_SRC_LESS_UNSIGNED ? execute_SRC2[31] : execute_SRC1[31]));
  assign execute_FullBarrelShifterPlugin_amplitude = execute_SRC2[4 : 0];
  always @ (*) begin
    _zz_467_[0] = execute_SRC1[31];
    _zz_467_[1] = execute_SRC1[30];
    _zz_467_[2] = execute_SRC1[29];
    _zz_467_[3] = execute_SRC1[28];
    _zz_467_[4] = execute_SRC1[27];
    _zz_467_[5] = execute_SRC1[26];
    _zz_467_[6] = execute_SRC1[25];
    _zz_467_[7] = execute_SRC1[24];
    _zz_467_[8] = execute_SRC1[23];
    _zz_467_[9] = execute_SRC1[22];
    _zz_467_[10] = execute_SRC1[21];
    _zz_467_[11] = execute_SRC1[20];
    _zz_467_[12] = execute_SRC1[19];
    _zz_467_[13] = execute_SRC1[18];
    _zz_467_[14] = execute_SRC1[17];
    _zz_467_[15] = execute_SRC1[16];
    _zz_467_[16] = execute_SRC1[15];
    _zz_467_[17] = execute_SRC1[14];
    _zz_467_[18] = execute_SRC1[13];
    _zz_467_[19] = execute_SRC1[12];
    _zz_467_[20] = execute_SRC1[11];
    _zz_467_[21] = execute_SRC1[10];
    _zz_467_[22] = execute_SRC1[9];
    _zz_467_[23] = execute_SRC1[8];
    _zz_467_[24] = execute_SRC1[7];
    _zz_467_[25] = execute_SRC1[6];
    _zz_467_[26] = execute_SRC1[5];
    _zz_467_[27] = execute_SRC1[4];
    _zz_467_[28] = execute_SRC1[3];
    _zz_467_[29] = execute_SRC1[2];
    _zz_467_[30] = execute_SRC1[1];
    _zz_467_[31] = execute_SRC1[0];
  end

  assign execute_FullBarrelShifterPlugin_reversed = ((execute_SHIFT_CTRL == `ShiftCtrlEnum_defaultEncoding_SLL_1) ? _zz_467_ : execute_SRC1);
  always @ (*) begin
    _zz_468_[0] = memory_SHIFT_RIGHT[31];
    _zz_468_[1] = memory_SHIFT_RIGHT[30];
    _zz_468_[2] = memory_SHIFT_RIGHT[29];
    _zz_468_[3] = memory_SHIFT_RIGHT[28];
    _zz_468_[4] = memory_SHIFT_RIGHT[27];
    _zz_468_[5] = memory_SHIFT_RIGHT[26];
    _zz_468_[6] = memory_SHIFT_RIGHT[25];
    _zz_468_[7] = memory_SHIFT_RIGHT[24];
    _zz_468_[8] = memory_SHIFT_RIGHT[23];
    _zz_468_[9] = memory_SHIFT_RIGHT[22];
    _zz_468_[10] = memory_SHIFT_RIGHT[21];
    _zz_468_[11] = memory_SHIFT_RIGHT[20];
    _zz_468_[12] = memory_SHIFT_RIGHT[19];
    _zz_468_[13] = memory_SHIFT_RIGHT[18];
    _zz_468_[14] = memory_SHIFT_RIGHT[17];
    _zz_468_[15] = memory_SHIFT_RIGHT[16];
    _zz_468_[16] = memory_SHIFT_RIGHT[15];
    _zz_468_[17] = memory_SHIFT_RIGHT[14];
    _zz_468_[18] = memory_SHIFT_RIGHT[13];
    _zz_468_[19] = memory_SHIFT_RIGHT[12];
    _zz_468_[20] = memory_SHIFT_RIGHT[11];
    _zz_468_[21] = memory_SHIFT_RIGHT[10];
    _zz_468_[22] = memory_SHIFT_RIGHT[9];
    _zz_468_[23] = memory_SHIFT_RIGHT[8];
    _zz_468_[24] = memory_SHIFT_RIGHT[7];
    _zz_468_[25] = memory_SHIFT_RIGHT[6];
    _zz_468_[26] = memory_SHIFT_RIGHT[5];
    _zz_468_[27] = memory_SHIFT_RIGHT[4];
    _zz_468_[28] = memory_SHIFT_RIGHT[3];
    _zz_468_[29] = memory_SHIFT_RIGHT[2];
    _zz_468_[30] = memory_SHIFT_RIGHT[1];
    _zz_468_[31] = memory_SHIFT_RIGHT[0];
  end

  always @ (*) begin
    _zz_469_ = 1'b0;
    if(_zz_606_)begin
      if(_zz_607_)begin
        if(_zz_474_)begin
          _zz_469_ = 1'b1;
        end
      end
    end
    if(_zz_608_)begin
      if(_zz_609_)begin
        if(_zz_476_)begin
          _zz_469_ = 1'b1;
        end
      end
    end
    if(_zz_610_)begin
      if(_zz_611_)begin
        if(_zz_478_)begin
          _zz_469_ = 1'b1;
        end
      end
    end
    if((! decode_RS1_USE))begin
      _zz_469_ = 1'b0;
    end
  end

  always @ (*) begin
    _zz_470_ = 1'b0;
    if(_zz_606_)begin
      if(_zz_607_)begin
        if(_zz_475_)begin
          _zz_470_ = 1'b1;
        end
      end
    end
    if(_zz_608_)begin
      if(_zz_609_)begin
        if(_zz_477_)begin
          _zz_470_ = 1'b1;
        end
      end
    end
    if(_zz_610_)begin
      if(_zz_611_)begin
        if(_zz_479_)begin
          _zz_470_ = 1'b1;
        end
      end
    end
    if((! decode_RS2_USE))begin
      _zz_470_ = 1'b0;
    end
  end

  assign _zz_474_ = (writeBack_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_475_ = (writeBack_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign _zz_476_ = (memory_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_477_ = (memory_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign _zz_478_ = (execute_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_479_ = (execute_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign execute_BranchPlugin_eq = (execute_SRC1 == execute_SRC2);
  assign _zz_480_ = execute_INSTRUCTION[14 : 12];
  always @ (*) begin
    if((_zz_480_ == (3'b000))) begin
        _zz_481_ = execute_BranchPlugin_eq;
    end else if((_zz_480_ == (3'b001))) begin
        _zz_481_ = (! execute_BranchPlugin_eq);
    end else if((((_zz_480_ & (3'b101)) == (3'b101)))) begin
        _zz_481_ = (! execute_SRC_LESS);
    end else begin
        _zz_481_ = execute_SRC_LESS;
    end
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : begin
        _zz_482_ = 1'b0;
      end
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_482_ = 1'b1;
      end
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        _zz_482_ = 1'b1;
      end
      default : begin
        _zz_482_ = _zz_481_;
      end
    endcase
  end

  assign _zz_483_ = _zz_751_[11];
  always @ (*) begin
    _zz_484_[19] = _zz_483_;
    _zz_484_[18] = _zz_483_;
    _zz_484_[17] = _zz_483_;
    _zz_484_[16] = _zz_483_;
    _zz_484_[15] = _zz_483_;
    _zz_484_[14] = _zz_483_;
    _zz_484_[13] = _zz_483_;
    _zz_484_[12] = _zz_483_;
    _zz_484_[11] = _zz_483_;
    _zz_484_[10] = _zz_483_;
    _zz_484_[9] = _zz_483_;
    _zz_484_[8] = _zz_483_;
    _zz_484_[7] = _zz_483_;
    _zz_484_[6] = _zz_483_;
    _zz_484_[5] = _zz_483_;
    _zz_484_[4] = _zz_483_;
    _zz_484_[3] = _zz_483_;
    _zz_484_[2] = _zz_483_;
    _zz_484_[1] = _zz_483_;
    _zz_484_[0] = _zz_483_;
  end

  assign _zz_485_ = _zz_752_[19];
  always @ (*) begin
    _zz_486_[10] = _zz_485_;
    _zz_486_[9] = _zz_485_;
    _zz_486_[8] = _zz_485_;
    _zz_486_[7] = _zz_485_;
    _zz_486_[6] = _zz_485_;
    _zz_486_[5] = _zz_485_;
    _zz_486_[4] = _zz_485_;
    _zz_486_[3] = _zz_485_;
    _zz_486_[2] = _zz_485_;
    _zz_486_[1] = _zz_485_;
    _zz_486_[0] = _zz_485_;
  end

  assign _zz_487_ = _zz_753_[11];
  always @ (*) begin
    _zz_488_[18] = _zz_487_;
    _zz_488_[17] = _zz_487_;
    _zz_488_[16] = _zz_487_;
    _zz_488_[15] = _zz_487_;
    _zz_488_[14] = _zz_487_;
    _zz_488_[13] = _zz_487_;
    _zz_488_[12] = _zz_487_;
    _zz_488_[11] = _zz_487_;
    _zz_488_[10] = _zz_487_;
    _zz_488_[9] = _zz_487_;
    _zz_488_[8] = _zz_487_;
    _zz_488_[7] = _zz_487_;
    _zz_488_[6] = _zz_487_;
    _zz_488_[5] = _zz_487_;
    _zz_488_[4] = _zz_487_;
    _zz_488_[3] = _zz_487_;
    _zz_488_[2] = _zz_487_;
    _zz_488_[1] = _zz_487_;
    _zz_488_[0] = _zz_487_;
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        _zz_489_ = (_zz_754_[1] ^ execute_RS1[1]);
      end
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_489_ = _zz_755_[1];
      end
      default : begin
        _zz_489_ = _zz_756_[1];
      end
    endcase
  end

  assign execute_BranchPlugin_missAlignedTarget = (execute_BRANCH_COND_RESULT && _zz_489_);
  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        execute_BranchPlugin_branch_src1 = execute_RS1;
      end
      default : begin
        execute_BranchPlugin_branch_src1 = execute_PC;
      end
    endcase
  end

  assign _zz_490_ = _zz_757_[11];
  always @ (*) begin
    _zz_491_[19] = _zz_490_;
    _zz_491_[18] = _zz_490_;
    _zz_491_[17] = _zz_490_;
    _zz_491_[16] = _zz_490_;
    _zz_491_[15] = _zz_490_;
    _zz_491_[14] = _zz_490_;
    _zz_491_[13] = _zz_490_;
    _zz_491_[12] = _zz_490_;
    _zz_491_[11] = _zz_490_;
    _zz_491_[10] = _zz_490_;
    _zz_491_[9] = _zz_490_;
    _zz_491_[8] = _zz_490_;
    _zz_491_[7] = _zz_490_;
    _zz_491_[6] = _zz_490_;
    _zz_491_[5] = _zz_490_;
    _zz_491_[4] = _zz_490_;
    _zz_491_[3] = _zz_490_;
    _zz_491_[2] = _zz_490_;
    _zz_491_[1] = _zz_490_;
    _zz_491_[0] = _zz_490_;
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        execute_BranchPlugin_branch_src2 = {_zz_491_,execute_INSTRUCTION[31 : 20]};
      end
      default : begin
        execute_BranchPlugin_branch_src2 = ((execute_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) ? {{_zz_493_,{{{_zz_1058_,execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]}},1'b0} : {{_zz_495_,{{{_zz_1059_,_zz_1060_},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]}},1'b0});
        if(execute_PREDICTION_HAD_BRANCHED2)begin
          execute_BranchPlugin_branch_src2 = {29'd0, _zz_760_};
        end
      end
    endcase
  end

  assign _zz_492_ = _zz_758_[19];
  always @ (*) begin
    _zz_493_[10] = _zz_492_;
    _zz_493_[9] = _zz_492_;
    _zz_493_[8] = _zz_492_;
    _zz_493_[7] = _zz_492_;
    _zz_493_[6] = _zz_492_;
    _zz_493_[5] = _zz_492_;
    _zz_493_[4] = _zz_492_;
    _zz_493_[3] = _zz_492_;
    _zz_493_[2] = _zz_492_;
    _zz_493_[1] = _zz_492_;
    _zz_493_[0] = _zz_492_;
  end

  assign _zz_494_ = _zz_759_[11];
  always @ (*) begin
    _zz_495_[18] = _zz_494_;
    _zz_495_[17] = _zz_494_;
    _zz_495_[16] = _zz_494_;
    _zz_495_[15] = _zz_494_;
    _zz_495_[14] = _zz_494_;
    _zz_495_[13] = _zz_494_;
    _zz_495_[12] = _zz_494_;
    _zz_495_[11] = _zz_494_;
    _zz_495_[10] = _zz_494_;
    _zz_495_[9] = _zz_494_;
    _zz_495_[8] = _zz_494_;
    _zz_495_[7] = _zz_494_;
    _zz_495_[6] = _zz_494_;
    _zz_495_[5] = _zz_494_;
    _zz_495_[4] = _zz_494_;
    _zz_495_[3] = _zz_494_;
    _zz_495_[2] = _zz_494_;
    _zz_495_[1] = _zz_494_;
    _zz_495_[0] = _zz_494_;
  end

  assign execute_BranchPlugin_branchAdder = (execute_BranchPlugin_branch_src1 + execute_BranchPlugin_branch_src2);
  assign BranchPlugin_jumpInterface_valid = ((memory_arbitration_isValid && memory_BRANCH_DO) && (! 1'b0));
  assign BranchPlugin_jumpInterface_payload = memory_BRANCH_CALC;
  assign BranchPlugin_branchExceptionPort_valid = (memory_arbitration_isValid && (memory_BRANCH_DO && memory_BRANCH_CALC[1]));
  assign BranchPlugin_branchExceptionPort_payload_code = (4'b0000);
  assign BranchPlugin_branchExceptionPort_payload_badAddr = memory_BRANCH_CALC;
  assign IBusCachedPlugin_decodePrediction_rsp_wasWrong = BranchPlugin_jumpInterface_valid;
  always @ (*) begin
    CsrPlugin_privilege = _zz_496_;
    if(CsrPlugin_forceMachineWire)begin
      CsrPlugin_privilege = (2'b11);
    end
  end

  assign _zz_497_ = (CsrPlugin_mip_MTIP && CsrPlugin_mie_MTIE);
  assign _zz_498_ = (CsrPlugin_mip_MSIP && CsrPlugin_mie_MSIE);
  assign _zz_499_ = (CsrPlugin_mip_MEIP && CsrPlugin_mie_MEIE);
  assign CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped = (2'b11);
  assign CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege = ((CsrPlugin_privilege < CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped) ? CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped : CsrPlugin_privilege);
  assign _zz_500_ = {decodeExceptionPort_valid,IBusCachedPlugin_decodeExceptionPort_valid};
  assign _zz_501_ = _zz_761_[0];
  always @ (*) begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_decode = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode;
    if(_zz_598_)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_decode = 1'b1;
    end
    if(decode_arbitration_isFlushed)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_decode = 1'b0;
    end
  end

  always @ (*) begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_execute = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute;
    if(CsrPlugin_selfException_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_execute = 1'b1;
    end
    if(execute_arbitration_isFlushed)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_execute = 1'b0;
    end
  end

  always @ (*) begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_memory = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory;
    if(BranchPlugin_branchExceptionPort_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_memory = 1'b1;
    end
    if(memory_arbitration_isFlushed)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_memory = 1'b0;
    end
  end

  always @ (*) begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack;
    if(DBusCachedPlugin_exceptionBus_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack = 1'b1;
    end
    if(writeBack_arbitration_isFlushed)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack = 1'b0;
    end
  end

  assign CsrPlugin_exceptionPendings_0 = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode;
  assign CsrPlugin_exceptionPendings_1 = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute;
  assign CsrPlugin_exceptionPendings_2 = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory;
  assign CsrPlugin_exceptionPendings_3 = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack;
  assign CsrPlugin_exception = (CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack && CsrPlugin_allowException);
  assign CsrPlugin_pipelineLiberator_active = ((CsrPlugin_interrupt_valid && CsrPlugin_allowInterrupts) && decode_arbitration_isValid);
  always @ (*) begin
    CsrPlugin_pipelineLiberator_done = CsrPlugin_pipelineLiberator_pcValids_2;
    if(({CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack,{CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory,CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute}} != (3'b000)))begin
      CsrPlugin_pipelineLiberator_done = 1'b0;
    end
    if(CsrPlugin_hadException)begin
      CsrPlugin_pipelineLiberator_done = 1'b0;
    end
  end

  assign CsrPlugin_interruptJump = ((CsrPlugin_interrupt_valid && CsrPlugin_pipelineLiberator_done) && CsrPlugin_allowInterrupts);
  always @ (*) begin
    CsrPlugin_targetPrivilege = CsrPlugin_interrupt_targetPrivilege;
    if(CsrPlugin_hadException)begin
      CsrPlugin_targetPrivilege = CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege;
    end
  end

  always @ (*) begin
    CsrPlugin_trapCause = CsrPlugin_interrupt_code;
    if(CsrPlugin_hadException)begin
      CsrPlugin_trapCause = CsrPlugin_exceptionPortCtrl_exceptionContext_code;
    end
  end

  always @ (*) begin
    CsrPlugin_xtvec_mode = (2'bxx);
    case(CsrPlugin_targetPrivilege)
      2'b11 : begin
        CsrPlugin_xtvec_mode = CsrPlugin_mtvec_mode;
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    CsrPlugin_xtvec_base = 30'h0;
    case(CsrPlugin_targetPrivilege)
      2'b11 : begin
        CsrPlugin_xtvec_base = CsrPlugin_mtvec_base;
      end
      default : begin
      end
    endcase
  end

  assign contextSwitching = CsrPlugin_jumpInterface_valid;
  assign execute_CsrPlugin_blockedBySideEffects = ({writeBack_arbitration_isValid,memory_arbitration_isValid} != (2'b00));
  always @ (*) begin
    execute_CsrPlugin_illegalAccess = 1'b1;
    if(execute_CsrPlugin_csr_3264)begin
      if(execute_CSR_READ_OPCODE)begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
    end
    if(execute_CsrPlugin_csr_944)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_945)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_946)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_947)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_948)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_949)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_950)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_951)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_952)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_953)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_954)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_955)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_956)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_957)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_958)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_959)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_928)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_929)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_930)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_931)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_3857)begin
      if(execute_CSR_READ_OPCODE)begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
    end
    if(execute_CsrPlugin_csr_3858)begin
      if(execute_CSR_READ_OPCODE)begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
    end
    if(execute_CsrPlugin_csr_3859)begin
      if(execute_CSR_READ_OPCODE)begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
    end
    if(execute_CsrPlugin_csr_3860)begin
      if(execute_CSR_READ_OPCODE)begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
    end
    if(execute_CsrPlugin_csr_769)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_768)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_836)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_772)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_773)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_833)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_832)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_834)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_835)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_2816)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_2944)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_2818)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_2946)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_3072)begin
      if(execute_CSR_READ_OPCODE)begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
    end
    if(execute_CsrPlugin_csr_3200)begin
      if(execute_CSR_READ_OPCODE)begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
    end
    if(execute_CsrPlugin_csr_3074)begin
      if(execute_CSR_READ_OPCODE)begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
    end
    if(execute_CsrPlugin_csr_3202)begin
      if(execute_CSR_READ_OPCODE)begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
    end
    if(execute_CsrPlugin_csr_3008)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_4032)begin
      if(execute_CSR_READ_OPCODE)begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
    end
    if(_zz_612_)begin
      execute_CsrPlugin_illegalAccess = 1'b1;
    end
    if(((! execute_arbitration_isValid) || (! execute_IS_CSR)))begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
  end

  always @ (*) begin
    execute_CsrPlugin_illegalInstruction = 1'b0;
    if((execute_arbitration_isValid && (execute_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET)))begin
      if((CsrPlugin_privilege < execute_INSTRUCTION[29 : 28]))begin
        execute_CsrPlugin_illegalInstruction = 1'b1;
      end
    end
  end

  always @ (*) begin
    CsrPlugin_selfException_valid = 1'b0;
    if(_zz_613_)begin
      CsrPlugin_selfException_valid = 1'b1;
    end
    if(_zz_614_)begin
      CsrPlugin_selfException_valid = 1'b1;
    end
  end

  always @ (*) begin
    CsrPlugin_selfException_payload_code = (4'bxxxx);
    if(_zz_613_)begin
      CsrPlugin_selfException_payload_code = (4'b0010);
    end
    if(_zz_614_)begin
      case(CsrPlugin_privilege)
        2'b00 : begin
          CsrPlugin_selfException_payload_code = (4'b1000);
        end
        default : begin
          CsrPlugin_selfException_payload_code = (4'b1011);
        end
      endcase
    end
  end

  assign CsrPlugin_selfException_payload_badAddr = execute_INSTRUCTION;
  always @ (*) begin
    execute_CsrPlugin_writeInstruction = ((execute_arbitration_isValid && execute_IS_CSR) && execute_CSR_WRITE_OPCODE);
    if(_zz_612_)begin
      execute_CsrPlugin_writeInstruction = 1'b0;
    end
  end

  always @ (*) begin
    execute_CsrPlugin_readInstruction = ((execute_arbitration_isValid && execute_IS_CSR) && execute_CSR_READ_OPCODE);
    if(_zz_612_)begin
      execute_CsrPlugin_readInstruction = 1'b0;
    end
  end

  assign execute_CsrPlugin_writeEnable = (execute_CsrPlugin_writeInstruction && (! execute_arbitration_isStuck));
  assign execute_CsrPlugin_readEnable = (execute_CsrPlugin_readInstruction && (! execute_arbitration_isStuck));
  assign execute_CsrPlugin_readToWriteData = execute_CsrPlugin_readData;
  always @ (*) begin
    case(_zz_641_)
      1'b0 : begin
        execute_CsrPlugin_writeData = execute_SRC1;
      end
      default : begin
        execute_CsrPlugin_writeData = (execute_INSTRUCTION[12] ? (execute_CsrPlugin_readToWriteData & (~ execute_SRC1)) : (execute_CsrPlugin_readToWriteData | execute_SRC1));
      end
    endcase
  end

  assign execute_CsrPlugin_csrAddress = execute_INSTRUCTION[31 : 20];
  assign execute_MulPlugin_a = execute_RS1;
  assign execute_MulPlugin_b = execute_RS2;
  always @ (*) begin
    case(_zz_615_)
      2'b01 : begin
        execute_MulPlugin_aSigned = 1'b1;
      end
      2'b10 : begin
        execute_MulPlugin_aSigned = 1'b1;
      end
      default : begin
        execute_MulPlugin_aSigned = 1'b0;
      end
    endcase
  end

  always @ (*) begin
    case(_zz_615_)
      2'b01 : begin
        execute_MulPlugin_bSigned = 1'b1;
      end
      2'b10 : begin
        execute_MulPlugin_bSigned = 1'b0;
      end
      default : begin
        execute_MulPlugin_bSigned = 1'b0;
      end
    endcase
  end

  assign execute_MulPlugin_aULow = execute_MulPlugin_a[15 : 0];
  assign execute_MulPlugin_bULow = execute_MulPlugin_b[15 : 0];
  assign execute_MulPlugin_aSLow = {1'b0,execute_MulPlugin_a[15 : 0]};
  assign execute_MulPlugin_bSLow = {1'b0,execute_MulPlugin_b[15 : 0]};
  assign execute_MulPlugin_aHigh = {(execute_MulPlugin_aSigned && execute_MulPlugin_a[31]),execute_MulPlugin_a[31 : 16]};
  assign execute_MulPlugin_bHigh = {(execute_MulPlugin_bSigned && execute_MulPlugin_b[31]),execute_MulPlugin_b[31 : 16]};
  assign writeBack_MulPlugin_result = ($signed(_zz_763_) + $signed(_zz_764_));
  assign memory_DivPlugin_frontendOk = 1'b1;
  always @ (*) begin
    memory_DivPlugin_div_counter_willIncrement = 1'b0;
    if(_zz_593_)begin
      if(_zz_616_)begin
        memory_DivPlugin_div_counter_willIncrement = 1'b1;
      end
    end
  end

  always @ (*) begin
    memory_DivPlugin_div_counter_willClear = 1'b0;
    if(_zz_617_)begin
      memory_DivPlugin_div_counter_willClear = 1'b1;
    end
  end

  assign memory_DivPlugin_div_counter_willOverflowIfInc = (memory_DivPlugin_div_counter_value == 6'h21);
  assign memory_DivPlugin_div_counter_willOverflow = (memory_DivPlugin_div_counter_willOverflowIfInc && memory_DivPlugin_div_counter_willIncrement);
  always @ (*) begin
    if(memory_DivPlugin_div_counter_willOverflow)begin
      memory_DivPlugin_div_counter_valueNext = 6'h0;
    end else begin
      memory_DivPlugin_div_counter_valueNext = (memory_DivPlugin_div_counter_value + _zz_768_);
    end
    if(memory_DivPlugin_div_counter_willClear)begin
      memory_DivPlugin_div_counter_valueNext = 6'h0;
    end
  end

  assign _zz_502_ = memory_DivPlugin_rs1[31 : 0];
  assign memory_DivPlugin_div_stage_0_remainderShifted = {memory_DivPlugin_accumulator[31 : 0],_zz_502_[31]};
  assign memory_DivPlugin_div_stage_0_remainderMinusDenominator = (memory_DivPlugin_div_stage_0_remainderShifted - _zz_769_);
  assign memory_DivPlugin_div_stage_0_outRemainder = ((! memory_DivPlugin_div_stage_0_remainderMinusDenominator[32]) ? _zz_770_ : _zz_771_);
  assign memory_DivPlugin_div_stage_0_outNumerator = _zz_772_[31:0];
  assign _zz_503_ = (memory_INSTRUCTION[13] ? memory_DivPlugin_accumulator[31 : 0] : memory_DivPlugin_rs1[31 : 0]);
  assign _zz_504_ = (execute_RS2[31] && execute_IS_RS2_SIGNED);
  assign _zz_505_ = (1'b0 || ((execute_IS_DIV && execute_RS1[31]) && execute_IS_RS1_SIGNED));
  always @ (*) begin
    _zz_506_[32] = (execute_IS_RS1_SIGNED && execute_RS1[31]);
    _zz_506_[31 : 0] = execute_RS1;
  end

  assign _zz_508_ = (_zz_507_ & externalInterruptArray_regNext);
  assign externalInterrupt = (_zz_508_ != 32'h0);
  assign _zz_26_ = decode_BRANCH_CTRL;
  assign _zz_54_ = _zz_43_;
  assign _zz_30_ = decode_to_execute_BRANCH_CTRL;
  assign _zz_24_ = decode_ENV_CTRL;
  assign _zz_21_ = execute_ENV_CTRL;
  assign _zz_19_ = memory_ENV_CTRL;
  assign _zz_22_ = _zz_44_;
  assign _zz_28_ = decode_to_execute_ENV_CTRL;
  assign _zz_27_ = execute_to_memory_ENV_CTRL;
  assign _zz_29_ = memory_to_writeBack_ENV_CTRL;
  assign _zz_17_ = decode_ALU_CTRL;
  assign _zz_15_ = _zz_47_;
  assign _zz_38_ = decode_to_execute_ALU_CTRL;
  assign _zz_14_ = decode_SHIFT_CTRL;
  assign _zz_11_ = execute_SHIFT_CTRL;
  assign _zz_12_ = _zz_46_;
  assign _zz_34_ = decode_to_execute_SHIFT_CTRL;
  assign _zz_33_ = execute_to_memory_SHIFT_CTRL;
  assign _zz_9_ = decode_SRC1_CTRL;
  assign _zz_7_ = _zz_49_;
  assign _zz_37_ = decode_to_execute_SRC1_CTRL;
  assign _zz_6_ = decode_ALU_BITWISE_CTRL;
  assign _zz_4_ = _zz_45_;
  assign _zz_39_ = decode_to_execute_ALU_BITWISE_CTRL;
  assign _zz_3_ = decode_SRC2_CTRL;
  assign _zz_1_ = _zz_48_;
  assign _zz_36_ = decode_to_execute_SRC2_CTRL;
  assign decode_arbitration_isFlushed = (({writeBack_arbitration_flushNext,{memory_arbitration_flushNext,execute_arbitration_flushNext}} != (3'b000)) || ({writeBack_arbitration_flushIt,{memory_arbitration_flushIt,{execute_arbitration_flushIt,decode_arbitration_flushIt}}} != (4'b0000)));
  assign execute_arbitration_isFlushed = (({writeBack_arbitration_flushNext,memory_arbitration_flushNext} != (2'b00)) || ({writeBack_arbitration_flushIt,{memory_arbitration_flushIt,execute_arbitration_flushIt}} != (3'b000)));
  assign memory_arbitration_isFlushed = ((writeBack_arbitration_flushNext != (1'b0)) || ({writeBack_arbitration_flushIt,memory_arbitration_flushIt} != (2'b00)));
  assign writeBack_arbitration_isFlushed = (1'b0 || (writeBack_arbitration_flushIt != (1'b0)));
  assign decode_arbitration_isStuckByOthers = (decode_arbitration_haltByOther || (((1'b0 || execute_arbitration_isStuck) || memory_arbitration_isStuck) || writeBack_arbitration_isStuck));
  assign decode_arbitration_isStuck = (decode_arbitration_haltItself || decode_arbitration_isStuckByOthers);
  assign decode_arbitration_isMoving = ((! decode_arbitration_isStuck) && (! decode_arbitration_removeIt));
  assign decode_arbitration_isFiring = ((decode_arbitration_isValid && (! decode_arbitration_isStuck)) && (! decode_arbitration_removeIt));
  assign execute_arbitration_isStuckByOthers = (execute_arbitration_haltByOther || ((1'b0 || memory_arbitration_isStuck) || writeBack_arbitration_isStuck));
  assign execute_arbitration_isStuck = (execute_arbitration_haltItself || execute_arbitration_isStuckByOthers);
  assign execute_arbitration_isMoving = ((! execute_arbitration_isStuck) && (! execute_arbitration_removeIt));
  assign execute_arbitration_isFiring = ((execute_arbitration_isValid && (! execute_arbitration_isStuck)) && (! execute_arbitration_removeIt));
  assign memory_arbitration_isStuckByOthers = (memory_arbitration_haltByOther || (1'b0 || writeBack_arbitration_isStuck));
  assign memory_arbitration_isStuck = (memory_arbitration_haltItself || memory_arbitration_isStuckByOthers);
  assign memory_arbitration_isMoving = ((! memory_arbitration_isStuck) && (! memory_arbitration_removeIt));
  assign memory_arbitration_isFiring = ((memory_arbitration_isValid && (! memory_arbitration_isStuck)) && (! memory_arbitration_removeIt));
  assign writeBack_arbitration_isStuckByOthers = (writeBack_arbitration_haltByOther || 1'b0);
  assign writeBack_arbitration_isStuck = (writeBack_arbitration_haltItself || writeBack_arbitration_isStuckByOthers);
  assign writeBack_arbitration_isMoving = ((! writeBack_arbitration_isStuck) && (! writeBack_arbitration_removeIt));
  assign writeBack_arbitration_isFiring = ((writeBack_arbitration_isValid && (! writeBack_arbitration_isStuck)) && (! writeBack_arbitration_removeIt));
  always @ (*) begin
    _zz_509_ = 32'h0;
    if(execute_CsrPlugin_csr_3264)begin
      _zz_509_[12 : 0] = 13'h1000;
      _zz_509_[25 : 20] = 6'h20;
    end
  end

  always @ (*) begin
    _zz_510_ = 32'h0;
    if(execute_CsrPlugin_csr_944)begin
      _zz_510_[31 : 0] = _zz_94_;
    end
  end

  always @ (*) begin
    _zz_511_ = 32'h0;
    if(execute_CsrPlugin_csr_945)begin
      _zz_511_[31 : 0] = _zz_110_;
    end
  end

  always @ (*) begin
    _zz_512_ = 32'h0;
    if(execute_CsrPlugin_csr_946)begin
      _zz_512_[31 : 0] = _zz_126_;
    end
  end

  always @ (*) begin
    _zz_513_ = 32'h0;
    if(execute_CsrPlugin_csr_947)begin
      _zz_513_[31 : 0] = _zz_142_;
    end
  end

  always @ (*) begin
    _zz_514_ = 32'h0;
    if(execute_CsrPlugin_csr_948)begin
      _zz_514_[31 : 0] = _zz_158_;
    end
  end

  always @ (*) begin
    _zz_515_ = 32'h0;
    if(execute_CsrPlugin_csr_949)begin
      _zz_515_[31 : 0] = _zz_174_;
    end
  end

  always @ (*) begin
    _zz_516_ = 32'h0;
    if(execute_CsrPlugin_csr_950)begin
      _zz_516_[31 : 0] = _zz_190_;
    end
  end

  always @ (*) begin
    _zz_517_ = 32'h0;
    if(execute_CsrPlugin_csr_951)begin
      _zz_517_[31 : 0] = _zz_206_;
    end
  end

  always @ (*) begin
    _zz_518_ = 32'h0;
    if(execute_CsrPlugin_csr_952)begin
      _zz_518_[31 : 0] = _zz_222_;
    end
  end

  always @ (*) begin
    _zz_519_ = 32'h0;
    if(execute_CsrPlugin_csr_953)begin
      _zz_519_[31 : 0] = _zz_238_;
    end
  end

  always @ (*) begin
    _zz_520_ = 32'h0;
    if(execute_CsrPlugin_csr_954)begin
      _zz_520_[31 : 0] = _zz_254_;
    end
  end

  always @ (*) begin
    _zz_521_ = 32'h0;
    if(execute_CsrPlugin_csr_955)begin
      _zz_521_[31 : 0] = _zz_270_;
    end
  end

  always @ (*) begin
    _zz_522_ = 32'h0;
    if(execute_CsrPlugin_csr_956)begin
      _zz_522_[31 : 0] = _zz_286_;
    end
  end

  always @ (*) begin
    _zz_523_ = 32'h0;
    if(execute_CsrPlugin_csr_957)begin
      _zz_523_[31 : 0] = _zz_302_;
    end
  end

  always @ (*) begin
    _zz_524_ = 32'h0;
    if(execute_CsrPlugin_csr_958)begin
      _zz_524_[31 : 0] = _zz_318_;
    end
  end

  always @ (*) begin
    _zz_525_ = 32'h0;
    if(execute_CsrPlugin_csr_959)begin
      _zz_525_[31 : 0] = _zz_334_;
    end
  end

  always @ (*) begin
    _zz_526_ = 32'h0;
    if(execute_CsrPlugin_csr_928)begin
      _zz_526_[31 : 31] = _zz_140_;
      _zz_526_[23 : 23] = _zz_124_;
      _zz_526_[15 : 15] = _zz_108_;
      _zz_526_[7 : 7] = _zz_92_;
      _zz_526_[28 : 27] = _zz_141_;
      _zz_526_[26 : 26] = _zz_139_;
      _zz_526_[25 : 25] = _zz_138_;
      _zz_526_[24 : 24] = _zz_137_;
      _zz_526_[20 : 19] = _zz_125_;
      _zz_526_[18 : 18] = _zz_123_;
      _zz_526_[17 : 17] = _zz_122_;
      _zz_526_[16 : 16] = _zz_121_;
      _zz_526_[12 : 11] = _zz_109_;
      _zz_526_[10 : 10] = _zz_107_;
      _zz_526_[9 : 9] = _zz_106_;
      _zz_526_[8 : 8] = _zz_105_;
      _zz_526_[4 : 3] = _zz_93_;
      _zz_526_[2 : 2] = _zz_91_;
      _zz_526_[1 : 1] = _zz_90_;
      _zz_526_[0 : 0] = _zz_89_;
    end
  end

  always @ (*) begin
    _zz_527_ = 32'h0;
    if(execute_CsrPlugin_csr_929)begin
      _zz_527_[31 : 31] = _zz_204_;
      _zz_527_[23 : 23] = _zz_188_;
      _zz_527_[15 : 15] = _zz_172_;
      _zz_527_[7 : 7] = _zz_156_;
      _zz_527_[28 : 27] = _zz_205_;
      _zz_527_[26 : 26] = _zz_203_;
      _zz_527_[25 : 25] = _zz_202_;
      _zz_527_[24 : 24] = _zz_201_;
      _zz_527_[20 : 19] = _zz_189_;
      _zz_527_[18 : 18] = _zz_187_;
      _zz_527_[17 : 17] = _zz_186_;
      _zz_527_[16 : 16] = _zz_185_;
      _zz_527_[12 : 11] = _zz_173_;
      _zz_527_[10 : 10] = _zz_171_;
      _zz_527_[9 : 9] = _zz_170_;
      _zz_527_[8 : 8] = _zz_169_;
      _zz_527_[4 : 3] = _zz_157_;
      _zz_527_[2 : 2] = _zz_155_;
      _zz_527_[1 : 1] = _zz_154_;
      _zz_527_[0 : 0] = _zz_153_;
    end
  end

  always @ (*) begin
    _zz_528_ = 32'h0;
    if(execute_CsrPlugin_csr_930)begin
      _zz_528_[31 : 31] = _zz_268_;
      _zz_528_[23 : 23] = _zz_252_;
      _zz_528_[15 : 15] = _zz_236_;
      _zz_528_[7 : 7] = _zz_220_;
      _zz_528_[28 : 27] = _zz_269_;
      _zz_528_[26 : 26] = _zz_267_;
      _zz_528_[25 : 25] = _zz_266_;
      _zz_528_[24 : 24] = _zz_265_;
      _zz_528_[20 : 19] = _zz_253_;
      _zz_528_[18 : 18] = _zz_251_;
      _zz_528_[17 : 17] = _zz_250_;
      _zz_528_[16 : 16] = _zz_249_;
      _zz_528_[12 : 11] = _zz_237_;
      _zz_528_[10 : 10] = _zz_235_;
      _zz_528_[9 : 9] = _zz_234_;
      _zz_528_[8 : 8] = _zz_233_;
      _zz_528_[4 : 3] = _zz_221_;
      _zz_528_[2 : 2] = _zz_219_;
      _zz_528_[1 : 1] = _zz_218_;
      _zz_528_[0 : 0] = _zz_217_;
    end
  end

  always @ (*) begin
    _zz_529_ = 32'h0;
    if(execute_CsrPlugin_csr_931)begin
      _zz_529_[31 : 31] = _zz_332_;
      _zz_529_[23 : 23] = _zz_316_;
      _zz_529_[15 : 15] = _zz_300_;
      _zz_529_[7 : 7] = _zz_284_;
      _zz_529_[28 : 27] = _zz_333_;
      _zz_529_[26 : 26] = _zz_331_;
      _zz_529_[25 : 25] = _zz_330_;
      _zz_529_[24 : 24] = _zz_329_;
      _zz_529_[20 : 19] = _zz_317_;
      _zz_529_[18 : 18] = _zz_315_;
      _zz_529_[17 : 17] = _zz_314_;
      _zz_529_[16 : 16] = _zz_313_;
      _zz_529_[12 : 11] = _zz_301_;
      _zz_529_[10 : 10] = _zz_299_;
      _zz_529_[9 : 9] = _zz_298_;
      _zz_529_[8 : 8] = _zz_297_;
      _zz_529_[4 : 3] = _zz_285_;
      _zz_529_[2 : 2] = _zz_283_;
      _zz_529_[1 : 1] = _zz_282_;
      _zz_529_[0 : 0] = _zz_281_;
    end
  end

  always @ (*) begin
    _zz_530_ = 32'h0;
    if(execute_CsrPlugin_csr_3857)begin
      _zz_530_[0 : 0] = (1'b1);
    end
  end

  always @ (*) begin
    _zz_531_ = 32'h0;
    if(execute_CsrPlugin_csr_3858)begin
      _zz_531_[1 : 0] = (2'b10);
    end
  end

  always @ (*) begin
    _zz_532_ = 32'h0;
    if(execute_CsrPlugin_csr_3859)begin
      _zz_532_[1 : 0] = (2'b11);
    end
  end

  always @ (*) begin
    _zz_533_ = 32'h0;
    if(execute_CsrPlugin_csr_769)begin
      _zz_533_[31 : 30] = CsrPlugin_misa_base;
      _zz_533_[25 : 0] = CsrPlugin_misa_extensions;
    end
  end

  always @ (*) begin
    _zz_534_ = 32'h0;
    if(execute_CsrPlugin_csr_768)begin
      _zz_534_[12 : 11] = CsrPlugin_mstatus_MPP;
      _zz_534_[7 : 7] = CsrPlugin_mstatus_MPIE;
      _zz_534_[3 : 3] = CsrPlugin_mstatus_MIE;
    end
  end

  always @ (*) begin
    _zz_535_ = 32'h0;
    if(execute_CsrPlugin_csr_836)begin
      _zz_535_[11 : 11] = CsrPlugin_mip_MEIP;
      _zz_535_[7 : 7] = CsrPlugin_mip_MTIP;
      _zz_535_[3 : 3] = CsrPlugin_mip_MSIP;
    end
  end

  always @ (*) begin
    _zz_536_ = 32'h0;
    if(execute_CsrPlugin_csr_772)begin
      _zz_536_[11 : 11] = CsrPlugin_mie_MEIE;
      _zz_536_[7 : 7] = CsrPlugin_mie_MTIE;
      _zz_536_[3 : 3] = CsrPlugin_mie_MSIE;
    end
  end

  always @ (*) begin
    _zz_537_ = 32'h0;
    if(execute_CsrPlugin_csr_773)begin
      _zz_537_[31 : 2] = CsrPlugin_mtvec_base;
      _zz_537_[1 : 0] = CsrPlugin_mtvec_mode;
    end
  end

  always @ (*) begin
    _zz_538_ = 32'h0;
    if(execute_CsrPlugin_csr_833)begin
      _zz_538_[31 : 0] = CsrPlugin_mepc;
    end
  end

  always @ (*) begin
    _zz_539_ = 32'h0;
    if(execute_CsrPlugin_csr_832)begin
      _zz_539_[31 : 0] = CsrPlugin_mscratch;
    end
  end

  always @ (*) begin
    _zz_540_ = 32'h0;
    if(execute_CsrPlugin_csr_834)begin
      _zz_540_[31 : 31] = CsrPlugin_mcause_interrupt;
      _zz_540_[3 : 0] = CsrPlugin_mcause_exceptionCode;
    end
  end

  always @ (*) begin
    _zz_541_ = 32'h0;
    if(execute_CsrPlugin_csr_835)begin
      _zz_541_[31 : 0] = CsrPlugin_mtval;
    end
  end

  always @ (*) begin
    _zz_542_ = 32'h0;
    if(execute_CsrPlugin_csr_2816)begin
      _zz_542_[31 : 0] = CsrPlugin_mcycle[31 : 0];
    end
  end

  always @ (*) begin
    _zz_543_ = 32'h0;
    if(execute_CsrPlugin_csr_2944)begin
      _zz_543_[31 : 0] = CsrPlugin_mcycle[63 : 32];
    end
  end

  always @ (*) begin
    _zz_544_ = 32'h0;
    if(execute_CsrPlugin_csr_2818)begin
      _zz_544_[31 : 0] = CsrPlugin_minstret[31 : 0];
    end
  end

  always @ (*) begin
    _zz_545_ = 32'h0;
    if(execute_CsrPlugin_csr_2946)begin
      _zz_545_[31 : 0] = CsrPlugin_minstret[63 : 32];
    end
  end

  always @ (*) begin
    _zz_546_ = 32'h0;
    if(execute_CsrPlugin_csr_3072)begin
      _zz_546_[31 : 0] = CsrPlugin_mcycle[31 : 0];
    end
  end

  always @ (*) begin
    _zz_547_ = 32'h0;
    if(execute_CsrPlugin_csr_3200)begin
      _zz_547_[31 : 0] = CsrPlugin_mcycle[63 : 32];
    end
  end

  always @ (*) begin
    _zz_548_ = 32'h0;
    if(execute_CsrPlugin_csr_3074)begin
      _zz_548_[31 : 0] = CsrPlugin_minstret[31 : 0];
    end
  end

  always @ (*) begin
    _zz_549_ = 32'h0;
    if(execute_CsrPlugin_csr_3202)begin
      _zz_549_[31 : 0] = CsrPlugin_minstret[63 : 32];
    end
  end

  always @ (*) begin
    _zz_550_ = 32'h0;
    if(execute_CsrPlugin_csr_3008)begin
      _zz_550_[31 : 0] = _zz_507_;
    end
  end

  always @ (*) begin
    _zz_551_ = 32'h0;
    if(execute_CsrPlugin_csr_4032)begin
      _zz_551_[31 : 0] = _zz_508_;
    end
  end

  assign execute_CsrPlugin_readData = (((((_zz_1061_ | _zz_1062_) | (_zz_1063_ | _zz_1064_)) | ((_zz_1065_ | _zz_1066_) | (_zz_1067_ | _zz_1068_))) | (((_zz_1069_ | _zz_1070_) | (_zz_1071_ | _zz_1072_)) | ((_zz_1073_ | _zz_1074_) | (_zz_1075_ | _zz_1076_)))) | ((((_zz_540_ | _zz_541_) | (_zz_542_ | _zz_543_)) | ((_zz_544_ | _zz_545_) | (_zz_546_ | _zz_547_))) | ((_zz_548_ | _zz_549_) | (_zz_550_ | _zz_551_))));
  assign iBusWishbone_ADR = {_zz_853_,_zz_552_};
  assign iBusWishbone_CTI = ((_zz_552_ == (3'b111)) ? (3'b111) : (3'b010));
  assign iBusWishbone_BTE = (2'b00);
  assign iBusWishbone_SEL = (4'b1111);
  assign iBusWishbone_WE = 1'b0;
  assign iBusWishbone_DAT_MOSI = 32'h0;
  always @ (*) begin
    iBusWishbone_CYC = 1'b0;
    if(_zz_618_)begin
      iBusWishbone_CYC = 1'b1;
    end
  end

  always @ (*) begin
    iBusWishbone_STB = 1'b0;
    if(_zz_618_)begin
      iBusWishbone_STB = 1'b1;
    end
  end

  assign iBus_cmd_ready = (iBus_cmd_valid && iBusWishbone_ACK);
  assign iBus_rsp_valid = _zz_553_;
  assign iBus_rsp_payload_data = iBusWishbone_DAT_MISO_regNext;
  assign iBus_rsp_payload_error = 1'b0;
  assign _zz_559_ = (dBus_cmd_payload_length != (3'b000));
  assign _zz_555_ = dBus_cmd_valid;
  assign _zz_557_ = dBus_cmd_payload_wr;
  assign _zz_558_ = (_zz_554_ == dBus_cmd_payload_length);
  assign dBus_cmd_ready = (_zz_556_ && (_zz_557_ || _zz_558_));
  assign dBusWishbone_ADR = ((_zz_559_ ? {{dBus_cmd_payload_address[31 : 5],_zz_554_},(2'b00)} : {dBus_cmd_payload_address[31 : 2],(2'b00)}) >>> 2);
  assign dBusWishbone_CTI = (_zz_559_ ? (_zz_558_ ? (3'b111) : (3'b010)) : (3'b000));
  assign dBusWishbone_BTE = (2'b00);
  assign dBusWishbone_SEL = (_zz_557_ ? dBus_cmd_payload_mask : (4'b1111));
  assign dBusWishbone_WE = _zz_557_;
  assign dBusWishbone_DAT_MOSI = dBus_cmd_payload_data;
  assign _zz_556_ = (_zz_555_ && dBusWishbone_ACK);
  assign dBusWishbone_CYC = _zz_555_;
  assign dBusWishbone_STB = _zz_555_;
  assign dBus_rsp_valid = _zz_560_;
  assign dBus_rsp_payload_data = dBusWishbone_DAT_MISO_regNext;
  assign dBus_rsp_payload_error = 1'b0;
  always @ (posedge clk) begin
    if(reset) begin
      IBusCachedPlugin_fetchPc_pcReg <= externalResetVector;
      IBusCachedPlugin_fetchPc_correctionReg <= 1'b0;
      IBusCachedPlugin_fetchPc_booted <= 1'b0;
      IBusCachedPlugin_fetchPc_inc <= 1'b0;
      _zz_67_ <= 1'b0;
      _zz_69_ <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_0 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_4 <= 1'b0;
      IBusCachedPlugin_rspCounter <= _zz_82_;
      IBusCachedPlugin_rspCounter <= 32'h0;
      dataCache_1__io_mem_cmd_s2mPipe_rValid <= 1'b0;
      dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rValid <= 1'b0;
      DBusCachedPlugin_rspCounter <= _zz_83_;
      DBusCachedPlugin_rspCounter <= 32'h0;
      _zz_92_ <= 1'b0;
      _zz_93_ <= (2'b00);
      _zz_98_ <= 1'b0;
      _zz_99_ <= 1'b0;
      _zz_108_ <= 1'b0;
      _zz_109_ <= (2'b00);
      _zz_114_ <= 1'b0;
      _zz_115_ <= 1'b0;
      _zz_124_ <= 1'b0;
      _zz_125_ <= (2'b00);
      _zz_130_ <= 1'b0;
      _zz_131_ <= 1'b0;
      _zz_140_ <= 1'b0;
      _zz_141_ <= (2'b00);
      _zz_146_ <= 1'b0;
      _zz_147_ <= 1'b0;
      _zz_156_ <= 1'b0;
      _zz_157_ <= (2'b00);
      _zz_162_ <= 1'b0;
      _zz_163_ <= 1'b0;
      _zz_172_ <= 1'b0;
      _zz_173_ <= (2'b00);
      _zz_178_ <= 1'b0;
      _zz_179_ <= 1'b0;
      _zz_188_ <= 1'b0;
      _zz_189_ <= (2'b00);
      _zz_194_ <= 1'b0;
      _zz_195_ <= 1'b0;
      _zz_204_ <= 1'b0;
      _zz_205_ <= (2'b00);
      _zz_210_ <= 1'b0;
      _zz_211_ <= 1'b0;
      _zz_220_ <= 1'b0;
      _zz_221_ <= (2'b00);
      _zz_226_ <= 1'b0;
      _zz_227_ <= 1'b0;
      _zz_236_ <= 1'b0;
      _zz_237_ <= (2'b00);
      _zz_242_ <= 1'b0;
      _zz_243_ <= 1'b0;
      _zz_252_ <= 1'b0;
      _zz_253_ <= (2'b00);
      _zz_258_ <= 1'b0;
      _zz_259_ <= 1'b0;
      _zz_268_ <= 1'b0;
      _zz_269_ <= (2'b00);
      _zz_274_ <= 1'b0;
      _zz_275_ <= 1'b0;
      _zz_284_ <= 1'b0;
      _zz_285_ <= (2'b00);
      _zz_290_ <= 1'b0;
      _zz_291_ <= 1'b0;
      _zz_300_ <= 1'b0;
      _zz_301_ <= (2'b00);
      _zz_306_ <= 1'b0;
      _zz_307_ <= 1'b0;
      _zz_316_ <= 1'b0;
      _zz_317_ <= (2'b00);
      _zz_322_ <= 1'b0;
      _zz_323_ <= 1'b0;
      _zz_332_ <= 1'b0;
      _zz_333_ <= (2'b00);
      _zz_338_ <= 1'b0;
      _zz_339_ <= 1'b0;
      _zz_459_ <= 1'b1;
      _zz_471_ <= 1'b0;
      _zz_496_ <= (2'b11);
      CsrPlugin_misa_base <= (2'b01);
      CsrPlugin_misa_extensions <= 26'h0101064;
      CsrPlugin_mstatus_MIE <= 1'b0;
      CsrPlugin_mstatus_MPIE <= 1'b0;
      CsrPlugin_mstatus_MPP <= (2'b11);
      CsrPlugin_mie_MEIE <= 1'b0;
      CsrPlugin_mie_MTIE <= 1'b0;
      CsrPlugin_mie_MSIE <= 1'b0;
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode <= 1'b0;
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute <= 1'b0;
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory <= 1'b0;
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack <= 1'b0;
      CsrPlugin_interrupt_valid <= 1'b0;
      CsrPlugin_lastStageWasWfi <= 1'b0;
      CsrPlugin_pipelineLiberator_pcValids_0 <= 1'b0;
      CsrPlugin_pipelineLiberator_pcValids_1 <= 1'b0;
      CsrPlugin_pipelineLiberator_pcValids_2 <= 1'b0;
      CsrPlugin_hadException <= 1'b0;
      execute_CsrPlugin_wfiWake <= 1'b0;
      memory_DivPlugin_div_counter_value <= 6'h0;
      _zz_507_ <= 32'h0;
      execute_arbitration_isValid <= 1'b0;
      memory_arbitration_isValid <= 1'b0;
      writeBack_arbitration_isValid <= 1'b0;
      memory_to_writeBack_REGFILE_WRITE_DATA <= 32'h0;
      memory_to_writeBack_INSTRUCTION <= 32'h0;
      _zz_552_ <= (3'b000);
      _zz_553_ <= 1'b0;
      _zz_554_ <= (3'b000);
      _zz_560_ <= 1'b0;
    end else begin
      if(IBusCachedPlugin_fetchPc_correction)begin
        IBusCachedPlugin_fetchPc_correctionReg <= 1'b1;
      end
      if((IBusCachedPlugin_fetchPc_output_valid && IBusCachedPlugin_fetchPc_output_ready))begin
        IBusCachedPlugin_fetchPc_correctionReg <= 1'b0;
      end
      IBusCachedPlugin_fetchPc_booted <= 1'b1;
      if((IBusCachedPlugin_fetchPc_correction || IBusCachedPlugin_fetchPc_pcRegPropagate))begin
        IBusCachedPlugin_fetchPc_inc <= 1'b0;
      end
      if((IBusCachedPlugin_fetchPc_output_valid && IBusCachedPlugin_fetchPc_output_ready))begin
        IBusCachedPlugin_fetchPc_inc <= 1'b1;
      end
      if(((! IBusCachedPlugin_fetchPc_output_valid) && IBusCachedPlugin_fetchPc_output_ready))begin
        IBusCachedPlugin_fetchPc_inc <= 1'b0;
      end
      if((IBusCachedPlugin_fetchPc_booted && ((IBusCachedPlugin_fetchPc_output_ready || IBusCachedPlugin_fetchPc_correction) || IBusCachedPlugin_fetchPc_pcRegPropagate)))begin
        IBusCachedPlugin_fetchPc_pcReg <= IBusCachedPlugin_fetchPc_pc;
      end
      if(IBusCachedPlugin_iBusRsp_flush)begin
        _zz_67_ <= 1'b0;
      end
      if(_zz_65_)begin
        _zz_67_ <= (IBusCachedPlugin_iBusRsp_stages_0_output_valid && (! 1'b0));
      end
      if(IBusCachedPlugin_iBusRsp_flush)begin
        _zz_69_ <= 1'b0;
      end
      if(IBusCachedPlugin_iBusRsp_stages_1_output_ready)begin
        _zz_69_ <= (IBusCachedPlugin_iBusRsp_stages_1_output_valid && (! IBusCachedPlugin_iBusRsp_flush));
      end
      if(IBusCachedPlugin_fetchPc_flushed)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_0 <= 1'b0;
      end
      if((! (! IBusCachedPlugin_iBusRsp_stages_1_input_ready)))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_0 <= 1'b1;
      end
      if(IBusCachedPlugin_fetchPc_flushed)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      end
      if((! (! IBusCachedPlugin_iBusRsp_stages_2_input_ready)))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_1 <= IBusCachedPlugin_injector_nextPcCalc_valids_0;
      end
      if(IBusCachedPlugin_fetchPc_flushed)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      end
      if(IBusCachedPlugin_fetchPc_flushed)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      end
      if((! execute_arbitration_isStuck))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_2 <= IBusCachedPlugin_injector_nextPcCalc_valids_1;
      end
      if(IBusCachedPlugin_fetchPc_flushed)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      end
      if(IBusCachedPlugin_fetchPc_flushed)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      end
      if((! memory_arbitration_isStuck))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_3 <= IBusCachedPlugin_injector_nextPcCalc_valids_2;
      end
      if(IBusCachedPlugin_fetchPc_flushed)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      end
      if(IBusCachedPlugin_fetchPc_flushed)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_4 <= 1'b0;
      end
      if((! writeBack_arbitration_isStuck))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_4 <= IBusCachedPlugin_injector_nextPcCalc_valids_3;
      end
      if(IBusCachedPlugin_fetchPc_flushed)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_4 <= 1'b0;
      end
      if(iBus_rsp_valid)begin
        IBusCachedPlugin_rspCounter <= (IBusCachedPlugin_rspCounter + 32'h00000001);
      end
      if(dataCache_1__io_mem_cmd_s2mPipe_ready)begin
        dataCache_1__io_mem_cmd_s2mPipe_rValid <= 1'b0;
      end
      if(_zz_619_)begin
        dataCache_1__io_mem_cmd_s2mPipe_rValid <= dataCache_1__io_mem_cmd_valid;
      end
      if(dataCache_1__io_mem_cmd_s2mPipe_ready)begin
        dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rValid <= dataCache_1__io_mem_cmd_s2mPipe_valid;
      end
      if(dBus_rsp_valid)begin
        DBusCachedPlugin_rspCounter <= (DBusCachedPlugin_rspCounter + 32'h00000001);
      end
      if(_zz_620_)begin
        _zz_98_ <= _zz_92_;
        _zz_99_ <= 1'b1;
        case(_zz_93_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_99_ <= 1'b0;
          end
        endcase
      end
      if(_zz_621_)begin
        _zz_114_ <= _zz_108_;
        _zz_115_ <= 1'b1;
        case(_zz_109_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_115_ <= 1'b0;
          end
        endcase
      end
      if(_zz_622_)begin
        _zz_130_ <= _zz_124_;
        _zz_131_ <= 1'b1;
        case(_zz_125_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_131_ <= 1'b0;
          end
        endcase
      end
      if(_zz_623_)begin
        _zz_146_ <= _zz_140_;
        _zz_147_ <= 1'b1;
        case(_zz_141_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_147_ <= 1'b0;
          end
        endcase
      end
      if(_zz_624_)begin
        _zz_162_ <= _zz_156_;
        _zz_163_ <= 1'b1;
        case(_zz_157_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_163_ <= 1'b0;
          end
        endcase
      end
      if(_zz_625_)begin
        _zz_178_ <= _zz_172_;
        _zz_179_ <= 1'b1;
        case(_zz_173_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_179_ <= 1'b0;
          end
        endcase
      end
      if(_zz_626_)begin
        _zz_194_ <= _zz_188_;
        _zz_195_ <= 1'b1;
        case(_zz_189_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_195_ <= 1'b0;
          end
        endcase
      end
      if(_zz_627_)begin
        _zz_210_ <= _zz_204_;
        _zz_211_ <= 1'b1;
        case(_zz_205_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_211_ <= 1'b0;
          end
        endcase
      end
      if(_zz_628_)begin
        _zz_226_ <= _zz_220_;
        _zz_227_ <= 1'b1;
        case(_zz_221_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_227_ <= 1'b0;
          end
        endcase
      end
      if(_zz_629_)begin
        _zz_242_ <= _zz_236_;
        _zz_243_ <= 1'b1;
        case(_zz_237_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_243_ <= 1'b0;
          end
        endcase
      end
      if(_zz_630_)begin
        _zz_258_ <= _zz_252_;
        _zz_259_ <= 1'b1;
        case(_zz_253_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_259_ <= 1'b0;
          end
        endcase
      end
      if(_zz_631_)begin
        _zz_274_ <= _zz_268_;
        _zz_275_ <= 1'b1;
        case(_zz_269_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_275_ <= 1'b0;
          end
        endcase
      end
      if(_zz_632_)begin
        _zz_290_ <= _zz_284_;
        _zz_291_ <= 1'b1;
        case(_zz_285_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_291_ <= 1'b0;
          end
        endcase
      end
      if(_zz_633_)begin
        _zz_306_ <= _zz_300_;
        _zz_307_ <= 1'b1;
        case(_zz_301_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_307_ <= 1'b0;
          end
        endcase
      end
      if(_zz_634_)begin
        _zz_322_ <= _zz_316_;
        _zz_323_ <= 1'b1;
        case(_zz_317_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_323_ <= 1'b0;
          end
        endcase
      end
      if(_zz_635_)begin
        _zz_338_ <= _zz_332_;
        _zz_339_ <= 1'b1;
        case(_zz_333_)
          2'b01 : begin
          end
          2'b10 : begin
          end
          2'b11 : begin
          end
          default : begin
            _zz_339_ <= 1'b0;
          end
        endcase
      end
      _zz_459_ <= 1'b0;
      _zz_471_ <= (_zz_41_ && writeBack_arbitration_isFiring);
      if((! decode_arbitration_isStuck))begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode <= 1'b0;
      end else begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode <= CsrPlugin_exceptionPortCtrl_exceptionValids_decode;
      end
      if((! execute_arbitration_isStuck))begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute <= (CsrPlugin_exceptionPortCtrl_exceptionValids_decode && (! decode_arbitration_isStuck));
      end else begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute <= CsrPlugin_exceptionPortCtrl_exceptionValids_execute;
      end
      if((! memory_arbitration_isStuck))begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory <= (CsrPlugin_exceptionPortCtrl_exceptionValids_execute && (! execute_arbitration_isStuck));
      end else begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory <= CsrPlugin_exceptionPortCtrl_exceptionValids_memory;
      end
      if((! writeBack_arbitration_isStuck))begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack <= (CsrPlugin_exceptionPortCtrl_exceptionValids_memory && (! memory_arbitration_isStuck));
      end else begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack <= 1'b0;
      end
      CsrPlugin_interrupt_valid <= 1'b0;
      if(_zz_636_)begin
        if(_zz_637_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
        if(_zz_638_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
        if(_zz_639_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
      end
      CsrPlugin_lastStageWasWfi <= (writeBack_arbitration_isFiring && (writeBack_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_WFI));
      if(CsrPlugin_pipelineLiberator_active)begin
        if((! execute_arbitration_isStuck))begin
          CsrPlugin_pipelineLiberator_pcValids_0 <= 1'b1;
        end
        if((! memory_arbitration_isStuck))begin
          CsrPlugin_pipelineLiberator_pcValids_1 <= CsrPlugin_pipelineLiberator_pcValids_0;
        end
        if((! writeBack_arbitration_isStuck))begin
          CsrPlugin_pipelineLiberator_pcValids_2 <= CsrPlugin_pipelineLiberator_pcValids_1;
        end
      end
      if(((! CsrPlugin_pipelineLiberator_active) || decode_arbitration_removeIt))begin
        CsrPlugin_pipelineLiberator_pcValids_0 <= 1'b0;
        CsrPlugin_pipelineLiberator_pcValids_1 <= 1'b0;
        CsrPlugin_pipelineLiberator_pcValids_2 <= 1'b0;
      end
      if(CsrPlugin_interruptJump)begin
        CsrPlugin_interrupt_valid <= 1'b0;
      end
      CsrPlugin_hadException <= CsrPlugin_exception;
      if(_zz_600_)begin
        _zz_496_ <= CsrPlugin_targetPrivilege;
        case(CsrPlugin_targetPrivilege)
          2'b11 : begin
            CsrPlugin_mstatus_MIE <= 1'b0;
            CsrPlugin_mstatus_MPIE <= CsrPlugin_mstatus_MIE;
            CsrPlugin_mstatus_MPP <= CsrPlugin_privilege;
          end
          default : begin
          end
        endcase
      end
      if(_zz_601_)begin
        case(_zz_602_)
          2'b11 : begin
            CsrPlugin_mstatus_MPP <= (2'b00);
            CsrPlugin_mstatus_MIE <= CsrPlugin_mstatus_MPIE;
            CsrPlugin_mstatus_MPIE <= 1'b1;
            _zz_496_ <= CsrPlugin_mstatus_MPP;
          end
          default : begin
          end
        endcase
      end
      execute_CsrPlugin_wfiWake <= (({_zz_499_,{_zz_498_,_zz_497_}} != (3'b000)) || CsrPlugin_thirdPartyWake);
      memory_DivPlugin_div_counter_value <= memory_DivPlugin_div_counter_valueNext;
      if((! writeBack_arbitration_isStuck))begin
        memory_to_writeBack_INSTRUCTION <= memory_INSTRUCTION;
      end
      if((! writeBack_arbitration_isStuck))begin
        memory_to_writeBack_REGFILE_WRITE_DATA <= _zz_32_;
      end
      if(((! execute_arbitration_isStuck) || execute_arbitration_removeIt))begin
        execute_arbitration_isValid <= 1'b0;
      end
      if(((! decode_arbitration_isStuck) && (! decode_arbitration_removeIt)))begin
        execute_arbitration_isValid <= decode_arbitration_isValid;
      end
      if(((! memory_arbitration_isStuck) || memory_arbitration_removeIt))begin
        memory_arbitration_isValid <= 1'b0;
      end
      if(((! execute_arbitration_isStuck) && (! execute_arbitration_removeIt)))begin
        memory_arbitration_isValid <= execute_arbitration_isValid;
      end
      if(((! writeBack_arbitration_isStuck) || writeBack_arbitration_removeIt))begin
        writeBack_arbitration_isValid <= 1'b0;
      end
      if(((! memory_arbitration_isStuck) && (! memory_arbitration_removeIt)))begin
        writeBack_arbitration_isValid <= memory_arbitration_isValid;
      end
      if(execute_CsrPlugin_csr_928)begin
        if(execute_CsrPlugin_writeEnable)begin
          _zz_140_ <= _zz_782_[0];
          _zz_124_ <= _zz_783_[0];
          _zz_108_ <= _zz_784_[0];
          _zz_92_ <= _zz_785_[0];
          _zz_141_ <= execute_CsrPlugin_writeData[28 : 27];
          _zz_125_ <= execute_CsrPlugin_writeData[20 : 19];
          _zz_109_ <= execute_CsrPlugin_writeData[12 : 11];
          _zz_93_ <= execute_CsrPlugin_writeData[4 : 3];
        end
      end
      if(execute_CsrPlugin_csr_929)begin
        if(execute_CsrPlugin_writeEnable)begin
          _zz_204_ <= _zz_798_[0];
          _zz_188_ <= _zz_799_[0];
          _zz_172_ <= _zz_800_[0];
          _zz_156_ <= _zz_801_[0];
          _zz_205_ <= execute_CsrPlugin_writeData[28 : 27];
          _zz_189_ <= execute_CsrPlugin_writeData[20 : 19];
          _zz_173_ <= execute_CsrPlugin_writeData[12 : 11];
          _zz_157_ <= execute_CsrPlugin_writeData[4 : 3];
        end
      end
      if(execute_CsrPlugin_csr_930)begin
        if(execute_CsrPlugin_writeEnable)begin
          _zz_268_ <= _zz_814_[0];
          _zz_252_ <= _zz_815_[0];
          _zz_236_ <= _zz_816_[0];
          _zz_220_ <= _zz_817_[0];
          _zz_269_ <= execute_CsrPlugin_writeData[28 : 27];
          _zz_253_ <= execute_CsrPlugin_writeData[20 : 19];
          _zz_237_ <= execute_CsrPlugin_writeData[12 : 11];
          _zz_221_ <= execute_CsrPlugin_writeData[4 : 3];
        end
      end
      if(execute_CsrPlugin_csr_931)begin
        if(execute_CsrPlugin_writeEnable)begin
          _zz_332_ <= _zz_830_[0];
          _zz_316_ <= _zz_831_[0];
          _zz_300_ <= _zz_832_[0];
          _zz_284_ <= _zz_833_[0];
          _zz_333_ <= execute_CsrPlugin_writeData[28 : 27];
          _zz_317_ <= execute_CsrPlugin_writeData[20 : 19];
          _zz_301_ <= execute_CsrPlugin_writeData[12 : 11];
          _zz_285_ <= execute_CsrPlugin_writeData[4 : 3];
        end
      end
      if(execute_CsrPlugin_csr_769)begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_misa_base <= execute_CsrPlugin_writeData[31 : 30];
          CsrPlugin_misa_extensions <= execute_CsrPlugin_writeData[25 : 0];
        end
      end
      if(execute_CsrPlugin_csr_768)begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_mstatus_MPP <= execute_CsrPlugin_writeData[12 : 11];
          CsrPlugin_mstatus_MPIE <= _zz_846_[0];
          CsrPlugin_mstatus_MIE <= _zz_847_[0];
        end
      end
      if(execute_CsrPlugin_csr_772)begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_mie_MEIE <= _zz_849_[0];
          CsrPlugin_mie_MTIE <= _zz_850_[0];
          CsrPlugin_mie_MSIE <= _zz_851_[0];
        end
      end
      if(execute_CsrPlugin_csr_3008)begin
        if(execute_CsrPlugin_writeEnable)begin
          _zz_507_ <= execute_CsrPlugin_writeData[31 : 0];
        end
      end
      if(_zz_618_)begin
        if(iBusWishbone_ACK)begin
          _zz_552_ <= (_zz_552_ + (3'b001));
        end
      end
      _zz_553_ <= (iBusWishbone_CYC && iBusWishbone_ACK);
      if((_zz_555_ && _zz_556_))begin
        _zz_554_ <= (_zz_554_ + (3'b001));
        if(_zz_558_)begin
          _zz_554_ <= (3'b000);
        end
      end
      _zz_560_ <= ((_zz_555_ && (! dBusWishbone_WE)) && dBusWishbone_ACK);
    end
  end

  always @ (posedge clk) begin
    if(IBusCachedPlugin_iBusRsp_stages_1_output_ready)begin
      _zz_70_ <= IBusCachedPlugin_iBusRsp_stages_1_output_payload;
    end
    if(IBusCachedPlugin_iBusRsp_stages_1_input_ready)begin
      IBusCachedPlugin_s1_tightlyCoupledHit <= IBusCachedPlugin_s0_tightlyCoupledHit;
    end
    if(IBusCachedPlugin_iBusRsp_stages_2_input_ready)begin
      IBusCachedPlugin_s2_tightlyCoupledHit <= IBusCachedPlugin_s1_tightlyCoupledHit;
    end
    if(_zz_619_)begin
      dataCache_1__io_mem_cmd_s2mPipe_rData_wr <= dataCache_1__io_mem_cmd_payload_wr;
      dataCache_1__io_mem_cmd_s2mPipe_rData_address <= dataCache_1__io_mem_cmd_payload_address;
      dataCache_1__io_mem_cmd_s2mPipe_rData_data <= dataCache_1__io_mem_cmd_payload_data;
      dataCache_1__io_mem_cmd_s2mPipe_rData_mask <= dataCache_1__io_mem_cmd_payload_mask;
      dataCache_1__io_mem_cmd_s2mPipe_rData_length <= dataCache_1__io_mem_cmd_payload_length;
      dataCache_1__io_mem_cmd_s2mPipe_rData_last <= dataCache_1__io_mem_cmd_payload_last;
    end
    if(dataCache_1__io_mem_cmd_s2mPipe_ready)begin
      dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_wr <= dataCache_1__io_mem_cmd_s2mPipe_payload_wr;
      dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_address <= dataCache_1__io_mem_cmd_s2mPipe_payload_address;
      dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_data <= dataCache_1__io_mem_cmd_s2mPipe_payload_data;
      dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_mask <= dataCache_1__io_mem_cmd_s2mPipe_payload_mask;
      dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_length <= dataCache_1__io_mem_cmd_s2mPipe_payload_length;
      dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rData_last <= dataCache_1__io_mem_cmd_s2mPipe_payload_last;
    end
    if(_zz_620_)begin
      _zz_95_ <= _zz_89_;
      _zz_96_ <= _zz_90_;
      _zz_97_ <= _zz_91_;
      case(_zz_93_)
        2'b01 : begin
          _zz_100_ <= 32'h0;
          _zz_101_ <= _zz_102_;
        end
        2'b10 : begin
          _zz_100_ <= _zz_102_;
          _zz_101_ <= (_zz_102_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_100_ <= _zz_104_;
          _zz_101_ <= (_zz_104_ + _zz_686_);
        end
        default : begin
          _zz_101_ <= _zz_102_;
        end
      endcase
    end
    if(_zz_621_)begin
      _zz_111_ <= _zz_105_;
      _zz_112_ <= _zz_106_;
      _zz_113_ <= _zz_107_;
      case(_zz_109_)
        2'b01 : begin
          _zz_116_ <= _zz_101_;
          _zz_117_ <= _zz_118_;
        end
        2'b10 : begin
          _zz_116_ <= _zz_118_;
          _zz_117_ <= (_zz_118_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_116_ <= _zz_120_;
          _zz_117_ <= (_zz_120_ + _zz_689_);
        end
        default : begin
          _zz_117_ <= _zz_118_;
        end
      endcase
    end
    if(_zz_622_)begin
      _zz_127_ <= _zz_121_;
      _zz_128_ <= _zz_122_;
      _zz_129_ <= _zz_123_;
      case(_zz_125_)
        2'b01 : begin
          _zz_132_ <= _zz_117_;
          _zz_133_ <= _zz_134_;
        end
        2'b10 : begin
          _zz_132_ <= _zz_134_;
          _zz_133_ <= (_zz_134_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_132_ <= _zz_136_;
          _zz_133_ <= (_zz_136_ + _zz_692_);
        end
        default : begin
          _zz_133_ <= _zz_134_;
        end
      endcase
    end
    if(_zz_623_)begin
      _zz_143_ <= _zz_137_;
      _zz_144_ <= _zz_138_;
      _zz_145_ <= _zz_139_;
      case(_zz_141_)
        2'b01 : begin
          _zz_148_ <= _zz_133_;
          _zz_149_ <= _zz_150_;
        end
        2'b10 : begin
          _zz_148_ <= _zz_150_;
          _zz_149_ <= (_zz_150_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_148_ <= _zz_152_;
          _zz_149_ <= (_zz_152_ + _zz_695_);
        end
        default : begin
          _zz_149_ <= _zz_150_;
        end
      endcase
    end
    if(_zz_624_)begin
      _zz_159_ <= _zz_153_;
      _zz_160_ <= _zz_154_;
      _zz_161_ <= _zz_155_;
      case(_zz_157_)
        2'b01 : begin
          _zz_164_ <= _zz_149_;
          _zz_165_ <= _zz_166_;
        end
        2'b10 : begin
          _zz_164_ <= _zz_166_;
          _zz_165_ <= (_zz_166_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_164_ <= _zz_168_;
          _zz_165_ <= (_zz_168_ + _zz_698_);
        end
        default : begin
          _zz_165_ <= _zz_166_;
        end
      endcase
    end
    if(_zz_625_)begin
      _zz_175_ <= _zz_169_;
      _zz_176_ <= _zz_170_;
      _zz_177_ <= _zz_171_;
      case(_zz_173_)
        2'b01 : begin
          _zz_180_ <= _zz_165_;
          _zz_181_ <= _zz_182_;
        end
        2'b10 : begin
          _zz_180_ <= _zz_182_;
          _zz_181_ <= (_zz_182_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_180_ <= _zz_184_;
          _zz_181_ <= (_zz_184_ + _zz_701_);
        end
        default : begin
          _zz_181_ <= _zz_182_;
        end
      endcase
    end
    if(_zz_626_)begin
      _zz_191_ <= _zz_185_;
      _zz_192_ <= _zz_186_;
      _zz_193_ <= _zz_187_;
      case(_zz_189_)
        2'b01 : begin
          _zz_196_ <= _zz_181_;
          _zz_197_ <= _zz_198_;
        end
        2'b10 : begin
          _zz_196_ <= _zz_198_;
          _zz_197_ <= (_zz_198_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_196_ <= _zz_200_;
          _zz_197_ <= (_zz_200_ + _zz_704_);
        end
        default : begin
          _zz_197_ <= _zz_198_;
        end
      endcase
    end
    if(_zz_627_)begin
      _zz_207_ <= _zz_201_;
      _zz_208_ <= _zz_202_;
      _zz_209_ <= _zz_203_;
      case(_zz_205_)
        2'b01 : begin
          _zz_212_ <= _zz_197_;
          _zz_213_ <= _zz_214_;
        end
        2'b10 : begin
          _zz_212_ <= _zz_214_;
          _zz_213_ <= (_zz_214_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_212_ <= _zz_216_;
          _zz_213_ <= (_zz_216_ + _zz_707_);
        end
        default : begin
          _zz_213_ <= _zz_214_;
        end
      endcase
    end
    if(_zz_628_)begin
      _zz_223_ <= _zz_217_;
      _zz_224_ <= _zz_218_;
      _zz_225_ <= _zz_219_;
      case(_zz_221_)
        2'b01 : begin
          _zz_228_ <= _zz_213_;
          _zz_229_ <= _zz_230_;
        end
        2'b10 : begin
          _zz_228_ <= _zz_230_;
          _zz_229_ <= (_zz_230_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_228_ <= _zz_232_;
          _zz_229_ <= (_zz_232_ + _zz_710_);
        end
        default : begin
          _zz_229_ <= _zz_230_;
        end
      endcase
    end
    if(_zz_629_)begin
      _zz_239_ <= _zz_233_;
      _zz_240_ <= _zz_234_;
      _zz_241_ <= _zz_235_;
      case(_zz_237_)
        2'b01 : begin
          _zz_244_ <= _zz_229_;
          _zz_245_ <= _zz_246_;
        end
        2'b10 : begin
          _zz_244_ <= _zz_246_;
          _zz_245_ <= (_zz_246_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_244_ <= _zz_248_;
          _zz_245_ <= (_zz_248_ + _zz_713_);
        end
        default : begin
          _zz_245_ <= _zz_246_;
        end
      endcase
    end
    if(_zz_630_)begin
      _zz_255_ <= _zz_249_;
      _zz_256_ <= _zz_250_;
      _zz_257_ <= _zz_251_;
      case(_zz_253_)
        2'b01 : begin
          _zz_260_ <= _zz_245_;
          _zz_261_ <= _zz_262_;
        end
        2'b10 : begin
          _zz_260_ <= _zz_262_;
          _zz_261_ <= (_zz_262_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_260_ <= _zz_264_;
          _zz_261_ <= (_zz_264_ + _zz_716_);
        end
        default : begin
          _zz_261_ <= _zz_262_;
        end
      endcase
    end
    if(_zz_631_)begin
      _zz_271_ <= _zz_265_;
      _zz_272_ <= _zz_266_;
      _zz_273_ <= _zz_267_;
      case(_zz_269_)
        2'b01 : begin
          _zz_276_ <= _zz_261_;
          _zz_277_ <= _zz_278_;
        end
        2'b10 : begin
          _zz_276_ <= _zz_278_;
          _zz_277_ <= (_zz_278_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_276_ <= _zz_280_;
          _zz_277_ <= (_zz_280_ + _zz_719_);
        end
        default : begin
          _zz_277_ <= _zz_278_;
        end
      endcase
    end
    if(_zz_632_)begin
      _zz_287_ <= _zz_281_;
      _zz_288_ <= _zz_282_;
      _zz_289_ <= _zz_283_;
      case(_zz_285_)
        2'b01 : begin
          _zz_292_ <= _zz_277_;
          _zz_293_ <= _zz_294_;
        end
        2'b10 : begin
          _zz_292_ <= _zz_294_;
          _zz_293_ <= (_zz_294_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_292_ <= _zz_296_;
          _zz_293_ <= (_zz_296_ + _zz_722_);
        end
        default : begin
          _zz_293_ <= _zz_294_;
        end
      endcase
    end
    if(_zz_633_)begin
      _zz_303_ <= _zz_297_;
      _zz_304_ <= _zz_298_;
      _zz_305_ <= _zz_299_;
      case(_zz_301_)
        2'b01 : begin
          _zz_308_ <= _zz_293_;
          _zz_309_ <= _zz_310_;
        end
        2'b10 : begin
          _zz_308_ <= _zz_310_;
          _zz_309_ <= (_zz_310_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_308_ <= _zz_312_;
          _zz_309_ <= (_zz_312_ + _zz_725_);
        end
        default : begin
          _zz_309_ <= _zz_310_;
        end
      endcase
    end
    if(_zz_634_)begin
      _zz_319_ <= _zz_313_;
      _zz_320_ <= _zz_314_;
      _zz_321_ <= _zz_315_;
      case(_zz_317_)
        2'b01 : begin
          _zz_324_ <= _zz_309_;
          _zz_325_ <= _zz_326_;
        end
        2'b10 : begin
          _zz_324_ <= _zz_326_;
          _zz_325_ <= (_zz_326_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_324_ <= _zz_328_;
          _zz_325_ <= (_zz_328_ + _zz_728_);
        end
        default : begin
          _zz_325_ <= _zz_326_;
        end
      endcase
    end
    if(_zz_635_)begin
      _zz_335_ <= _zz_329_;
      _zz_336_ <= _zz_330_;
      _zz_337_ <= _zz_331_;
      case(_zz_333_)
        2'b01 : begin
          _zz_340_ <= _zz_325_;
          _zz_341_ <= _zz_342_;
        end
        2'b10 : begin
          _zz_340_ <= _zz_342_;
          _zz_341_ <= (_zz_342_ + 32'h00000004);
        end
        2'b11 : begin
          _zz_340_ <= _zz_344_;
          _zz_341_ <= (_zz_344_ + _zz_731_);
        end
        default : begin
          _zz_341_ <= _zz_342_;
        end
      endcase
    end
    _zz_472_ <= _zz_40_[11 : 7];
    _zz_473_ <= _zz_52_;
    CsrPlugin_mip_MEIP <= externalInterrupt;
    CsrPlugin_mip_MTIP <= timerInterrupt;
    CsrPlugin_mip_MSIP <= softwareInterrupt;
    CsrPlugin_mcycle <= (CsrPlugin_mcycle + 64'h0000000000000001);
    if(writeBack_arbitration_isFiring)begin
      CsrPlugin_minstret <= (CsrPlugin_minstret + 64'h0000000000000001);
    end
    if(_zz_598_)begin
      CsrPlugin_exceptionPortCtrl_exceptionContext_code <= (_zz_501_ ? IBusCachedPlugin_decodeExceptionPort_payload_code : decodeExceptionPort_payload_code);
      CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= (_zz_501_ ? IBusCachedPlugin_decodeExceptionPort_payload_badAddr : decodeExceptionPort_payload_badAddr);
    end
    if(CsrPlugin_selfException_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionContext_code <= CsrPlugin_selfException_payload_code;
      CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= CsrPlugin_selfException_payload_badAddr;
    end
    if(BranchPlugin_branchExceptionPort_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionContext_code <= BranchPlugin_branchExceptionPort_payload_code;
      CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= BranchPlugin_branchExceptionPort_payload_badAddr;
    end
    if(DBusCachedPlugin_exceptionBus_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionContext_code <= DBusCachedPlugin_exceptionBus_payload_code;
      CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= DBusCachedPlugin_exceptionBus_payload_badAddr;
    end
    if(_zz_636_)begin
      if(_zz_637_)begin
        CsrPlugin_interrupt_code <= (4'b0111);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
      if(_zz_638_)begin
        CsrPlugin_interrupt_code <= (4'b0011);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
      if(_zz_639_)begin
        CsrPlugin_interrupt_code <= (4'b1011);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
    end
    if(_zz_600_)begin
      case(CsrPlugin_targetPrivilege)
        2'b11 : begin
          CsrPlugin_mcause_interrupt <= (! CsrPlugin_hadException);
          CsrPlugin_mcause_exceptionCode <= CsrPlugin_trapCause;
          CsrPlugin_mepc <= writeBack_PC;
          if(CsrPlugin_hadException)begin
            CsrPlugin_mtval <= CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr;
          end
        end
        default : begin
        end
      endcase
    end
    if((memory_DivPlugin_div_counter_value == 6'h20))begin
      memory_DivPlugin_div_done <= 1'b1;
    end
    if((! memory_arbitration_isStuck))begin
      memory_DivPlugin_div_done <= 1'b0;
    end
    if(_zz_593_)begin
      if(_zz_616_)begin
        memory_DivPlugin_rs1[31 : 0] <= memory_DivPlugin_div_stage_0_outNumerator;
        memory_DivPlugin_accumulator[31 : 0] <= memory_DivPlugin_div_stage_0_outRemainder;
        if((memory_DivPlugin_div_counter_value == 6'h20))begin
          memory_DivPlugin_div_result <= _zz_773_[31:0];
        end
      end
    end
    if(_zz_617_)begin
      memory_DivPlugin_accumulator <= 65'h0;
      memory_DivPlugin_rs1 <= ((_zz_505_ ? (~ _zz_506_) : _zz_506_) + _zz_779_);
      memory_DivPlugin_rs2 <= ((_zz_504_ ? (~ execute_RS2) : execute_RS2) + _zz_781_);
      memory_DivPlugin_div_needRevert <= ((_zz_505_ ^ (_zz_504_ && (! execute_INSTRUCTION[13]))) && (! (((execute_RS2 == 32'h0) && execute_IS_RS2_SIGNED) && (! execute_INSTRUCTION[13]))));
    end
    externalInterruptArray_regNext <= externalInterruptArray;
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_RS2_SIGNED <= decode_IS_RS2_SIGNED;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_MANAGMENT <= decode_MEMORY_MANAGMENT;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_PC <= decode_PC;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_PC <= _zz_35_;
    end
    if(((! writeBack_arbitration_isStuck) && (! CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack)))begin
      memory_to_writeBack_PC <= memory_PC;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BRANCH_CTRL <= _zz_25_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_REGFILE_WRITE_VALID <= decode_REGFILE_WRITE_VALID;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_REGFILE_WRITE_VALID <= execute_REGFILE_WRITE_VALID;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_REGFILE_WRITE_VALID <= memory_REGFILE_WRITE_VALID;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_INSTRUCTION <= decode_INSTRUCTION;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_INSTRUCTION <= execute_INSTRUCTION;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MUL_HH <= execute_MUL_HH;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MUL_HH <= memory_MUL_HH;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_MUL <= decode_IS_MUL;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_IS_MUL <= execute_IS_MUL;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_IS_MUL <= memory_IS_MUL;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_RS1_SIGNED <= decode_IS_RS1_SIGNED;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ENV_CTRL <= _zz_23_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_ENV_CTRL <= _zz_20_;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_ENV_CTRL <= _zz_18_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ALU_CTRL <= _zz_16_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BYPASSABLE_EXECUTE_STAGE <= decode_BYPASSABLE_EXECUTE_STAGE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MUL_HL <= execute_MUL_HL;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_ADDRESS_LOW <= execute_MEMORY_ADDRESS_LOW;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MEMORY_ADDRESS_LOW <= memory_MEMORY_ADDRESS_LOW;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_PREDICTION_HAD_BRANCHED2 <= decode_PREDICTION_HAD_BRANCHED2;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BRANCH_CALC <= execute_BRANCH_CALC;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BYPASSABLE_MEMORY_STAGE <= decode_BYPASSABLE_MEMORY_STAGE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BYPASSABLE_MEMORY_STAGE <= execute_BYPASSABLE_MEMORY_STAGE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC_LESS_UNSIGNED <= decode_SRC_LESS_UNSIGNED;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SHIFT_CTRL <= _zz_13_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_SHIFT_CTRL <= _zz_10_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_RS1 <= decode_RS1;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_FORMAL_PC_NEXT <= _zz_56_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_FORMAL_PC_NEXT <= execute_FORMAL_PC_NEXT;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_FORMAL_PC_NEXT <= _zz_55_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_SHIFT_RIGHT <= execute_SHIFT_RIGHT;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_CSR <= decode_IS_CSR;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_RS2 <= decode_RS2;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC1_CTRL <= _zz_8_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC2_FORCE_ZERO <= decode_SRC2_FORCE_ZERO;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_ENABLE <= decode_MEMORY_ENABLE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_ENABLE <= execute_MEMORY_ENABLE;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MEMORY_ENABLE <= memory_MEMORY_ENABLE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_CSR_WRITE_OPCODE <= decode_CSR_WRITE_OPCODE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MUL_LL <= execute_MUL_LL;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MUL_LH <= execute_MUL_LH;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_WR <= decode_MEMORY_WR;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_WR <= execute_MEMORY_WR;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MEMORY_WR <= memory_MEMORY_WR;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ALU_BITWISE_CTRL <= _zz_5_;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MUL_LOW <= memory_MUL_LOW;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC2_CTRL <= _zz_2_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_DIV <= decode_IS_DIV;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_IS_DIV <= execute_IS_DIV;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BRANCH_DO <= execute_BRANCH_DO;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_REGFILE_WRITE_DATA <= _zz_31_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC_USE_SUB_LESS <= decode_SRC_USE_SUB_LESS;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_CSR_READ_OPCODE <= decode_CSR_READ_OPCODE;
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_3264 <= (decode_INSTRUCTION[31 : 20] == 12'hcc0);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_944 <= (decode_INSTRUCTION[31 : 20] == 12'h3b0);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_945 <= (decode_INSTRUCTION[31 : 20] == 12'h3b1);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_946 <= (decode_INSTRUCTION[31 : 20] == 12'h3b2);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_947 <= (decode_INSTRUCTION[31 : 20] == 12'h3b3);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_948 <= (decode_INSTRUCTION[31 : 20] == 12'h3b4);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_949 <= (decode_INSTRUCTION[31 : 20] == 12'h3b5);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_950 <= (decode_INSTRUCTION[31 : 20] == 12'h3b6);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_951 <= (decode_INSTRUCTION[31 : 20] == 12'h3b7);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_952 <= (decode_INSTRUCTION[31 : 20] == 12'h3b8);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_953 <= (decode_INSTRUCTION[31 : 20] == 12'h3b9);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_954 <= (decode_INSTRUCTION[31 : 20] == 12'h3ba);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_955 <= (decode_INSTRUCTION[31 : 20] == 12'h3bb);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_956 <= (decode_INSTRUCTION[31 : 20] == 12'h3bc);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_957 <= (decode_INSTRUCTION[31 : 20] == 12'h3bd);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_958 <= (decode_INSTRUCTION[31 : 20] == 12'h3be);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_959 <= (decode_INSTRUCTION[31 : 20] == 12'h3bf);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_928 <= (decode_INSTRUCTION[31 : 20] == 12'h3a0);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_929 <= (decode_INSTRUCTION[31 : 20] == 12'h3a1);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_930 <= (decode_INSTRUCTION[31 : 20] == 12'h3a2);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_931 <= (decode_INSTRUCTION[31 : 20] == 12'h3a3);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_3857 <= (decode_INSTRUCTION[31 : 20] == 12'hf11);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_3858 <= (decode_INSTRUCTION[31 : 20] == 12'hf12);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_3859 <= (decode_INSTRUCTION[31 : 20] == 12'hf13);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_3860 <= (decode_INSTRUCTION[31 : 20] == 12'hf14);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_769 <= (decode_INSTRUCTION[31 : 20] == 12'h301);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_768 <= (decode_INSTRUCTION[31 : 20] == 12'h300);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_836 <= (decode_INSTRUCTION[31 : 20] == 12'h344);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_772 <= (decode_INSTRUCTION[31 : 20] == 12'h304);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_773 <= (decode_INSTRUCTION[31 : 20] == 12'h305);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_833 <= (decode_INSTRUCTION[31 : 20] == 12'h341);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_832 <= (decode_INSTRUCTION[31 : 20] == 12'h340);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_834 <= (decode_INSTRUCTION[31 : 20] == 12'h342);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_835 <= (decode_INSTRUCTION[31 : 20] == 12'h343);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_2816 <= (decode_INSTRUCTION[31 : 20] == 12'hb00);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_2944 <= (decode_INSTRUCTION[31 : 20] == 12'hb80);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_2818 <= (decode_INSTRUCTION[31 : 20] == 12'hb02);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_2946 <= (decode_INSTRUCTION[31 : 20] == 12'hb82);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_3072 <= (decode_INSTRUCTION[31 : 20] == 12'hc00);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_3200 <= (decode_INSTRUCTION[31 : 20] == 12'hc80);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_3074 <= (decode_INSTRUCTION[31 : 20] == 12'hc02);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_3202 <= (decode_INSTRUCTION[31 : 20] == 12'hc82);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_3008 <= (decode_INSTRUCTION[31 : 20] == 12'hbc0);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_4032 <= (decode_INSTRUCTION[31 : 20] == 12'hfc0);
    end
    if(execute_CsrPlugin_csr_944)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_94_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_945)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_110_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_946)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_126_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_947)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_142_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_948)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_158_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_949)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_174_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_950)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_190_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_951)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_206_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_952)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_222_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_953)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_238_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_954)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_254_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_955)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_270_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_956)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_286_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_957)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_302_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_958)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_318_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_959)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_334_ <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_928)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_139_ <= _zz_786_[0];
        _zz_138_ <= _zz_787_[0];
        _zz_137_ <= _zz_788_[0];
        _zz_123_ <= _zz_789_[0];
        _zz_122_ <= _zz_790_[0];
        _zz_121_ <= _zz_791_[0];
        _zz_107_ <= _zz_792_[0];
        _zz_106_ <= _zz_793_[0];
        _zz_105_ <= _zz_794_[0];
        _zz_91_ <= _zz_795_[0];
        _zz_90_ <= _zz_796_[0];
        _zz_89_ <= _zz_797_[0];
      end
    end
    if(execute_CsrPlugin_csr_929)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_203_ <= _zz_802_[0];
        _zz_202_ <= _zz_803_[0];
        _zz_201_ <= _zz_804_[0];
        _zz_187_ <= _zz_805_[0];
        _zz_186_ <= _zz_806_[0];
        _zz_185_ <= _zz_807_[0];
        _zz_171_ <= _zz_808_[0];
        _zz_170_ <= _zz_809_[0];
        _zz_169_ <= _zz_810_[0];
        _zz_155_ <= _zz_811_[0];
        _zz_154_ <= _zz_812_[0];
        _zz_153_ <= _zz_813_[0];
      end
    end
    if(execute_CsrPlugin_csr_930)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_267_ <= _zz_818_[0];
        _zz_266_ <= _zz_819_[0];
        _zz_265_ <= _zz_820_[0];
        _zz_251_ <= _zz_821_[0];
        _zz_250_ <= _zz_822_[0];
        _zz_249_ <= _zz_823_[0];
        _zz_235_ <= _zz_824_[0];
        _zz_234_ <= _zz_825_[0];
        _zz_233_ <= _zz_826_[0];
        _zz_219_ <= _zz_827_[0];
        _zz_218_ <= _zz_828_[0];
        _zz_217_ <= _zz_829_[0];
      end
    end
    if(execute_CsrPlugin_csr_931)begin
      if(execute_CsrPlugin_writeEnable)begin
        _zz_331_ <= _zz_834_[0];
        _zz_330_ <= _zz_835_[0];
        _zz_329_ <= _zz_836_[0];
        _zz_315_ <= _zz_837_[0];
        _zz_314_ <= _zz_838_[0];
        _zz_313_ <= _zz_839_[0];
        _zz_299_ <= _zz_840_[0];
        _zz_298_ <= _zz_841_[0];
        _zz_297_ <= _zz_842_[0];
        _zz_283_ <= _zz_843_[0];
        _zz_282_ <= _zz_844_[0];
        _zz_281_ <= _zz_845_[0];
      end
    end
    if(execute_CsrPlugin_csr_836)begin
      if(execute_CsrPlugin_writeEnable)begin
        CsrPlugin_mip_MSIP <= _zz_848_[0];
      end
    end
    if(execute_CsrPlugin_csr_773)begin
      if(execute_CsrPlugin_writeEnable)begin
        CsrPlugin_mtvec_base <= execute_CsrPlugin_writeData[31 : 2];
        CsrPlugin_mtvec_mode <= execute_CsrPlugin_writeData[1 : 0];
      end
    end
    if(execute_CsrPlugin_csr_833)begin
      if(execute_CsrPlugin_writeEnable)begin
        CsrPlugin_mepc <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_832)begin
      if(execute_CsrPlugin_writeEnable)begin
        CsrPlugin_mscratch <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_834)begin
      if(execute_CsrPlugin_writeEnable)begin
        CsrPlugin_mcause_interrupt <= _zz_852_[0];
        CsrPlugin_mcause_exceptionCode <= execute_CsrPlugin_writeData[3 : 0];
      end
    end
    if(execute_CsrPlugin_csr_835)begin
      if(execute_CsrPlugin_writeEnable)begin
        CsrPlugin_mtval <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_2816)begin
      if(execute_CsrPlugin_writeEnable)begin
        CsrPlugin_mcycle[31 : 0] <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_2944)begin
      if(execute_CsrPlugin_writeEnable)begin
        CsrPlugin_mcycle[63 : 32] <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_2818)begin
      if(execute_CsrPlugin_writeEnable)begin
        CsrPlugin_minstret[31 : 0] <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    if(execute_CsrPlugin_csr_2946)begin
      if(execute_CsrPlugin_writeEnable)begin
        CsrPlugin_minstret[63 : 32] <= execute_CsrPlugin_writeData[31 : 0];
      end
    end
    iBusWishbone_DAT_MISO_regNext <= iBusWishbone_DAT_MISO;
    dBusWishbone_DAT_MISO_regNext <= dBusWishbone_DAT_MISO;
  end


endmodule
