<?php
/**
 * index.php
 *
 * Entry point for Save Our Scientists API.
 *
 * Written by: Brendan Lensink [blensink192@gmail.com].
 * Written on: November 11th, 2015.
 */

/* That's super secret key. I'm aware this is kind of futile but better than nothing I think.
* The idea being that this might stop other queries to the server. Maybe not though.
*/
if( $_POST['ssk'] == "w:6pbL6Yt;_wjsa^" )
{
	$level = $_POST['level']
}
?>