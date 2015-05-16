#!/usr/bin/perl 
#!/usr/local/bin/perl 
# Test conditional move instructions

use Getopt::Std;
use lib ".";
use tester;

cmdline();

@vals = (32, 64);

@instr = ("rrmovl", "cmovle", "cmovl", "cmove", "cmovne", "cmovge", "cmovg");

# Create set of forward tests
foreach $t (@instr) {
    foreach $va (@vals) {
	foreach $vb (@vals) {
	    $tname = "cm-$t-$va-$vb";
	    open (YFILE, ">$tname.ys") || die "Can't write to $tname.ys\n";
	    print YFILE <<STUFF;
	      irmovl \$4, %edi
	      irmovl \$8, %esi
	      irmovl \$$va, %eax
	      irmovl \$$vb, %edx
	      subl %edx,%eax
	      $t %edi,%esi
              halt
STUFF
	    close YFILE;
	    &run_test($tname);
	}
    }
}

&test_stat();


