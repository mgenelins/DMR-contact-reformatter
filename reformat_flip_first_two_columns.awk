BEGIN { FS=","; }
{ printf "%s,%s,%s\n", $2, $1, $3 }
END { }
