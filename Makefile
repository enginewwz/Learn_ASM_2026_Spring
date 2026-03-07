AS      ?= as           # assembler (override for cross toolchains)
LD      ?= ld           # linker
CPP     ?= cpp          # C preprocessor for .S files

ASFLAGS ?=              # extra flags for assembler
LDFLAGS ?=              # extra flags for linker
CPPFLAGS?=              # extra flags for preprocessing .S

BUILD   := build        # output directory

SRCS    := $(wildcard *.s) $(wildcard *.S)                            # all assembly sources
OBJS    := $(patsubst %.s,$(BUILD)/%.o,$(filter %.s,$(SRCS))) \
           $(patsubst %.S,$(BUILD)/%.o,$(filter %.S,$(SRCS)))         # object targets
BINS    := $(patsubst $(BUILD)/%.o,$(BUILD)/%,$(OBJS))                # executable targets

.PHONY: all
all: $(BINS)            # default: build all executables

# assemble .s → .o
$(BUILD)/%.o: %.s | $(BUILD)
	$(AS) $(ASFLAGS) -o $@ $<

# preprocess .S then assemble → .o
$(BUILD)/%.o: %.S | $(BUILD)
	$(CPP) $(CPPFLAGS) $< | $(AS) $(ASFLAGS) -o $@

# link .o → executable (same basename)
$(BUILD)/%: $(BUILD)/%.o
	$(LD) $(LDFLAGS) -o $@ $<

# ensure build directory exists
$(BUILD):
	mkdir -p $(BUILD)

.PHONY: clean
clean:
	rm -rf $(BUILD)      # remove all outputs