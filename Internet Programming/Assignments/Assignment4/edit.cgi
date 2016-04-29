#!/usr/bin/python
import cgi
import cgitb
import os,sys
import Image
cgitb.enable()
UPLOAD_DIR = "/home/wang5167/.www/pictures"

form = cgi.FieldStorage()
if form.has_key("dname"):
	name = form['dname'].value
if form.has_key("old"):
	name = form['old'].value

def print_HTML():
	print
	print "<!DOCTYPE html>"
	print "<html><head><title>File Upload</title>"
	print "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"
	print "<link rel='stylesheet' type='text/css' href='styles.css'>"
	print "<script type='text/javascript'>"
	print "function cancel()"
	print "{"
	print "var x = document.getElementById('editform')"
	print "x.action='gallery.cgi'"
	print "x.submit()"
	print "}"
	print "</script>"
	print "</head>"
	print "<body align = 'center'>"
	print "<h1>Edit Picture Title</h1>"
	print "<div class='setborder'>"
	print "<br/>"
	print "<form action='edit.cgi' id= 'editform' method='POST' enctype='multipart/form-data'>"
	print "Title:<input type ='text' id='title' name ='new' value ='"+name+"'> <br/><br/>"
	print "<input  type = 'submit'  value ='Update' id='update' >"
	print "<input  type = 'button'  value ='Cancel' onclick='cancel()'>"
	print "<input type='hidden' name ='old' value ='"+name+"'>"
	print "</form>"
	print "</div>"
	print "</body>"
	print "</html>"

def print_HTML_Empty():
	print
	print "<!DOCTYPE html>"
	print "<html><head><title>File Upload</title>"
	print "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"
	print "<link rel='stylesheet' type='text/css' href='styles.css'>"
	print "<script type='text/javascript'>"
	print "function cancel()"
	print "{"
	print "var x = document.getElementById('editform')"
	print "x.action='gallery.cgi'"
	print "x.submit()"
	print "}"
	print "</script>"
	print "</head>"
	print "<body align = 'center'>"
	print "<h1>Edit Picture Title</h1>"
	print "<div class='setborder'>"
	print "<br/>"
	print "<form action='edit.cgi' id= 'editform' method='POST' enctype='multipart/form-data'>"
	print "<p style='color:red;'>Please enter a valid title</p>"
	print "Title:<input type ='text' id='title' name ='new'> <br/><br/>"
	print "<input  type = 'submit'  value ='Update' id='update' >"
	print "<input  type = 'button'  value ='Cancel' onclick='cancel()'>"
	print "<input type='hidden' name ='old' value ='"+name+"'>"
	print "</form>"
	print "</div>"
	print "</body>"
	print "</html>"

def edit_file (upload_dir):
	if form.has_key("new"):
		if len(form['new'].value) ==0:
			print_HTML_Empty()
			return
		os.remove(form['old'].value)
		os.rename("/home/wang5167/.www/pictures/"+form['old'].value,"/home/wang5167/.www/pictures/"+form['new'].value)
 		print "Location:gallery.cgi"
 		print_HTML()
 	if form.has_key("dname"):
		print_HTML()

print "content-type: text/html"
edit_file (UPLOAD_DIR)