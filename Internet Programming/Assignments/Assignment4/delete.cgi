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


def print_HTML():
	print
	print "<!DOCTYPE html>"
	print "<html><head><title>File Upload</title>"
	print "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"
	print "<link rel='stylesheet' type='text/css' href='styles.css'>"
	print "<script type='text/javascript'>"
	print "function cancel()"
	print "{"
	print "var x = document.getElementById('deleteform')"
	print "x.action='gallery.cgi'"
	print "x.submit()"
	print "}"
	print "</script>"
	print "</head>"
	print "<body align = 'center'>"
	print "<h1>Delete Picture</h1>"
	print "<div class='setborder'>"
	print "<br/>"
	print "<form action='delete.cgi' id= 'deleteform' method='POST' enctype='multipart/form-data'>"
	print "Are you sure? You want to delete picture [ "+name+" ] <br/><br/>"
	print "<input  type = 'submit'  value ='Delete' id='delete' >"
	print "<input  type = 'button'  value ='Cancel' onclick='cancel()'>"
	print "<input type='hidden' name ='del' value ='"+name+"'>"
	print "</form>"
	print "</div>"
	print "</body>"
	print "</html>"

def delete_file (upload_dir):
	if form.has_key("del"):
		os.remove(form['del'].value)
 		os.remove("/home/wang5167/.www/pictures/"+form['del'].value)
 		print "Location:gallery.cgi"
 		print_HTML()
 	if form.has_key("dname"):
		print_HTML()

print "content-type: text/html"
delete_file (UPLOAD_DIR)