# ===========================================================================
# Makefile for the various kconfig executables:
# conf:	  Used for defconfig, oldconfig and related targets
# mconf:  Used for the mconfig target.
#         Utilizes the lxdialog package
# object files used by all kconfig flavours

CC		:= gcc
CXX		:= g++
CFLAGS		:= -g -O2 -D_DEFAULT_SOURCE -D_XOPEN_SOURCE=600
CPPFLAGS	:= 
LDFLAGS		:= 

CPPFLAGS += \
	-DPACKAGE='"ptxdist"' \
	-DCONFIG_='"PTXCONF_"'

YACC		:= /usr/bin/bison
LEX		:= /usr/bin/flex

MCONF_LIBS := -Wl,-Bsymbolic-functions -lncursesw -ltinfo
NCONF_LIBS := -Wl,-Bsymbolic-functions -lncursesw -ltinfo -Wl,-Bsymbolic-functions -lmenuw -Wl,-Bsymbolic-functions -lpanelw

lkc-deps := lkc.h lkc_defs.h expr.h

lxdialog-objs := \
	lxdialog/checklist.o \
	lxdialog/inputbox.o  \
	lxdialog/menubox.o   \
	lxdialog/textbox.o   \
	lxdialog/util.o      \
	lxdialog/yesno.o     \

common-objs := \
	confdata.o \
	expr.o \
	lexer.lex.o \
	parser.tab.o \
	preprocess.o \
	symbol.o \
	util.o

conf-objs := \
	$(common-objs) \
	conf.o

mconf-objs := \
	$(common-objs) \
	mconf.o \
	$(lxdialog-objs)

nconf-objs := \
	$(common-objs) \
	nconf.o \
	nconf.gui.o

NCONF = nconf

all: conf mconf $(NCONF)

conf: $(conf-objs)
	$(CC) $^ $(LDFLAGS) -o $@

mconf: $(mconf-objs)
	$(CC) $^ $(LDFLAGS) -o $@ $(MCONF_LIBS)

nconf: $(nconf-objs)
	$(CC) $^ $(LDFLAGS) -o $@ $(NCONF_LIBS)

%.o: %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

lkc_defs.h: lkc_proto.h
	sed < $< > $@ 's/P(\([^,]*\),.*/#define \1 (\*\1_p)/'

kconfig_load.o: $(lkc-deps)

lexer.lex.o: parser.tab.h

parser.tab.o: menu.c

.INTERMEDIATE: parser.tab.h

%.tab.c: %.y
	$(YACC) -o$@ -t -l $<

%.tab.h: %.y
	$(YACC) -o/dev/null --defines=$@ -t -l $<

%.lex.c: %.l
	$(LEX) -o$@ -L $<

clean:
	rm -f $(conf-objs) $(mconf-objs) $(nconf-objs) conf mconf nconf
	rm -f lkc_defs.h *.lex.c *.tab.c *.tab.h
