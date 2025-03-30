a=`awk 'BEGIN{print substr("'$1'",1,3)}'`
if [ $a = "oss" ] ; then

echo "oss"
/opt/ossutil ls $1 | awk '$NF~/outs\/metrics_summary/{match($NF,/([^/]*)\/outs/,a);print "/opt/ossutil cp "$NF" ./"a[1]"_metrics_summary.csv"}$NF~/outs\/web_summary.html/{match($NF,/([^/]*)\/outs/,a);print "/opt/ossutil cp "$NF" ./"a[1]"_web_summary.html"}$NF~/outs\/filtered_feature_bc_matrix\/$/{match($NF,/([^/]*)\/outs/,a);print "/opt/ossutil cp -r "$NF" ./"a[1]"_filtered_feature_bc_matrix"}' 
elif [ $a = "cos" ] ; then
echo "cos"
b=`awk 'BEGIN{match("'$1'",/(.*:\/\/[^/]*)/,a);print a[1]}'`
echo $b
/usr/bin/coscli ls -r $1 | awk '$1~/outs\/web_summary.html/{match($1,/(.*00.cellranger)/,d);match($1,/([^/]*)\/outs/,a);;c[a[1]]="'$b'/"d[1]"/"a[1]"/"a[1]"/outs/"}END{for(m in c){ print "/usr/bin/coscli cp  "c[m]"web_summary.html "m"_web_summary.html";print "/usr/bin/coscli cp  "c[m]"metrics_summary.csv "m"_metrics_summary.csv";print "/usr/bin/coscli cp -r "c[m]"filtered_feature_bc_matrix/ "m"_filtered_feature_bc_matrix"}}' | sh 
#/usr/bin/coscli ls -r $1 | awk '$1~/outs\/web_summary.html/{match($1,/(.*00.cellranger)/,d);match($1,/([^/]*)\/outs/,a);;c[a[1]]="'$b'/"d[1]"/"a[1]"/"a[1]"/outs/"}END{for(m in c){ print "/usr/bin/coscli cp  "c[m]"web_summary.html "m"_web_summary.html";print "/usr/bin/coscli cp  "c[m]"metrics_summary.csv "m"_metrics_summary.csv";print "/usr/bin/coscli cp -r "c[m]"cloupe.cloupe "m"_cloupe.cloupe"}}' 

else
echo "not cos or oss check it"
fi
find ./ -maxdepth 1 -type f  -name "*summary.csv"|xargs awk -vFPAT='([^,]*)|("[^"]+")' -vOFS="\t" 'BEGIN{getline;print "name",$1,$2,$3,$4,$5,$6}FNR!=1{match(FILENAME,/\/(.*)_metrics_summary.csv/,a);print a[1],$1,$2,$3,$4,$5,$6}' > summary.xls

awk 'BEGIN{a="'"`date --rfc-3339='date'`"'";print "\n\n\n###pipline\nzip -r result"a".zip ./*";match("'"`pwd`"'",/(HGC20[^/]*)/,b);print "coscli cp result"a".zip '$2'"b[1]"/result"a".zip";print "coscli signurl '$2'"b[1]"/result"a".zip -t 6048000 -e cos.ap-guangzhou.tencentcos.cn"}'

#/opt/ossutil ls $1 | awk '$NF~/outs\/metrics_summary/{match($NF,/([^/]*)\/outs/,a);print "/opt/ossutil cp "$NF" ./"a[1]"_metrics_summary.csv"}$NF~/outs\/web_summary.html/{match($NF,/([^/]*)\/outs/,a);print "/opt/ossutil cp "$NF" ./"a[1]"_web_summary.html"}$NF~/outs\/filtered_feature_bc_matrix\/$/{match($NF,/([^/]*)\/outs/,a);print "/opt/ossutil cp -r "$NF" ./"a[1]"_filtered_feature_bc_matrix"}' 
