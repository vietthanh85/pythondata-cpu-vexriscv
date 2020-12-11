// Generator : SpinalHDL v1.4.0    git head : ecb5a80b713566f417ea3ea061f9969e73770a7f
// Date      : 11/12/2020, 15:37:50
// Component : VexRiscv


`define BranchCtrlEnum_defaultEncoding_type [1:0]
`define BranchCtrlEnum_defaultEncoding_INC 2'b00
`define BranchCtrlEnum_defaultEncoding_B 2'b01
`define BranchCtrlEnum_defaultEncoding_JAL 2'b10
`define BranchCtrlEnum_defaultEncoding_JALR 2'b11

`define ShiftCtrlEnum_defaultEncoding_type [1:0]
`define ShiftCtrlEnum_defaultEncoding_DISABLE_1 2'b00
`define ShiftCtrlEnum_defaultEncoding_SLL_1 2'b01
`define ShiftCtrlEnum_defaultEncoding_SRL_1 2'b10
`define ShiftCtrlEnum_defaultEncoding_SRA_1 2'b11

`define Src1CtrlEnum_defaultEncoding_type [1:0]
`define Src1CtrlEnum_defaultEncoding_RS 2'b00
`define Src1CtrlEnum_defaultEncoding_IMU 2'b01
`define Src1CtrlEnum_defaultEncoding_PC_INCREMENT 2'b10
`define Src1CtrlEnum_defaultEncoding_URS1 2'b11

`define AluBitwiseCtrlEnum_defaultEncoding_type [1:0]
`define AluBitwiseCtrlEnum_defaultEncoding_XOR_1 2'b00
`define AluBitwiseCtrlEnum_defaultEncoding_OR_1 2'b01
`define AluBitwiseCtrlEnum_defaultEncoding_AND_1 2'b10

`define AluCtrlEnum_defaultEncoding_type [1:0]
`define AluCtrlEnum_defaultEncoding_ADD_SUB 2'b00
`define AluCtrlEnum_defaultEncoding_SLT_SLTU 2'b01
`define AluCtrlEnum_defaultEncoding_BITWISE 2'b10

`define Src2CtrlEnum_defaultEncoding_type [1:0]
`define Src2CtrlEnum_defaultEncoding_RS 2'b00
`define Src2CtrlEnum_defaultEncoding_IMI 2'b01
`define Src2CtrlEnum_defaultEncoding_IMS 2'b10
`define Src2CtrlEnum_defaultEncoding_PC 2'b11

`define EnvCtrlEnum_defaultEncoding_type [1:0]
`define EnvCtrlEnum_defaultEncoding_NONE 2'b00
`define EnvCtrlEnum_defaultEncoding_XRET 2'b01
`define EnvCtrlEnum_defaultEncoding_ECALL 2'b10


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
  input      [2:0]    _zz_10_,
  input      [31:0]   _zz_11_,
  input               clk,
  input               reset 
);
  reg        [21:0]   _zz_12_;
  reg        [31:0]   _zz_13_;
  wire                _zz_14_;
  wire                _zz_15_;
  wire       [0:0]    _zz_16_;
  wire       [0:0]    _zz_17_;
  wire       [21:0]   _zz_18_;
  reg                 _zz_1_;
  reg                 _zz_2_;
  reg                 lineLoader_fire;
  reg                 lineLoader_valid;
  (* keep , syn_keep *) reg        [31:0]   lineLoader_address /* synthesis syn_keep = 1 */ ;
  reg                 lineLoader_hadError;
  reg                 lineLoader_flushPending;
  reg        [7:0]    lineLoader_flushCounter;
  reg                 _zz_3_;
  reg                 lineLoader_cmdSent;
  reg                 lineLoader_wayToAllocate_willIncrement;
  wire                lineLoader_wayToAllocate_willClear;
  wire                lineLoader_wayToAllocate_willOverflowIfInc;
  wire                lineLoader_wayToAllocate_willOverflow;
  (* keep , syn_keep *) reg        [2:0]    lineLoader_wordIndex /* synthesis syn_keep = 1 */ ;
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

  assign _zz_14_ = (! lineLoader_flushCounter[7]);
  assign _zz_15_ = (lineLoader_flushPending && (! (lineLoader_valid || io_cpu_fetch_isValid)));
  assign _zz_16_ = _zz_7_[0 : 0];
  assign _zz_17_ = _zz_7_[1 : 1];
  assign _zz_18_ = {lineLoader_write_tag_0_payload_data_address,{lineLoader_write_tag_0_payload_data_error,lineLoader_write_tag_0_payload_data_valid}};
  always @ (posedge clk) begin
    if(_zz_2_) begin
      ways_0_tags[lineLoader_write_tag_0_payload_address] <= _zz_18_;
    end
  end

  always @ (posedge clk) begin
    if(_zz_6_) begin
      _zz_12_ <= ways_0_tags[_zz_5_];
    end
  end

  always @ (posedge clk) begin
    if(_zz_1_) begin
      ways_0_datas[lineLoader_write_data_0_payload_address] <= lineLoader_write_data_0_payload_data;
    end
  end

  always @ (posedge clk) begin
    if(_zz_9_) begin
      _zz_13_ <= ways_0_datas[_zz_8_];
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
    if(_zz_14_)begin
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
  assign _zz_7_ = _zz_12_;
  assign fetchStage_read_waysValues_0_tag_valid = _zz_16_[0];
  assign fetchStage_read_waysValues_0_tag_error = _zz_17_[0];
  assign fetchStage_read_waysValues_0_tag_address = _zz_7_[21 : 2];
  assign _zz_8_ = io_cpu_prefetch_pc[11 : 2];
  assign _zz_9_ = (! io_cpu_fetch_isStuck);
  assign fetchStage_read_waysValues_0_data = _zz_13_;
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
      if(_zz_15_)begin
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
    if(_zz_14_)begin
      lineLoader_flushCounter <= (lineLoader_flushCounter + 8'h01);
    end
    _zz_3_ <= lineLoader_flushCounter[7];
    if(_zz_15_)begin
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
    if((_zz_10_ != (3'b000)))begin
      io_cpu_fetch_data_regNextWhen <= _zz_11_;
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
  input               debug_bus_cmd_valid,
  output reg          debug_bus_cmd_ready,
  input               debug_bus_cmd_payload_wr,
  input      [7:0]    debug_bus_cmd_payload_address,
  input      [31:0]   debug_bus_cmd_payload_data,
  output reg [31:0]   debug_bus_rsp_data,
  output              debug_resetOut,
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
  input               reset,
  input               debugReset 
);
  wire                _zz_169_;
  wire                _zz_170_;
  wire                _zz_171_;
  wire                _zz_172_;
  wire                _zz_173_;
  wire                _zz_174_;
  wire                _zz_175_;
  reg                 _zz_176_;
  wire                _zz_177_;
  wire       [31:0]   _zz_178_;
  wire                _zz_179_;
  wire       [31:0]   _zz_180_;
  reg                 _zz_181_;
  wire                _zz_182_;
  wire                _zz_183_;
  wire       [31:0]   _zz_184_;
  wire                _zz_185_;
  wire                _zz_186_;
  reg        [31:0]   _zz_187_;
  reg        [31:0]   _zz_188_;
  reg        [31:0]   _zz_189_;
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
  wire                _zz_190_;
  wire                _zz_191_;
  wire                _zz_192_;
  wire                _zz_193_;
  wire                _zz_194_;
  wire                _zz_195_;
  wire                _zz_196_;
  wire                _zz_197_;
  wire                _zz_198_;
  wire                _zz_199_;
  wire                _zz_200_;
  wire                _zz_201_;
  wire                _zz_202_;
  wire                _zz_203_;
  wire                _zz_204_;
  wire                _zz_205_;
  wire       [1:0]    _zz_206_;
  wire                _zz_207_;
  wire                _zz_208_;
  wire                _zz_209_;
  wire                _zz_210_;
  wire                _zz_211_;
  wire                _zz_212_;
  wire                _zz_213_;
  wire                _zz_214_;
  wire                _zz_215_;
  wire       [1:0]    _zz_216_;
  wire                _zz_217_;
  wire                _zz_218_;
  wire       [5:0]    _zz_219_;
  wire                _zz_220_;
  wire                _zz_221_;
  wire                _zz_222_;
  wire                _zz_223_;
  wire                _zz_224_;
  wire                _zz_225_;
  wire       [1:0]    _zz_226_;
  wire                _zz_227_;
  wire       [1:0]    _zz_228_;
  wire       [51:0]   _zz_229_;
  wire       [51:0]   _zz_230_;
  wire       [51:0]   _zz_231_;
  wire       [32:0]   _zz_232_;
  wire       [51:0]   _zz_233_;
  wire       [49:0]   _zz_234_;
  wire       [51:0]   _zz_235_;
  wire       [49:0]   _zz_236_;
  wire       [51:0]   _zz_237_;
  wire       [0:0]    _zz_238_;
  wire       [32:0]   _zz_239_;
  wire       [31:0]   _zz_240_;
  wire       [32:0]   _zz_241_;
  wire       [0:0]    _zz_242_;
  wire       [0:0]    _zz_243_;
  wire       [0:0]    _zz_244_;
  wire       [0:0]    _zz_245_;
  wire       [0:0]    _zz_246_;
  wire       [0:0]    _zz_247_;
  wire       [0:0]    _zz_248_;
  wire       [0:0]    _zz_249_;
  wire       [0:0]    _zz_250_;
  wire       [0:0]    _zz_251_;
  wire       [0:0]    _zz_252_;
  wire       [0:0]    _zz_253_;
  wire       [0:0]    _zz_254_;
  wire       [0:0]    _zz_255_;
  wire       [0:0]    _zz_256_;
  wire       [0:0]    _zz_257_;
  wire       [0:0]    _zz_258_;
  wire       [3:0]    _zz_259_;
  wire       [2:0]    _zz_260_;
  wire       [31:0]   _zz_261_;
  wire       [11:0]   _zz_262_;
  wire       [31:0]   _zz_263_;
  wire       [19:0]   _zz_264_;
  wire       [11:0]   _zz_265_;
  wire       [31:0]   _zz_266_;
  wire       [31:0]   _zz_267_;
  wire       [19:0]   _zz_268_;
  wire       [11:0]   _zz_269_;
  wire       [2:0]    _zz_270_;
  wire       [2:0]    _zz_271_;
  wire       [0:0]    _zz_272_;
  wire       [2:0]    _zz_273_;
  wire       [4:0]    _zz_274_;
  wire       [11:0]   _zz_275_;
  wire       [11:0]   _zz_276_;
  wire       [31:0]   _zz_277_;
  wire       [31:0]   _zz_278_;
  wire       [31:0]   _zz_279_;
  wire       [31:0]   _zz_280_;
  wire       [31:0]   _zz_281_;
  wire       [31:0]   _zz_282_;
  wire       [31:0]   _zz_283_;
  wire       [11:0]   _zz_284_;
  wire       [19:0]   _zz_285_;
  wire       [11:0]   _zz_286_;
  wire       [31:0]   _zz_287_;
  wire       [31:0]   _zz_288_;
  wire       [31:0]   _zz_289_;
  wire       [11:0]   _zz_290_;
  wire       [19:0]   _zz_291_;
  wire       [11:0]   _zz_292_;
  wire       [2:0]    _zz_293_;
  wire       [1:0]    _zz_294_;
  wire       [1:0]    _zz_295_;
  wire       [65:0]   _zz_296_;
  wire       [65:0]   _zz_297_;
  wire       [31:0]   _zz_298_;
  wire       [31:0]   _zz_299_;
  wire       [0:0]    _zz_300_;
  wire       [5:0]    _zz_301_;
  wire       [32:0]   _zz_302_;
  wire       [31:0]   _zz_303_;
  wire       [31:0]   _zz_304_;
  wire       [32:0]   _zz_305_;
  wire       [32:0]   _zz_306_;
  wire       [32:0]   _zz_307_;
  wire       [32:0]   _zz_308_;
  wire       [0:0]    _zz_309_;
  wire       [32:0]   _zz_310_;
  wire       [0:0]    _zz_311_;
  wire       [32:0]   _zz_312_;
  wire       [0:0]    _zz_313_;
  wire       [31:0]   _zz_314_;
  wire       [0:0]    _zz_315_;
  wire       [0:0]    _zz_316_;
  wire       [0:0]    _zz_317_;
  wire       [0:0]    _zz_318_;
  wire       [0:0]    _zz_319_;
  wire       [0:0]    _zz_320_;
  wire       [26:0]   _zz_321_;
  wire                _zz_322_;
  wire                _zz_323_;
  wire       [1:0]    _zz_324_;
  wire       [31:0]   _zz_325_;
  wire       [31:0]   _zz_326_;
  wire       [31:0]   _zz_327_;
  wire                _zz_328_;
  wire       [0:0]    _zz_329_;
  wire       [13:0]   _zz_330_;
  wire       [31:0]   _zz_331_;
  wire       [31:0]   _zz_332_;
  wire       [31:0]   _zz_333_;
  wire                _zz_334_;
  wire       [0:0]    _zz_335_;
  wire       [7:0]    _zz_336_;
  wire       [31:0]   _zz_337_;
  wire       [31:0]   _zz_338_;
  wire       [31:0]   _zz_339_;
  wire                _zz_340_;
  wire       [0:0]    _zz_341_;
  wire       [1:0]    _zz_342_;
  wire                _zz_343_;
  wire                _zz_344_;
  wire                _zz_345_;
  wire       [31:0]   _zz_346_;
  wire       [31:0]   _zz_347_;
  wire       [31:0]   _zz_348_;
  wire                _zz_349_;
  wire       [3:0]    _zz_350_;
  wire       [3:0]    _zz_351_;
  wire                _zz_352_;
  wire       [0:0]    _zz_353_;
  wire       [26:0]   _zz_354_;
  wire       [31:0]   _zz_355_;
  wire       [31:0]   _zz_356_;
  wire                _zz_357_;
  wire       [0:0]    _zz_358_;
  wire       [0:0]    _zz_359_;
  wire       [31:0]   _zz_360_;
  wire       [31:0]   _zz_361_;
  wire                _zz_362_;
  wire       [1:0]    _zz_363_;
  wire       [1:0]    _zz_364_;
  wire                _zz_365_;
  wire       [0:0]    _zz_366_;
  wire       [23:0]   _zz_367_;
  wire       [31:0]   _zz_368_;
  wire       [31:0]   _zz_369_;
  wire       [31:0]   _zz_370_;
  wire       [31:0]   _zz_371_;
  wire                _zz_372_;
  wire       [0:0]    _zz_373_;
  wire       [0:0]    _zz_374_;
  wire       [5:0]    _zz_375_;
  wire       [5:0]    _zz_376_;
  wire                _zz_377_;
  wire       [0:0]    _zz_378_;
  wire       [20:0]   _zz_379_;
  wire       [31:0]   _zz_380_;
  wire       [31:0]   _zz_381_;
  wire                _zz_382_;
  wire       [0:0]    _zz_383_;
  wire       [2:0]    _zz_384_;
  wire       [31:0]   _zz_385_;
  wire       [31:0]   _zz_386_;
  wire                _zz_387_;
  wire       [1:0]    _zz_388_;
  wire       [1:0]    _zz_389_;
  wire                _zz_390_;
  wire       [0:0]    _zz_391_;
  wire       [17:0]   _zz_392_;
  wire       [31:0]   _zz_393_;
  wire       [31:0]   _zz_394_;
  wire       [31:0]   _zz_395_;
  wire                _zz_396_;
  wire                _zz_397_;
  wire       [31:0]   _zz_398_;
  wire       [31:0]   _zz_399_;
  wire       [31:0]   _zz_400_;
  wire       [31:0]   _zz_401_;
  wire                _zz_402_;
  wire       [0:0]    _zz_403_;
  wire       [0:0]    _zz_404_;
  wire                _zz_405_;
  wire       [0:0]    _zz_406_;
  wire       [0:0]    _zz_407_;
  wire                _zz_408_;
  wire       [0:0]    _zz_409_;
  wire       [14:0]   _zz_410_;
  wire       [31:0]   _zz_411_;
  wire       [31:0]   _zz_412_;
  wire       [31:0]   _zz_413_;
  wire       [31:0]   _zz_414_;
  wire       [31:0]   _zz_415_;
  wire       [31:0]   _zz_416_;
  wire       [31:0]   _zz_417_;
  wire       [31:0]   _zz_418_;
  wire       [31:0]   _zz_419_;
  wire       [31:0]   _zz_420_;
  wire       [0:0]    _zz_421_;
  wire       [0:0]    _zz_422_;
  wire       [0:0]    _zz_423_;
  wire       [0:0]    _zz_424_;
  wire                _zz_425_;
  wire       [0:0]    _zz_426_;
  wire       [12:0]   _zz_427_;
  wire       [31:0]   _zz_428_;
  wire       [31:0]   _zz_429_;
  wire       [31:0]   _zz_430_;
  wire       [0:0]    _zz_431_;
  wire       [0:0]    _zz_432_;
  wire                _zz_433_;
  wire       [0:0]    _zz_434_;
  wire       [8:0]    _zz_435_;
  wire                _zz_436_;
  wire       [0:0]    _zz_437_;
  wire       [1:0]    _zz_438_;
  wire                _zz_439_;
  wire       [0:0]    _zz_440_;
  wire       [2:0]    _zz_441_;
  wire       [0:0]    _zz_442_;
  wire       [1:0]    _zz_443_;
  wire       [1:0]    _zz_444_;
  wire       [1:0]    _zz_445_;
  wire                _zz_446_;
  wire       [0:0]    _zz_447_;
  wire       [3:0]    _zz_448_;
  wire       [31:0]   _zz_449_;
  wire       [31:0]   _zz_450_;
  wire       [31:0]   _zz_451_;
  wire                _zz_452_;
  wire                _zz_453_;
  wire       [31:0]   _zz_454_;
  wire                _zz_455_;
  wire       [0:0]    _zz_456_;
  wire       [0:0]    _zz_457_;
  wire       [31:0]   _zz_458_;
  wire       [31:0]   _zz_459_;
  wire                _zz_460_;
  wire                _zz_461_;
  wire                _zz_462_;
  wire                _zz_463_;
  wire                _zz_464_;
  wire       [1:0]    _zz_465_;
  wire       [1:0]    _zz_466_;
  wire                _zz_467_;
  wire       [0:0]    _zz_468_;
  wire       [1:0]    _zz_469_;
  wire       [31:0]   _zz_470_;
  wire       [31:0]   _zz_471_;
  wire       [31:0]   _zz_472_;
  wire       [31:0]   _zz_473_;
  wire       [31:0]   _zz_474_;
  wire       [31:0]   _zz_475_;
  wire       [31:0]   _zz_476_;
  wire       [31:0]   _zz_477_;
  wire       [31:0]   _zz_478_;
  wire       [31:0]   _zz_479_;
  wire       [31:0]   _zz_480_;
  wire       [31:0]   _zz_481_;
  wire                _zz_482_;
  wire                _zz_483_;
  wire       [0:0]    _zz_484_;
  wire       [1:0]    _zz_485_;
  wire       [1:0]    _zz_486_;
  wire       [1:0]    _zz_487_;
  wire                _zz_488_;
  wire                _zz_489_;
  wire       [31:0]   _zz_490_;
  wire       [31:0]   _zz_491_;
  wire       [31:0]   _zz_492_;
  wire       [31:0]   _zz_493_;
  wire       [31:0]   _zz_494_;
  wire       [31:0]   _zz_495_;
  wire       [31:0]   _zz_496_;
  wire                _zz_497_;
  wire       [31:0]   _zz_498_;
  wire       [31:0]   _zz_499_;
  wire                _zz_500_;
  wire                _zz_501_;
  wire                _zz_502_;
  wire       [1:0]    memory_MEMORY_ADDRESS_LOW;
  wire       [1:0]    execute_MEMORY_ADDRESS_LOW;
  wire       [31:0]   writeBack_FORMAL_PC_NEXT;
  wire       [31:0]   memory_FORMAL_PC_NEXT;
  wire       [31:0]   execute_FORMAL_PC_NEXT;
  wire       [31:0]   decode_FORMAL_PC_NEXT;
  wire       [33:0]   execute_MUL_LH;
  wire                decode_CSR_READ_OPCODE;
  wire       [51:0]   memory_MUL_LOW;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_1_;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_2_;
  wire                memory_MEMORY_WR;
  wire                decode_MEMORY_WR;
  wire       [31:0]   execute_SHIFT_RIGHT;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_3_;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_4_;
  wire       `ShiftCtrlEnum_defaultEncoding_type decode_SHIFT_CTRL;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_5_;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_6_;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_7_;
  wire       [31:0]   execute_BRANCH_CALC;
  wire                decode_IS_RS1_SIGNED;
  wire                decode_BYPASSABLE_EXECUTE_STAGE;
  wire                decode_DO_EBREAK;
  wire       `Src1CtrlEnum_defaultEncoding_type decode_SRC1_CTRL;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_8_;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_9_;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_10_;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type decode_ALU_BITWISE_CTRL;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_11_;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_12_;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_13_;
  wire       [31:0]   execute_MUL_LL;
  wire       [33:0]   memory_MUL_HH;
  wire       [33:0]   execute_MUL_HH;
  wire                execute_BYPASSABLE_MEMORY_STAGE;
  wire                decode_BYPASSABLE_MEMORY_STAGE;
  wire                decode_SRC_LESS_UNSIGNED;
  wire                decode_MEMORY_MANAGMENT;
  wire       [31:0]   memory_PC;
  wire       `AluCtrlEnum_defaultEncoding_type decode_ALU_CTRL;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_14_;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_15_;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_16_;
  wire       `Src2CtrlEnum_defaultEncoding_type decode_SRC2_CTRL;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_17_;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_18_;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_19_;
  wire                memory_IS_MUL;
  wire                execute_IS_MUL;
  wire                decode_IS_MUL;
  wire       [33:0]   execute_MUL_HL;
  wire       [31:0]   execute_REGFILE_WRITE_DATA;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_20_;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_21_;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_22_;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_23_;
  wire       `EnvCtrlEnum_defaultEncoding_type decode_ENV_CTRL;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_24_;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_25_;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_26_;
  wire                decode_IS_CSR;
  wire                decode_PREDICTION_HAD_BRANCHED2;
  wire                decode_IS_DIV;
  wire                decode_SRC2_FORCE_ZERO;
  wire                decode_IS_RS2_SIGNED;
  wire                execute_BRANCH_DO;
  wire                decode_CSR_WRITE_OPCODE;
  wire                execute_DO_EBREAK;
  wire                decode_IS_EBREAK;
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
  (* keep , syn_keep *) wire       [31:0]   execute_RS1 /* synthesis syn_keep = 1 */ ;
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
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_43_;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_44_;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_45_;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_46_;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_47_;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_48_;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_49_;
  reg        [31:0]   _zz_50_;
  wire       [1:0]    writeBack_MEMORY_ADDRESS_LOW;
  wire                writeBack_MEMORY_WR;
  wire       [31:0]   writeBack_REGFILE_WRITE_DATA;
  wire                writeBack_MEMORY_ENABLE;
  wire       [31:0]   memory_REGFILE_WRITE_DATA;
  wire                memory_MEMORY_ENABLE;
  wire                execute_MEMORY_MANAGMENT;
  (* keep , syn_keep *) wire       [31:0]   execute_RS2 /* synthesis syn_keep = 1 */ ;
  wire                execute_MEMORY_WR;
  wire       [31:0]   execute_SRC_ADD;
  wire                execute_MEMORY_ENABLE;
  wire       [31:0]   execute_INSTRUCTION;
  wire                decode_MEMORY_ENABLE;
  wire                decode_FLUSH_ALL;
  reg                 _zz_51_;
  reg                 _zz_51__2;
  reg                 _zz_51__1;
  reg                 _zz_51__0;
  wire       `BranchCtrlEnum_defaultEncoding_type decode_BRANCH_CTRL;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_52_;
  wire       [31:0]   decode_INSTRUCTION;
  reg        [31:0]   _zz_53_;
  reg        [31:0]   _zz_54_;
  wire       [31:0]   decode_PC;
  wire       [31:0]   writeBack_PC;
  wire       [31:0]   writeBack_INSTRUCTION;
  reg                 decode_arbitration_haltItself;
  reg                 decode_arbitration_haltByOther;
  reg                 decode_arbitration_removeIt;
  wire                decode_arbitration_flushIt;
  reg                 decode_arbitration_flushNext;
  reg                 decode_arbitration_isValid;
  wire                decode_arbitration_isStuck;
  wire                decode_arbitration_isStuckByOthers;
  wire                decode_arbitration_isFlushed;
  wire                decode_arbitration_isMoving;
  wire                decode_arbitration_isFiring;
  reg                 execute_arbitration_haltItself;
  reg                 execute_arbitration_haltByOther;
  reg                 execute_arbitration_removeIt;
  reg                 execute_arbitration_flushIt;
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
  (* keep , syn_keep *) wire       [31:0]   IBusCachedPlugin_predictionJumpInterface_payload /* synthesis syn_keep = 1 */ ;
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
  wire                IBusCachedPlugin_mmuBus_rsp_allowRead;
  wire                IBusCachedPlugin_mmuBus_rsp_allowWrite;
  wire                IBusCachedPlugin_mmuBus_rsp_allowExecute;
  wire                IBusCachedPlugin_mmuBus_rsp_exception;
  wire                IBusCachedPlugin_mmuBus_rsp_refilling;
  wire                IBusCachedPlugin_mmuBus_end;
  wire                IBusCachedPlugin_mmuBus_busy;
  wire                DBusCachedPlugin_mmuBus_cmd_isValid;
  wire       [31:0]   DBusCachedPlugin_mmuBus_cmd_virtualAddress;
  wire                DBusCachedPlugin_mmuBus_cmd_bypassTranslation;
  wire       [31:0]   DBusCachedPlugin_mmuBus_rsp_physicalAddress;
  wire                DBusCachedPlugin_mmuBus_rsp_isIoAccess;
  wire                DBusCachedPlugin_mmuBus_rsp_allowRead;
  wire                DBusCachedPlugin_mmuBus_rsp_allowWrite;
  wire                DBusCachedPlugin_mmuBus_rsp_allowExecute;
  wire                DBusCachedPlugin_mmuBus_rsp_exception;
  wire                DBusCachedPlugin_mmuBus_rsp_refilling;
  wire                DBusCachedPlugin_mmuBus_end;
  wire                DBusCachedPlugin_mmuBus_busy;
  reg                 DBusCachedPlugin_redoBranch_valid;
  wire       [31:0]   DBusCachedPlugin_redoBranch_payload;
  reg                 DBusCachedPlugin_exceptionBus_valid;
  reg        [3:0]    DBusCachedPlugin_exceptionBus_payload_code;
  wire       [31:0]   DBusCachedPlugin_exceptionBus_payload_badAddr;
  reg                 _zz_55_;
  wire                decodeExceptionPort_valid;
  wire       [3:0]    decodeExceptionPort_payload_code;
  wire       [31:0]   decodeExceptionPort_payload_badAddr;
  wire                BranchPlugin_jumpInterface_valid;
  wire       [31:0]   BranchPlugin_jumpInterface_payload;
  wire                BranchPlugin_branchExceptionPort_valid;
  wire       [3:0]    BranchPlugin_branchExceptionPort_payload_code;
  wire       [31:0]   BranchPlugin_branchExceptionPort_payload_badAddr;
  wire                CsrPlugin_inWfi /* verilator public */ ;
  reg                 CsrPlugin_thirdPartyWake;
  reg                 CsrPlugin_jumpInterface_valid;
  reg        [31:0]   CsrPlugin_jumpInterface_payload;
  wire                CsrPlugin_exceptionPendings_0;
  wire                CsrPlugin_exceptionPendings_1;
  wire                CsrPlugin_exceptionPendings_2;
  wire                CsrPlugin_exceptionPendings_3;
  wire                externalInterrupt;
  wire                contextSwitching;
  reg        [1:0]    CsrPlugin_privilege;
  reg                 CsrPlugin_forceMachineWire;
  reg                 CsrPlugin_selfException_valid;
  reg        [3:0]    CsrPlugin_selfException_payload_code;
  wire       [31:0]   CsrPlugin_selfException_payload_badAddr;
  reg                 CsrPlugin_allowInterrupts;
  reg                 CsrPlugin_allowException;
  reg                 IBusCachedPlugin_injectionPort_valid;
  reg                 IBusCachedPlugin_injectionPort_ready;
  wire       [31:0]   IBusCachedPlugin_injectionPort_payload;
  wire                IBusCachedPlugin_externalFlush;
  wire                IBusCachedPlugin_jump_pcLoad_valid;
  wire       [31:0]   IBusCachedPlugin_jump_pcLoad_payload;
  wire       [3:0]    _zz_56_;
  wire       [3:0]    _zz_57_;
  wire                _zz_58_;
  wire                _zz_59_;
  wire                _zz_60_;
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
  wire                _zz_61_;
  wire                _zz_62_;
  wire                _zz_63_;
  wire                IBusCachedPlugin_iBusRsp_flush;
  wire                _zz_64_;
  wire                _zz_65_;
  reg                 _zz_66_;
  wire                _zz_67_;
  reg                 _zz_68_;
  reg        [31:0]   _zz_69_;
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
  wire                _zz_70_;
  reg        [18:0]   _zz_71_;
  wire                _zz_72_;
  reg        [10:0]   _zz_73_;
  wire                _zz_74_;
  reg        [18:0]   _zz_75_;
  reg                 _zz_76_;
  wire                _zz_77_;
  reg        [10:0]   _zz_78_;
  wire                _zz_79_;
  reg        [18:0]   _zz_80_;
  wire                iBus_cmd_valid;
  wire                iBus_cmd_ready;
  reg        [31:0]   iBus_cmd_payload_address;
  wire       [2:0]    iBus_cmd_payload_size;
  wire                iBus_rsp_valid;
  wire       [31:0]   iBus_rsp_payload_data;
  wire                iBus_rsp_payload_error;
  wire       [31:0]   _zz_81_;
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
  wire       [31:0]   _zz_82_;
  reg        [31:0]   DBusCachedPlugin_rspCounter;
  wire       [1:0]    execute_DBusCachedPlugin_size;
  reg        [31:0]   _zz_83_;
  reg        [31:0]   writeBack_DBusCachedPlugin_rspShifted;
  wire                _zz_84_;
  reg        [31:0]   _zz_85_;
  wire                _zz_86_;
  reg        [31:0]   _zz_87_;
  reg        [31:0]   writeBack_DBusCachedPlugin_rspFormated;
  wire       [32:0]   _zz_88_;
  wire                _zz_89_;
  wire                _zz_90_;
  wire                _zz_91_;
  wire                _zz_92_;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_93_;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_94_;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_95_;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_96_;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_97_;
  wire       `EnvCtrlEnum_defaultEncoding_type _zz_98_;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_99_;
  wire       [4:0]    decode_RegFilePlugin_regFileReadAddress1;
  wire       [4:0]    decode_RegFilePlugin_regFileReadAddress2;
  wire       [31:0]   decode_RegFilePlugin_rs1Data;
  wire       [31:0]   decode_RegFilePlugin_rs2Data;
  reg                 lastStageRegFileWrite_valid /* verilator public */ ;
  wire       [4:0]    lastStageRegFileWrite_payload_address /* verilator public */ ;
  wire       [31:0]   lastStageRegFileWrite_payload_data /* verilator public */ ;
  reg                 _zz_100_;
  reg        [31:0]   execute_IntAluPlugin_bitwise;
  reg        [31:0]   _zz_101_;
  reg        [31:0]   _zz_102_;
  wire                _zz_103_;
  reg        [19:0]   _zz_104_;
  wire                _zz_105_;
  reg        [19:0]   _zz_106_;
  reg        [31:0]   _zz_107_;
  reg        [31:0]   execute_SrcPlugin_addSub;
  wire                execute_SrcPlugin_less;
  wire       [4:0]    execute_FullBarrelShifterPlugin_amplitude;
  reg        [31:0]   _zz_108_;
  wire       [31:0]   execute_FullBarrelShifterPlugin_reversed;
  reg        [31:0]   _zz_109_;
  reg                 _zz_110_;
  reg                 _zz_111_;
  reg                 _zz_112_;
  reg        [4:0]    _zz_113_;
  reg        [31:0]   _zz_114_;
  wire                _zz_115_;
  wire                _zz_116_;
  wire                _zz_117_;
  wire                _zz_118_;
  wire                _zz_119_;
  wire                _zz_120_;
  wire                execute_BranchPlugin_eq;
  wire       [2:0]    _zz_121_;
  reg                 _zz_122_;
  reg                 _zz_123_;
  wire                _zz_124_;
  reg        [19:0]   _zz_125_;
  wire                _zz_126_;
  reg        [10:0]   _zz_127_;
  wire                _zz_128_;
  reg        [18:0]   _zz_129_;
  reg                 _zz_130_;
  wire                execute_BranchPlugin_missAlignedTarget;
  reg        [31:0]   execute_BranchPlugin_branch_src1;
  reg        [31:0]   execute_BranchPlugin_branch_src2;
  wire                _zz_131_;
  reg        [19:0]   _zz_132_;
  wire                _zz_133_;
  reg        [10:0]   _zz_134_;
  wire                _zz_135_;
  reg        [18:0]   _zz_136_;
  wire       [31:0]   execute_BranchPlugin_branchAdder;
  wire       [1:0]    CsrPlugin_misa_base;
  wire       [25:0]   CsrPlugin_misa_extensions;
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
  reg                 CsrPlugin_mcause_interrupt;
  reg        [3:0]    CsrPlugin_mcause_exceptionCode;
  reg        [31:0]   CsrPlugin_mtval;
  reg        [63:0]   CsrPlugin_mcycle = 64'b0000000000000000000000000000000000000000000000000000000000000000;
  reg        [63:0]   CsrPlugin_minstret = 64'b0000000000000000000000000000000000000000000000000000000000000000;
  wire                _zz_137_;
  wire                _zz_138_;
  wire                _zz_139_;
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
  wire       [1:0]    _zz_140_;
  wire                _zz_141_;
  reg                 CsrPlugin_interrupt_valid;
  reg        [3:0]    CsrPlugin_interrupt_code /* verilator public */ ;
  reg        [1:0]    CsrPlugin_interrupt_targetPrivilege;
  wire                CsrPlugin_exception;
  wire                CsrPlugin_lastStageWasWfi;
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
  wire       [31:0]   _zz_142_;
  wire       [32:0]   memory_DivPlugin_div_stage_0_remainderShifted;
  wire       [32:0]   memory_DivPlugin_div_stage_0_remainderMinusDenominator;
  wire       [31:0]   memory_DivPlugin_div_stage_0_outRemainder;
  wire       [31:0]   memory_DivPlugin_div_stage_0_outNumerator;
  wire       [31:0]   _zz_143_;
  wire                _zz_144_;
  wire                _zz_145_;
  reg        [32:0]   _zz_146_;
  reg        [31:0]   externalInterruptArray_regNext;
  reg        [31:0]   _zz_147_;
  wire       [31:0]   _zz_148_;
  reg                 DebugPlugin_firstCycle;
  reg                 DebugPlugin_secondCycle;
  reg                 DebugPlugin_resetIt;
  reg                 DebugPlugin_haltIt;
  reg                 DebugPlugin_stepIt;
  reg                 DebugPlugin_isPipBusy;
  reg                 DebugPlugin_godmode;
  reg                 DebugPlugin_haltedByBreak;
  reg        [31:0]   DebugPlugin_busReadDataReg;
  reg                 _zz_149_;
  wire                DebugPlugin_allowEBreak;
  reg                 DebugPlugin_resetIt_regNext;
  reg                 decode_to_execute_CSR_WRITE_OPCODE;
  reg                 execute_to_memory_BRANCH_DO;
  reg                 decode_to_execute_IS_RS2_SIGNED;
  reg                 decode_to_execute_SRC2_FORCE_ZERO;
  reg        [31:0]   decode_to_execute_RS1;
  reg                 decode_to_execute_IS_DIV;
  reg                 execute_to_memory_IS_DIV;
  reg                 decode_to_execute_PREDICTION_HAD_BRANCHED2;
  reg                 decode_to_execute_IS_CSR;
  reg        `EnvCtrlEnum_defaultEncoding_type decode_to_execute_ENV_CTRL;
  reg        `EnvCtrlEnum_defaultEncoding_type execute_to_memory_ENV_CTRL;
  reg        `EnvCtrlEnum_defaultEncoding_type memory_to_writeBack_ENV_CTRL;
  reg        [31:0]   execute_to_memory_REGFILE_WRITE_DATA;
  reg        [31:0]   memory_to_writeBack_REGFILE_WRITE_DATA;
  reg        [33:0]   execute_to_memory_MUL_HL;
  reg                 decode_to_execute_IS_MUL;
  reg                 execute_to_memory_IS_MUL;
  reg                 memory_to_writeBack_IS_MUL;
  reg        `Src2CtrlEnum_defaultEncoding_type decode_to_execute_SRC2_CTRL;
  reg        `AluCtrlEnum_defaultEncoding_type decode_to_execute_ALU_CTRL;
  reg        [31:0]   decode_to_execute_RS2;
  reg        [31:0]   decode_to_execute_PC;
  reg        [31:0]   execute_to_memory_PC;
  reg        [31:0]   memory_to_writeBack_PC;
  reg                 decode_to_execute_MEMORY_MANAGMENT;
  reg                 decode_to_execute_SRC_LESS_UNSIGNED;
  reg                 decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  reg                 execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  reg                 decode_to_execute_REGFILE_WRITE_VALID;
  reg                 execute_to_memory_REGFILE_WRITE_VALID;
  reg                 memory_to_writeBack_REGFILE_WRITE_VALID;
  reg        [33:0]   execute_to_memory_MUL_HH;
  reg        [33:0]   memory_to_writeBack_MUL_HH;
  reg        [31:0]   execute_to_memory_MUL_LL;
  reg                 decode_to_execute_MEMORY_ENABLE;
  reg                 execute_to_memory_MEMORY_ENABLE;
  reg                 memory_to_writeBack_MEMORY_ENABLE;
  reg        `AluBitwiseCtrlEnum_defaultEncoding_type decode_to_execute_ALU_BITWISE_CTRL;
  reg        `Src1CtrlEnum_defaultEncoding_type decode_to_execute_SRC1_CTRL;
  reg        [31:0]   decode_to_execute_INSTRUCTION;
  reg        [31:0]   execute_to_memory_INSTRUCTION;
  reg        [31:0]   memory_to_writeBack_INSTRUCTION;
  reg                 decode_to_execute_DO_EBREAK;
  reg                 decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  reg                 decode_to_execute_IS_RS1_SIGNED;
  reg        [31:0]   execute_to_memory_BRANCH_CALC;
  reg                 decode_to_execute_SRC_USE_SUB_LESS;
  reg        `ShiftCtrlEnum_defaultEncoding_type decode_to_execute_SHIFT_CTRL;
  reg        `ShiftCtrlEnum_defaultEncoding_type execute_to_memory_SHIFT_CTRL;
  reg        [31:0]   execute_to_memory_SHIFT_RIGHT;
  reg                 decode_to_execute_MEMORY_WR;
  reg                 execute_to_memory_MEMORY_WR;
  reg                 memory_to_writeBack_MEMORY_WR;
  reg        `BranchCtrlEnum_defaultEncoding_type decode_to_execute_BRANCH_CTRL;
  reg        [51:0]   memory_to_writeBack_MUL_LOW;
  reg                 decode_to_execute_CSR_READ_OPCODE;
  reg        [33:0]   execute_to_memory_MUL_LH;
  reg        [31:0]   decode_to_execute_FORMAL_PC_NEXT;
  reg        [31:0]   execute_to_memory_FORMAL_PC_NEXT;
  reg        [31:0]   memory_to_writeBack_FORMAL_PC_NEXT;
  reg        [1:0]    execute_to_memory_MEMORY_ADDRESS_LOW;
  reg        [1:0]    memory_to_writeBack_MEMORY_ADDRESS_LOW;
  reg        [2:0]    _zz_150_;
  reg                 execute_CsrPlugin_csr_3264;
  reg                 execute_CsrPlugin_csr_768;
  reg                 execute_CsrPlugin_csr_836;
  reg                 execute_CsrPlugin_csr_772;
  reg                 execute_CsrPlugin_csr_773;
  reg                 execute_CsrPlugin_csr_833;
  reg                 execute_CsrPlugin_csr_834;
  reg                 execute_CsrPlugin_csr_835;
  reg                 execute_CsrPlugin_csr_3008;
  reg                 execute_CsrPlugin_csr_4032;
  reg        [31:0]   _zz_151_;
  reg        [31:0]   _zz_152_;
  reg        [31:0]   _zz_153_;
  reg        [31:0]   _zz_154_;
  reg        [31:0]   _zz_155_;
  reg        [31:0]   _zz_156_;
  reg        [31:0]   _zz_157_;
  reg        [31:0]   _zz_158_;
  reg        [31:0]   _zz_159_;
  reg        [2:0]    _zz_160_;
  reg                 _zz_161_;
  reg        [31:0]   iBusWishbone_DAT_MISO_regNext;
  reg        [2:0]    _zz_162_;
  wire                _zz_163_;
  wire                _zz_164_;
  wire                _zz_165_;
  wire                _zz_166_;
  wire                _zz_167_;
  reg                 _zz_168_;
  reg        [31:0]   dBusWishbone_DAT_MISO_regNext;
  `ifndef SYNTHESIS
  reg [31:0] _zz_1__string;
  reg [31:0] _zz_2__string;
  reg [71:0] _zz_3__string;
  reg [71:0] _zz_4__string;
  reg [71:0] decode_SHIFT_CTRL_string;
  reg [71:0] _zz_5__string;
  reg [71:0] _zz_6__string;
  reg [71:0] _zz_7__string;
  reg [95:0] decode_SRC1_CTRL_string;
  reg [95:0] _zz_8__string;
  reg [95:0] _zz_9__string;
  reg [95:0] _zz_10__string;
  reg [39:0] decode_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_11__string;
  reg [39:0] _zz_12__string;
  reg [39:0] _zz_13__string;
  reg [63:0] decode_ALU_CTRL_string;
  reg [63:0] _zz_14__string;
  reg [63:0] _zz_15__string;
  reg [63:0] _zz_16__string;
  reg [23:0] decode_SRC2_CTRL_string;
  reg [23:0] _zz_17__string;
  reg [23:0] _zz_18__string;
  reg [23:0] _zz_19__string;
  reg [39:0] _zz_20__string;
  reg [39:0] _zz_21__string;
  reg [39:0] _zz_22__string;
  reg [39:0] _zz_23__string;
  reg [39:0] decode_ENV_CTRL_string;
  reg [39:0] _zz_24__string;
  reg [39:0] _zz_25__string;
  reg [39:0] _zz_26__string;
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
  reg [39:0] _zz_43__string;
  reg [39:0] _zz_44__string;
  reg [23:0] _zz_45__string;
  reg [63:0] _zz_46__string;
  reg [71:0] _zz_47__string;
  reg [31:0] _zz_48__string;
  reg [95:0] _zz_49__string;
  reg [31:0] decode_BRANCH_CTRL_string;
  reg [31:0] _zz_52__string;
  reg [95:0] _zz_93__string;
  reg [31:0] _zz_94__string;
  reg [71:0] _zz_95__string;
  reg [63:0] _zz_96__string;
  reg [23:0] _zz_97__string;
  reg [39:0] _zz_98__string;
  reg [39:0] _zz_99__string;
  reg [39:0] decode_to_execute_ENV_CTRL_string;
  reg [39:0] execute_to_memory_ENV_CTRL_string;
  reg [39:0] memory_to_writeBack_ENV_CTRL_string;
  reg [23:0] decode_to_execute_SRC2_CTRL_string;
  reg [63:0] decode_to_execute_ALU_CTRL_string;
  reg [39:0] decode_to_execute_ALU_BITWISE_CTRL_string;
  reg [95:0] decode_to_execute_SRC1_CTRL_string;
  reg [71:0] decode_to_execute_SHIFT_CTRL_string;
  reg [71:0] execute_to_memory_SHIFT_CTRL_string;
  reg [31:0] decode_to_execute_BRANCH_CTRL_string;
  `endif

  (* ram_style = "block" *) reg [31:0] RegFilePlugin_regFile [0:31] /* verilator public */ ;

  assign _zz_190_ = (execute_arbitration_isValid && execute_IS_CSR);
  assign _zz_191_ = (writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID);
  assign _zz_192_ = 1'b1;
  assign _zz_193_ = (memory_arbitration_isValid && memory_REGFILE_WRITE_VALID);
  assign _zz_194_ = (execute_arbitration_isValid && execute_REGFILE_WRITE_VALID);
  assign _zz_195_ = (memory_arbitration_isValid && memory_IS_DIV);
  assign _zz_196_ = ((_zz_173_ && IBusCachedPlugin_cache_io_cpu_decode_error) && (! _zz_51__2));
  assign _zz_197_ = ((_zz_173_ && IBusCachedPlugin_cache_io_cpu_decode_cacheMiss) && (! _zz_51__1));
  assign _zz_198_ = ((_zz_173_ && IBusCachedPlugin_cache_io_cpu_decode_mmuException) && (! _zz_51__0));
  assign _zz_199_ = ((_zz_173_ && IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling) && (! IBusCachedPlugin_rsp_issueDetected));
  assign _zz_200_ = ({decodeExceptionPort_valid,IBusCachedPlugin_decodeExceptionPort_valid} != (2'b00));
  assign _zz_201_ = (execute_arbitration_isValid && execute_DO_EBREAK);
  assign _zz_202_ = (({writeBack_arbitration_isValid,memory_arbitration_isValid} != (2'b00)) == 1'b0);
  assign _zz_203_ = (CsrPlugin_hadException || CsrPlugin_interruptJump);
  assign _zz_204_ = (writeBack_arbitration_isValid && (writeBack_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET));
  assign _zz_205_ = (DebugPlugin_stepIt && IBusCachedPlugin_incomingInstruction);
  assign _zz_206_ = writeBack_INSTRUCTION[29 : 28];
  assign _zz_207_ = (writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE);
  assign _zz_208_ = (writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID);
  assign _zz_209_ = (1'b0 || (! 1'b1));
  assign _zz_210_ = (memory_arbitration_isValid && memory_REGFILE_WRITE_VALID);
  assign _zz_211_ = (1'b0 || (! memory_BYPASSABLE_MEMORY_STAGE));
  assign _zz_212_ = (execute_arbitration_isValid && execute_REGFILE_WRITE_VALID);
  assign _zz_213_ = (1'b0 || (! execute_BYPASSABLE_EXECUTE_STAGE));
  assign _zz_214_ = (CsrPlugin_privilege < execute_CsrPlugin_csrAddress[9 : 8]);
  assign _zz_215_ = (execute_arbitration_isValid && (execute_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_ECALL));
  assign _zz_216_ = execute_INSTRUCTION[13 : 12];
  assign _zz_217_ = (memory_DivPlugin_frontendOk && (! memory_DivPlugin_div_done));
  assign _zz_218_ = (! memory_arbitration_isStuck);
  assign _zz_219_ = debug_bus_cmd_payload_address[7 : 2];
  assign _zz_220_ = (iBus_cmd_valid || (_zz_160_ != (3'b000)));
  assign _zz_221_ = (_zz_186_ && (! dataCache_1__io_mem_cmd_s2mPipe_ready));
  assign _zz_222_ = (CsrPlugin_mstatus_MIE || (CsrPlugin_privilege < (2'b11)));
  assign _zz_223_ = ((_zz_137_ && 1'b1) && (! 1'b0));
  assign _zz_224_ = ((_zz_138_ && 1'b1) && (! 1'b0));
  assign _zz_225_ = ((_zz_139_ && 1'b1) && (! 1'b0));
  assign _zz_226_ = writeBack_INSTRUCTION[13 : 12];
  assign _zz_227_ = execute_INSTRUCTION[13];
  assign _zz_228_ = writeBack_INSTRUCTION[13 : 12];
  assign _zz_229_ = ($signed(_zz_230_) + $signed(_zz_235_));
  assign _zz_230_ = ($signed(_zz_231_) + $signed(_zz_233_));
  assign _zz_231_ = 52'h0;
  assign _zz_232_ = {1'b0,memory_MUL_LL};
  assign _zz_233_ = {{19{_zz_232_[32]}}, _zz_232_};
  assign _zz_234_ = ({16'd0,memory_MUL_LH} <<< 16);
  assign _zz_235_ = {{2{_zz_234_[49]}}, _zz_234_};
  assign _zz_236_ = ({16'd0,memory_MUL_HL} <<< 16);
  assign _zz_237_ = {{2{_zz_236_[49]}}, _zz_236_};
  assign _zz_238_ = _zz_88_[5 : 5];
  assign _zz_239_ = ($signed(_zz_241_) >>> execute_FullBarrelShifterPlugin_amplitude);
  assign _zz_240_ = _zz_239_[31 : 0];
  assign _zz_241_ = {((execute_SHIFT_CTRL == `ShiftCtrlEnum_defaultEncoding_SRA_1) && execute_FullBarrelShifterPlugin_reversed[31]),execute_FullBarrelShifterPlugin_reversed};
  assign _zz_242_ = _zz_88_[10 : 10];
  assign _zz_243_ = _zz_88_[9 : 9];
  assign _zz_244_ = _zz_88_[8 : 8];
  assign _zz_245_ = _zz_88_[6 : 6];
  assign _zz_246_ = _zz_88_[17 : 17];
  assign _zz_247_ = _zz_88_[13 : 13];
  assign _zz_248_ = _zz_88_[24 : 24];
  assign _zz_249_ = _zz_88_[14 : 14];
  assign _zz_250_ = _zz_88_[12 : 12];
  assign _zz_251_ = _zz_88_[18 : 18];
  assign _zz_252_ = _zz_88_[4 : 4];
  assign _zz_253_ = _zz_88_[29 : 29];
  assign _zz_254_ = _zz_88_[3 : 3];
  assign _zz_255_ = _zz_88_[11 : 11];
  assign _zz_256_ = _zz_88_[23 : 23];
  assign _zz_257_ = _zz_88_[32 : 32];
  assign _zz_258_ = _zz_88_[0 : 0];
  assign _zz_259_ = (_zz_56_ - (4'b0001));
  assign _zz_260_ = {IBusCachedPlugin_fetchPc_inc,(2'b00)};
  assign _zz_261_ = {29'd0, _zz_260_};
  assign _zz_262_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_263_ = {{_zz_71_,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_264_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]};
  assign _zz_265_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_266_ = {{_zz_73_,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]}},1'b0};
  assign _zz_267_ = {{_zz_75_,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_268_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]};
  assign _zz_269_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_270_ = (writeBack_MEMORY_WR ? (3'b111) : (3'b101));
  assign _zz_271_ = (writeBack_MEMORY_WR ? (3'b110) : (3'b100));
  assign _zz_272_ = execute_SRC_LESS;
  assign _zz_273_ = (3'b100);
  assign _zz_274_ = execute_INSTRUCTION[19 : 15];
  assign _zz_275_ = execute_INSTRUCTION[31 : 20];
  assign _zz_276_ = {execute_INSTRUCTION[31 : 25],execute_INSTRUCTION[11 : 7]};
  assign _zz_277_ = ($signed(_zz_278_) + $signed(_zz_281_));
  assign _zz_278_ = ($signed(_zz_279_) + $signed(_zz_280_));
  assign _zz_279_ = execute_SRC1;
  assign _zz_280_ = (execute_SRC_USE_SUB_LESS ? (~ execute_SRC2) : execute_SRC2);
  assign _zz_281_ = (execute_SRC_USE_SUB_LESS ? _zz_282_ : _zz_283_);
  assign _zz_282_ = 32'h00000001;
  assign _zz_283_ = 32'h0;
  assign _zz_284_ = execute_INSTRUCTION[31 : 20];
  assign _zz_285_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]};
  assign _zz_286_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]};
  assign _zz_287_ = {_zz_125_,execute_INSTRUCTION[31 : 20]};
  assign _zz_288_ = {{_zz_127_,{{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]}},1'b0};
  assign _zz_289_ = {{_zz_129_,{{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_290_ = execute_INSTRUCTION[31 : 20];
  assign _zz_291_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]};
  assign _zz_292_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]};
  assign _zz_293_ = (3'b100);
  assign _zz_294_ = (_zz_140_ & (~ _zz_295_));
  assign _zz_295_ = (_zz_140_ - (2'b01));
  assign _zz_296_ = {{14{writeBack_MUL_LOW[51]}}, writeBack_MUL_LOW};
  assign _zz_297_ = ({32'd0,writeBack_MUL_HH} <<< 32);
  assign _zz_298_ = writeBack_MUL_LOW[31 : 0];
  assign _zz_299_ = writeBack_MulPlugin_result[63 : 32];
  assign _zz_300_ = memory_DivPlugin_div_counter_willIncrement;
  assign _zz_301_ = {5'd0, _zz_300_};
  assign _zz_302_ = {1'd0, memory_DivPlugin_rs2};
  assign _zz_303_ = memory_DivPlugin_div_stage_0_remainderMinusDenominator[31:0];
  assign _zz_304_ = memory_DivPlugin_div_stage_0_remainderShifted[31:0];
  assign _zz_305_ = {_zz_142_,(! memory_DivPlugin_div_stage_0_remainderMinusDenominator[32])};
  assign _zz_306_ = _zz_307_;
  assign _zz_307_ = _zz_308_;
  assign _zz_308_ = ({1'b0,(memory_DivPlugin_div_needRevert ? (~ _zz_143_) : _zz_143_)} + _zz_310_);
  assign _zz_309_ = memory_DivPlugin_div_needRevert;
  assign _zz_310_ = {32'd0, _zz_309_};
  assign _zz_311_ = _zz_145_;
  assign _zz_312_ = {32'd0, _zz_311_};
  assign _zz_313_ = _zz_144_;
  assign _zz_314_ = {31'd0, _zz_313_};
  assign _zz_315_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_316_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_317_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_318_ = execute_CsrPlugin_writeData[11 : 11];
  assign _zz_319_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_320_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_321_ = (iBus_cmd_payload_address >>> 5);
  assign _zz_322_ = 1'b1;
  assign _zz_323_ = 1'b1;
  assign _zz_324_ = {_zz_60_,_zz_59_};
  assign _zz_325_ = 32'h0000107f;
  assign _zz_326_ = (decode_INSTRUCTION & 32'h0000207f);
  assign _zz_327_ = 32'h00002073;
  assign _zz_328_ = ((decode_INSTRUCTION & 32'h0000407f) == 32'h00004063);
  assign _zz_329_ = ((decode_INSTRUCTION & 32'h0000207f) == 32'h00002013);
  assign _zz_330_ = {((decode_INSTRUCTION & 32'h0000603f) == 32'h00000023),{((decode_INSTRUCTION & 32'h0000207f) == 32'h00000003),{((decode_INSTRUCTION & _zz_331_) == 32'h00000003),{(_zz_332_ == _zz_333_),{_zz_334_,{_zz_335_,_zz_336_}}}}}};
  assign _zz_331_ = 32'h0000505f;
  assign _zz_332_ = (decode_INSTRUCTION & 32'h0000707b);
  assign _zz_333_ = 32'h00000063;
  assign _zz_334_ = ((decode_INSTRUCTION & 32'h0000607f) == 32'h0000000f);
  assign _zz_335_ = ((decode_INSTRUCTION & 32'hfc00007f) == 32'h00000033);
  assign _zz_336_ = {((decode_INSTRUCTION & 32'h01f0707f) == 32'h0000500f),{((decode_INSTRUCTION & 32'hbc00707f) == 32'h00005013),{((decode_INSTRUCTION & _zz_337_) == 32'h00001013),{(_zz_338_ == _zz_339_),{_zz_340_,{_zz_341_,_zz_342_}}}}}};
  assign _zz_337_ = 32'hfc00307f;
  assign _zz_338_ = (decode_INSTRUCTION & 32'hbe00707f);
  assign _zz_339_ = 32'h00005033;
  assign _zz_340_ = ((decode_INSTRUCTION & 32'hbe00707f) == 32'h00000033);
  assign _zz_341_ = ((decode_INSTRUCTION & 32'hdfffffff) == 32'h10200073);
  assign _zz_342_ = {((decode_INSTRUCTION & 32'hffefffff) == 32'h00000073),((decode_INSTRUCTION & 32'hffffffff) == 32'h10500073)};
  assign _zz_343_ = decode_INSTRUCTION[31];
  assign _zz_344_ = decode_INSTRUCTION[31];
  assign _zz_345_ = decode_INSTRUCTION[7];
  assign _zz_346_ = 32'h00000058;
  assign _zz_347_ = (decode_INSTRUCTION & 32'h00001000);
  assign _zz_348_ = 32'h00001000;
  assign _zz_349_ = ((decode_INSTRUCTION & 32'h00003000) == 32'h00002000);
  assign _zz_350_ = {(_zz_355_ == _zz_356_),{_zz_357_,{_zz_358_,_zz_359_}}};
  assign _zz_351_ = (4'b0000);
  assign _zz_352_ = ((_zz_360_ == _zz_361_) != (1'b0));
  assign _zz_353_ = (_zz_362_ != (1'b0));
  assign _zz_354_ = {(_zz_363_ != _zz_364_),{_zz_365_,{_zz_366_,_zz_367_}}};
  assign _zz_355_ = (decode_INSTRUCTION & 32'h00000044);
  assign _zz_356_ = 32'h0;
  assign _zz_357_ = ((decode_INSTRUCTION & 32'h00000018) == 32'h0);
  assign _zz_358_ = ((decode_INSTRUCTION & _zz_368_) == 32'h00002000);
  assign _zz_359_ = ((decode_INSTRUCTION & _zz_369_) == 32'h00001000);
  assign _zz_360_ = (decode_INSTRUCTION & 32'h10103050);
  assign _zz_361_ = 32'h00000050;
  assign _zz_362_ = ((decode_INSTRUCTION & 32'h10403050) == 32'h10000050);
  assign _zz_363_ = {_zz_90_,(_zz_370_ == _zz_371_)};
  assign _zz_364_ = (2'b00);
  assign _zz_365_ = ({_zz_90_,_zz_372_} != (2'b00));
  assign _zz_366_ = ({_zz_373_,_zz_374_} != (2'b00));
  assign _zz_367_ = {(_zz_375_ != _zz_376_),{_zz_377_,{_zz_378_,_zz_379_}}};
  assign _zz_368_ = 32'h00006004;
  assign _zz_369_ = 32'h00005004;
  assign _zz_370_ = (decode_INSTRUCTION & 32'h00000070);
  assign _zz_371_ = 32'h00000020;
  assign _zz_372_ = ((decode_INSTRUCTION & 32'h00000020) == 32'h0);
  assign _zz_373_ = ((decode_INSTRUCTION & _zz_380_) == 32'h00001050);
  assign _zz_374_ = ((decode_INSTRUCTION & _zz_381_) == 32'h00002050);
  assign _zz_375_ = {_zz_92_,{_zz_382_,{_zz_383_,_zz_384_}}};
  assign _zz_376_ = 6'h0;
  assign _zz_377_ = ((_zz_385_ == _zz_386_) != (1'b0));
  assign _zz_378_ = (_zz_387_ != (1'b0));
  assign _zz_379_ = {(_zz_388_ != _zz_389_),{_zz_390_,{_zz_391_,_zz_392_}}};
  assign _zz_380_ = 32'h00001050;
  assign _zz_381_ = 32'h00002050;
  assign _zz_382_ = ((decode_INSTRUCTION & 32'h00001010) == 32'h00001010);
  assign _zz_383_ = ((decode_INSTRUCTION & _zz_393_) == 32'h00002010);
  assign _zz_384_ = {(_zz_394_ == _zz_395_),{_zz_396_,_zz_397_}};
  assign _zz_385_ = (decode_INSTRUCTION & 32'h00004014);
  assign _zz_386_ = 32'h00004010;
  assign _zz_387_ = ((decode_INSTRUCTION & 32'h00006014) == 32'h00002010);
  assign _zz_388_ = {(_zz_398_ == _zz_399_),(_zz_400_ == _zz_401_)};
  assign _zz_389_ = (2'b00);
  assign _zz_390_ = ({_zz_402_,{_zz_403_,_zz_404_}} != (3'b000));
  assign _zz_391_ = (_zz_405_ != (1'b0));
  assign _zz_392_ = {(_zz_406_ != _zz_407_),{_zz_408_,{_zz_409_,_zz_410_}}};
  assign _zz_393_ = 32'h00002010;
  assign _zz_394_ = (decode_INSTRUCTION & 32'h00000050);
  assign _zz_395_ = 32'h00000010;
  assign _zz_396_ = ((decode_INSTRUCTION & _zz_411_) == 32'h00000004);
  assign _zz_397_ = ((decode_INSTRUCTION & _zz_412_) == 32'h0);
  assign _zz_398_ = (decode_INSTRUCTION & 32'h00007034);
  assign _zz_399_ = 32'h00005010;
  assign _zz_400_ = (decode_INSTRUCTION & 32'h02007064);
  assign _zz_401_ = 32'h00005020;
  assign _zz_402_ = ((decode_INSTRUCTION & _zz_413_) == 32'h40001010);
  assign _zz_403_ = (_zz_414_ == _zz_415_);
  assign _zz_404_ = (_zz_416_ == _zz_417_);
  assign _zz_405_ = ((decode_INSTRUCTION & _zz_418_) == 32'h00100050);
  assign _zz_406_ = (_zz_419_ == _zz_420_);
  assign _zz_407_ = (1'b0);
  assign _zz_408_ = ({_zz_421_,_zz_422_} != (2'b00));
  assign _zz_409_ = (_zz_423_ != _zz_424_);
  assign _zz_410_ = {_zz_425_,{_zz_426_,_zz_427_}};
  assign _zz_411_ = 32'h0000000c;
  assign _zz_412_ = 32'h00000028;
  assign _zz_413_ = 32'h40003054;
  assign _zz_414_ = (decode_INSTRUCTION & 32'h00007034);
  assign _zz_415_ = 32'h00001010;
  assign _zz_416_ = (decode_INSTRUCTION & 32'h02007054);
  assign _zz_417_ = 32'h00001010;
  assign _zz_418_ = 32'h10103050;
  assign _zz_419_ = (decode_INSTRUCTION & 32'h00004048);
  assign _zz_420_ = 32'h00004008;
  assign _zz_421_ = _zz_92_;
  assign _zz_422_ = ((decode_INSTRUCTION & 32'h0000001c) == 32'h00000004);
  assign _zz_423_ = ((decode_INSTRUCTION & 32'h00000058) == 32'h00000040);
  assign _zz_424_ = (1'b0);
  assign _zz_425_ = (((decode_INSTRUCTION & _zz_428_) == 32'h02004020) != (1'b0));
  assign _zz_426_ = ((_zz_429_ == _zz_430_) != (1'b0));
  assign _zz_427_ = {(_zz_91_ != (1'b0)),{(_zz_431_ != _zz_432_),{_zz_433_,{_zz_434_,_zz_435_}}}};
  assign _zz_428_ = 32'h02004064;
  assign _zz_429_ = (decode_INSTRUCTION & 32'h02004074);
  assign _zz_430_ = 32'h02000030;
  assign _zz_431_ = ((decode_INSTRUCTION & 32'h00000064) == 32'h00000024);
  assign _zz_432_ = (1'b0);
  assign _zz_433_ = (_zz_91_ != (1'b0));
  assign _zz_434_ = ({_zz_90_,{_zz_436_,{_zz_437_,_zz_438_}}} != 5'h0);
  assign _zz_435_ = {({_zz_439_,{_zz_440_,_zz_441_}} != 5'h0),{({_zz_442_,_zz_443_} != (3'b000)),{(_zz_444_ != _zz_445_),{_zz_446_,{_zz_447_,_zz_448_}}}}};
  assign _zz_436_ = ((decode_INSTRUCTION & _zz_449_) == 32'h00002010);
  assign _zz_437_ = (_zz_450_ == _zz_451_);
  assign _zz_438_ = {_zz_452_,_zz_453_};
  assign _zz_439_ = ((decode_INSTRUCTION & _zz_454_) == 32'h00000040);
  assign _zz_440_ = _zz_90_;
  assign _zz_441_ = {_zz_455_,{_zz_456_,_zz_457_}};
  assign _zz_442_ = (_zz_458_ == _zz_459_);
  assign _zz_443_ = {_zz_460_,_zz_461_};
  assign _zz_444_ = {_zz_462_,_zz_463_};
  assign _zz_445_ = (2'b00);
  assign _zz_446_ = (_zz_464_ != (1'b0));
  assign _zz_447_ = (_zz_465_ != _zz_466_);
  assign _zz_448_ = {_zz_467_,{_zz_468_,_zz_469_}};
  assign _zz_449_ = 32'h00002030;
  assign _zz_450_ = (decode_INSTRUCTION & 32'h00001030);
  assign _zz_451_ = 32'h00000010;
  assign _zz_452_ = ((decode_INSTRUCTION & _zz_470_) == 32'h00002020);
  assign _zz_453_ = ((decode_INSTRUCTION & _zz_471_) == 32'h00000020);
  assign _zz_454_ = 32'h00000040;
  assign _zz_455_ = ((decode_INSTRUCTION & _zz_472_) == 32'h00004020);
  assign _zz_456_ = (_zz_473_ == _zz_474_);
  assign _zz_457_ = (_zz_475_ == _zz_476_);
  assign _zz_458_ = (decode_INSTRUCTION & 32'h00000050);
  assign _zz_459_ = 32'h00000040;
  assign _zz_460_ = ((decode_INSTRUCTION & _zz_477_) == 32'h0);
  assign _zz_461_ = ((decode_INSTRUCTION & _zz_478_) == 32'h00000040);
  assign _zz_462_ = ((decode_INSTRUCTION & _zz_479_) == 32'h00002000);
  assign _zz_463_ = ((decode_INSTRUCTION & _zz_480_) == 32'h00001000);
  assign _zz_464_ = ((decode_INSTRUCTION & _zz_481_) == 32'h00000020);
  assign _zz_465_ = {_zz_482_,_zz_483_};
  assign _zz_466_ = (2'b00);
  assign _zz_467_ = ({_zz_484_,_zz_485_} != (3'b000));
  assign _zz_468_ = (_zz_486_ != _zz_487_);
  assign _zz_469_ = {_zz_488_,_zz_489_};
  assign _zz_470_ = 32'h02002060;
  assign _zz_471_ = 32'h02003020;
  assign _zz_472_ = 32'h00004020;
  assign _zz_473_ = (decode_INSTRUCTION & 32'h00000030);
  assign _zz_474_ = 32'h00000010;
  assign _zz_475_ = (decode_INSTRUCTION & 32'h02000020);
  assign _zz_476_ = 32'h00000020;
  assign _zz_477_ = 32'h00000038;
  assign _zz_478_ = 32'h00103040;
  assign _zz_479_ = 32'h00002010;
  assign _zz_480_ = 32'h00005000;
  assign _zz_481_ = 32'h00000020;
  assign _zz_482_ = ((decode_INSTRUCTION & 32'h00000034) == 32'h00000020);
  assign _zz_483_ = ((decode_INSTRUCTION & 32'h00000064) == 32'h00000020);
  assign _zz_484_ = ((decode_INSTRUCTION & _zz_490_) == 32'h00000040);
  assign _zz_485_ = {(_zz_491_ == _zz_492_),(_zz_493_ == _zz_494_)};
  assign _zz_486_ = {(_zz_495_ == _zz_496_),_zz_89_};
  assign _zz_487_ = (2'b00);
  assign _zz_488_ = ({_zz_497_,_zz_89_} != (2'b00));
  assign _zz_489_ = ((_zz_498_ == _zz_499_) != (1'b0));
  assign _zz_490_ = 32'h00000044;
  assign _zz_491_ = (decode_INSTRUCTION & 32'h00002014);
  assign _zz_492_ = 32'h00002010;
  assign _zz_493_ = (decode_INSTRUCTION & 32'h40000034);
  assign _zz_494_ = 32'h40000030;
  assign _zz_495_ = (decode_INSTRUCTION & 32'h00000014);
  assign _zz_496_ = 32'h00000004;
  assign _zz_497_ = ((decode_INSTRUCTION & 32'h00000044) == 32'h00000004);
  assign _zz_498_ = (decode_INSTRUCTION & 32'h00005048);
  assign _zz_499_ = 32'h00001008;
  assign _zz_500_ = execute_INSTRUCTION[31];
  assign _zz_501_ = execute_INSTRUCTION[31];
  assign _zz_502_ = execute_INSTRUCTION[7];
  always @ (posedge clk) begin
    if(_zz_322_) begin
      _zz_187_ <= RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress1];
    end
  end

  always @ (posedge clk) begin
    if(_zz_323_) begin
      _zz_188_ <= RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress2];
    end
  end

  always @ (posedge clk) begin
    if(_zz_42_) begin
      RegFilePlugin_regFile[lastStageRegFileWrite_payload_address] <= lastStageRegFileWrite_payload_data;
    end
  end

  InstructionCache IBusCachedPlugin_cache ( 
    .io_flush                                     (_zz_169_                                                             ), //i
    .io_cpu_prefetch_isValid                      (_zz_170_                                                             ), //i
    .io_cpu_prefetch_haltIt                       (IBusCachedPlugin_cache_io_cpu_prefetch_haltIt                        ), //o
    .io_cpu_prefetch_pc                           (IBusCachedPlugin_iBusRsp_stages_0_input_payload[31:0]                ), //i
    .io_cpu_fetch_isValid                         (_zz_171_                                                             ), //i
    .io_cpu_fetch_isStuck                         (_zz_172_                                                             ), //i
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
    .io_cpu_decode_isValid                        (_zz_173_                                                             ), //i
    .io_cpu_decode_isStuck                        (_zz_174_                                                             ), //i
    .io_cpu_decode_pc                             (IBusCachedPlugin_iBusRsp_stages_2_input_payload[31:0]                ), //i
    .io_cpu_decode_physicalAddress                (IBusCachedPlugin_cache_io_cpu_decode_physicalAddress[31:0]           ), //o
    .io_cpu_decode_data                           (IBusCachedPlugin_cache_io_cpu_decode_data[31:0]                      ), //o
    .io_cpu_decode_cacheMiss                      (IBusCachedPlugin_cache_io_cpu_decode_cacheMiss                       ), //o
    .io_cpu_decode_error                          (IBusCachedPlugin_cache_io_cpu_decode_error                           ), //o
    .io_cpu_decode_mmuRefilling                   (IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling                    ), //o
    .io_cpu_decode_mmuException                   (IBusCachedPlugin_cache_io_cpu_decode_mmuException                    ), //o
    .io_cpu_decode_isUser                         (_zz_175_                                                             ), //i
    .io_cpu_fill_valid                            (_zz_176_                                                             ), //i
    .io_cpu_fill_payload                          (IBusCachedPlugin_cache_io_cpu_decode_physicalAddress[31:0]           ), //i
    .io_mem_cmd_valid                             (IBusCachedPlugin_cache_io_mem_cmd_valid                              ), //o
    .io_mem_cmd_ready                             (iBus_cmd_ready                                                       ), //i
    .io_mem_cmd_payload_address                   (IBusCachedPlugin_cache_io_mem_cmd_payload_address[31:0]              ), //o
    .io_mem_cmd_payload_size                      (IBusCachedPlugin_cache_io_mem_cmd_payload_size[2:0]                  ), //o
    .io_mem_rsp_valid                             (iBus_rsp_valid                                                       ), //i
    .io_mem_rsp_payload_data                      (iBus_rsp_payload_data[31:0]                                          ), //i
    .io_mem_rsp_payload_error                     (iBus_rsp_payload_error                                               ), //i
    ._zz_10_                                      (_zz_150_[2:0]                                                        ), //i
    ._zz_11_                                      (IBusCachedPlugin_injectionPort_payload[31:0]                         ), //i
    .clk                                          (clk                                                                  ), //i
    .reset                                        (reset                                                                )  //i
  );
  DataCache dataCache_1_ ( 
    .io_cpu_execute_isValid                        (_zz_177_                                                    ), //i
    .io_cpu_execute_address                        (_zz_178_[31:0]                                              ), //i
    .io_cpu_execute_args_wr                        (execute_MEMORY_WR                                           ), //i
    .io_cpu_execute_args_data                      (_zz_83_[31:0]                                               ), //i
    .io_cpu_execute_args_size                      (execute_DBusCachedPlugin_size[1:0]                          ), //i
    .io_cpu_memory_isValid                         (_zz_179_                                                    ), //i
    .io_cpu_memory_isStuck                         (memory_arbitration_isStuck                                  ), //i
    .io_cpu_memory_isRemoved                       (memory_arbitration_removeIt                                 ), //i
    .io_cpu_memory_isWrite                         (dataCache_1__io_cpu_memory_isWrite                          ), //o
    .io_cpu_memory_address                         (_zz_180_[31:0]                                              ), //i
    .io_cpu_memory_mmuBus_cmd_isValid              (dataCache_1__io_cpu_memory_mmuBus_cmd_isValid               ), //o
    .io_cpu_memory_mmuBus_cmd_virtualAddress       (dataCache_1__io_cpu_memory_mmuBus_cmd_virtualAddress[31:0]  ), //o
    .io_cpu_memory_mmuBus_cmd_bypassTranslation    (dataCache_1__io_cpu_memory_mmuBus_cmd_bypassTranslation     ), //o
    .io_cpu_memory_mmuBus_rsp_physicalAddress      (DBusCachedPlugin_mmuBus_rsp_physicalAddress[31:0]           ), //i
    .io_cpu_memory_mmuBus_rsp_isIoAccess           (_zz_181_                                                    ), //i
    .io_cpu_memory_mmuBus_rsp_allowRead            (DBusCachedPlugin_mmuBus_rsp_allowRead                       ), //i
    .io_cpu_memory_mmuBus_rsp_allowWrite           (DBusCachedPlugin_mmuBus_rsp_allowWrite                      ), //i
    .io_cpu_memory_mmuBus_rsp_allowExecute         (DBusCachedPlugin_mmuBus_rsp_allowExecute                    ), //i
    .io_cpu_memory_mmuBus_rsp_exception            (DBusCachedPlugin_mmuBus_rsp_exception                       ), //i
    .io_cpu_memory_mmuBus_rsp_refilling            (DBusCachedPlugin_mmuBus_rsp_refilling                       ), //i
    .io_cpu_memory_mmuBus_end                      (dataCache_1__io_cpu_memory_mmuBus_end                       ), //o
    .io_cpu_memory_mmuBus_busy                     (DBusCachedPlugin_mmuBus_busy                                ), //i
    .io_cpu_writeBack_isValid                      (_zz_182_                                                    ), //i
    .io_cpu_writeBack_isStuck                      (writeBack_arbitration_isStuck                               ), //i
    .io_cpu_writeBack_isUser                       (_zz_183_                                                    ), //i
    .io_cpu_writeBack_haltIt                       (dataCache_1__io_cpu_writeBack_haltIt                        ), //o
    .io_cpu_writeBack_isWrite                      (dataCache_1__io_cpu_writeBack_isWrite                       ), //o
    .io_cpu_writeBack_data                         (dataCache_1__io_cpu_writeBack_data[31:0]                    ), //o
    .io_cpu_writeBack_address                      (_zz_184_[31:0]                                              ), //i
    .io_cpu_writeBack_mmuException                 (dataCache_1__io_cpu_writeBack_mmuException                  ), //o
    .io_cpu_writeBack_unalignedAccess              (dataCache_1__io_cpu_writeBack_unalignedAccess               ), //o
    .io_cpu_writeBack_accessError                  (dataCache_1__io_cpu_writeBack_accessError                   ), //o
    .io_cpu_redo                                   (dataCache_1__io_cpu_redo                                    ), //o
    .io_cpu_flush_valid                            (_zz_185_                                                    ), //i
    .io_cpu_flush_ready                            (dataCache_1__io_cpu_flush_ready                             ), //o
    .io_mem_cmd_valid                              (dataCache_1__io_mem_cmd_valid                               ), //o
    .io_mem_cmd_ready                              (_zz_186_                                                    ), //i
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
    case(_zz_324_)
      2'b00 : begin
        _zz_189_ = DBusCachedPlugin_redoBranch_payload;
      end
      2'b01 : begin
        _zz_189_ = CsrPlugin_jumpInterface_payload;
      end
      2'b10 : begin
        _zz_189_ = BranchPlugin_jumpInterface_payload;
      end
      default : begin
        _zz_189_ = IBusCachedPlugin_predictionJumpInterface_payload;
      end
    endcase
  end

  `ifndef SYNTHESIS
  always @(*) begin
    case(_zz_1_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_1__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_1__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_1__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_1__string = "JALR";
      default : _zz_1__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_2_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_2__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_2__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_2__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_2__string = "JALR";
      default : _zz_2__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_3_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_3__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_3__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_3__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_3__string = "SRA_1    ";
      default : _zz_3__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_4_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_4__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_4__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_4__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_4__string = "SRA_1    ";
      default : _zz_4__string = "?????????";
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
    case(_zz_5_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_5__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_5__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_5__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_5__string = "SRA_1    ";
      default : _zz_5__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_6_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_6__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_6__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_6__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_6__string = "SRA_1    ";
      default : _zz_6__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_7_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_7__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_7__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_7__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_7__string = "SRA_1    ";
      default : _zz_7__string = "?????????";
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
      `Src1CtrlEnum_defaultEncoding_RS : _zz_10__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_10__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_10__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_10__string = "URS1        ";
      default : _zz_10__string = "????????????";
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
    case(_zz_11_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_11__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_11__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_11__string = "AND_1";
      default : _zz_11__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_12_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_12__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_12__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_12__string = "AND_1";
      default : _zz_12__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_13_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_13__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_13__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_13__string = "AND_1";
      default : _zz_13__string = "?????";
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
    case(_zz_14_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_14__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_14__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_14__string = "BITWISE ";
      default : _zz_14__string = "????????";
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
    case(decode_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : decode_SRC2_CTRL_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : decode_SRC2_CTRL_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : decode_SRC2_CTRL_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : decode_SRC2_CTRL_string = "PC ";
      default : decode_SRC2_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_17_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_17__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_17__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_17__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_17__string = "PC ";
      default : _zz_17__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_18_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_18__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_18__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_18__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_18__string = "PC ";
      default : _zz_18__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_19_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_19__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_19__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_19__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_19__string = "PC ";
      default : _zz_19__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_20_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_20__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_20__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_20__string = "ECALL";
      default : _zz_20__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_21_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_21__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_21__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_21__string = "ECALL";
      default : _zz_21__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_22_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_22__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_22__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_22__string = "ECALL";
      default : _zz_22__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_23_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_23__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_23__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_23__string = "ECALL";
      default : _zz_23__string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : decode_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : decode_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : decode_ENV_CTRL_string = "ECALL";
      default : decode_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_24_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_24__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_24__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_24__string = "ECALL";
      default : _zz_24__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_25_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_25__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_25__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_25__string = "ECALL";
      default : _zz_25__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_26_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_26__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_26__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_26__string = "ECALL";
      default : _zz_26__string = "?????";
    endcase
  end
  always @(*) begin
    case(memory_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : memory_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : memory_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : memory_ENV_CTRL_string = "ECALL";
      default : memory_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_27_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_27__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_27__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_27__string = "ECALL";
      default : _zz_27__string = "?????";
    endcase
  end
  always @(*) begin
    case(execute_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : execute_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : execute_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : execute_ENV_CTRL_string = "ECALL";
      default : execute_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_28_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_28__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_28__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_28__string = "ECALL";
      default : _zz_28__string = "?????";
    endcase
  end
  always @(*) begin
    case(writeBack_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : writeBack_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : writeBack_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : writeBack_ENV_CTRL_string = "ECALL";
      default : writeBack_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_29_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_29__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_29__string = "XRET ";
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
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_43__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_43__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_43__string = "AND_1";
      default : _zz_43__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_44_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_44__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_44__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_44__string = "ECALL";
      default : _zz_44__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_45_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_45__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_45__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_45__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_45__string = "PC ";
      default : _zz_45__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_46_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_46__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_46__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_46__string = "BITWISE ";
      default : _zz_46__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_47_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_47__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_47__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_47__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_47__string = "SRA_1    ";
      default : _zz_47__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_48_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_48__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_48__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_48__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_48__string = "JALR";
      default : _zz_48__string = "????";
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
    case(_zz_52_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_52__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_52__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_52__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_52__string = "JALR";
      default : _zz_52__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_93_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_93__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_93__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_93__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_93__string = "URS1        ";
      default : _zz_93__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_94_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_94__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_94__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_94__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_94__string = "JALR";
      default : _zz_94__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_95_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_95__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_95__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_95__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_95__string = "SRA_1    ";
      default : _zz_95__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_96_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_96__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_96__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_96__string = "BITWISE ";
      default : _zz_96__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_97_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_97__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_97__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_97__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_97__string = "PC ";
      default : _zz_97__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_98_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_98__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_98__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_98__string = "ECALL";
      default : _zz_98__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_99_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_99__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_99__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_99__string = "AND_1";
      default : _zz_99__string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : decode_to_execute_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : decode_to_execute_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : decode_to_execute_ENV_CTRL_string = "ECALL";
      default : decode_to_execute_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(execute_to_memory_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : execute_to_memory_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : execute_to_memory_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : execute_to_memory_ENV_CTRL_string = "ECALL";
      default : execute_to_memory_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(memory_to_writeBack_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : memory_to_writeBack_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : memory_to_writeBack_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : memory_to_writeBack_ENV_CTRL_string = "ECALL";
      default : memory_to_writeBack_ENV_CTRL_string = "?????";
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
  always @(*) begin
    case(decode_to_execute_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : decode_to_execute_ALU_CTRL_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : decode_to_execute_ALU_CTRL_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : decode_to_execute_ALU_CTRL_string = "BITWISE ";
      default : decode_to_execute_ALU_CTRL_string = "????????";
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
    case(decode_to_execute_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : decode_to_execute_SRC1_CTRL_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : decode_to_execute_SRC1_CTRL_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : decode_to_execute_SRC1_CTRL_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : decode_to_execute_SRC1_CTRL_string = "URS1        ";
      default : decode_to_execute_SRC1_CTRL_string = "????????????";
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
    case(decode_to_execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : decode_to_execute_BRANCH_CTRL_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : decode_to_execute_BRANCH_CTRL_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : decode_to_execute_BRANCH_CTRL_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : decode_to_execute_BRANCH_CTRL_string = "JALR";
      default : decode_to_execute_BRANCH_CTRL_string = "????";
    endcase
  end
  `endif

  assign memory_MEMORY_ADDRESS_LOW = execute_to_memory_MEMORY_ADDRESS_LOW;
  assign execute_MEMORY_ADDRESS_LOW = _zz_178_[1 : 0];
  assign writeBack_FORMAL_PC_NEXT = memory_to_writeBack_FORMAL_PC_NEXT;
  assign memory_FORMAL_PC_NEXT = execute_to_memory_FORMAL_PC_NEXT;
  assign execute_FORMAL_PC_NEXT = decode_to_execute_FORMAL_PC_NEXT;
  assign decode_FORMAL_PC_NEXT = (decode_PC + 32'h00000004);
  assign execute_MUL_LH = ($signed(execute_MulPlugin_aSLow) * $signed(execute_MulPlugin_bHigh));
  assign decode_CSR_READ_OPCODE = (decode_INSTRUCTION[13 : 7] != 7'h20);
  assign memory_MUL_LOW = ($signed(_zz_229_) + $signed(_zz_237_));
  assign _zz_1_ = _zz_2_;
  assign memory_MEMORY_WR = execute_to_memory_MEMORY_WR;
  assign decode_MEMORY_WR = _zz_238_[0];
  assign execute_SHIFT_RIGHT = _zz_240_;
  assign _zz_3_ = _zz_4_;
  assign decode_SHIFT_CTRL = _zz_5_;
  assign _zz_6_ = _zz_7_;
  assign execute_BRANCH_CALC = {execute_BranchPlugin_branchAdder[31 : 1],(1'b0)};
  assign decode_IS_RS1_SIGNED = _zz_242_[0];
  assign decode_BYPASSABLE_EXECUTE_STAGE = _zz_243_[0];
  assign decode_DO_EBREAK = (((! DebugPlugin_haltIt) && (decode_IS_EBREAK || 1'b0)) && DebugPlugin_allowEBreak);
  assign decode_SRC1_CTRL = _zz_8_;
  assign _zz_9_ = _zz_10_;
  assign decode_ALU_BITWISE_CTRL = _zz_11_;
  assign _zz_12_ = _zz_13_;
  assign execute_MUL_LL = (execute_MulPlugin_aULow * execute_MulPlugin_bULow);
  assign memory_MUL_HH = execute_to_memory_MUL_HH;
  assign execute_MUL_HH = ($signed(execute_MulPlugin_aHigh) * $signed(execute_MulPlugin_bHigh));
  assign execute_BYPASSABLE_MEMORY_STAGE = decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  assign decode_BYPASSABLE_MEMORY_STAGE = _zz_244_[0];
  assign decode_SRC_LESS_UNSIGNED = _zz_245_[0];
  assign decode_MEMORY_MANAGMENT = _zz_246_[0];
  assign memory_PC = execute_to_memory_PC;
  assign decode_ALU_CTRL = _zz_14_;
  assign _zz_15_ = _zz_16_;
  assign decode_SRC2_CTRL = _zz_17_;
  assign _zz_18_ = _zz_19_;
  assign memory_IS_MUL = execute_to_memory_IS_MUL;
  assign execute_IS_MUL = decode_to_execute_IS_MUL;
  assign decode_IS_MUL = _zz_247_[0];
  assign execute_MUL_HL = ($signed(execute_MulPlugin_aHigh) * $signed(execute_MulPlugin_bSLow));
  assign execute_REGFILE_WRITE_DATA = _zz_101_;
  assign _zz_20_ = _zz_21_;
  assign _zz_22_ = _zz_23_;
  assign decode_ENV_CTRL = _zz_24_;
  assign _zz_25_ = _zz_26_;
  assign decode_IS_CSR = _zz_248_[0];
  assign decode_PREDICTION_HAD_BRANCHED2 = IBusCachedPlugin_decodePrediction_cmd_hadBranch;
  assign decode_IS_DIV = _zz_249_[0];
  assign decode_SRC2_FORCE_ZERO = (decode_SRC_ADD_ZERO && (! decode_SRC_USE_SUB_LESS));
  assign decode_IS_RS2_SIGNED = _zz_250_[0];
  assign execute_BRANCH_DO = ((execute_PREDICTION_HAD_BRANCHED2 != execute_BRANCH_COND_RESULT) || execute_BranchPlugin_missAlignedTarget);
  assign decode_CSR_WRITE_OPCODE = (! (((decode_INSTRUCTION[14 : 13] == (2'b01)) && (decode_INSTRUCTION[19 : 15] == 5'h0)) || ((decode_INSTRUCTION[14 : 13] == (2'b11)) && (decode_INSTRUCTION[19 : 15] == 5'h0))));
  assign execute_DO_EBREAK = decode_to_execute_DO_EBREAK;
  assign decode_IS_EBREAK = _zz_251_[0];
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
  assign execute_BRANCH_COND_RESULT = _zz_123_;
  assign execute_BRANCH_CTRL = _zz_30_;
  assign decode_RS2_USE = _zz_252_[0];
  assign decode_RS1_USE = _zz_253_[0];
  always @ (*) begin
    _zz_31_ = execute_REGFILE_WRITE_DATA;
    if(_zz_190_)begin
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
    if(_zz_112_)begin
      if((_zz_113_ == decode_INSTRUCTION[24 : 20]))begin
        decode_RS2 = _zz_114_;
      end
    end
    if(_zz_191_)begin
      if(_zz_192_)begin
        if(_zz_116_)begin
          decode_RS2 = _zz_50_;
        end
      end
    end
    if(_zz_193_)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_118_)begin
          decode_RS2 = _zz_32_;
        end
      end
    end
    if(_zz_194_)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_120_)begin
          decode_RS2 = _zz_31_;
        end
      end
    end
  end

  always @ (*) begin
    decode_RS1 = decode_RegFilePlugin_rs1Data;
    if(_zz_112_)begin
      if((_zz_113_ == decode_INSTRUCTION[19 : 15]))begin
        decode_RS1 = _zz_114_;
      end
    end
    if(_zz_191_)begin
      if(_zz_192_)begin
        if(_zz_115_)begin
          decode_RS1 = _zz_50_;
        end
      end
    end
    if(_zz_193_)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_117_)begin
          decode_RS1 = _zz_32_;
        end
      end
    end
    if(_zz_194_)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_119_)begin
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
          _zz_32_ = _zz_109_;
        end
        `ShiftCtrlEnum_defaultEncoding_SRL_1, `ShiftCtrlEnum_defaultEncoding_SRA_1 : begin
          _zz_32_ = memory_SHIFT_RIGHT;
        end
        default : begin
        end
      endcase
    end
    if(_zz_195_)begin
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
  assign decode_SRC_USE_SUB_LESS = _zz_254_[0];
  assign decode_SRC_ADD_ZERO = _zz_255_[0];
  assign execute_SRC_ADD_SUB = execute_SrcPlugin_addSub;
  assign execute_SRC_LESS = execute_SrcPlugin_less;
  assign execute_ALU_CTRL = _zz_38_;
  assign execute_SRC2 = _zz_107_;
  assign execute_SRC1 = _zz_102_;
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
    decode_REGFILE_WRITE_VALID = _zz_256_[0];
    if((decode_INSTRUCTION[11 : 7] == 5'h0))begin
      decode_REGFILE_WRITE_VALID = 1'b0;
    end
  end

  assign decode_LEGAL_INSTRUCTION = ({((decode_INSTRUCTION & 32'h0000005f) == 32'h00000017),{((decode_INSTRUCTION & 32'h0000007f) == 32'h0000006f),{((decode_INSTRUCTION & 32'h0000106f) == 32'h00000003),{((decode_INSTRUCTION & _zz_325_) == 32'h00001073),{(_zz_326_ == _zz_327_),{_zz_328_,{_zz_329_,_zz_330_}}}}}}} != 21'h0);
  always @ (*) begin
    _zz_50_ = writeBack_REGFILE_WRITE_DATA;
    if((writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE))begin
      _zz_50_ = writeBack_DBusCachedPlugin_rspFormated;
    end
    if((writeBack_arbitration_isValid && writeBack_IS_MUL))begin
      case(_zz_228_)
        2'b00 : begin
          _zz_50_ = _zz_298_;
        end
        default : begin
          _zz_50_ = _zz_299_;
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
  assign decode_MEMORY_ENABLE = _zz_257_[0];
  assign decode_FLUSH_ALL = _zz_258_[0];
  always @ (*) begin
    _zz_51_ = _zz_51__2;
    if(_zz_196_)begin
      _zz_51_ = 1'b1;
    end
  end

  always @ (*) begin
    _zz_51__2 = _zz_51__1;
    if(_zz_197_)begin
      _zz_51__2 = 1'b1;
    end
  end

  always @ (*) begin
    _zz_51__1 = _zz_51__0;
    if(_zz_198_)begin
      _zz_51__1 = 1'b1;
    end
  end

  always @ (*) begin
    _zz_51__0 = IBusCachedPlugin_rsp_issueDetected;
    if(_zz_199_)begin
      _zz_51__0 = 1'b1;
    end
  end

  assign decode_BRANCH_CTRL = _zz_52_;
  assign decode_INSTRUCTION = IBusCachedPlugin_iBusRsp_output_payload_rsp_inst;
  always @ (*) begin
    _zz_53_ = memory_FORMAL_PC_NEXT;
    if(BranchPlugin_jumpInterface_valid)begin
      _zz_53_ = BranchPlugin_jumpInterface_payload;
    end
  end

  always @ (*) begin
    _zz_54_ = decode_FORMAL_PC_NEXT;
    if(IBusCachedPlugin_predictionJumpInterface_valid)begin
      _zz_54_ = IBusCachedPlugin_predictionJumpInterface_payload;
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
    case(_zz_150_)
      3'b000 : begin
      end
      3'b001 : begin
      end
      3'b010 : begin
        decode_arbitration_haltItself = 1'b1;
      end
      3'b011 : begin
      end
      3'b100 : begin
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    decode_arbitration_haltByOther = 1'b0;
    if((decode_arbitration_isValid && (_zz_110_ || _zz_111_)))begin
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
    if(_zz_200_)begin
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
    if(_zz_200_)begin
      decode_arbitration_flushNext = 1'b1;
    end
  end

  always @ (*) begin
    execute_arbitration_haltItself = 1'b0;
    if((_zz_185_ && (! dataCache_1__io_cpu_flush_ready)))begin
      execute_arbitration_haltItself = 1'b1;
    end
    if(((dataCache_1__io_cpu_redo && execute_arbitration_isValid) && execute_MEMORY_ENABLE))begin
      execute_arbitration_haltItself = 1'b1;
    end
    if(_zz_190_)begin
      if(execute_CsrPlugin_blockedBySideEffects)begin
        execute_arbitration_haltItself = 1'b1;
      end
    end
  end

  always @ (*) begin
    execute_arbitration_haltByOther = 1'b0;
    if(_zz_201_)begin
      execute_arbitration_haltByOther = 1'b1;
    end
  end

  always @ (*) begin
    execute_arbitration_removeIt = 1'b0;
    if(CsrPlugin_selfException_valid)begin
      execute_arbitration_removeIt = 1'b1;
    end
    if(execute_arbitration_isFlushed)begin
      execute_arbitration_removeIt = 1'b1;
    end
  end

  always @ (*) begin
    execute_arbitration_flushIt = 1'b0;
    if(_zz_201_)begin
      if(_zz_202_)begin
        execute_arbitration_flushIt = 1'b1;
      end
    end
  end

  always @ (*) begin
    execute_arbitration_flushNext = 1'b0;
    if(CsrPlugin_selfException_valid)begin
      execute_arbitration_flushNext = 1'b1;
    end
    if(_zz_201_)begin
      if(_zz_202_)begin
        execute_arbitration_flushNext = 1'b1;
      end
    end
  end

  always @ (*) begin
    memory_arbitration_haltItself = 1'b0;
    if(_zz_195_)begin
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
    if(_zz_203_)begin
      writeBack_arbitration_flushNext = 1'b1;
    end
    if(_zz_204_)begin
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
    if(_zz_203_)begin
      IBusCachedPlugin_fetcherHalt = 1'b1;
    end
    if(_zz_204_)begin
      IBusCachedPlugin_fetcherHalt = 1'b1;
    end
    if(_zz_201_)begin
      if(_zz_202_)begin
        IBusCachedPlugin_fetcherHalt = 1'b1;
      end
    end
    if(DebugPlugin_haltIt)begin
      IBusCachedPlugin_fetcherHalt = 1'b1;
    end
    if(_zz_205_)begin
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
    _zz_55_ = 1'b0;
    if(DebugPlugin_godmode)begin
      _zz_55_ = 1'b1;
    end
  end

  assign CsrPlugin_inWfi = 1'b0;
  always @ (*) begin
    CsrPlugin_thirdPartyWake = 1'b0;
    if(DebugPlugin_haltIt)begin
      CsrPlugin_thirdPartyWake = 1'b1;
    end
  end

  always @ (*) begin
    CsrPlugin_jumpInterface_valid = 1'b0;
    if(_zz_203_)begin
      CsrPlugin_jumpInterface_valid = 1'b1;
    end
    if(_zz_204_)begin
      CsrPlugin_jumpInterface_valid = 1'b1;
    end
  end

  always @ (*) begin
    CsrPlugin_jumpInterface_payload = 32'h0;
    if(_zz_203_)begin
      CsrPlugin_jumpInterface_payload = {CsrPlugin_xtvec_base,(2'b00)};
    end
    if(_zz_204_)begin
      case(_zz_206_)
        2'b11 : begin
          CsrPlugin_jumpInterface_payload = CsrPlugin_mepc;
        end
        default : begin
        end
      endcase
    end
  end

  always @ (*) begin
    CsrPlugin_forceMachineWire = 1'b0;
    if(DebugPlugin_godmode)begin
      CsrPlugin_forceMachineWire = 1'b1;
    end
  end

  always @ (*) begin
    CsrPlugin_allowInterrupts = 1'b1;
    if((DebugPlugin_haltIt || DebugPlugin_stepIt))begin
      CsrPlugin_allowInterrupts = 1'b0;
    end
  end

  always @ (*) begin
    CsrPlugin_allowException = 1'b1;
    if(DebugPlugin_godmode)begin
      CsrPlugin_allowException = 1'b0;
    end
  end

  assign IBusCachedPlugin_externalFlush = ({writeBack_arbitration_flushNext,{memory_arbitration_flushNext,{execute_arbitration_flushNext,decode_arbitration_flushNext}}} != (4'b0000));
  assign IBusCachedPlugin_jump_pcLoad_valid = ({CsrPlugin_jumpInterface_valid,{BranchPlugin_jumpInterface_valid,{DBusCachedPlugin_redoBranch_valid,IBusCachedPlugin_predictionJumpInterface_valid}}} != (4'b0000));
  assign _zz_56_ = {IBusCachedPlugin_predictionJumpInterface_valid,{BranchPlugin_jumpInterface_valid,{CsrPlugin_jumpInterface_valid,DBusCachedPlugin_redoBranch_valid}}};
  assign _zz_57_ = (_zz_56_ & (~ _zz_259_));
  assign _zz_58_ = _zz_57_[3];
  assign _zz_59_ = (_zz_57_[1] || _zz_58_);
  assign _zz_60_ = (_zz_57_[2] || _zz_58_);
  assign IBusCachedPlugin_jump_pcLoad_payload = _zz_189_;
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
    IBusCachedPlugin_fetchPc_pc = (IBusCachedPlugin_fetchPc_pcReg + _zz_261_);
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

  assign _zz_61_ = (! IBusCachedPlugin_iBusRsp_stages_0_halt);
  assign IBusCachedPlugin_iBusRsp_stages_0_input_ready = (IBusCachedPlugin_iBusRsp_stages_0_output_ready && _zz_61_);
  assign IBusCachedPlugin_iBusRsp_stages_0_output_valid = (IBusCachedPlugin_iBusRsp_stages_0_input_valid && _zz_61_);
  assign IBusCachedPlugin_iBusRsp_stages_0_output_payload = IBusCachedPlugin_iBusRsp_stages_0_input_payload;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_stages_1_halt = 1'b0;
    if(IBusCachedPlugin_cache_io_cpu_fetch_haltIt)begin
      IBusCachedPlugin_iBusRsp_stages_1_halt = 1'b1;
    end
  end

  assign _zz_62_ = (! IBusCachedPlugin_iBusRsp_stages_1_halt);
  assign IBusCachedPlugin_iBusRsp_stages_1_input_ready = (IBusCachedPlugin_iBusRsp_stages_1_output_ready && _zz_62_);
  assign IBusCachedPlugin_iBusRsp_stages_1_output_valid = (IBusCachedPlugin_iBusRsp_stages_1_input_valid && _zz_62_);
  assign IBusCachedPlugin_iBusRsp_stages_1_output_payload = IBusCachedPlugin_iBusRsp_stages_1_input_payload;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_stages_2_halt = 1'b0;
    if((_zz_51_ || IBusCachedPlugin_rsp_iBusRspOutputHalt))begin
      IBusCachedPlugin_iBusRsp_stages_2_halt = 1'b1;
    end
  end

  assign _zz_63_ = (! IBusCachedPlugin_iBusRsp_stages_2_halt);
  assign IBusCachedPlugin_iBusRsp_stages_2_input_ready = (IBusCachedPlugin_iBusRsp_stages_2_output_ready && _zz_63_);
  assign IBusCachedPlugin_iBusRsp_stages_2_output_valid = (IBusCachedPlugin_iBusRsp_stages_2_input_valid && _zz_63_);
  assign IBusCachedPlugin_iBusRsp_stages_2_output_payload = IBusCachedPlugin_iBusRsp_stages_2_input_payload;
  assign IBusCachedPlugin_fetchPc_redo_valid = IBusCachedPlugin_iBusRsp_redoFetch;
  assign IBusCachedPlugin_fetchPc_redo_payload = IBusCachedPlugin_iBusRsp_stages_2_input_payload;
  assign IBusCachedPlugin_iBusRsp_flush = ((decode_arbitration_removeIt || (decode_arbitration_flushNext && (! decode_arbitration_isStuck))) || IBusCachedPlugin_iBusRsp_redoFetch);
  assign IBusCachedPlugin_iBusRsp_stages_0_output_ready = _zz_64_;
  assign _zz_64_ = ((1'b0 && (! _zz_65_)) || IBusCachedPlugin_iBusRsp_stages_1_input_ready);
  assign _zz_65_ = _zz_66_;
  assign IBusCachedPlugin_iBusRsp_stages_1_input_valid = _zz_65_;
  assign IBusCachedPlugin_iBusRsp_stages_1_input_payload = IBusCachedPlugin_fetchPc_pcReg;
  assign IBusCachedPlugin_iBusRsp_stages_1_output_ready = ((1'b0 && (! _zz_67_)) || IBusCachedPlugin_iBusRsp_stages_2_input_ready);
  assign _zz_67_ = _zz_68_;
  assign IBusCachedPlugin_iBusRsp_stages_2_input_valid = _zz_67_;
  assign IBusCachedPlugin_iBusRsp_stages_2_input_payload = _zz_69_;
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
  always @ (*) begin
    decode_arbitration_isValid = IBusCachedPlugin_iBusRsp_output_valid;
    case(_zz_150_)
      3'b000 : begin
      end
      3'b001 : begin
      end
      3'b010 : begin
        decode_arbitration_isValid = 1'b1;
      end
      3'b011 : begin
        decode_arbitration_isValid = 1'b1;
      end
      3'b100 : begin
      end
      default : begin
      end
    endcase
  end

  assign _zz_70_ = _zz_262_[11];
  always @ (*) begin
    _zz_71_[18] = _zz_70_;
    _zz_71_[17] = _zz_70_;
    _zz_71_[16] = _zz_70_;
    _zz_71_[15] = _zz_70_;
    _zz_71_[14] = _zz_70_;
    _zz_71_[13] = _zz_70_;
    _zz_71_[12] = _zz_70_;
    _zz_71_[11] = _zz_70_;
    _zz_71_[10] = _zz_70_;
    _zz_71_[9] = _zz_70_;
    _zz_71_[8] = _zz_70_;
    _zz_71_[7] = _zz_70_;
    _zz_71_[6] = _zz_70_;
    _zz_71_[5] = _zz_70_;
    _zz_71_[4] = _zz_70_;
    _zz_71_[3] = _zz_70_;
    _zz_71_[2] = _zz_70_;
    _zz_71_[1] = _zz_70_;
    _zz_71_[0] = _zz_70_;
  end

  always @ (*) begin
    IBusCachedPlugin_decodePrediction_cmd_hadBranch = ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) || ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_B) && _zz_263_[31]));
    if(_zz_76_)begin
      IBusCachedPlugin_decodePrediction_cmd_hadBranch = 1'b0;
    end
  end

  assign _zz_72_ = _zz_264_[19];
  always @ (*) begin
    _zz_73_[10] = _zz_72_;
    _zz_73_[9] = _zz_72_;
    _zz_73_[8] = _zz_72_;
    _zz_73_[7] = _zz_72_;
    _zz_73_[6] = _zz_72_;
    _zz_73_[5] = _zz_72_;
    _zz_73_[4] = _zz_72_;
    _zz_73_[3] = _zz_72_;
    _zz_73_[2] = _zz_72_;
    _zz_73_[1] = _zz_72_;
    _zz_73_[0] = _zz_72_;
  end

  assign _zz_74_ = _zz_265_[11];
  always @ (*) begin
    _zz_75_[18] = _zz_74_;
    _zz_75_[17] = _zz_74_;
    _zz_75_[16] = _zz_74_;
    _zz_75_[15] = _zz_74_;
    _zz_75_[14] = _zz_74_;
    _zz_75_[13] = _zz_74_;
    _zz_75_[12] = _zz_74_;
    _zz_75_[11] = _zz_74_;
    _zz_75_[10] = _zz_74_;
    _zz_75_[9] = _zz_74_;
    _zz_75_[8] = _zz_74_;
    _zz_75_[7] = _zz_74_;
    _zz_75_[6] = _zz_74_;
    _zz_75_[5] = _zz_74_;
    _zz_75_[4] = _zz_74_;
    _zz_75_[3] = _zz_74_;
    _zz_75_[2] = _zz_74_;
    _zz_75_[1] = _zz_74_;
    _zz_75_[0] = _zz_74_;
  end

  always @ (*) begin
    case(decode_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_76_ = _zz_266_[1];
      end
      default : begin
        _zz_76_ = _zz_267_[1];
      end
    endcase
  end

  assign IBusCachedPlugin_predictionJumpInterface_valid = (decode_arbitration_isValid && IBusCachedPlugin_decodePrediction_cmd_hadBranch);
  assign _zz_77_ = _zz_268_[19];
  always @ (*) begin
    _zz_78_[10] = _zz_77_;
    _zz_78_[9] = _zz_77_;
    _zz_78_[8] = _zz_77_;
    _zz_78_[7] = _zz_77_;
    _zz_78_[6] = _zz_77_;
    _zz_78_[5] = _zz_77_;
    _zz_78_[4] = _zz_77_;
    _zz_78_[3] = _zz_77_;
    _zz_78_[2] = _zz_77_;
    _zz_78_[1] = _zz_77_;
    _zz_78_[0] = _zz_77_;
  end

  assign _zz_79_ = _zz_269_[11];
  always @ (*) begin
    _zz_80_[18] = _zz_79_;
    _zz_80_[17] = _zz_79_;
    _zz_80_[16] = _zz_79_;
    _zz_80_[15] = _zz_79_;
    _zz_80_[14] = _zz_79_;
    _zz_80_[13] = _zz_79_;
    _zz_80_[12] = _zz_79_;
    _zz_80_[11] = _zz_79_;
    _zz_80_[10] = _zz_79_;
    _zz_80_[9] = _zz_79_;
    _zz_80_[8] = _zz_79_;
    _zz_80_[7] = _zz_79_;
    _zz_80_[6] = _zz_79_;
    _zz_80_[5] = _zz_79_;
    _zz_80_[4] = _zz_79_;
    _zz_80_[3] = _zz_79_;
    _zz_80_[2] = _zz_79_;
    _zz_80_[1] = _zz_79_;
    _zz_80_[0] = _zz_79_;
  end

  assign IBusCachedPlugin_predictionJumpInterface_payload = (decode_PC + ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) ? {{_zz_78_,{{{_zz_343_,decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]}},1'b0} : {{_zz_80_,{{{_zz_344_,_zz_345_},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0}));
  assign iBus_cmd_valid = IBusCachedPlugin_cache_io_mem_cmd_valid;
  always @ (*) begin
    iBus_cmd_payload_address = IBusCachedPlugin_cache_io_mem_cmd_payload_address;
    iBus_cmd_payload_address = IBusCachedPlugin_cache_io_mem_cmd_payload_address;
  end

  assign iBus_cmd_payload_size = IBusCachedPlugin_cache_io_mem_cmd_payload_size;
  assign IBusCachedPlugin_s0_tightlyCoupledHit = 1'b0;
  assign _zz_170_ = (IBusCachedPlugin_iBusRsp_stages_0_input_valid && (! IBusCachedPlugin_s0_tightlyCoupledHit));
  assign _zz_171_ = (IBusCachedPlugin_iBusRsp_stages_1_input_valid && (! IBusCachedPlugin_s1_tightlyCoupledHit));
  assign _zz_172_ = (! IBusCachedPlugin_iBusRsp_stages_1_input_ready);
  assign _zz_173_ = (IBusCachedPlugin_iBusRsp_stages_2_input_valid && (! IBusCachedPlugin_s2_tightlyCoupledHit));
  assign _zz_174_ = (! IBusCachedPlugin_iBusRsp_stages_2_input_ready);
  assign _zz_175_ = (CsrPlugin_privilege == (2'b00));
  assign IBusCachedPlugin_rsp_iBusRspOutputHalt = 1'b0;
  assign IBusCachedPlugin_rsp_issueDetected = 1'b0;
  always @ (*) begin
    IBusCachedPlugin_rsp_redoFetch = 1'b0;
    if(_zz_199_)begin
      IBusCachedPlugin_rsp_redoFetch = 1'b1;
    end
    if(_zz_197_)begin
      IBusCachedPlugin_rsp_redoFetch = 1'b1;
    end
  end

  always @ (*) begin
    _zz_176_ = (IBusCachedPlugin_rsp_redoFetch && (! IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling));
    if(_zz_197_)begin
      _zz_176_ = 1'b1;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_decodeExceptionPort_valid = 1'b0;
    if(_zz_198_)begin
      IBusCachedPlugin_decodeExceptionPort_valid = IBusCachedPlugin_iBusRsp_readyForError;
    end
    if(_zz_196_)begin
      IBusCachedPlugin_decodeExceptionPort_valid = IBusCachedPlugin_iBusRsp_readyForError;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_decodeExceptionPort_payload_code = (4'bxxxx);
    if(_zz_198_)begin
      IBusCachedPlugin_decodeExceptionPort_payload_code = (4'b1100);
    end
    if(_zz_196_)begin
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
  assign _zz_169_ = (decode_arbitration_isValid && decode_FLUSH_ALL);
  assign dataCache_1__io_mem_cmd_s2mPipe_valid = (dataCache_1__io_mem_cmd_valid || dataCache_1__io_mem_cmd_s2mPipe_rValid);
  assign _zz_186_ = (! dataCache_1__io_mem_cmd_s2mPipe_rValid);
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
  assign _zz_177_ = (execute_arbitration_isValid && execute_MEMORY_ENABLE);
  assign _zz_178_ = execute_SRC_ADD;
  always @ (*) begin
    case(execute_DBusCachedPlugin_size)
      2'b00 : begin
        _zz_83_ = {{{execute_RS2[7 : 0],execute_RS2[7 : 0]},execute_RS2[7 : 0]},execute_RS2[7 : 0]};
      end
      2'b01 : begin
        _zz_83_ = {execute_RS2[15 : 0],execute_RS2[15 : 0]};
      end
      default : begin
        _zz_83_ = execute_RS2[31 : 0];
      end
    endcase
  end

  assign _zz_185_ = (execute_arbitration_isValid && execute_MEMORY_MANAGMENT);
  assign _zz_179_ = (memory_arbitration_isValid && memory_MEMORY_ENABLE);
  assign _zz_180_ = memory_REGFILE_WRITE_DATA;
  assign DBusCachedPlugin_mmuBus_cmd_isValid = dataCache_1__io_cpu_memory_mmuBus_cmd_isValid;
  assign DBusCachedPlugin_mmuBus_cmd_virtualAddress = dataCache_1__io_cpu_memory_mmuBus_cmd_virtualAddress;
  assign DBusCachedPlugin_mmuBus_cmd_bypassTranslation = dataCache_1__io_cpu_memory_mmuBus_cmd_bypassTranslation;
  always @ (*) begin
    _zz_181_ = DBusCachedPlugin_mmuBus_rsp_isIoAccess;
    if((_zz_55_ && (! dataCache_1__io_cpu_memory_isWrite)))begin
      _zz_181_ = 1'b1;
    end
  end

  assign DBusCachedPlugin_mmuBus_end = dataCache_1__io_cpu_memory_mmuBus_end;
  assign _zz_182_ = (writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE);
  assign _zz_183_ = (CsrPlugin_privilege == (2'b00));
  assign _zz_184_ = writeBack_REGFILE_WRITE_DATA;
  always @ (*) begin
    DBusCachedPlugin_redoBranch_valid = 1'b0;
    if(_zz_207_)begin
      if(dataCache_1__io_cpu_redo)begin
        DBusCachedPlugin_redoBranch_valid = 1'b1;
      end
    end
  end

  assign DBusCachedPlugin_redoBranch_payload = writeBack_PC;
  always @ (*) begin
    DBusCachedPlugin_exceptionBus_valid = 1'b0;
    if(_zz_207_)begin
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
    if(_zz_207_)begin
      if(dataCache_1__io_cpu_writeBack_accessError)begin
        DBusCachedPlugin_exceptionBus_payload_code = {1'd0, _zz_270_};
      end
      if(dataCache_1__io_cpu_writeBack_unalignedAccess)begin
        DBusCachedPlugin_exceptionBus_payload_code = {1'd0, _zz_271_};
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

  assign _zz_84_ = (writeBack_DBusCachedPlugin_rspShifted[7] && (! writeBack_INSTRUCTION[14]));
  always @ (*) begin
    _zz_85_[31] = _zz_84_;
    _zz_85_[30] = _zz_84_;
    _zz_85_[29] = _zz_84_;
    _zz_85_[28] = _zz_84_;
    _zz_85_[27] = _zz_84_;
    _zz_85_[26] = _zz_84_;
    _zz_85_[25] = _zz_84_;
    _zz_85_[24] = _zz_84_;
    _zz_85_[23] = _zz_84_;
    _zz_85_[22] = _zz_84_;
    _zz_85_[21] = _zz_84_;
    _zz_85_[20] = _zz_84_;
    _zz_85_[19] = _zz_84_;
    _zz_85_[18] = _zz_84_;
    _zz_85_[17] = _zz_84_;
    _zz_85_[16] = _zz_84_;
    _zz_85_[15] = _zz_84_;
    _zz_85_[14] = _zz_84_;
    _zz_85_[13] = _zz_84_;
    _zz_85_[12] = _zz_84_;
    _zz_85_[11] = _zz_84_;
    _zz_85_[10] = _zz_84_;
    _zz_85_[9] = _zz_84_;
    _zz_85_[8] = _zz_84_;
    _zz_85_[7 : 0] = writeBack_DBusCachedPlugin_rspShifted[7 : 0];
  end

  assign _zz_86_ = (writeBack_DBusCachedPlugin_rspShifted[15] && (! writeBack_INSTRUCTION[14]));
  always @ (*) begin
    _zz_87_[31] = _zz_86_;
    _zz_87_[30] = _zz_86_;
    _zz_87_[29] = _zz_86_;
    _zz_87_[28] = _zz_86_;
    _zz_87_[27] = _zz_86_;
    _zz_87_[26] = _zz_86_;
    _zz_87_[25] = _zz_86_;
    _zz_87_[24] = _zz_86_;
    _zz_87_[23] = _zz_86_;
    _zz_87_[22] = _zz_86_;
    _zz_87_[21] = _zz_86_;
    _zz_87_[20] = _zz_86_;
    _zz_87_[19] = _zz_86_;
    _zz_87_[18] = _zz_86_;
    _zz_87_[17] = _zz_86_;
    _zz_87_[16] = _zz_86_;
    _zz_87_[15 : 0] = writeBack_DBusCachedPlugin_rspShifted[15 : 0];
  end

  always @ (*) begin
    case(_zz_226_)
      2'b00 : begin
        writeBack_DBusCachedPlugin_rspFormated = _zz_85_;
      end
      2'b01 : begin
        writeBack_DBusCachedPlugin_rspFormated = _zz_87_;
      end
      default : begin
        writeBack_DBusCachedPlugin_rspFormated = writeBack_DBusCachedPlugin_rspShifted;
      end
    endcase
  end

  assign IBusCachedPlugin_mmuBus_rsp_physicalAddress = IBusCachedPlugin_mmuBus_cmd_virtualAddress;
  assign IBusCachedPlugin_mmuBus_rsp_allowRead = 1'b1;
  assign IBusCachedPlugin_mmuBus_rsp_allowWrite = 1'b1;
  assign IBusCachedPlugin_mmuBus_rsp_allowExecute = 1'b1;
  assign IBusCachedPlugin_mmuBus_rsp_isIoAccess = IBusCachedPlugin_mmuBus_rsp_physicalAddress[31];
  assign IBusCachedPlugin_mmuBus_rsp_exception = 1'b0;
  assign IBusCachedPlugin_mmuBus_rsp_refilling = 1'b0;
  assign IBusCachedPlugin_mmuBus_busy = 1'b0;
  assign DBusCachedPlugin_mmuBus_rsp_physicalAddress = DBusCachedPlugin_mmuBus_cmd_virtualAddress;
  assign DBusCachedPlugin_mmuBus_rsp_allowRead = 1'b1;
  assign DBusCachedPlugin_mmuBus_rsp_allowWrite = 1'b1;
  assign DBusCachedPlugin_mmuBus_rsp_allowExecute = 1'b1;
  assign DBusCachedPlugin_mmuBus_rsp_isIoAccess = DBusCachedPlugin_mmuBus_rsp_physicalAddress[31];
  assign DBusCachedPlugin_mmuBus_rsp_exception = 1'b0;
  assign DBusCachedPlugin_mmuBus_rsp_refilling = 1'b0;
  assign DBusCachedPlugin_mmuBus_busy = 1'b0;
  assign _zz_89_ = ((decode_INSTRUCTION & 32'h00004050) == 32'h00004050);
  assign _zz_90_ = ((decode_INSTRUCTION & 32'h00000004) == 32'h00000004);
  assign _zz_91_ = ((decode_INSTRUCTION & 32'h00001000) == 32'h0);
  assign _zz_92_ = ((decode_INSTRUCTION & 32'h00000048) == 32'h00000048);
  assign _zz_88_ = {(((decode_INSTRUCTION & _zz_346_) == 32'h0) != (1'b0)),{((_zz_347_ == _zz_348_) != (1'b0)),{(_zz_349_ != (1'b0)),{(_zz_350_ != _zz_351_),{_zz_352_,{_zz_353_,_zz_354_}}}}}};
  assign _zz_93_ = _zz_88_[2 : 1];
  assign _zz_49_ = _zz_93_;
  assign _zz_94_ = _zz_88_[16 : 15];
  assign _zz_48_ = _zz_94_;
  assign _zz_95_ = _zz_88_[20 : 19];
  assign _zz_47_ = _zz_95_;
  assign _zz_96_ = _zz_88_[22 : 21];
  assign _zz_46_ = _zz_96_;
  assign _zz_97_ = _zz_88_[26 : 25];
  assign _zz_45_ = _zz_97_;
  assign _zz_98_ = _zz_88_[28 : 27];
  assign _zz_44_ = _zz_98_;
  assign _zz_99_ = _zz_88_[31 : 30];
  assign _zz_43_ = _zz_99_;
  assign decodeExceptionPort_valid = (decode_arbitration_isValid && (! decode_LEGAL_INSTRUCTION));
  assign decodeExceptionPort_payload_code = (4'b0010);
  assign decodeExceptionPort_payload_badAddr = decode_INSTRUCTION;
  assign decode_RegFilePlugin_regFileReadAddress1 = decode_INSTRUCTION_ANTICIPATED[19 : 15];
  assign decode_RegFilePlugin_regFileReadAddress2 = decode_INSTRUCTION_ANTICIPATED[24 : 20];
  assign decode_RegFilePlugin_rs1Data = _zz_187_;
  assign decode_RegFilePlugin_rs2Data = _zz_188_;
  always @ (*) begin
    lastStageRegFileWrite_valid = (_zz_41_ && writeBack_arbitration_isFiring);
    if(_zz_100_)begin
      lastStageRegFileWrite_valid = 1'b1;
    end
  end

  assign lastStageRegFileWrite_payload_address = _zz_40_[11 : 7];
  assign lastStageRegFileWrite_payload_data = _zz_50_;
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
        _zz_101_ = execute_IntAluPlugin_bitwise;
      end
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : begin
        _zz_101_ = {31'd0, _zz_272_};
      end
      default : begin
        _zz_101_ = execute_SRC_ADD_SUB;
      end
    endcase
  end

  always @ (*) begin
    case(execute_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : begin
        _zz_102_ = execute_RS1;
      end
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : begin
        _zz_102_ = {29'd0, _zz_273_};
      end
      `Src1CtrlEnum_defaultEncoding_IMU : begin
        _zz_102_ = {execute_INSTRUCTION[31 : 12],12'h0};
      end
      default : begin
        _zz_102_ = {27'd0, _zz_274_};
      end
    endcase
  end

  assign _zz_103_ = _zz_275_[11];
  always @ (*) begin
    _zz_104_[19] = _zz_103_;
    _zz_104_[18] = _zz_103_;
    _zz_104_[17] = _zz_103_;
    _zz_104_[16] = _zz_103_;
    _zz_104_[15] = _zz_103_;
    _zz_104_[14] = _zz_103_;
    _zz_104_[13] = _zz_103_;
    _zz_104_[12] = _zz_103_;
    _zz_104_[11] = _zz_103_;
    _zz_104_[10] = _zz_103_;
    _zz_104_[9] = _zz_103_;
    _zz_104_[8] = _zz_103_;
    _zz_104_[7] = _zz_103_;
    _zz_104_[6] = _zz_103_;
    _zz_104_[5] = _zz_103_;
    _zz_104_[4] = _zz_103_;
    _zz_104_[3] = _zz_103_;
    _zz_104_[2] = _zz_103_;
    _zz_104_[1] = _zz_103_;
    _zz_104_[0] = _zz_103_;
  end

  assign _zz_105_ = _zz_276_[11];
  always @ (*) begin
    _zz_106_[19] = _zz_105_;
    _zz_106_[18] = _zz_105_;
    _zz_106_[17] = _zz_105_;
    _zz_106_[16] = _zz_105_;
    _zz_106_[15] = _zz_105_;
    _zz_106_[14] = _zz_105_;
    _zz_106_[13] = _zz_105_;
    _zz_106_[12] = _zz_105_;
    _zz_106_[11] = _zz_105_;
    _zz_106_[10] = _zz_105_;
    _zz_106_[9] = _zz_105_;
    _zz_106_[8] = _zz_105_;
    _zz_106_[7] = _zz_105_;
    _zz_106_[6] = _zz_105_;
    _zz_106_[5] = _zz_105_;
    _zz_106_[4] = _zz_105_;
    _zz_106_[3] = _zz_105_;
    _zz_106_[2] = _zz_105_;
    _zz_106_[1] = _zz_105_;
    _zz_106_[0] = _zz_105_;
  end

  always @ (*) begin
    case(execute_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : begin
        _zz_107_ = execute_RS2;
      end
      `Src2CtrlEnum_defaultEncoding_IMI : begin
        _zz_107_ = {_zz_104_,execute_INSTRUCTION[31 : 20]};
      end
      `Src2CtrlEnum_defaultEncoding_IMS : begin
        _zz_107_ = {_zz_106_,{execute_INSTRUCTION[31 : 25],execute_INSTRUCTION[11 : 7]}};
      end
      default : begin
        _zz_107_ = _zz_35_;
      end
    endcase
  end

  always @ (*) begin
    execute_SrcPlugin_addSub = _zz_277_;
    if(execute_SRC2_FORCE_ZERO)begin
      execute_SrcPlugin_addSub = execute_SRC1;
    end
  end

  assign execute_SrcPlugin_less = ((execute_SRC1[31] == execute_SRC2[31]) ? execute_SrcPlugin_addSub[31] : (execute_SRC_LESS_UNSIGNED ? execute_SRC2[31] : execute_SRC1[31]));
  assign execute_FullBarrelShifterPlugin_amplitude = execute_SRC2[4 : 0];
  always @ (*) begin
    _zz_108_[0] = execute_SRC1[31];
    _zz_108_[1] = execute_SRC1[30];
    _zz_108_[2] = execute_SRC1[29];
    _zz_108_[3] = execute_SRC1[28];
    _zz_108_[4] = execute_SRC1[27];
    _zz_108_[5] = execute_SRC1[26];
    _zz_108_[6] = execute_SRC1[25];
    _zz_108_[7] = execute_SRC1[24];
    _zz_108_[8] = execute_SRC1[23];
    _zz_108_[9] = execute_SRC1[22];
    _zz_108_[10] = execute_SRC1[21];
    _zz_108_[11] = execute_SRC1[20];
    _zz_108_[12] = execute_SRC1[19];
    _zz_108_[13] = execute_SRC1[18];
    _zz_108_[14] = execute_SRC1[17];
    _zz_108_[15] = execute_SRC1[16];
    _zz_108_[16] = execute_SRC1[15];
    _zz_108_[17] = execute_SRC1[14];
    _zz_108_[18] = execute_SRC1[13];
    _zz_108_[19] = execute_SRC1[12];
    _zz_108_[20] = execute_SRC1[11];
    _zz_108_[21] = execute_SRC1[10];
    _zz_108_[22] = execute_SRC1[9];
    _zz_108_[23] = execute_SRC1[8];
    _zz_108_[24] = execute_SRC1[7];
    _zz_108_[25] = execute_SRC1[6];
    _zz_108_[26] = execute_SRC1[5];
    _zz_108_[27] = execute_SRC1[4];
    _zz_108_[28] = execute_SRC1[3];
    _zz_108_[29] = execute_SRC1[2];
    _zz_108_[30] = execute_SRC1[1];
    _zz_108_[31] = execute_SRC1[0];
  end

  assign execute_FullBarrelShifterPlugin_reversed = ((execute_SHIFT_CTRL == `ShiftCtrlEnum_defaultEncoding_SLL_1) ? _zz_108_ : execute_SRC1);
  always @ (*) begin
    _zz_109_[0] = memory_SHIFT_RIGHT[31];
    _zz_109_[1] = memory_SHIFT_RIGHT[30];
    _zz_109_[2] = memory_SHIFT_RIGHT[29];
    _zz_109_[3] = memory_SHIFT_RIGHT[28];
    _zz_109_[4] = memory_SHIFT_RIGHT[27];
    _zz_109_[5] = memory_SHIFT_RIGHT[26];
    _zz_109_[6] = memory_SHIFT_RIGHT[25];
    _zz_109_[7] = memory_SHIFT_RIGHT[24];
    _zz_109_[8] = memory_SHIFT_RIGHT[23];
    _zz_109_[9] = memory_SHIFT_RIGHT[22];
    _zz_109_[10] = memory_SHIFT_RIGHT[21];
    _zz_109_[11] = memory_SHIFT_RIGHT[20];
    _zz_109_[12] = memory_SHIFT_RIGHT[19];
    _zz_109_[13] = memory_SHIFT_RIGHT[18];
    _zz_109_[14] = memory_SHIFT_RIGHT[17];
    _zz_109_[15] = memory_SHIFT_RIGHT[16];
    _zz_109_[16] = memory_SHIFT_RIGHT[15];
    _zz_109_[17] = memory_SHIFT_RIGHT[14];
    _zz_109_[18] = memory_SHIFT_RIGHT[13];
    _zz_109_[19] = memory_SHIFT_RIGHT[12];
    _zz_109_[20] = memory_SHIFT_RIGHT[11];
    _zz_109_[21] = memory_SHIFT_RIGHT[10];
    _zz_109_[22] = memory_SHIFT_RIGHT[9];
    _zz_109_[23] = memory_SHIFT_RIGHT[8];
    _zz_109_[24] = memory_SHIFT_RIGHT[7];
    _zz_109_[25] = memory_SHIFT_RIGHT[6];
    _zz_109_[26] = memory_SHIFT_RIGHT[5];
    _zz_109_[27] = memory_SHIFT_RIGHT[4];
    _zz_109_[28] = memory_SHIFT_RIGHT[3];
    _zz_109_[29] = memory_SHIFT_RIGHT[2];
    _zz_109_[30] = memory_SHIFT_RIGHT[1];
    _zz_109_[31] = memory_SHIFT_RIGHT[0];
  end

  always @ (*) begin
    _zz_110_ = 1'b0;
    if(_zz_208_)begin
      if(_zz_209_)begin
        if(_zz_115_)begin
          _zz_110_ = 1'b1;
        end
      end
    end
    if(_zz_210_)begin
      if(_zz_211_)begin
        if(_zz_117_)begin
          _zz_110_ = 1'b1;
        end
      end
    end
    if(_zz_212_)begin
      if(_zz_213_)begin
        if(_zz_119_)begin
          _zz_110_ = 1'b1;
        end
      end
    end
    if((! decode_RS1_USE))begin
      _zz_110_ = 1'b0;
    end
  end

  always @ (*) begin
    _zz_111_ = 1'b0;
    if(_zz_208_)begin
      if(_zz_209_)begin
        if(_zz_116_)begin
          _zz_111_ = 1'b1;
        end
      end
    end
    if(_zz_210_)begin
      if(_zz_211_)begin
        if(_zz_118_)begin
          _zz_111_ = 1'b1;
        end
      end
    end
    if(_zz_212_)begin
      if(_zz_213_)begin
        if(_zz_120_)begin
          _zz_111_ = 1'b1;
        end
      end
    end
    if((! decode_RS2_USE))begin
      _zz_111_ = 1'b0;
    end
  end

  assign _zz_115_ = (writeBack_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_116_ = (writeBack_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign _zz_117_ = (memory_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_118_ = (memory_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign _zz_119_ = (execute_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_120_ = (execute_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign execute_BranchPlugin_eq = (execute_SRC1 == execute_SRC2);
  assign _zz_121_ = execute_INSTRUCTION[14 : 12];
  always @ (*) begin
    if((_zz_121_ == (3'b000))) begin
        _zz_122_ = execute_BranchPlugin_eq;
    end else if((_zz_121_ == (3'b001))) begin
        _zz_122_ = (! execute_BranchPlugin_eq);
    end else if((((_zz_121_ & (3'b101)) == (3'b101)))) begin
        _zz_122_ = (! execute_SRC_LESS);
    end else begin
        _zz_122_ = execute_SRC_LESS;
    end
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : begin
        _zz_123_ = 1'b0;
      end
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_123_ = 1'b1;
      end
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        _zz_123_ = 1'b1;
      end
      default : begin
        _zz_123_ = _zz_122_;
      end
    endcase
  end

  assign _zz_124_ = _zz_284_[11];
  always @ (*) begin
    _zz_125_[19] = _zz_124_;
    _zz_125_[18] = _zz_124_;
    _zz_125_[17] = _zz_124_;
    _zz_125_[16] = _zz_124_;
    _zz_125_[15] = _zz_124_;
    _zz_125_[14] = _zz_124_;
    _zz_125_[13] = _zz_124_;
    _zz_125_[12] = _zz_124_;
    _zz_125_[11] = _zz_124_;
    _zz_125_[10] = _zz_124_;
    _zz_125_[9] = _zz_124_;
    _zz_125_[8] = _zz_124_;
    _zz_125_[7] = _zz_124_;
    _zz_125_[6] = _zz_124_;
    _zz_125_[5] = _zz_124_;
    _zz_125_[4] = _zz_124_;
    _zz_125_[3] = _zz_124_;
    _zz_125_[2] = _zz_124_;
    _zz_125_[1] = _zz_124_;
    _zz_125_[0] = _zz_124_;
  end

  assign _zz_126_ = _zz_285_[19];
  always @ (*) begin
    _zz_127_[10] = _zz_126_;
    _zz_127_[9] = _zz_126_;
    _zz_127_[8] = _zz_126_;
    _zz_127_[7] = _zz_126_;
    _zz_127_[6] = _zz_126_;
    _zz_127_[5] = _zz_126_;
    _zz_127_[4] = _zz_126_;
    _zz_127_[3] = _zz_126_;
    _zz_127_[2] = _zz_126_;
    _zz_127_[1] = _zz_126_;
    _zz_127_[0] = _zz_126_;
  end

  assign _zz_128_ = _zz_286_[11];
  always @ (*) begin
    _zz_129_[18] = _zz_128_;
    _zz_129_[17] = _zz_128_;
    _zz_129_[16] = _zz_128_;
    _zz_129_[15] = _zz_128_;
    _zz_129_[14] = _zz_128_;
    _zz_129_[13] = _zz_128_;
    _zz_129_[12] = _zz_128_;
    _zz_129_[11] = _zz_128_;
    _zz_129_[10] = _zz_128_;
    _zz_129_[9] = _zz_128_;
    _zz_129_[8] = _zz_128_;
    _zz_129_[7] = _zz_128_;
    _zz_129_[6] = _zz_128_;
    _zz_129_[5] = _zz_128_;
    _zz_129_[4] = _zz_128_;
    _zz_129_[3] = _zz_128_;
    _zz_129_[2] = _zz_128_;
    _zz_129_[1] = _zz_128_;
    _zz_129_[0] = _zz_128_;
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        _zz_130_ = (_zz_287_[1] ^ execute_RS1[1]);
      end
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_130_ = _zz_288_[1];
      end
      default : begin
        _zz_130_ = _zz_289_[1];
      end
    endcase
  end

  assign execute_BranchPlugin_missAlignedTarget = (execute_BRANCH_COND_RESULT && _zz_130_);
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

  assign _zz_131_ = _zz_290_[11];
  always @ (*) begin
    _zz_132_[19] = _zz_131_;
    _zz_132_[18] = _zz_131_;
    _zz_132_[17] = _zz_131_;
    _zz_132_[16] = _zz_131_;
    _zz_132_[15] = _zz_131_;
    _zz_132_[14] = _zz_131_;
    _zz_132_[13] = _zz_131_;
    _zz_132_[12] = _zz_131_;
    _zz_132_[11] = _zz_131_;
    _zz_132_[10] = _zz_131_;
    _zz_132_[9] = _zz_131_;
    _zz_132_[8] = _zz_131_;
    _zz_132_[7] = _zz_131_;
    _zz_132_[6] = _zz_131_;
    _zz_132_[5] = _zz_131_;
    _zz_132_[4] = _zz_131_;
    _zz_132_[3] = _zz_131_;
    _zz_132_[2] = _zz_131_;
    _zz_132_[1] = _zz_131_;
    _zz_132_[0] = _zz_131_;
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        execute_BranchPlugin_branch_src2 = {_zz_132_,execute_INSTRUCTION[31 : 20]};
      end
      default : begin
        execute_BranchPlugin_branch_src2 = ((execute_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) ? {{_zz_134_,{{{_zz_500_,execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]}},1'b0} : {{_zz_136_,{{{_zz_501_,_zz_502_},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]}},1'b0});
        if(execute_PREDICTION_HAD_BRANCHED2)begin
          execute_BranchPlugin_branch_src2 = {29'd0, _zz_293_};
        end
      end
    endcase
  end

  assign _zz_133_ = _zz_291_[19];
  always @ (*) begin
    _zz_134_[10] = _zz_133_;
    _zz_134_[9] = _zz_133_;
    _zz_134_[8] = _zz_133_;
    _zz_134_[7] = _zz_133_;
    _zz_134_[6] = _zz_133_;
    _zz_134_[5] = _zz_133_;
    _zz_134_[4] = _zz_133_;
    _zz_134_[3] = _zz_133_;
    _zz_134_[2] = _zz_133_;
    _zz_134_[1] = _zz_133_;
    _zz_134_[0] = _zz_133_;
  end

  assign _zz_135_ = _zz_292_[11];
  always @ (*) begin
    _zz_136_[18] = _zz_135_;
    _zz_136_[17] = _zz_135_;
    _zz_136_[16] = _zz_135_;
    _zz_136_[15] = _zz_135_;
    _zz_136_[14] = _zz_135_;
    _zz_136_[13] = _zz_135_;
    _zz_136_[12] = _zz_135_;
    _zz_136_[11] = _zz_135_;
    _zz_136_[10] = _zz_135_;
    _zz_136_[9] = _zz_135_;
    _zz_136_[8] = _zz_135_;
    _zz_136_[7] = _zz_135_;
    _zz_136_[6] = _zz_135_;
    _zz_136_[5] = _zz_135_;
    _zz_136_[4] = _zz_135_;
    _zz_136_[3] = _zz_135_;
    _zz_136_[2] = _zz_135_;
    _zz_136_[1] = _zz_135_;
    _zz_136_[0] = _zz_135_;
  end

  assign execute_BranchPlugin_branchAdder = (execute_BranchPlugin_branch_src1 + execute_BranchPlugin_branch_src2);
  assign BranchPlugin_jumpInterface_valid = ((memory_arbitration_isValid && memory_BRANCH_DO) && (! 1'b0));
  assign BranchPlugin_jumpInterface_payload = memory_BRANCH_CALC;
  assign BranchPlugin_branchExceptionPort_valid = (memory_arbitration_isValid && (memory_BRANCH_DO && memory_BRANCH_CALC[1]));
  assign BranchPlugin_branchExceptionPort_payload_code = (4'b0000);
  assign BranchPlugin_branchExceptionPort_payload_badAddr = memory_BRANCH_CALC;
  assign IBusCachedPlugin_decodePrediction_rsp_wasWrong = BranchPlugin_jumpInterface_valid;
  always @ (*) begin
    CsrPlugin_privilege = (2'b11);
    if(CsrPlugin_forceMachineWire)begin
      CsrPlugin_privilege = (2'b11);
    end
  end

  assign CsrPlugin_misa_base = (2'b01);
  assign CsrPlugin_misa_extensions = 26'h0000042;
  assign _zz_137_ = (CsrPlugin_mip_MTIP && CsrPlugin_mie_MTIE);
  assign _zz_138_ = (CsrPlugin_mip_MSIP && CsrPlugin_mie_MSIE);
  assign _zz_139_ = (CsrPlugin_mip_MEIP && CsrPlugin_mie_MEIE);
  assign CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped = (2'b11);
  assign CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege = ((CsrPlugin_privilege < CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped) ? CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped : CsrPlugin_privilege);
  assign _zz_140_ = {decodeExceptionPort_valid,IBusCachedPlugin_decodeExceptionPort_valid};
  assign _zz_141_ = _zz_294_[0];
  always @ (*) begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_decode = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode;
    if(_zz_200_)begin
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
  assign CsrPlugin_lastStageWasWfi = 1'b0;
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
      if(execute_CSR_WRITE_OPCODE)begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
    end
    if(execute_CsrPlugin_csr_833)begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
    if(execute_CsrPlugin_csr_834)begin
      if(execute_CSR_READ_OPCODE)begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
    end
    if(execute_CsrPlugin_csr_835)begin
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
    if(_zz_214_)begin
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
    if(_zz_215_)begin
      CsrPlugin_selfException_valid = 1'b1;
    end
  end

  always @ (*) begin
    CsrPlugin_selfException_payload_code = (4'bxxxx);
    if(_zz_215_)begin
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
    if(_zz_214_)begin
      execute_CsrPlugin_writeInstruction = 1'b0;
    end
  end

  always @ (*) begin
    execute_CsrPlugin_readInstruction = ((execute_arbitration_isValid && execute_IS_CSR) && execute_CSR_READ_OPCODE);
    if(_zz_214_)begin
      execute_CsrPlugin_readInstruction = 1'b0;
    end
  end

  assign execute_CsrPlugin_writeEnable = (execute_CsrPlugin_writeInstruction && (! execute_arbitration_isStuck));
  assign execute_CsrPlugin_readEnable = (execute_CsrPlugin_readInstruction && (! execute_arbitration_isStuck));
  assign execute_CsrPlugin_readToWriteData = execute_CsrPlugin_readData;
  always @ (*) begin
    case(_zz_227_)
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
    case(_zz_216_)
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
    case(_zz_216_)
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
  assign writeBack_MulPlugin_result = ($signed(_zz_296_) + $signed(_zz_297_));
  assign memory_DivPlugin_frontendOk = 1'b1;
  always @ (*) begin
    memory_DivPlugin_div_counter_willIncrement = 1'b0;
    if(_zz_195_)begin
      if(_zz_217_)begin
        memory_DivPlugin_div_counter_willIncrement = 1'b1;
      end
    end
  end

  always @ (*) begin
    memory_DivPlugin_div_counter_willClear = 1'b0;
    if(_zz_218_)begin
      memory_DivPlugin_div_counter_willClear = 1'b1;
    end
  end

  assign memory_DivPlugin_div_counter_willOverflowIfInc = (memory_DivPlugin_div_counter_value == 6'h21);
  assign memory_DivPlugin_div_counter_willOverflow = (memory_DivPlugin_div_counter_willOverflowIfInc && memory_DivPlugin_div_counter_willIncrement);
  always @ (*) begin
    if(memory_DivPlugin_div_counter_willOverflow)begin
      memory_DivPlugin_div_counter_valueNext = 6'h0;
    end else begin
      memory_DivPlugin_div_counter_valueNext = (memory_DivPlugin_div_counter_value + _zz_301_);
    end
    if(memory_DivPlugin_div_counter_willClear)begin
      memory_DivPlugin_div_counter_valueNext = 6'h0;
    end
  end

  assign _zz_142_ = memory_DivPlugin_rs1[31 : 0];
  assign memory_DivPlugin_div_stage_0_remainderShifted = {memory_DivPlugin_accumulator[31 : 0],_zz_142_[31]};
  assign memory_DivPlugin_div_stage_0_remainderMinusDenominator = (memory_DivPlugin_div_stage_0_remainderShifted - _zz_302_);
  assign memory_DivPlugin_div_stage_0_outRemainder = ((! memory_DivPlugin_div_stage_0_remainderMinusDenominator[32]) ? _zz_303_ : _zz_304_);
  assign memory_DivPlugin_div_stage_0_outNumerator = _zz_305_[31:0];
  assign _zz_143_ = (memory_INSTRUCTION[13] ? memory_DivPlugin_accumulator[31 : 0] : memory_DivPlugin_rs1[31 : 0]);
  assign _zz_144_ = (execute_RS2[31] && execute_IS_RS2_SIGNED);
  assign _zz_145_ = (1'b0 || ((execute_IS_DIV && execute_RS1[31]) && execute_IS_RS1_SIGNED));
  always @ (*) begin
    _zz_146_[32] = (execute_IS_RS1_SIGNED && execute_RS1[31]);
    _zz_146_[31 : 0] = execute_RS1;
  end

  assign _zz_148_ = (_zz_147_ & externalInterruptArray_regNext);
  assign externalInterrupt = (_zz_148_ != 32'h0);
  always @ (*) begin
    debug_bus_cmd_ready = 1'b1;
    if(debug_bus_cmd_valid)begin
      case(_zz_219_)
        6'b000000 : begin
        end
        6'b000001 : begin
          if(debug_bus_cmd_payload_wr)begin
            debug_bus_cmd_ready = IBusCachedPlugin_injectionPort_ready;
          end
        end
        default : begin
        end
      endcase
    end
  end

  always @ (*) begin
    debug_bus_rsp_data = DebugPlugin_busReadDataReg;
    if((! _zz_149_))begin
      debug_bus_rsp_data[0] = DebugPlugin_resetIt;
      debug_bus_rsp_data[1] = DebugPlugin_haltIt;
      debug_bus_rsp_data[2] = DebugPlugin_isPipBusy;
      debug_bus_rsp_data[3] = DebugPlugin_haltedByBreak;
      debug_bus_rsp_data[4] = DebugPlugin_stepIt;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_injectionPort_valid = 1'b0;
    if(debug_bus_cmd_valid)begin
      case(_zz_219_)
        6'b000000 : begin
        end
        6'b000001 : begin
          if(debug_bus_cmd_payload_wr)begin
            IBusCachedPlugin_injectionPort_valid = 1'b1;
          end
        end
        default : begin
        end
      endcase
    end
  end

  assign IBusCachedPlugin_injectionPort_payload = debug_bus_cmd_payload_data;
  assign DebugPlugin_allowEBreak = (CsrPlugin_privilege == (2'b11));
  assign debug_resetOut = DebugPlugin_resetIt_regNext;
  assign _zz_26_ = decode_ENV_CTRL;
  assign _zz_23_ = execute_ENV_CTRL;
  assign _zz_21_ = memory_ENV_CTRL;
  assign _zz_24_ = _zz_44_;
  assign _zz_28_ = decode_to_execute_ENV_CTRL;
  assign _zz_27_ = execute_to_memory_ENV_CTRL;
  assign _zz_29_ = memory_to_writeBack_ENV_CTRL;
  assign _zz_19_ = decode_SRC2_CTRL;
  assign _zz_17_ = _zz_45_;
  assign _zz_36_ = decode_to_execute_SRC2_CTRL;
  assign _zz_16_ = decode_ALU_CTRL;
  assign _zz_14_ = _zz_46_;
  assign _zz_38_ = decode_to_execute_ALU_CTRL;
  assign _zz_13_ = decode_ALU_BITWISE_CTRL;
  assign _zz_11_ = _zz_43_;
  assign _zz_39_ = decode_to_execute_ALU_BITWISE_CTRL;
  assign _zz_10_ = decode_SRC1_CTRL;
  assign _zz_8_ = _zz_49_;
  assign _zz_37_ = decode_to_execute_SRC1_CTRL;
  assign _zz_7_ = decode_SHIFT_CTRL;
  assign _zz_4_ = execute_SHIFT_CTRL;
  assign _zz_5_ = _zz_47_;
  assign _zz_34_ = decode_to_execute_SHIFT_CTRL;
  assign _zz_33_ = execute_to_memory_SHIFT_CTRL;
  assign _zz_2_ = decode_BRANCH_CTRL;
  assign _zz_52_ = _zz_48_;
  assign _zz_30_ = decode_to_execute_BRANCH_CTRL;
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
    IBusCachedPlugin_injectionPort_ready = 1'b0;
    case(_zz_150_)
      3'b000 : begin
      end
      3'b001 : begin
      end
      3'b010 : begin
      end
      3'b011 : begin
      end
      3'b100 : begin
        IBusCachedPlugin_injectionPort_ready = 1'b1;
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_151_ = 32'h0;
    if(execute_CsrPlugin_csr_3264)begin
      _zz_151_[12 : 0] = 13'h1000;
      _zz_151_[25 : 20] = 6'h20;
    end
  end

  always @ (*) begin
    _zz_152_ = 32'h0;
    if(execute_CsrPlugin_csr_768)begin
      _zz_152_[12 : 11] = CsrPlugin_mstatus_MPP;
      _zz_152_[7 : 7] = CsrPlugin_mstatus_MPIE;
      _zz_152_[3 : 3] = CsrPlugin_mstatus_MIE;
    end
  end

  always @ (*) begin
    _zz_153_ = 32'h0;
    if(execute_CsrPlugin_csr_836)begin
      _zz_153_[11 : 11] = CsrPlugin_mip_MEIP;
      _zz_153_[7 : 7] = CsrPlugin_mip_MTIP;
      _zz_153_[3 : 3] = CsrPlugin_mip_MSIP;
    end
  end

  always @ (*) begin
    _zz_154_ = 32'h0;
    if(execute_CsrPlugin_csr_772)begin
      _zz_154_[11 : 11] = CsrPlugin_mie_MEIE;
      _zz_154_[7 : 7] = CsrPlugin_mie_MTIE;
      _zz_154_[3 : 3] = CsrPlugin_mie_MSIE;
    end
  end

  always @ (*) begin
    _zz_155_ = 32'h0;
    if(execute_CsrPlugin_csr_833)begin
      _zz_155_[31 : 0] = CsrPlugin_mepc;
    end
  end

  always @ (*) begin
    _zz_156_ = 32'h0;
    if(execute_CsrPlugin_csr_834)begin
      _zz_156_[31 : 31] = CsrPlugin_mcause_interrupt;
      _zz_156_[3 : 0] = CsrPlugin_mcause_exceptionCode;
    end
  end

  always @ (*) begin
    _zz_157_ = 32'h0;
    if(execute_CsrPlugin_csr_835)begin
      _zz_157_[31 : 0] = CsrPlugin_mtval;
    end
  end

  always @ (*) begin
    _zz_158_ = 32'h0;
    if(execute_CsrPlugin_csr_3008)begin
      _zz_158_[31 : 0] = _zz_147_;
    end
  end

  always @ (*) begin
    _zz_159_ = 32'h0;
    if(execute_CsrPlugin_csr_4032)begin
      _zz_159_[31 : 0] = _zz_148_;
    end
  end

  assign execute_CsrPlugin_readData = ((((_zz_151_ | _zz_152_) | (_zz_153_ | _zz_154_)) | ((_zz_155_ | _zz_156_) | (_zz_157_ | _zz_158_))) | _zz_159_);
  assign iBusWishbone_ADR = {_zz_321_,_zz_160_};
  assign iBusWishbone_CTI = ((_zz_160_ == (3'b111)) ? (3'b111) : (3'b010));
  assign iBusWishbone_BTE = (2'b00);
  assign iBusWishbone_SEL = (4'b1111);
  assign iBusWishbone_WE = 1'b0;
  assign iBusWishbone_DAT_MOSI = 32'h0;
  always @ (*) begin
    iBusWishbone_CYC = 1'b0;
    if(_zz_220_)begin
      iBusWishbone_CYC = 1'b1;
    end
  end

  always @ (*) begin
    iBusWishbone_STB = 1'b0;
    if(_zz_220_)begin
      iBusWishbone_STB = 1'b1;
    end
  end

  assign iBus_cmd_ready = (iBus_cmd_valid && iBusWishbone_ACK);
  assign iBus_rsp_valid = _zz_161_;
  assign iBus_rsp_payload_data = iBusWishbone_DAT_MISO_regNext;
  assign iBus_rsp_payload_error = 1'b0;
  assign _zz_167_ = (dBus_cmd_payload_length != (3'b000));
  assign _zz_163_ = dBus_cmd_valid;
  assign _zz_165_ = dBus_cmd_payload_wr;
  assign _zz_166_ = (_zz_162_ == dBus_cmd_payload_length);
  assign dBus_cmd_ready = (_zz_164_ && (_zz_165_ || _zz_166_));
  assign dBusWishbone_ADR = ((_zz_167_ ? {{dBus_cmd_payload_address[31 : 5],_zz_162_},(2'b00)} : {dBus_cmd_payload_address[31 : 2],(2'b00)}) >>> 2);
  assign dBusWishbone_CTI = (_zz_167_ ? (_zz_166_ ? (3'b111) : (3'b010)) : (3'b000));
  assign dBusWishbone_BTE = (2'b00);
  assign dBusWishbone_SEL = (_zz_165_ ? dBus_cmd_payload_mask : (4'b1111));
  assign dBusWishbone_WE = _zz_165_;
  assign dBusWishbone_DAT_MOSI = dBus_cmd_payload_data;
  assign _zz_164_ = (_zz_163_ && dBusWishbone_ACK);
  assign dBusWishbone_CYC = _zz_163_;
  assign dBusWishbone_STB = _zz_163_;
  assign dBus_rsp_valid = _zz_168_;
  assign dBus_rsp_payload_data = dBusWishbone_DAT_MISO_regNext;
  assign dBus_rsp_payload_error = 1'b0;
  always @ (posedge clk) begin
    if(reset) begin
      IBusCachedPlugin_fetchPc_pcReg <= externalResetVector;
      IBusCachedPlugin_fetchPc_correctionReg <= 1'b0;
      IBusCachedPlugin_fetchPc_booted <= 1'b0;
      IBusCachedPlugin_fetchPc_inc <= 1'b0;
      _zz_66_ <= 1'b0;
      _zz_68_ <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_0 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_4 <= 1'b0;
      IBusCachedPlugin_rspCounter <= _zz_81_;
      IBusCachedPlugin_rspCounter <= 32'h0;
      dataCache_1__io_mem_cmd_s2mPipe_rValid <= 1'b0;
      dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rValid <= 1'b0;
      DBusCachedPlugin_rspCounter <= _zz_82_;
      DBusCachedPlugin_rspCounter <= 32'h0;
      _zz_100_ <= 1'b1;
      _zz_112_ <= 1'b0;
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
      CsrPlugin_pipelineLiberator_pcValids_0 <= 1'b0;
      CsrPlugin_pipelineLiberator_pcValids_1 <= 1'b0;
      CsrPlugin_pipelineLiberator_pcValids_2 <= 1'b0;
      CsrPlugin_hadException <= 1'b0;
      execute_CsrPlugin_wfiWake <= 1'b0;
      memory_DivPlugin_div_counter_value <= 6'h0;
      _zz_147_ <= 32'h0;
      execute_arbitration_isValid <= 1'b0;
      memory_arbitration_isValid <= 1'b0;
      writeBack_arbitration_isValid <= 1'b0;
      _zz_150_ <= (3'b000);
      memory_to_writeBack_REGFILE_WRITE_DATA <= 32'h0;
      memory_to_writeBack_INSTRUCTION <= 32'h0;
      _zz_160_ <= (3'b000);
      _zz_161_ <= 1'b0;
      _zz_162_ <= (3'b000);
      _zz_168_ <= 1'b0;
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
        _zz_66_ <= 1'b0;
      end
      if(_zz_64_)begin
        _zz_66_ <= (IBusCachedPlugin_iBusRsp_stages_0_output_valid && (! 1'b0));
      end
      if(IBusCachedPlugin_iBusRsp_flush)begin
        _zz_68_ <= 1'b0;
      end
      if(IBusCachedPlugin_iBusRsp_stages_1_output_ready)begin
        _zz_68_ <= (IBusCachedPlugin_iBusRsp_stages_1_output_valid && (! IBusCachedPlugin_iBusRsp_flush));
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
      if(_zz_221_)begin
        dataCache_1__io_mem_cmd_s2mPipe_rValid <= dataCache_1__io_mem_cmd_valid;
      end
      if(dataCache_1__io_mem_cmd_s2mPipe_ready)begin
        dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_rValid <= dataCache_1__io_mem_cmd_s2mPipe_valid;
      end
      if(dBus_rsp_valid)begin
        DBusCachedPlugin_rspCounter <= (DBusCachedPlugin_rspCounter + 32'h00000001);
      end
      _zz_100_ <= 1'b0;
      _zz_112_ <= (_zz_41_ && writeBack_arbitration_isFiring);
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
      if(_zz_222_)begin
        if(_zz_223_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
        if(_zz_224_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
        if(_zz_225_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
      end
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
      if(_zz_203_)begin
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
      if(_zz_204_)begin
        case(_zz_206_)
          2'b11 : begin
            CsrPlugin_mstatus_MPP <= (2'b00);
            CsrPlugin_mstatus_MIE <= CsrPlugin_mstatus_MPIE;
            CsrPlugin_mstatus_MPIE <= 1'b1;
          end
          default : begin
          end
        endcase
      end
      execute_CsrPlugin_wfiWake <= (({_zz_139_,{_zz_138_,_zz_137_}} != (3'b000)) || CsrPlugin_thirdPartyWake);
      memory_DivPlugin_div_counter_value <= memory_DivPlugin_div_counter_valueNext;
      if((! writeBack_arbitration_isStuck))begin
        memory_to_writeBack_REGFILE_WRITE_DATA <= _zz_32_;
      end
      if((! writeBack_arbitration_isStuck))begin
        memory_to_writeBack_INSTRUCTION <= memory_INSTRUCTION;
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
      case(_zz_150_)
        3'b000 : begin
          if(IBusCachedPlugin_injectionPort_valid)begin
            _zz_150_ <= (3'b001);
          end
        end
        3'b001 : begin
          _zz_150_ <= (3'b010);
        end
        3'b010 : begin
          _zz_150_ <= (3'b011);
        end
        3'b011 : begin
          if((! decode_arbitration_isStuck))begin
            _zz_150_ <= (3'b100);
          end
        end
        3'b100 : begin
          _zz_150_ <= (3'b000);
        end
        default : begin
        end
      endcase
      if(execute_CsrPlugin_csr_768)begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_mstatus_MPP <= execute_CsrPlugin_writeData[12 : 11];
          CsrPlugin_mstatus_MPIE <= _zz_315_[0];
          CsrPlugin_mstatus_MIE <= _zz_316_[0];
        end
      end
      if(execute_CsrPlugin_csr_772)begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_mie_MEIE <= _zz_318_[0];
          CsrPlugin_mie_MTIE <= _zz_319_[0];
          CsrPlugin_mie_MSIE <= _zz_320_[0];
        end
      end
      if(execute_CsrPlugin_csr_3008)begin
        if(execute_CsrPlugin_writeEnable)begin
          _zz_147_ <= execute_CsrPlugin_writeData[31 : 0];
        end
      end
      if(_zz_220_)begin
        if(iBusWishbone_ACK)begin
          _zz_160_ <= (_zz_160_ + (3'b001));
        end
      end
      _zz_161_ <= (iBusWishbone_CYC && iBusWishbone_ACK);
      if((_zz_163_ && _zz_164_))begin
        _zz_162_ <= (_zz_162_ + (3'b001));
        if(_zz_166_)begin
          _zz_162_ <= (3'b000);
        end
      end
      _zz_168_ <= ((_zz_163_ && (! dBusWishbone_WE)) && dBusWishbone_ACK);
    end
  end

  always @ (posedge clk) begin
    if(IBusCachedPlugin_iBusRsp_stages_1_output_ready)begin
      _zz_69_ <= IBusCachedPlugin_iBusRsp_stages_1_output_payload;
    end
    if(IBusCachedPlugin_iBusRsp_stages_1_input_ready)begin
      IBusCachedPlugin_s1_tightlyCoupledHit <= IBusCachedPlugin_s0_tightlyCoupledHit;
    end
    if(IBusCachedPlugin_iBusRsp_stages_2_input_ready)begin
      IBusCachedPlugin_s2_tightlyCoupledHit <= IBusCachedPlugin_s1_tightlyCoupledHit;
    end
    if(_zz_221_)begin
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
    _zz_113_ <= _zz_40_[11 : 7];
    _zz_114_ <= _zz_50_;
    CsrPlugin_mip_MEIP <= externalInterrupt;
    CsrPlugin_mip_MTIP <= timerInterrupt;
    CsrPlugin_mip_MSIP <= softwareInterrupt;
    CsrPlugin_mcycle <= (CsrPlugin_mcycle + 64'h0000000000000001);
    if(writeBack_arbitration_isFiring)begin
      CsrPlugin_minstret <= (CsrPlugin_minstret + 64'h0000000000000001);
    end
    if(_zz_200_)begin
      CsrPlugin_exceptionPortCtrl_exceptionContext_code <= (_zz_141_ ? IBusCachedPlugin_decodeExceptionPort_payload_code : decodeExceptionPort_payload_code);
      CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= (_zz_141_ ? IBusCachedPlugin_decodeExceptionPort_payload_badAddr : decodeExceptionPort_payload_badAddr);
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
    if(_zz_222_)begin
      if(_zz_223_)begin
        CsrPlugin_interrupt_code <= (4'b0111);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
      if(_zz_224_)begin
        CsrPlugin_interrupt_code <= (4'b0011);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
      if(_zz_225_)begin
        CsrPlugin_interrupt_code <= (4'b1011);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
    end
    if(_zz_203_)begin
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
    if(_zz_195_)begin
      if(_zz_217_)begin
        memory_DivPlugin_rs1[31 : 0] <= memory_DivPlugin_div_stage_0_outNumerator;
        memory_DivPlugin_accumulator[31 : 0] <= memory_DivPlugin_div_stage_0_outRemainder;
        if((memory_DivPlugin_div_counter_value == 6'h20))begin
          memory_DivPlugin_div_result <= _zz_306_[31:0];
        end
      end
    end
    if(_zz_218_)begin
      memory_DivPlugin_accumulator <= 65'h0;
      memory_DivPlugin_rs1 <= ((_zz_145_ ? (~ _zz_146_) : _zz_146_) + _zz_312_);
      memory_DivPlugin_rs2 <= ((_zz_144_ ? (~ execute_RS2) : execute_RS2) + _zz_314_);
      memory_DivPlugin_div_needRevert <= ((_zz_145_ ^ (_zz_144_ && (! execute_INSTRUCTION[13]))) && (! (((execute_RS2 == 32'h0) && execute_IS_RS2_SIGNED) && (! execute_INSTRUCTION[13]))));
    end
    externalInterruptArray_regNext <= externalInterruptArray;
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_CSR_WRITE_OPCODE <= decode_CSR_WRITE_OPCODE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BRANCH_DO <= execute_BRANCH_DO;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_RS2_SIGNED <= decode_IS_RS2_SIGNED;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC2_FORCE_ZERO <= decode_SRC2_FORCE_ZERO;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_RS1 <= decode_RS1;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_DIV <= decode_IS_DIV;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_IS_DIV <= execute_IS_DIV;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_PREDICTION_HAD_BRANCHED2 <= decode_PREDICTION_HAD_BRANCHED2;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_CSR <= decode_IS_CSR;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ENV_CTRL <= _zz_25_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_ENV_CTRL <= _zz_22_;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_ENV_CTRL <= _zz_20_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_REGFILE_WRITE_DATA <= _zz_31_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MUL_HL <= execute_MUL_HL;
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
      decode_to_execute_SRC2_CTRL <= _zz_18_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ALU_CTRL <= _zz_15_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_RS2 <= decode_RS2;
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
      decode_to_execute_MEMORY_MANAGMENT <= decode_MEMORY_MANAGMENT;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC_LESS_UNSIGNED <= decode_SRC_LESS_UNSIGNED;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BYPASSABLE_MEMORY_STAGE <= decode_BYPASSABLE_MEMORY_STAGE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BYPASSABLE_MEMORY_STAGE <= execute_BYPASSABLE_MEMORY_STAGE;
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
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MUL_HH <= execute_MUL_HH;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MUL_HH <= memory_MUL_HH;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MUL_LL <= execute_MUL_LL;
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
      decode_to_execute_ALU_BITWISE_CTRL <= _zz_12_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC1_CTRL <= _zz_9_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_INSTRUCTION <= decode_INSTRUCTION;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_INSTRUCTION <= execute_INSTRUCTION;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_DO_EBREAK <= decode_DO_EBREAK;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BYPASSABLE_EXECUTE_STAGE <= decode_BYPASSABLE_EXECUTE_STAGE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_RS1_SIGNED <= decode_IS_RS1_SIGNED;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BRANCH_CALC <= execute_BRANCH_CALC;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC_USE_SUB_LESS <= decode_SRC_USE_SUB_LESS;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SHIFT_CTRL <= _zz_6_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_SHIFT_CTRL <= _zz_3_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_SHIFT_RIGHT <= execute_SHIFT_RIGHT;
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
      decode_to_execute_BRANCH_CTRL <= _zz_1_;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MUL_LOW <= memory_MUL_LOW;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_CSR_READ_OPCODE <= decode_CSR_READ_OPCODE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MUL_LH <= execute_MUL_LH;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_FORMAL_PC_NEXT <= _zz_54_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_FORMAL_PC_NEXT <= execute_FORMAL_PC_NEXT;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_FORMAL_PC_NEXT <= _zz_53_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_ADDRESS_LOW <= execute_MEMORY_ADDRESS_LOW;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MEMORY_ADDRESS_LOW <= memory_MEMORY_ADDRESS_LOW;
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_3264 <= (decode_INSTRUCTION[31 : 20] == 12'hcc0);
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
      execute_CsrPlugin_csr_834 <= (decode_INSTRUCTION[31 : 20] == 12'h342);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_835 <= (decode_INSTRUCTION[31 : 20] == 12'h343);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_3008 <= (decode_INSTRUCTION[31 : 20] == 12'hbc0);
    end
    if((! execute_arbitration_isStuck))begin
      execute_CsrPlugin_csr_4032 <= (decode_INSTRUCTION[31 : 20] == 12'hfc0);
    end
    if(execute_CsrPlugin_csr_836)begin
      if(execute_CsrPlugin_writeEnable)begin
        CsrPlugin_mip_MSIP <= _zz_317_[0];
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
    iBusWishbone_DAT_MISO_regNext <= iBusWishbone_DAT_MISO;
    dBusWishbone_DAT_MISO_regNext <= dBusWishbone_DAT_MISO;
  end

  always @ (posedge clk) begin
    DebugPlugin_firstCycle <= 1'b0;
    if(debug_bus_cmd_ready)begin
      DebugPlugin_firstCycle <= 1'b1;
    end
    DebugPlugin_secondCycle <= DebugPlugin_firstCycle;
    DebugPlugin_isPipBusy <= (({writeBack_arbitration_isValid,{memory_arbitration_isValid,{execute_arbitration_isValid,decode_arbitration_isValid}}} != (4'b0000)) || IBusCachedPlugin_incomingInstruction);
    if(writeBack_arbitration_isValid)begin
      DebugPlugin_busReadDataReg <= _zz_50_;
    end
    _zz_149_ <= debug_bus_cmd_payload_address[2];
    if(_zz_201_)begin
      DebugPlugin_busReadDataReg <= execute_PC;
    end
    DebugPlugin_resetIt_regNext <= DebugPlugin_resetIt;
  end

  always @ (posedge clk) begin
    if(debugReset) begin
      DebugPlugin_resetIt <= 1'b0;
      DebugPlugin_haltIt <= 1'b0;
      DebugPlugin_stepIt <= 1'b0;
      DebugPlugin_godmode <= 1'b0;
      DebugPlugin_haltedByBreak <= 1'b0;
    end else begin
      if((DebugPlugin_haltIt && (! DebugPlugin_isPipBusy)))begin
        DebugPlugin_godmode <= 1'b1;
      end
      if(debug_bus_cmd_valid)begin
        case(_zz_219_)
          6'b000000 : begin
            if(debug_bus_cmd_payload_wr)begin
              DebugPlugin_stepIt <= debug_bus_cmd_payload_data[4];
              if(debug_bus_cmd_payload_data[16])begin
                DebugPlugin_resetIt <= 1'b1;
              end
              if(debug_bus_cmd_payload_data[24])begin
                DebugPlugin_resetIt <= 1'b0;
              end
              if(debug_bus_cmd_payload_data[17])begin
                DebugPlugin_haltIt <= 1'b1;
              end
              if(debug_bus_cmd_payload_data[25])begin
                DebugPlugin_haltIt <= 1'b0;
              end
              if(debug_bus_cmd_payload_data[25])begin
                DebugPlugin_haltedByBreak <= 1'b0;
              end
              if(debug_bus_cmd_payload_data[25])begin
                DebugPlugin_godmode <= 1'b0;
              end
            end
          end
          6'b000001 : begin
          end
          default : begin
          end
        endcase
      end
      if(_zz_201_)begin
        if(_zz_202_)begin
          DebugPlugin_haltIt <= 1'b1;
          DebugPlugin_haltedByBreak <= 1'b1;
        end
      end
      if(_zz_205_)begin
        if(decode_arbitration_isValid)begin
          DebugPlugin_haltIt <= 1'b1;
        end
      end
    end
  end


endmodule
