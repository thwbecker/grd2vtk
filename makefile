ARCH = x86_64

BDIR = bin/$(ARCH)/
ODIR = objects/$(ARCH)/


all: dirs $(BDIR)/asciiint2bebin $(BDIR)/asciifloat2bebin $(BDIR)/sphere

dirs:
	if [ ! -s $(ODIR) ];then\
		mkdir -p $(ODIR); \
	fi;\
	if [ ! -s $(BDIR) ];then\
		mkdir -p $(BDIR); \
	fi

$(BDIR)/asciiint2bebin: asciiint2bebin.c $(ODIR)/flip_byte_order.o
	$(CC) $(CFLAGS) asciiint2bebin.c  $(ODIR)/flip_byte_order.o -o $(BDIR)/asciiint2bebin $(LDFLAGS)

$(BDIR)/asciifloat2bebin: asciifloat2bebin.c $(ODIR)/flip_byte_order.o
	$(CC) $(CFLAGS) asciifloat2bebin.c  $(ODIR)/flip_byte_order.o -o $(BDIR)/asciifloat2bebin $(LDFLAGS)

$(BDIR)/sphere: sphere.c
	$(CC) $(CFLAGS) sphere.c -o $(BDIR)/sphere -lm

$(ODIR)/%.o: %.c  $(HDR_FLS)
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $(ODIR)/$*.o

