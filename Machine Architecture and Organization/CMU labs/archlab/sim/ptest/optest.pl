#!/usr/bin/perl 
#!/usr/local/bin/perl 
# Test single instructions in pipeline

use Getopt::Std;
use lib ".";
require tester;

cmdline();

@vals = (0x100, 0x020, 0x004);

@instr = ("rrmovl", "addl", "subl", "andl", "xorl");
@regs = ("edx", "ebx", "esp");

foreach $t (@instr) {
    foreach $ra (@regs) {
	foreach $rb (@regs) {
	    $tname = "op-$t-$ra-$rb";
	    open (YFILE, ">$tname.ys") || die "Can't write to $tname.ys\n";
	    print YFILE <<STUFF;
	      irmovl \$$vals[0], %$ra
	      irmovl \$$vals[1], %$rb
	      nop
	      nop
	      nop
	      $t %$ra,%$rb
	      nop
	      nop
	      halt
STUFF
	    close YFILE;
	    run_test($tname);
	}
    }
}

@instr = ("leal0", "leal1", "leal2", "leal4", "leal8");
@args = ("\$4(%ecx,%ebx)", "\$64(%eax,%ecx)", "\$1(%ebx,%eax)");
@nums = (0, 1, 2);

if ($testleal) {
	foreach $t (@instr) {
	foreach $num (@nums) {
		$tname = "op-$t-$num";
		open (YFILE, ">$tname.ys") || die "Can't write to $tname.ys\n";
		print YFILE <<STUFF;
		irmovl \$16, %ecx
		irmovl \$32, %ebx
		irmovl \$64, %eax
		nop
		nop
		nop
		$t $args[$num]
		nop
		nop
		nop
		nop
		halt
STUFF
		close YFILE;
		&run_test($tname);
	}
	}
}

@instr = ("pushl", "popl");
@regs = ("edx", "esp");

foreach $t (@instr) {
    foreach $ra (@regs) {
	$tname = "op-$t-$ra";
	open (YFILE, ">$tname.ys") || die "Can't write to $tname.ys\n";
	print YFILE <<STUFF;
        irmovl \$0x200,%esp
	irmovl \$$vals[1], %eax
	nop
	nop
        nop
        rmmovl %eax, 0(%esp)
	irmovl \$$vals[2], %eax
	nop
        nop
        nop
	rmmovl %eax, -4(%esp)
	irmovl \$$vals[0], %edx
	nop
        nop
        nop
	$t %$ra
	nop
	nop
        halt
STUFF
	close YFILE;
	&run_test($tname);
    }
}

&test_stat();
