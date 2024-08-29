#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

function trichounette()
{
	grep -rF "thzeribi" . | grep -v "./test.sh"
	grep -rF "buf\[BUF_SIZE + 1\]" . | grep -v "./test.sh"
	grep -rF "res == NULL || nb != ft_atoi(res)" . | grep -v "./test.sh"
	grep -rF "thousand(int nb, char \*buf)" . | grep -v "./test.sh"
	grep -rF "nb > 20 && nb < 100 && (nb % 10 != 0)" . | grep -v "./test.sh"
	grep -rF "ft_strstr(buf, ft_itoa(1" . | grep -v "./test.sh"
}

function test_diff()
{
	"$@" &> d1
	shift
	./testok "$@" &> d2
	if diff d1 d2 > /dev/null
	then
		echo -e "${GREEN}diff ok${NC}"
	else
		echo -e "${YELLOW}diff ko${NC}"
	fi
	rm d1 d2
}

function test_random()
{
	x=1
	KO=0
	while [[ $x -le 1000 ]]
	do
		printf ' %s /1000\r' "$x"
		y=$RANDOM
		./rush-02 "$y" &> d1
		./testok "$y" &> d2
		if diff d1 d2 > /dev/null
		then
			x=$(( "$x" + 1 ))
		else
			echo "${YELLOW}random test: $y ko${NC}"
			x=1001
			KO=1
		fi
		rm d1 d2
	done
	if [[ $KO == 0 ]]
	then
		echo "${GREEN}random test: ok${NC}"
	fi
}

function to_result()
{
	echo "$@" |& cat -e
	"$@" &>> /dev/null
	if [[ $? == 139 ]]
	then
		echo -e "${RED}SEGFAULT !!!${NC}"
	else
		test_diff "$@"
		"$@" |& cat -e
	fi
}

function to_result1()
{
	echo "$@"
	"$@"
}

function to_result2()
{
	echo "$@"
}

function get_authors()
{
	grep -rF "by" . |& grep -v "./test.sh"
	git log --all |& grep "Author:"
}


to_result2 "============================================="
to_result2 "|             auteurs                       |"
to_result2 "============================================="

get_authors

to_result2 "============================================="
to_result2 "|             logs                          |"
to_result2 "============================================="

to_result1 git log --all --oneline | cat -e

to_result2 "============================================="
to_result2 "|             norminette                    |"
to_result2 "============================================="

to_result1 norminette --version
to_result1 norminette


to_result2 "============================================="
to_result2 "|             trichounette                  |"
to_result2 "============================================="

#toute les detection doivent etre verifie a la main

trichounette

to_result2 "============================================="
to_result2 "|             compilation                   |"
to_result2 "============================================="

#ajouter `-g3 -fsanitize=leak,undefined,address`
# pour le deuxieme test

to_result1 make fclean
to_result1 make all
to_result1 make all
to_result1 make clean
to_result1 make rush-02
to_result1 make rush-02

to_result2 "============================================="
to_result2 "|             fonctions utilise             |"
to_result2 "============================================="

to_result1 nm -u rush-02

to_result2 "============================================="
to_result2 "|             test Error                    |"
to_result2 "============================================="

to_result ./rush-02
to_result ./rush-02 $'\0'
to_result ./rush-02 "abc"
to_result ./rush-02 "a1a"
to_result ./rush-02 "1.1"
to_result ./rush-02 "-1"
to_result ./rush-02 "1 1"
to_result ./rush-02 " a"
to_result ./rush-02 "-a"
to_result ./rush-02 "+1"
to_result ./rush-02 "1" $'\0' $'\0'
to_result ./rush-02 $'\0' "1" $'\0'
to_result ./rush-02 $'\0' $'\0' "1"
to_result ./rush-02 "notfound.dict" "1"
to_result ./rush-02 "Makefile" "1"
to_result1 chmod 000 "test.dict"
to_result ./rush-02 "test.dict" "1"
to_result1 chmod 444 "test.dict"
to_result ./rush-02 "test.dict" "a"
to_result1 chmod 644 "test.dict"
to_result1 mkdir dir
to_result ./rush-02 "dir" "1"
to_result1 rmdir dir

to_result2 "============================================="
to_result2 "|             test triviaux                 |"
to_result2 "============================================="

to_result ./rush-02 "42"
to_result ./rush-02 "0"
to_result ./rush-02 "1"
to_result ./rush-02 "2"
to_result ./rush-02 "3"
to_result ./rush-02 "4"
to_result ./rush-02 "5"
to_result ./rush-02 "6"
to_result ./rush-02 "7"
to_result ./rush-02 "8"
to_result ./rush-02 "9"
to_result ./rush-02 "10"
to_result ./rush-02 "11"
to_result ./rush-02 "12"
to_result ./rush-02 "13"
to_result ./rush-02 "14"
to_result ./rush-02 "15"
to_result ./rush-02 "16"
to_result ./rush-02 "17"
to_result ./rush-02 "18"
to_result ./rush-02 "19"
to_result ./rush-02 "20"
to_result ./rush-02 "21"
to_result ./rush-02 "59"
to_result ./rush-02 "101"
to_result ./rush-02 "210"
to_result ./rush-02 "00"
to_result ./rush-02 "000"
to_result ./rush-02 "0000"
to_result ./rush-02 "00000"
to_result ./rush-02 "0000000000"
to_result ./rush-02 "0000000001"
to_result ./rush-02 "0000000010"
to_result ./rush-02 "0000000020"
to_result ./rush-02 "0000000100"
to_result ./rush-02 "0000001000"
to_result ./rush-02 "0000010000"
to_result ./rush-02 "0000100000"
to_result ./rush-02 "0001000000"
to_result ./rush-02 "0010000000"
to_result ./rush-02 "0100000000"
to_result ./rush-02 "1000000000"
to_result ./rush-02 "0100000010"
to_result ./rush-02 "0000100001"
to_result ./rush-02 "0010011000"
to_result ./rush-02 "0009000004"
to_result ./rush-02 "1000000015"
to_result ./rush-02 "1111111111"
to_result ./rush-02 "2222222222"
to_result ./rush-02 "1234567890"
to_result ./rush-02 "4242424244"
to_result ./rush-02 "2147483646"
to_result ./rush-02 "2147483647"
to_result ./rush-02 "2147483648"
to_result ./rush-02 "4294967294"
to_result ./rush-02 "4294967295"
to_result ./rush-02 "4294967296"
to_result ./rush-02 "8589934589"
to_result ./rush-02 "858993459"
to_result ./rush-02 "8589934591"
to_result ./rush-02 "9223372036854775806"
to_result ./rush-02 "9223372036854775807"
to_result ./rush-02 "9223372036854775808"
to_result ./rush-02 "1234567890"
to_result ./rush-02 "12345678901234567890"
to_result ./rush-02 "123456789012345678901234567890"
to_result ./rush-02 "1234567890123456789012345678901234567890"
to_result ./rush-02 "12345678901234567890123456789012345678901234567890"
to_result ./rush-02 "123456789012345678901234567890123456789012345678901234567890"

to_result2 "============================================="
to_result2 "|             test random                   |"
to_result2 "============================================="

test_random

to_result2 "============================================="
to_result2 "|             test base dict                |"
to_result2 "============================================="

to_result ./rush-02 "test.dict" "42"
to_result ./rush-02 "test.dict" "0"
to_result ./rush-02 "test.dict" "1001"
to_result ./rush-02 "test.dict" "11000"
to_result ./rush-02 "test.dict" "5200"
to_result ./rush-02 "test.dict" "52000404"
to_result ./rush-02 "test.dict" "666"
to_result ./rush-02 "test.dict" "123456"
to_result ./rush-02 "test.dict" "3615"
to_result ./rush-02 "test.dict" "9999999"

to_result2 "============================================="
to_result2 "|             test bis dict                 |"
to_result2 "============================================="

to_result ./rush-02 "testbis.dict" "42"
to_result ./rush-02 "testbis.dict" "0"
to_result ./rush-02 "testbis.dict" "1001"
to_result ./rush-02 "testbis.dict" "11000"
to_result ./rush-02 "testbis.dict" "5200"
to_result ./rush-02 "testbis.dict" "52000404"
to_result ./rush-02 "testbis.dict" "666"
to_result ./rush-02 "testbis.dict" "123456"
to_result ./rush-02 "testbis.dict" "3615"
to_result ./rush-02 "testbis.dict" "9999999"

touch testbis_faux_mille.dict
echo "1001: faux_mille" > testbis_faux_mille.dict
cat test.dict >> testbis_faux_mille.dict
to_result ./rush-02 testbis_faux_mille.dict "1234"
rm -f testbis_faux_mille.dict

to_result2 "============================================="
to_result2 "|             test fr dict                  |"
to_result2 "============================================="

to_result ./rush-02 "testfr.dict" "42"
to_result ./rush-02 "testfr.dict" "0"
to_result ./rush-02 "testfr.dict" "1001"
to_result ./rush-02 "testfr.dict" "11000"
to_result ./rush-02 "testfr.dict" "5200"
to_result ./rush-02 "testfr.dict" "52000404"
to_result ./rush-02 "testfr.dict" "666"
to_result ./rush-02 "testfr.dict" "123456"
to_result ./rush-02 "testfr.dict" "3615"
to_result ./rush-02 "testfr.dict" "9999999"

to_result2 "============================================="
to_result2 "|             test extended dict            |"
to_result2 "============================================="

to_result ./rush-02 "testextended.dict" "42"
to_result ./rush-02 "testextended.dict" "0"
to_result ./rush-02 "testextended.dict" "1001"
to_result ./rush-02 "testextended.dict" "11000"
to_result ./rush-02 "testextended.dict" "5200"
to_result ./rush-02 "testextended.dict" "52000404"
to_result ./rush-02 "testextended.dict" "666"
to_result ./rush-02 "testextended.dict" "123456"
to_result ./rush-02 "testextended.dict" "3615"
to_result ./rush-02 "testextended.dict" "9999999"
to_result ./rush-02 "testextended.dict" "20000300004000000000000000000000000000000000000000000000000000000000"

to_result2 "============================================="
to_result2 "|             test dict invalide            |"
to_result2 "============================================="

function test_invalide_dict()
{
	cp test.dict "$2"
	echo "$1" >> "$2"
	to_result ./rush-02 "$2" "$3"
	rm -f "$2"
}

test_invalide_dict "invalid line" "testinvalid1.dict" "1234"
test_invalide_dict "4a4:not four" "testinvalid2.dict" "1234"
test_invalide_dict "truc:truc" "testinvalid3.dict" "1234"
test_invalide_dict "abc123:bidule" "testinvalid4.dict" "1234"
test_invalide_dict "101:" "testinvalid5.dict" "1234"
test_invalide_dict "ha:ha" "testinvalid6.dict" "1234"
test_invalide_dict ":qui?" "testinvalid7.dict" "1234"
test_invalide_dict "   :quoi?" "testinvalid8.dict" "1234"
test_invalide_dict "+27: ou?" "testinvalid9.dict" "1234"
test_invalide_dict "-15: kezaco" "testinvalid10.dict" "1234"

cp test.dict testinvalid11.dict
sed -i -e 's/1000: thousand/1001: faux_mille/' testinvalid11.dict
to_result ./rush-02 "testinvalid11.dict" "1234"
rm -f testinvalid11.dict

to_result2 "============================================="
to_result2 "|             test Erreur avance            |"
to_result2 "============================================="

to_result ./rush-02 "/dev/random" "1234"
to_result ./rush-02 "/dev/null" "1234"
