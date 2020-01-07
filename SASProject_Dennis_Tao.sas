*STAT 611 Project;

*Starting, I want to define the file path for both files;
%let dirdata=/folders/myfolders/Project/;

*Question 1**************************************************************************************************;

*Question 1 A*****;

Title "Q1a";
data snow1;
infile "&dirdata.Pr1Snowfall1.csv" DLM=',' MISSOVER;
input Year 1-4 Season $ 1-7 Sep $ Oct $ Nov $ Dec $ Jan $ Feb $ Mar $ Apr $ May $ Total $;
*While the snowfall values are numeric, with T being used as the missing value, a warning will appear as it 
reads in the character. Keeping them all as character values gets rid of this warning.;
If Year=. Then delete;
ARRAY monthn (9) Sep--May; 
do i=1 to 9;
	IF monthn(i)='T' Then monthn(i)=0;
	IF monthn(i)='' Then delete;
	*This way only the full seasons will be included, as requested in the problem.;
End;
Drop i;
run;
Footnote "Q1a";

proc contents data=snow1;
run;

proc print data=snow1;
*Title 'Full Seasons of Snow';
run;

*Question 1 B*****;

Title "Q1b";
data fullsnow;
	set snow1 end=eof;
	if eof then put _N_'Full Years of Snowfall Data.';
run;
Footnote "Q1b";

proc print data=fullsnow;
*Title 'Full Seasons of Snow';
run;


*Question 1 C*****;

Title "Q1c";
data snow2;
infile "&dirdata.Pr1Snowfall2.csv" DLM=',' MISSOVER;
input Year 1-4 Season $ 1-7 Sep $ Oct $ Nov $ Dec $ Jan $ Feb $ Mar $ Apr $ May $ Total $;
If Year=. Then delete;
ARRAY monthn (9) Sep--May; 
do i=1 to 9;
	IF monthn(i)='T' Then monthn(i)=0;
	IF monthn(i)='' Then delete;
	*This way only the full seasons will be included, as requested in the problem.;
End;
Drop i;
run;
Footnote "Q1c";

proc contents data=snow2;
run;


proc print data=snow2;
*Title 'Full Seasons of Snow';
run;


*Question 2**************************************************************************************************;

*Question 2 A*****;

Title "Q2a";
data CT1;
	infile "&dirdata.Pr1CT.dat" DLM='09'X firstobs=2; 
	length PatientID $ 8 Sex $ 8 Race $ 15;
	input PatientID $ Sex $ Race Treatment $ Sens0 Sens1 Sens3 Sens6 Sens12 Sens24;
	array character (4) _CHARACTER_;
		do i=1 to 4;
			if character(i)="Missing" then character(i)=".";
		end;
	drop i;
run;
Footnote "Q2a";

PROC CONTENTS data=CT1; 
RUN; 

*Changed obs to be 50 to reduce size of output Word document.;
proc print data=CT1 (obs=50);
*Title 'Clinical Trial Dataset';
run;

*Question 2 B*****;

Title "Q2b";
data CT2;
	set CT1;
	Location=substr(PatientID,1,1);
	IDNumber=substr(PatientID,2,3);
run;
Footnote "Q2b";

PROC CONTENTS data=CT2; 
RUN; 

proc print data=CT2 (obs=50);
*Title 'Clinical Trial Dataset with Location and ID Number';
run;

*Question 2 C*****;

Title "Q2c";
data CT3;
	set CT2 end=eof;
	if Location in ('P','J','M','N','V') then good=1;
		else good=0;
	Loction=Location;
	if good=0 then Location="X";
	retain Total 0;
	Total=Total + good;
	*Need to adjust Total in if statement for all possible values.;
	if eof and Total=_n_ Then put "All Location Values Are Correct";
	if good=0 then put "Error: Location " Loction "changed to X for PatientID " PatientID;
	drop good Total Loction;
run;
Footnote "Q2c";

proc print data=CT3 (obs=50);
*Title 'Clinical Trial Dataset with Updated Locations';
run;

*Double Checking***********************************;

*This data step is identical to the last one except with the addition of Location X in the conditional
statement. This is to make sure that the if eof and Total=_n_ would work if all the locations are set to
what we want them to be.;

data CT999999;
	set CT3 end=eof;
	if Location in ('P','J','M','N','V','X') then good=1;
		else good=0;
	Loction=Location;
	if good=0 then Location="X";
	retain Total 0;
	Total=Total + good;
	*Need to adjust Total in if statement for all possible values.;
	if eof and Total=_n_ Then put "All Location Values Are Correct";
	if good=0 then put "Error: Location " Loction "changed to X for PatientID " PatientID;
	drop good Total Loction;
run;

proc print data=CT999999 (obs=50);
*Title 'Clinical Trial Dataset with Updated Locations';
run;

*Looking in the log after running the data step, we can see that it had printed out the statement when all
locations are what we want them to be.;

*End of Double Checking***********************************;

*Question 2 D*****;

Title "Q2d";
data CT4;
	set CT3 end=eof;
	IDNuber=int(IDNumber);
	if IDNuber^=. and IDNuber>101 and IDNuber<999 then intgood=1;
		else intgood=0;
	IDNumer=IDNumber;
	if intgood=0 then IDNumber=999;
	retain TotalNum 0;
	TotalNum=TotalNum+intgood;
	if eof and TotalNum=_n_ then put "All ID Values Are Corrct";
	if intgood=0 then put "Error: ID Value " IDNumer "changed to 999 for PatientID " PatientID;
	*Many notes generated in Log for convertion of variables and invalid data. Should find out how to get rid;
	drop intgood TotalNum IDNuber IDNumer;
run;
Footnote "Q2d";

proc print data=CT4 (obs=50);
*Title 'Clinical Trial Dataset with Updated IDNumber';
run;

*Double Checking***********************************;

*This data step is identical to the last one except with the addition of an equal sign in the conditional
statement. This is to make sure that the if eof and Total=_n_ would work if all the ID Numbers are set to
what we want them to be.;

data CT000000000;
	set CT4 end=eof;
	IDNuber=int(IDNumber);
	if IDNuber^=. and IDNuber>101 and IDNuber<=999 then intgood=1;
		else intgood=0;
	IDNumer=IDNumber;
	if intgood=0 then IDNumber=999;
	retain TotalNum 0;
	TotalNum=TotalNum+intgood;
	if eof and TotalNum=_n_ then put "All ID Values Are Corrct";
	if intgood=0 then put "Error: ID Value " IDNumer "changed to 999 for PatientID " PatientID;
	*Many notes generated in Log for convertion of variables and invalid data. Should find out how to get rid;
	drop intgood TotalNum IDNuber IDNumer;
run;

proc print data=CT000000000 (obs=50);
run;

*Looking in the log after running the data step, we can see that it had printed out the statement when all
ID Numbers are what we want them to be.;

*End of Double Checking***********************************;

*Question 2 E*****;
Title 'Q2e';
proc tabulate data=CT4;
	Class Treatment;
	Var Sens0--Sens24;
	Table (Mean*Treatment)*format=round. (STDDEV*Treatment)*format=round., Sens0--Sens24;
	*Title "Mean and Standard Deviations of the Treatments";
	Footnote 'Q2e';
run;


*Question 3**************************************************************************************************;

*Question 3 A*****;

Title "Q3a";
data wBuff1;
	infile "&dirdata.Weather_Buffalo.csv" DSD firstobs=2;
	length Station_ID $ 17 Station $ 43; *Elevation 8 Latitude 8 Longitude 8;
	input Station_ID Station Elevation Latitude Longitude Date MaxSnow Miss CMiss Precip Miss_1 CMiss_1 
	Snowfall Miss_2 CMiss_2 MeanMaxTemp Miss_3 CMiss_3 MeanMinTemp Miss_4 CMiss_4 MeanTemp Miss_5 CMiss_5;
	informat date yymmdd8.;
	format date yymmdd10.;
	array measured (6) MaxSnow Precip Snowfall MeanMaxTemp MeanMinTemp MeanTemp;
	do i=1 to 6;
		if measured(i)=-9999 then measured(i)=.;
	end;
	drop i;
run;
Footnote "Q3a";

proc contents data=wBuff1;run;

options ls=256;
proc print data=wbuff1 (obs=20);
*Title 'Snow in Buffalo over the Years';
run;

*Question 3 B*****;

proc means data=wBuff1 NOPRINT;
var Miss CMiss Miss_1 CMiss_1 Miss_2 CMiss_2 Miss_3 CMiss_3 Miss_4 CMiss_4 Miss_5 CMiss_5;
output out=Totals
	SUM(Miss CMiss Miss_1 CMiss_1 Miss_2 CMiss_2 Miss_3 CMiss_3 Miss_4 CMiss_4 Miss_5 CMiss_5) = 
	TotalM TotalCM TotalM1 TotalCM1 TotalM2 TotalCM2 TotalM3 TotalCM3 TotalM4 TotalCM4 TotalM5 TotalCM5;

options ls=256;
Title 'Q3b';
proc print data=Totals;
var TotalM--TotalCM5;
*Title 'Total Number of Missing Days and Consecutive Missing Days'; Footnote 'Q3b';
run;

*Question 3 C*****;

Title "Q3c";
data wBuff2;
	set wBuff1;
	drop Miss CMiss Miss_1 CMiss_1 Miss_2 CMiss_2 Miss_3 CMiss_3 Miss_4 CMiss_4 Miss_5 CMiss_5 Station_ID
	Elevation--Longitude;
run;
Footnote "Q3c";

*I used a nodupkey in this code to remove any of the duplicate station names in the data set. The number of 
remaining observations will be equal to the number of unique station names.;
proc sort data=wBuff2 out=wBuffnodup nodupkey;
by Station;
run;

proc contents data=wBuffnodup;
run;

proc print data=wBuffnodup;
*Title 'Unique Station Names in Buffalo Dataset';
run;

*Based on the output, there are two unique station names.;

*Question 3 D*****;

Title "Q3d";
data wBuff3;
	set wBuff2;
	if Station="BUFFALO NIAGARA INTERNATIONAL AIRPORT NY US" then Station="Buffalo Airport";
		else Station="Buffalo City";
	City=substr(Station,1,7);
	Site=substr(Station,9,7);
run;
Footnote "Q3d";

proc contents data=wBuff3;
run;
	
proc print data=wBuff3 (obs=20);
*Title 'Updated Buffalo Dataset';
run;

*Question 3 E*****;

Title "Q3e";
data wBuff4;
	set wBuff3;
	MonthN=Month(Date);
	Month= put(Date,monname3.);
	Year=Year(Date);
	if MonthN in (10,11,12) then SnowSeasonLong= Year;
		else if MonthN in (1,2,3,4) then SnowSeasonLong= Year-1;
		else SnowSeasonLong=.;
run;
Footnote "Q3e";

proc contents data=wBuff4;
run;

proc print data=wBuff4 (obs=20);
*Title 'Buffalo Dataset with new Month, MonthN, Year, and SnowSeasonLong variables';
run;

*Question 3 F*****;

Title "Q3f";
data wBuff5;
	set wBuff4;
*The original units for the variables are as follows: 
MaxSnow=m e-3
Percip=m e-4
Snowfall=m e-3
MeanMaxTemp=C e-1
MeanMinTemp=C e-1
MeanTemp=C e-1
I would need to convert them with the equations below.;
		MaxSnow=Round(MaxSnow*.039370079, 0.1);
		Precip=Round(Precip*.0039370079, 0.1);
		Snowfall=Round(Snowfall*.039370079, 0.1);
		MeanMaxTemp=Round(MeanMaxTemp*.18+32, 0.1);
		MeanMinTemp=Round(MeanMinTemp*.18+32, 0.1);
		MeanTemp=Round(MeanTemp*.18+32, 0.1);
run;
Footnote "Q3f";

proc print data=wBuff5 (obs=20);
*Title 'Buffalo Dataset with values converted to Inches and Farhenhit';
run;


*Question 4**************************************************************************************************;

*Question 4 A*****;

Title "Q4a";
data wBuffcity (rename=(snowfall=Snowfall_City precip=Precip_City));
	set wBuff5;
	if Site="Airport" then delete;
	drop Station MaxSnow MeanMaxTemp--MeanTemp City Site;
run;
Footnote "Q4a";
	
proc print data=wBuffcity;
*Title 'Buffalo Dataset with only the City sites';
run;

Title "Q4a";
data wBuffairport (rename=(snowfall=Snowfall_Air precip=Precip_Air));
	set wBuff5;
	if Site="City" then delete;
	drop Station MaxSnow MeanMaxTemp--MeanTemp City Site;
run;
Footnote "Q4a";

proc print data=wbuffairport;
*Title 'Buffalo Dataset with only the Airport sites';
run;

*Will probably have to split the data into two and then merge them?;
proc sort data=wbuffcity;
by date;
run;

proc sort data=wbuffairport;
by date;
run;

*Using IN= options I was able to get it to only include dates that appeared in both datasets.;

Title "Q4a";
data wbuffmerge;
	merge wBuffairport (in=air) wBuffcity (in=city);
	by date;
	if air=city;
run;
Footnote "Q4a";

proc print data=wbuffmerge;
*Title 'Sorted Buffalo Dataset with Overlapping Dates in both the City and Airport site';
var Date Snowfall_Air Precip_Air Snowfall_City Precip_City;
run;

*Question 4 B*****;

Title "Q4b";
data wBuff;
	set wbuff5;
	if Site="City" and Year >= 1943 and MonthN >= 7 then delete;
	if Site="City" and Year > 1943 then delete;
	if Site="Airport" and Year <= 1943 and MonthN < 7 then delete;
	if Site="Airport" and Year < 1943 then delete;
run;
Footnote "Q4b";

proc contents data=wBuff;
run;

proc print data=wBuff;
*Title 'Buffalo Dataset with no Overlapping Dates';
run;

*Question 5**************************************************************************************************;

*First I need to define all the data sets and change the Snowfall variable to one that makes sense.;
libname perm "&dirdata";

data wA (rename=(snowfall=Snowfall_A));
	set perm.walb;
	drop station maxsnow precip meanmaxtemp--site;
run;

proc sort data=wa;
by date;
run;

proc print data=wa;
run;

data wS (rename=(snowfall=Snowfall_S));
	set perm.wsyr;
	drop station maxsnow precip meanmaxtemp--site;
run;

proc sort data=wS;
by date;
run;

proc print data=wS;
run;

data wR (rename=(snowfall=Snowfall_R));
	set perm.wroch;
	drop station maxsnow precip meanmaxtemp--site;
run;

proc sort data=wR;
by date;
run;

proc print data=wR;
run;

data wB (rename=(snowfall=Snowfall_B));
	set wBuff5;
	drop Station MaxSnow precip MeanMaxTemp--MeanTemp City Site;
run;

proc sort data=wB;
by date;
run;

proc print data=wB;
run;

*Question 5 A*****;

Title "Q5a";
data wAll;
	merge wA (IN=A) wB (IN=B) wR (IN=R) wS (IN=S);
	by date;
	if A=B=R=S;
run;
Footnote "Q5a";

proc contents data=wAll;run;

proc print data=wAll (obs=20);
var Date SnowSeasonLong Year Month MonthN Snowfall_B Snowfall_R Snowfall_S Snowfall_A;
*Title 'Merged Datasets From Buffalo, Rochester, Syracuse, and Albany';
run;

*Question 5 B*****;

Title "Q5b";
data wAll1;
	set wAll;
	If SnowSeasonLong=. or SnowSeasonLong=1925 then delete;
run;
Footnote "Q5b";

proc transpose data=wAll1 out=wAll2 name=City;
var Snowfall_A Snowfall_B--Snowfall_S;
by SnowSeasonLong;
run;

proc print data=wAll2;
run;

Title "Q5b";
data wAllYearSumsSLpre;
	set wall2;
	Total=sum(of COL:);
	drop COL1--COL14;
run;
Footnote "Q5b";

proc transpose data=wAllYearSumsSLpre out=wAllYearSumsSL (drop=_name_);
id City;
by SnowSeasonLong;
run;

proc contents data=wallyearsumssl;
run;

proc print data=wallyearsumssl (obs=20);
var SnowSeasonLong Snowfall_B Snowfall_R Snowfall_S Snowfall_A;
run;

proc tabulate data=wallyearsumssl out=wallyeartable;
var Snowfall_A--Snowfall_S;
table (mean)*format=round. (stddev)*format=round. (cv)*format=round.
, Snowfall_A--Snowfall_S;
run;


*Question 6**************************************************************************************************;

*Created the following data set to match problem description. Has the first fifty variables with 10 
observations each. This data set will be referenced in the macro so be sure to run it before using the macro.;

Title 'Q6a';
data x1x50;
	infile "&dirdata.Pr3x1x500.txt" obs=10;
	input x1-x50;
run;
Footnote 'Q6a';

proc print data=x1x50;
run;


*Question 6 A*****;

*Editted subsection of original file must first be loaded with the code above.;
%macro varchange (datain=, dataout=,seqEnd=,prefix=,grpPrefs=);
	data &dataout;
		set &datain;
		*First I had to calculate the number of groups that the variables were going to be split into.;
		%let g=%sysfunc(countw(&grpPrefs));
		*The put statements here help keep track of the macro outputs and ensure that they are outputting the
		correct values;
		%put &grpPrefs &g;
		%let divgrp=%sysevalf(&seqEnd/&g);
		%put &divgrp;
		%put %sysevalf(%sysevalf(&seqEnd/&g)-%eval(&seqEnd/&g));
		%if %sysevalf(%sysevalf(&seqEnd/&g)-%eval(&seqEnd/&g))=0 %then
	%do;
			%do j=1 %to &divgrp;
				%do i=1 %to &g;
					%let index=%eval((&j-1)*&g+&i);
					%put &index;
					%scan(&grpPrefs,&i)&j=&prefix&index;
				%end;
			%end;
		drop x1--x50;
	run;
	*The following transpose and sort proc steps are used to organize the variables in the order specified in
	the problem.;
	proc transpose data=&dataout out=transfile1 name=variable;
		var _ALL_;
	run;
	proc sort data=transfile1 out=sortedfile sortseq=linguistic (NUMERIC_COLLATION=ON);
		by variable;
	run;
	proc transpose data=sortedfile out=transfile2 (drop=_name_);
		id variable;
	run;
	proc print data=transfile2 (obs=5);
	Title "Reorganized variables into &g groups of &divgrp each";
	run;
	proc contents data=transfile2 order=varnum;
	run;
	%end;
		%else %put "Error in dividing &g by &seqEnd so macro will now stop.";
	run;
%mend varchange;

*The first situation requested by the problem, with the replacing prefixes being a, b, c, d, and e.;
%varchange (datain=x1x50,dataout=spacefile1,seqEnd=50,prefix=x,grpPrefs=a b c d e);

*The second situation requested by the problem, with the replacing prefixes being pre and post.;
%varchange (datain=x1x50,dataout=spacefile1,seqEnd=50,prefix=x,grpPrefs=pre post);

*Question 6 B*****;

%varchange (datain=x1x50,dataout=spacefile1,seqEnd=50,prefix=x,grpPrefs=a b c d e f g h i j k);

*Obviously, this won't work because 50 isn't divisiable by 11. So we get the error message in the log. No
results are printed.;
