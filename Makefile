UC = $(shell echo '$1' | tr '[:lower:]' '[:upper:]')

PROJECT	:= platypus
AS		:= ca65
LD		:= ld65
MKDIR	:= mkdir -p
RMDIR	:= rmdir -p
CONFIG  := ./$(PROJECT).cfg
ASFLAGS	:= --cpu 65C02 -g
LDFLAGS	:= -C $(CONFIG)
SRC		:= ./src
OBJ		:= ./obj
SRCS	:= $(wildcard $(SRC)/*.s)
OBJS    := $(patsubst $(SRC)/%.s,$(OBJ)/%.o,$(SRCS))
EXE		:= $(call UC,$(PROJECT).PRG)
SDCARD	:= ./sdcard.img

default: all

all: $(EXE)

$(EXE): $(OBJS) $(CONFIG)
	$(LD) $(LDFLAGS) $(OBJS) -o $@ 

$(OBJ)/%.o: $(SRC)/%.s | $(OBJ)
	$(AS) $(ASFLAGS) $< -o $@

$(OBJ):
	$(MKDIR) $@

$(SDCARD): $(EXE)
	$(RM) $(SDCARD)
	truncate -s 100M $(SDCARD)
	parted -s $(SDCARD) mklabel msdos mkpart primary fat32 2048s -- -1
	mformat -i $(SDCARD)@@1M -F
	mcopy -i $(SDCARD)@@1M -o -m $(EXE) ::

.PHONY: clean run
clean:
	$(RM) $(EXE) $(OBJS) $(SDCARD)

run: $(EXE) $(SDCARD)
	x16emu -sdcard $(SDCARD) -prg $(EXE) -run
	