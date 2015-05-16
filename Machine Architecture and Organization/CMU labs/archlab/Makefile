####################################################
# Students' Makefile for the CS:APP Architecture Lab
####################################################

# Default team name
TEAM = CSCI2021
NAME = yourname

# Where are the different parts of the lab should be copied to when they
# are handed in.
HANDINDIR-PARTA = ~/archlab/handin-parta
HANDINDIR-PARTB = ~/archlab/handin-partb
HANDINDIR-PARTC = ~/archlab/handin-partc

sim:
	(cd sim; make)

# Use this rule to hand in Part A ("make handin-parta")
handin-parta:
	cp sim/misc/search.ys $(HANDINDIR-PARTA)/$(TEAM)-$(NAME)-search.ys
	cp sim/misc/matrix_xor.ys $(HANDINDIR-PARTA)/$(TEAM)-$(NAME)-matrix_xor.ys

# Use this rule to handin Part B ("make handin-partb")
handin-partb:
	cp sim/seq/seq-full.hcl $(HANDINDIR-PARTB)/$(TEAM)-$(NAME)-seq-full.hcl
	cp sim/pipe/pipe-full.hcl $(HANDINDIR-PARTB)/$(TEAM)-$(NAME)-pipe-full.hcl
	cp sim/misc/isa.c $(HANDINDIR-PARTB)/$(TEAM)-$(NAME)-isa.c

# Use this rule to handin Part C ("make handin-partc")
handin-partc:
	cp sim/pipe/matrix_xor.ys $(HANDINDIR-PARTC)/$(TEAM)-$(NAME)-matrix_xor.ys

clean:
	rm -f *~ *.o
