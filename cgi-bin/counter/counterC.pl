#!/usr/local/bin/perl

$debug = "of";

$digits = "C";
#$user=$ENV{'QUERY_STRING'};
#$user = lc($user);

#$path = `egrep $user: /etc/passwd`;
#$path = substr($path,index($path,"/web/",3));
#$path = substr($path,0,index($path,"/./"));

#$user_dir = "$path/cgi-bin/counter";

#$count_file = "$user_dir/count.txt";
#$digit_dir = "digits/$digits";
#$flyprog = "/usr/local/bin/fly -q";
#$fly_temp = "$user_dir/fly_temp.gif";

$count_file = "./count.txt";
$digit_dir = "./digits/".$digits;
$flyprog = "/usr/local/cgi/fly -q";
$fly_temp = "./fly_temp.gif";




if ($debug eq "on") {
print "Content-type: text/html\n\n";
print "<html><body>\n";
print "$user_dir<BR>\n";
print "$count_file<BR>\n";
print "$digit_dir<BR>\n";
print "$fly_temp<BR>\n";
print "$path<BR>\n";
print "</body></html>\n";
exit;
}

### IMAGE SETTINGS ###
$width = "16";
$height = "22";

$tp = "X";
$il = "1";

$frame_width = "1";
$frame_color = "0,0,0";

$dot = "X";
$logo = "X";

##############################################################################
# Get the Counter Number And Write New One to File
&get_num;

# If they Just want a transparent dot or a logo, give them that.
&check_dot;

# Determine Length of Counter Number
$num = $length = length($count);

# Set Individual Counter Numbers Into Associative Array
while ($num > 0) {
   $CHAR{$num} = chop($count);
   $num--;
}

# Determine the Height and Width of the Image
$img_width = (($width * $length) + ($frame_width * 2));
$img_height = (($frame_width * 2) + $height);

# Open the In-File for Commands
open(FLY,">$fly_temp") || die "Can't Open In File For FLY Commands: $!\n";

# Create New Counter Image
print FLY "new\n";
print FLY "size $img_width,$img_height\n";

# If User Wants Frame, Print Commands to the In-File
&make_frame;

# Copy Individual Counter Images Commands to In-File
$j = 1;
while ($j <= $length) {
   print FLY "copy $insert_width,$insert_height,-1,-1,-1,-1,$digit_dir/$CHAR{$j}\.gif\n";
   $insert_width = ($insert_width + $width); 
   $j++;
}

# If they want a color transparent, make it transparent
if ($tp ne "X" && $tp =~ /.*,.*,.*/) {
   print FLY "transparent $tp\n";
}

# If they want the image interlaced, make it interlaced
if ($il == 1) {
   print FLY "interlace\n";
}

# Close FLY
close(FLY);

$output = `$flyprog -i $fly_temp`;
print "Content-type: image/gif\n\n";
print "$output";

# Remove Temp File
unlink($fly_temp);


sub get_num {
   open(COUNT,"$count_file") || die "Can't Open Count Data File: $!\n"; 
   $count = <COUNT>;
   close(COUNT);
   if ($count =~ /\n$/) {
      chop($count);
   }

   $count++;

   open(COUNT,">$count_file") || die "Can't Open Count Data File For Writing: $!\n";
   print COUNT "$count";
   close(COUNT);
}

sub check_dot {

   if ($dot == 1) {
      # Open the In-File for Commands
      open(FLY,">$fly_temp") || die "Can't Open In File For FLY Commands: $!\n";

      # Create New Counter Image
      print FLY "new\n";
      print FLY "size 1,1\n";
      print FLY "fill x,y,0,0,0\n";
      print FLY "transparent 0,0,0\n";
      close(FLY);

      $output = `$flyprog -i $fly_temp`;
      print "Content-type: image/gif\n\n";
      print "$output";

      exit;
   }
   elsif ($logo ne "X" && $logo =~ /.*tp:\/\//) {
      print "Location: $logo\n\n";
      exit;
   }
}

sub make_frame {
   $insert_width = $insert_height = $frame_width;

   $insert_frame = 0;

   while ($insert_frame < $frame_width) {
      $current_width = ($img_width - $insert_frame);
      $current_height = ($img_height - $insert_frame);
 
      print FLY "line 0,$insert_frame,$img_width,$insert_frame,$frame_color\n";
      print FLY "line $insert_frame,0,$insert_frame,$img_height,$frame_color\n";
      print FLY "line $current_width,0,$current_width,$img_height,$frame_color\n";
      print FLY "line $current_height,0,$current_height,$img_width,$frame_color\n";

      $insert_frame++;
   }
}

sub log_access {
   open(LOG,">>$access_log") || die "Can't Open User Access Log: $!\n";
#   print LOG "[$date] $ENV{'HTTP_REFERER'} - $ENV{'REMOTE_HOST'} -  $ENV{'HTTP_USER_AGENT'}\n";
   close(LOG);
}
