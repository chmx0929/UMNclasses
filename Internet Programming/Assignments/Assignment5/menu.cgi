#!/usr/bin/python
import cgi
import os,sys
import cgitb; cgitb.enable()
import Cookie
import time
import MySQLdb


f = open("config.txt")
line1 = f.readline()
line1 = line1[:-1]
user = line1.split(':')
line2 = f.readline()
line2 = line2[:-1]
pasd = line2.split(':')
line3 = f.readline()
line3 = line3[:-1]
time = line3.split(':')
f.close()
db = MySQLdb.connect(host='egon.cs.umn.edu', user=""+user[1]+"",passwd=""+pasd[1]+"", port=3307,db=""+user[1]+"")
cursor = db.cursor()
cookie = Cookie.SimpleCookie()
form = cgi.FieldStorage()
name = form.getvalue('username')
passwd = form.getvalue('password')
timeout = time[1]
cookie['NAME'] = name
cookie['PASSWD'] = passwd
cookie['NAME']['max-age'] = timeout
cookie['PASSWD']['max-age'] = timeout
username = form.getvalue('username')
password = form.getvalue('password')

query = "SELECT Role FROM Users WHERE Name = '"+username+"' AND Password = '"+password+"'"
result = cursor.execute(query)
if result == 1 :  
	for row in cursor :
		cookie['ROLE'] = row[0]
		cookie['ROLE']['max-age'] = timeout
		if row[0] == 'owner' :

			print cookie
			print "content-type: text/html"
			print "Location:owner.cgi"
			print
		else :
			print cookie
			print "content-type: text/html"
			print "Location:gallery_re.cgi"
			print
else :
	print "content-type: text/html"
	print "Location:login.html"
	print 