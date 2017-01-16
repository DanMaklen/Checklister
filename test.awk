BEGIN{
	RS="\n,,,,,,,,,,\n"
	FS="\n"

	nItem = 0
	maxNF = 0
}
{
	print "Record:" NR
	print "\"\"\"" $0 "\"\"\""
	maxNF = (maxNF < NF ? NF : maxNF)
	maxN = 0
	for(f = 1; f <= NF; f++){
		print ""
		print "Field " f " \"" $f "\""
		#n = split($f, tarr, ",+(No)?,*") - 1
		n = split($f, tarr, ",(No)?,?,?") - 1
		maxN = (maxN < n ? n : maxN)
		print "n="n "("maxN")"
		for(i = 1; i <= n; i++){
			arr[nItem+i][f] = tarr[i]
			print i " " tarr[i]
		}
	}
	nItem += maxN
}
END{
	print ""
	print ""
	print ""
	print ""
	print "NItem=" nItem
	print "maxNF=" maxNF
	print ""
	print ""
	print ""
	print ""

	#asort(arr, arr, "comp")
	for(i in arr) asort(arr[i], arr[i], "comp2")
	#exit
	for(i = 1; i <= nItem; i++){
		if(arr[i][1] == "") continue;
		print "{"
		print "\ttext: \"" arr[i][1] "\","
		print "\tchild_check_count: 0,"
		print "\thref: \"#\","
		print "\tnodes: ["
		for(j = 2; j <= maxNF; j++){
			if(arr[i][j] == "") continue;
			print "\t\t{"
			print "\t\t\ttext: \"" arr[i][j] "\","
			print "\t\t\tchild_check_count: 0,"
			print "\t\t\thref: \"#\""
			print "\t\t" (j < maxNF ? "}," : "}")
		}
		print "\t]"
		print (i < nItem ? "}," : "}")
	}
}

function comp(i1, v1, i2, v2){
	if(v1[1] < v2[1]) return -1;
	if(v1[1] == v2[1]) return 0;
	if(v1[1] > v2[1]) return 1;
	return 2;
}
function comp2(i1, v1, i2, v2){
	if(i1 == 1) return -1;
	if(i2 == 1) return 1;

	if(v1 < v2) return -1;
	if(v1 == v2) return 0;
	if(v1 > v2) return 1;
	return 2;
}
