#!/usr/bin/perl

# Check length of matrix_xor function in .yo file
# Assumes that function starts with label "matrixFun"
# and finishes with label "EndFun:"

$startpos = -1;
$endpos = -1;

while (<>) {
  $line = $_;
  if ($line =~ /(0x[0-9a-fA-F]+):.* matrixFun:/) {
    $startpos = hex($1);
  }
  if ($line =~ /(0x[0-9a-fA-F]+):.* EndFun:/) {
    $endpos = hex($1);
  }
}

if ($startpos >= 0 && $endpos > $startpos) {
  $len = $endpos - $startpos;
  print "matrixFun length = $len bytes\n";
} else {
  print "Couldn't determine matrix_xor length\n";
}
