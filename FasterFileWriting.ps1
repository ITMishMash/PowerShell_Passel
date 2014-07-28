#Faster file writing
#This is a huge performance boost when writing large text files
#like file or directory listings, for example
#
#SOURCES:
#http://blogs.technet.com/b/gbordier/archive/2009/05/05/powershell-and-writing-files-how-fast-can-you-write-to-a-file.aspx

#Declare the output file at the beginning of the script
$outputFile = "C:\TEMP\temp.txt"
#Create the StreamWriter object at the beginning of the script
$stream = [System.IO.StreamWriter] $outputFile

#Either store a line in a variable, or send it directly into StreamWriter
$srNewLine = "New line of text"
$stream.WriteLine($srNewLine)

#Close the file after the script will no longer need to access it
$stream.close()
