#!/usr//bin/python
#
# driver.py - The driver tests the correctness of the student's cache
#     simulator and the correctness and performance of their matrix 
#     wavefront function. It uses ./test-csim to check the correctness of the
#     simulator and it runs ./test-trans on two different sized caches on a 
#     matrices (256x256) to test the correctness and performance of the matrix wavefront
#     function. Caches used 512B, s=5, E=2, b =3
#     and cache size 4KB, s=8, E=2, b=3
#
import subprocess;
import re;
import os;
import sys;
import optparse;

#
# computeMissScore - compute the score depending on the number of
# cache misses
#
def computeMissScore(miss, lower, upper, full_score):
    if miss <= lower:
        return full_score
    if ((miss > (lower+20000)) and (miss <= (lower+20000))): 
        return full_score - 3
    if ((miss > (lower+20000)) and (miss <= upper )): 
        return full_score - 6
    if miss > upper: 
        return 0



    score = (miss - lower) * 1.0 
    range = (upper- lower) * 1.0
    return round((1 - score / range) * full_score, 1)

#
# main - Main function
#
def main():

    # Configure maxscores here
    maxscore= {};
    maxscore['csim'] = 27
    maxscore['transc'] = 1
    maxscore['trans32'] = 10
    maxscore['trans64'] = 8

    # Parse the command line arguments 
    p = optparse.OptionParser()
    p.add_option("-A", action="store_true", dest="autograde", 
                 help="emit autoresult string for Autolab");
    opts, args = p.parse_args()
    autograde = opts.autograde

    # Check the correctness of the cache simulator
    print "Part A: Testing cache simulator"
    print "Running ./test-csim"
    p = subprocess.Popen("./test-csim", 
                         shell=True, stdout=subprocess.PIPE)
    stdout_data = p.communicate()[0]

    # Emit the output from test-csim
    stdout_data = re.split('\n', stdout_data)
    for line in stdout_data:
        if re.match("TEST_CSIM_RESULTS", line):
            resultsim = re.findall(r'(\d+)', line)
        else:
            print "%s" % (line)

    # Check the correctness and performance of the transpose function
    # 256x256 matrix_wavefront, for s=5, E=2, b=3
    print "Part B: Testing transpose function"
    print "Running ./test-trans -M 256 -N 256"
    p = subprocess.Popen("./test-trans -M 256 -N 256 -s 5 -E 2 -b 3 | grep TEST_TRANS_RESULTS", 
                         shell=True, stdout=subprocess.PIPE)
    stdout_data = p.communicate()[0]
    result32 = re.findall(r'(\d+)', stdout_data)


    # 256x256 matrix_wavefront, for s=8, E=2, b=3
    print "Running ./test-trans -M 256 -N 256"
    p = subprocess.Popen("./test-trans -M 256 -N 256 -s 8 -E 2 -b 3 | grep TEST_TRANS_RESULTS", 
                         shell=True, stdout=subprocess.PIPE)
    stdout_data = p.communicate()[0]
    result64 = re.findall(r'(\d+)', stdout_data)
    
    # Compute the scores for each step
    csim_cscore  = map(int, resultsim[0:1])
    #trans_cscore = int(result32[0] * int(result64[0])) ;
    miss32 = int(result32[1])
    miss64 = int(result64[1])
    trans32_score = computeMissScore(miss32, 35000, 70000, maxscore['trans32']) * int(result32[0])
    trans64_score = computeMissScore(miss64, 33000, 68000, maxscore['trans64']) * int(result64[0])
    total_score = csim_cscore[0] + trans32_score + trans64_score 

    # Summarize the results
    print "\nCache Lab summary:"
    print "%-25s%11s%13s%15s" % ("", "Points", "Max pts", "Misses")
    print "%-25s%11.1f%13d" % ("Csim correctness", csim_cscore[0], 
                              maxscore['csim'])

    misses = str(miss32)
    if miss32 == 2**31-1 :
        misses = "invalid"
    print "%-25s%11.1f%13d%15s" % ("Wave perf 256x256 small$", trans32_score, 
                                  maxscore['trans32'], misses)
#
    misses = str(miss64)
    if miss64 == 2**31-1 :
        misses = "invalid"
    print "%-25s%11.1f%13d%15s" % ("Wave perf 256x256 large$", trans64_score, 
                                  maxscore['trans64'], misses)

    print "%25s%11.1f%13d" % ("Total points", total_score,
                             maxscore['csim'] + 
                             maxscore['trans32'] +
				maxscore['trans64'])

 
    # Emit autoresult string for Autolab if called with -A option
    if autograde:
        autoresult="%.1f:%d" % (total_score, miss32, miss64)
        print "\nAUTORESULT_STRING=%s" % autoresult
    
    
# execute main only if called as a script
if __name__ == "__main__":
    main()

