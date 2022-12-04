UC = $(shell echo '$1' | tr '[:lower:]' '[:upper:]')

PROJECT	:= platypus
AS		:= ca65
LD		:= ld65
MKDIR	:= mkdir -p
RMDIR	:= rmdir -p
CONFIG  := $(PROJECT).cfg
ASFLAGS	:= --cpu 65C02 -g
LDFLAGS	:= -C $(CONFIG)
SRC		:= ./src
OBJ		:= ./obj
SRCS	:= $(wildcard $(SRC)/*.s)
OBJS    := $(patsubst $(SRC)/%.s,$(OBJ)/%.o,$(SRCS))
EXE		:= $(call UC,$(PROJECT).PRG)

default: all

all: $(EXE) $(OBJS)

$(EXE): $(OBJS) $(CONFIG)
	$(LD) $(LDFLAGS) $(OBJS) -o $@ 

$(OBJ)/%.o: $(SRC)/%.s | $(OBJ)
	$(AS) $(ASFLAGS) $< -o $@

$(OBJ):
	$(MKDIR) $@

.PHONY: clean
clean:
	$(RM) $(EXE) $(OBJS)


