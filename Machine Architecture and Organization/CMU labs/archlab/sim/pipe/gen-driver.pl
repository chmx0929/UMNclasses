#!/usr/bin/perl 
#!/usr/local/bin/perl 

#
# gen-driver - Generate driver file for any matrix_xor function
#
use Getopt::Std;

$n = 0;

getopts('hcrn:f:b:');

if ($opt_h) {
    print STDERR "Usage $argv[0] [-h] [-c] [-n N] [-f FILE]\n";
    print STDERR "   -h      print help message\n";
    print STDERR "   -c      include correctness checking code\n";
    print STDERR "   -n N    set number of elements\n";
    print STDERR "   -f FILE set input file (default stdin)\n";
    print STDERR "   -b blim set byte limit for function\n";
    die "\n";
}

$check = 0;
if ($opt_c) {
    $check = 1;
}

$bytelim = 1000;
if ($opt_b) {
    $bytelim = $opt_b;
}

if ($opt_n) {
    $n = $opt_n;
    if ($n < 0) {
	print STDERR "n must be at least 0\n";
	die "\n";
    }
}

print <<PROLOGUE;
.pos 0
main:  irmovl Stack, %esp
       irmovl Stack, %ebp
       irmovl mC, %eax #push the matrix C start pointer
       pushl %eax
       irmovl mB, %eax #push the matrix B start pointer 
       pushl %eax 
       irmovl mA, %eax #push the matrix A start pointer 
       pushl %eax 
       irmovl $n, %eax #push the matrix  size 
       pushl %eax 
       call matrixFun
PROLOGUE


if ($check) {
print <<CALL;
	call check	        # Call checker code
	halt                    # should halt with 0xaaaa in %eax
CALL
} else {
print <<HALT;
	halt			# should halt with num nonzeros in %eax
HALT
}

print "StartFun:\n";
if ($opt_f) {
    open (CODEFILE, "$opt_f") || die "Can't open code file $opt_f\n";
    while (<CODEFILE>) {
	printf "%s", $_;
    }
} else {
    while (<>) {
	printf "%s", $_;
    }
}
print "EndFun:\n";
my $nsqr = $n*$n;
if ($check) {
print <<CHECK;
#################################################################### 
# Epilogue code for the correctness testing driver
####################################################################

# This is the correctness checking code.
# If all checks pass, then sets %eax to 0xaaaa
check:
	pushl %ebp
	rrmovl %esp,%ebp
	pushl %esi
	pushl %ebx
	pushl %edi
checkb:
	irmovl EndFun,%eax
	irmovl StartFun,%edx
	subl %edx,%eax
	irmovl \$$bytelim,%edx
	subl %eax,%edx
	jge checkm
	irmovl \$0xcccc,%eax  # Failed test #2
	jmp cdone
checkm:
	irmovl mC, %edx # Pointer to next destination location
	irmovl correctAns,%ebx   # Pointer to next source location
	irmovl \$$nsqr,%edi  # Count
mcloop:
	mrmovl (%edx),%eax
	mrmovl (%ebx),%esi
	subl %esi,%eax
	je  mok
	irmovl \$0xdddd,%eax # Failed test #3
	jmp cdone
mok:
	irmovl \$4,%eax
	addl %eax,%edx	  # dest ++
	addl %eax,%ebx    # src++
	irmovl \$1,%eax
	subl %eax,%edi    # cnt--
	jg mcloop
checkok:
	irmovl \$0xaaaa,%eax
cdone:
	popl %edi
	popl %ebx
	popl %esi
	rrmovl %ebp, %esp
	popl %ebp
	ret
CHECK
}

print <<EPILOGUE1;
.pos 0x400
.align 4
mA:
EPILOGUE1

my @A = ();
my $B = ();
for ($i = 1; $i < $n*$n+1; $i++) {
    $A[$i-1] = $i;
    print "\t.long $A[$i-1]\n";
}

print "mB: \n";
for ($i=1;$i < $n*$n+1 ; $i++){
    $B[$i-1] = $i+4;
    print "\t.long $B[$i-1]\n";
}

print "mC: \n";
for ($i=1;$i < $n*$n+1 ; $i++){
    $C[$i-1] = 0;
    print "\t.long $C[$i-1]\n";
}

print ".pos 0x700 \n";
print "correctAns: \n";

my $temp,$temp1;
for (my $x = 0; $x < $nsqr; $x++){
   my $sum = 0;
   for(my $k = 0; $k < $n; $k++){
      $temp = $A[$n*int($x/$n)+$k] ;
      $temp1 = $B[$n*$k+($x%$n)] ;
      $sum = $sum + ($temp ^ $temp1);  
   }
print "\t.long $sum  \n";
}

print <<EPILOGUE2;
# Run time stack
	.long 0
	.long 0
	.long 0
	.long 0
	.long 0
	.long 0
	.long 0
	.long 0
	.long 0
	.long 0
	.long 0
	.long 0
	.long 0
	.long 0
	.long 0
	.long 0
	.long 0
	.long 0
	.long 0
	.long 0
	.long 0
	.long 0
	.long 0
	.long 0
	.long 0
Stack:
EPILOGUE2
