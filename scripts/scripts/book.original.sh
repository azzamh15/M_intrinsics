#!/bin/bash
#@(#) given a topic string for current man(1) path build document
####################################################################################################################################
INDX(){
#set -x
export TOPIC="$1" NAME
export SECTION="$2"
export TOPHTML=${TOPHTML:-tmp/html}
export MAN_CMD=${MAN_CMD:-man}
HTML >$TOPHTML/BOOK_$TOPIC.html
(
   echo 'function loadthem(){'
   if [ "$TOPIC" = 'INDEX' ]
   then
      (
         cd $TOPHTML
         # make sure sort(1) does not sort case-insensitive
         find . -type f -name 'BOOK_*.html' |env LC_ALL=C /usr/bin/sort
      )
   else
      # make sure sort(1) does not sort case-insensitive
      (
        echo "$TOPIC.3${SECTION}.html"
	# put section 3 topics first
        $MAN_CMD -k "\[${TOPIC}\>"|env LC_ALL=C /usr/bin/sort -k 2r,2r -k 1,1|grep -i "(3${TOPIC})"
	# put non-section 3 topics next
        $MAN_CMD -k "\[${TOPIC}\>"|env LC_ALL=C /usr/bin/sort -k 2r,2r -k 1,1|grep -i "(3${TOPIC})"
      )|tr -d '()'| awk '{printf "%s.%s.html\n",$1,$2}'
   fi| uniq|while read NAME
   do
      if [ -r "$TOPHTML/$NAME" ]
      then
         echo "append(\"$NAME\");"
      fi
   done
   echo '}'
) > $TOPHTML/$TOPIC.js
}
####################################################################################################################################
HTML(){
cat <<\EOF
<html>
<head>
<meta name="Copyright" content="Images, text, datasets, and content (c) Copyright John S. Urban, 2002. All rights reserved.">
<meta name="generator" content="vi(1)/vim(1)" />
EOF
####################################################################################################################################
cat <<EOF
<meta name="description" content="@(#)$TOPIC::BOOK_$TOPIC: BOOK composed of pages for man(1) topic $TOPIC"/>
<meta name="author"      content="$(logname)" />
<meta name="date"        content="$(date +%Y-%m-%d)" />
<meta name="keywords"    content="Fortran, Fortran code, source code repository, Fortran library, Fortran archive, source code" />
EOF
####################################################################################################################################
cat <<\EOF
<!--
   Pick your favorite style sheet from among the eight offerings:
   Chocolate, Midnight, Modernist, Oldstyle, Steely, Swiss, Traditional, and Ultramarine.
   #!/bin/sh
   for NAME in Chocolate Midnight Modernist Oldstyle Steely Swiss Traditional Ultramarine
   do
     curl --get http://www.w3.org/StyleSheets/Core/$NAME.css >StyleSheets/$NAME.css
   done
-->
<link  rel="stylesheet"            href="StyleSheets/man.css"          type="text/css"  title="man"          />
<link  rel="alternate stylesheet"  href="StyleSheets/Simple.css"       type="text/css"  title="Simple"       />
<link  rel="alternate stylesheet"  href="StyleSheets/fancy.css"        type="text/css"  title="Local"        />
<link  rel="alternate stylesheet"  href="StyleSheets/Chocolate.css"    type="text/css"  title="Chocolate"    />
<link  rel="alternate stylesheet"  href="StyleSheets/Midnight.css"     type="text/css"  title="Midnight"     />
<link  rel="alternate stylesheet"  href="StyleSheets/Modernist.css"    type="text/css"  title="Modernist"    />
<link  rel="alternate stylesheet"  href="StyleSheets/OldStyle.css"     type="text/css"  title="OldStyle"     />
<link  rel="alternate stylesheet"  href="StyleSheets/Steely.css"       type="text/css"  title="Steely"       />
<link  rel="alternate stylesheet"  href="StyleSheets/Swiss.css"        type="text/css"  title="Swiss"        />
<link  rel="alternate stylesheet"  href="StyleSheets/Traditional.css"  type="text/css"  title="Traditional"  />
<link  rel="alternate stylesheet"  href="StyleSheets/Ultramarine.css"  type="text/css"  title="Ultramarine"  />
<link  rel="alternate stylesheet"  href="StyleSheets/fortran.css"      type="text/css"  title="fortran"      />
<style type="text/css">
/*<![CDATA[*/
/* ======================================================== */
iframe {
   width=0;
   height=0;
}
/* ======================================================== */
/* Start new page on printing */
BR.newpage{
   page-break-before:always
}
/* ======================================================== */
pX {
   font-family: "Lucida Console", Monaco, monospace
}
/* ======================================================== */
divX {
   background-color: #ffffff;
   border-style: solid;
   border-color: blue;
}
/* ======================================================== */
bodyX{
   margin-top:     1.58em;
   margin-left:    8%;
   margin-right:   4%;
   margin-bottom:  1.58em;
   padding-top:    0;
   padding-left:   0;
   padding-right:  0;
   padding-bottom: 0;
   border-top:     0;
   border-left:    0;
   border-bottom:  0;
   border-right:   0;
   width:  auto;
} /* end body box */
img{max-width: 55em}
/* ======================================================== */
/*]]>*/
</style>
<style> 
px {font-family: "Lucida Console", Monaco, monospace}
p { font-size:100%; line-height:1.1em; }
body {xfont-style: sans-serif}
body {
color:#333; font-family:Verdana, Arial, Helvetica, sans-serif; font-size:1em; line-height:1.3em; }
a:visited { color:#666; }
h1,h2,h3,h4,h5,h6 { color:#333; font-family:georgia, verdana, sans-serif; }
h1 { font-size:150%; page-break-before:auto;background-color: #aaaaff}
h2 { font-size:143%;color:teal; }
h3 { font-size:134%;color:blue; }
h4 { font-size:120%;color:gray; }
img { max-width: 55em}
p{ padding: 0;margin:0; }
p{ padding-right:1.4em; }
p{ padding-bottom:1em; }
p{ padding-top:1em; }
p{ whitespace: pre-wrap; }
h5,h6 { font-size:100% }
a.nav,a:link.nav, a:visited.nav { background-color:#FFF; color:#000; }
XXtable { border:double #000; border-collapse:collapse; }
XXtable { border-collapse:collapse; }
XXtd { border:thin solid #888; }
XXtd { border:none; }
li { margin-bottom:0.5em; }
blockquote { display:block; font-size:100%; line-height:1.1em; margin:0 0 1.5em; padding:0 2.5em; }
pre { background-color:#DDD; font-size:100%; overflow:auto; padding:1em; }
a,li span { color:#000; }
a:hover, a.nav:hover, a:hover math { background-color:#000; color:#FFF; }
#Container { margin:0 10px; text-align:center; background-color: #BBB}
#Content { border-top:none; margin:auto; padding:0.3em; text-align:left; width:100%; max-width:55em; background:#FFF}
span.webName { font-size:.5em; }
textarea#content { font-size: 1em; line-height: 1.125; }
h1#pageName { line-height:1em; margin:0.2em 0 0.2em 0; padding:0; }
.property { color:#666; font-size:100%; }
a.existingWikiWord[title]{ //border: 1px dashed #BBB; }
.byline { color:#666; font-size:1.0em; font-style:italic; margin-bottom:1em; padding-top:1px; } 
</style> 

<script language="JavaScript1.1"  type="text/javascript">
// *** TO BE CUSTOMISED ***

var style_cookie_name = "style" ;
var style_cookie_duration = 30 ;

// *** END OF CUSTOMISABLE SECTION ***

function switch_style ( css_title )
{
// You may use this script on your site free of charge provided
// you do not remote this notice or the URL below. Script from
// http://www.thesitewizard.com/javascripts/change-style-sheets.shtml
  var i, link_tag ;
  for (i = 0, link_tag = document.getElementsByTagName("link") ;
    i < link_tag.length ; i++ ) {
    if ((link_tag[i].rel.indexOf( "stylesheet" ) != -1) &&
      link_tag[i].title) {
      link_tag[i].disabled = true ;
      if (link_tag[i].title == css_title) {
        link_tag[i].disabled = false ;
      }
    }
    set_cookie( style_cookie_name, css_title,
      style_cookie_duration );
  }
}
function set_style_from_cookie()
{
  var css_title = get_cookie( style_cookie_name );
  if (css_title.length) {
    switch_style( css_title );
  }
}
function set_cookie ( cookie_name, cookie_value,
    lifespan_in_days, valid_domain )
{
    // http://www.thesitewizard.com/javascripts/cookies.shtml
    var domain_string = valid_domain ?
                       ("; domain=" + valid_domain) : '' ;
    document.cookie = cookie_name +
                       "=" + encodeURIComponent( cookie_value ) +
                       "; max-age=" + 60 * 60 *
                       24 * lifespan_in_days +
                       "; path=/" + domain_string ;
}
function get_cookie ( cookie_name )
{
    // http://www.thesitewizard.com/javascripts/cookies.shtml
    var cookie_string = document.cookie ;
    if (cookie_string.length != 0) {
        var cookie_value = cookie_string.match (
                        '(^|;)[\s]*' +
                        cookie_name +
                        '=([^;]*)' );
        return decodeURIComponent ( cookie_value[2] ) ;
    }
    return '' ;
}
</script>

<!--
-->

EOF

cat <<EOF
<script language="JavaScript" type="text/javascript" src="$TOPIC.js"> </script>
EOF

cat <<\EOF
<script language="JavaScript1.1"  type="text/javascript">
//<![CDATA[
/* ============================================================================================================================== */
/*
   The following code merges a number of files like an include; so you
   can have a single printable document created from many small files.
   File references are NOT relative so a lot of things do not work as one
   would hope.  IFRAME and JavaScript support are required.
*/
/* ============================================================================================================================== */
FRAMECOUNT=0;
FIRSTPASS=0;
COLUMNS=0;
/* ============================================================================================================================== */
function baseName(str)
{
   var base = new String(str).substring(str.lastIndexOf('/') + 1);
    if(base.lastIndexOf(".") != -1)
        base = base.substring(0, base.lastIndexOf("."));
   return base;
}
/* ============================================================================================================================== */
function append(target){
   if(FIRSTPASS == 0){
      append_index(target);
   }else{
      append_doc(target);
   }
}
/* ============================================================================================================================== */
//alert('START 1');
function append_index(target){
   FRAMECOUNT=FRAMECOUNT+1;
   if( COLUMNS == 5 ){
	   document.write('</tr>\n');
	   COLUMNS=0;
   }
   COLUMNS=COLUMNS+1;
   if( COLUMNS == 1 ){
	   document.write('<tr>\n');
   }
   document.write('<td><a href="#DOCUMENT'+ FRAMECOUNT  + '">' + baseName(target) + '</a></td>\n');
}
/* ============================================================================================================================== */
//alert('START');
function append_doc(target){
   FRAMECOUNT=FRAMECOUNT+1;
   /* document.write('<xmp>');
   */
   document.write('<br class="newpage"/>');
   document.write('<a name="DOCUMENT'+ FRAMECOUNT  + '"><a href="#TOP"> &nbsp;INDEX</a></a>\n');

   document.write('<div id="display' + FRAMECOUNT + '"></div>');
   document.write('<iframe width="0" height="0" id="buffer' + FRAMECOUNT + '" name="buffer' + FRAMECOUNT + '" src="' + target + '" ');
   document.write('onload="copyIframe(');
   document.write('\'buffer' + FRAMECOUNT + '\',');
   document.write('\'display' + FRAMECOUNT + '\'');
   document.write(')"></iframe>\n');
   /* document.write('</xmp>');
   */
}
/* ============================================================================================================================== */
/*
   on load of iframe displays body content of IFRAME document in DIV
*/

function copyIframe(iframeId, divId ) {
    var CurrentDiv = document.getElementById? document.getElementById(divId): null;
    if ( window.frames[iframeId] && CurrentDiv ) {
       /* copy data in iframe to div */
        CurrentDiv.innerHTML = window.frames[iframeId].document.body.innerHTML;
        CurrentDiv.style.display = 'block';
    }
}
/* ============================================================================================================================== */
//alert('GOT HERE 2 END');
/* ============================================================================================================================== */
//]]>
</script>
<title></title>
</head>
<body onload="set_style_from_cookie()">
<a name="TOP">&nbsp;</a>

<div>
<form>
Themes:
<input  type="submit"  onclick="switch_style('man');return          false;"  name="theme"  value="man"          id="man">
<input  type="submit"  onclick="switch_style('Simple');return       false;"  name="theme"  value="Simple"       id="Simple">
<input  type="submit"  onclick="switch_style('fortran');return      false;"  name="theme"  value="fortran"      id="fortran">
<input  type="submit"  onclick="switch_style('Local');return        false;"  name="theme"  value="Local"        id="Local">
<input  type="submit"  onclick="switch_style('Chocolate');return    false;"  name="theme"  value="Chocolate"    id="Chocolate">
<input  type="submit"  onclick="switch_style('Midnight');return     false;"  name="theme"  value="Midnight"     id="Midnight">
<input  type="submit"  onclick="switch_style('Modernist');return    false;"  name="theme"  value="Modernist"    id="Modernist">
<input  type="submit"  onclick="switch_style('Oldstyle');return     false;"  name="theme"  value="Oldstyle"     id="Oldstyle">
<input  type="submit"  onclick="switch_style('Steely');return       false;"  name="theme"  value="Steely"       id="Steely">
<input  type="submit"  onclick="switch_style('Traditional');return  false;"  name="theme"  value="Traditional"  id="Traditional">
<input  type="submit"  onclick="switch_style('Ultramarine');return  false;"  name="theme"  value="Ultramarine"  id="Ultramarine">
</form>
</div>
<hr>
<h3>SHORTCUTS:</h3>
<script language="JavaScript1.1"  type="text/javascript">
document.write('<center><table border="4" >\n');
document.write('<tbody>\n');
loadthem();
if (COLUMNS != 5 ){
   document.write('</tr>\n');
}
document.write('</tbody>\n');
document.write('</table></center>\n');
document.write('<hr\n>');
FIRSTPASS=1;
FRAMECOUNT=0;
loadthem();
</script>
</div>
</body>
EOF
}
####################################################################################################################################
BOOKNAME=$1
SECTION=$2
   echo 'Creating book '"$BOOKNAME"
   banner.sh $BOOKNAME
   INDX $BOOKNAME $SECTION
####################################################################################################################################
exit
####################################################################################################################################
