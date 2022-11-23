#Toro Etele tegi4297
#AWK 06 feladatcsoport 08 as feladat
#A) A parancssorban megadott állományokra írassuk ki az egymás utáni ismétlődő sorok esetén:
#        [állománynév]: [sor] - [ismétlődések száma]
#Végül írjuk ki az egymásután ismétlődő azonos sorok maximális számát, ezt a sort, az állományt, amelyben szerepel, és azt, hogy az állomány hányadik soraiban van.

if [ $# -lt 1 ]
then
	echo "Hasznalat: $0 szoveges allomany(ok)"
	exit 1
fi

for i
do
	if [ ! -f $i ]
	then
		echo $i nem allomany
		echo Hasznalat: $0 allomanynevek
		exit 1
	fi
done

awk '{if($0==prev && prevFile==FILENAME){
		print $0
		count++;
	}else{	
		if(count>1){
			print FILENAME ": ",prev " - ",count;
		}
		if(count>maxCount){
			maxCount = count;
			maxRow = prev;
			maxFile = FILENAME;
			maxIndexStart = indexStart;
			maxIndexEnd = FNR -1;
		}
		prev=$0;
		prevFile=FILENAME;
		count=1;
		indexStart=FNR;
	}}
	END{
		if(count>1){
			print FILENAME ": ",prev " - ", count;
		}
		print "Maximalis ismetlodes:"  maxCount,maxRow,maxFile,maxIndexStart,maxIndexEnd
	}' $*

#Toro Etele tegi4297
#AWK 06 feladatcsoport 08 as feladat
#B) A paraméterként megadott karakter esetében asszociatív tömb(ök) használatának segítségével határozzuk meg az illető karakterrel kezdődő keresztnevek előfordulási gyakoriságát a rendszerben levő alapképzéses diák-felhasználók körében (megj.: az alapképzéses diákok alapkatalógusában szerepel a "licenta" alkatalógus). Az eredményt [keresztnév] : [szám] formában írjuk ki, ahol a helykitöltőket a megfelelő információkkal helyettesítjük.
#(Megj.: úgy tekintjük, hogy az /etc/passwd állomány 5. mezejében szereplő névben a második szóközig tart a vezetéknév és a szülő keresztnevének iniciáléja, ezt követi(k) a keresztnév(~nevek), amelyek közt az elválasztó karakternek a szóközt tekintjük (amennyiben . karakterrel vannak elválasztva, azt egy szónak tekintjük). Mivel nem minden név követi ezt a szabályt, a kimenetben megjelenhetnek "furcsa" keresztnevek is.)

if [ ! $# -eq 1 ]
then
	echo "Hasznalat: $0 karakter"
	exit 1
fi

if [[ $1 =~ [^a-Z] ]]
then
	echo $1 nem betu
	echo "Hasznalat: $0 karakter"
fi

#awk 'BEGIN{FS=":"}
#	/licenta/{print $5}
#	' /etc/passwd |
#	awk '{count[$3]++}
#	END{for(i in count){
#		print i ":" count[i]
#	}}' | awk -v char=$1 '$0 ~ char {print $1}'

awk -v char=$1 'BEGIN{FS=":| "}
	/licenta/{
		if(substr($7,1,1)==char){
			count[$7]++;
		}}
	END{for(i in count){
			print i " : " count[i]
		}}' /etc/passwd