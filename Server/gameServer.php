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
	switch( $_POST['operation'] )
	{
		case "store":
			$level = $_POST['level'];

			$file = fopen( "games/".$_POST['levelName'].".txt", "w");
			fwrite( $file, $level );
			fclose( $file );

			break;
		
		case "getRandom":
			$files = scandir( "/games" );

			$randomKey = array_rand( $files );
			$filename = $files[$randomKey];
			$file = fopen( "games/".$filename, "r" );
			echo fread( $file, filesize( "games/".$filename ) );
			fclose( $file );
			break;
	}

}
?>