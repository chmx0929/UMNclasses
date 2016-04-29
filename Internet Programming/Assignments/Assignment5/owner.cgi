#!/usr/bin/python
import cgi
import os,sys
import cgitb; cgitb.enable()
import Cookie
import time
import MySQLdb

def print_HTML():
	print "content-type: text/html"
	print
	print "<!DOCTYPE html>"
	print "<html><head><title>OwnerMenu</title>"
	print "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"
	print "<script type='text/javascript'>"
	print "function cancel()"
	print "{"
	print "var x = document.getElementById('uploadform')"
	print "x.action='gallery.cgi'"
	print "x.submit()"
	print "}"
	print "</script>"
	print "</head>"
	print "<body align = 'center'>"
	print "<h1>Add User</h1>"
	print "<form action = 'actondb.cgi' name = 'add'>"
	print "username : <input type ='text' name = 'adduser'><br/>"
	print "password : <input type ='text' name = 'addpasd'><br/><br/>"
	print "<input type ='submit' value = 'Add User'>"
	print "</form>"
	print "<h1>Change password</h1>"
	print "<form action = 'actondb.cgi' name = 'Change'>"
	print "username : <input type ='text' name = 'usr'><br/><br/>"
	print "password : <input type ='text' name = 'psd'><br/><br/>"
	print "<input type = 'submit' value = 'Change password'>"
	print "</form>"
	print "<h1>Delete User</h1>"
	print "<form action = 'actondb.cgi' name = 'delete'>"
	print "username : <input type ='text' name = 'deluser'><br/><br/>"
	print "<input type = 'submit' value = 'Delete User'>"
	print "</form>"
	print "<h1>Go to gallery</h1>"
	print "<form action='gallery.cgi'>"
	print "<input  type = 'submit'  value ='gallery' >"
	print "</form>"
	print "</body>"
	print "</html>"


p = 0
if 'HTTP_COOKIE' in os.environ:
	cookies = os.environ['HTTP_COOKIE']
	cookies = cookies.split('; ')
handler = {}
for cookie in cookies:
	cookie = cookie.split('=')
	handler[cookie[0]] = cookie[1]
for key,value in handler.iteritems():
	if key == "ROLE" and value == 'owner':
		print_HTML()
		p = 1
	if key == "ROLE" and value == 'visitor' :
		print "content-type: text/html"
		print "Location:gallery_re.cgi"
 		print
 		p = 1
if p == 0 :
	print "content-type: text/html"
	print "Location:login.html"
 	print